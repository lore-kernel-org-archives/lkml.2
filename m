Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2BCPsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:48:20 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:56120 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2BCPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:48:18 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/6] ipmi: use a tasklet for handling received messages
Date: Fri, 03 Feb 2012 09:47:56 -0600
Message-id: <1328284079-5489-3-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPMI driver would release a lock, deliver a message, then relock.
This is obviously ugly, and this patch converts the message handler
interface to use a tasklet to schedule work.  This lets the receive
handler be called from an interrupt handler with interrupts enabled.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |  141 +++++++++++++++++++++--------------
 drivers/char/ipmi/ipmi_si_intf.c    |   14 +---
 2 files changed, 88 insertions(+), 67 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 58c0e63..289ab50 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -46,6 +46,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
+#include <linux/interrupt.h>
 
 #define PFX "IPMI message handler: "
 
@@ -53,6 +54,8 @@
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
+static void smi_recv_tasklet(unsigned long);
+static void handle_new_recv_msgs(ipmi_smi_t intf);
 
 static int initialized;
 
@@ -355,12 +358,15 @@ struct ipmi_smi {
 	int curr_seq;
 
 	/*
-	 * Messages that were delayed for some reason (out of memory,
-	 * for instance), will go in here to be processed later in a
-	 * periodic timer interrupt.
+	 * Messages queued for delivery.  If delivery fails (out of memory
+	 * for instance), They will stay in here to be processed later in a
+	 * periodic timer interrupt.  The tasklet is for handling received
+	 * messages directly from the handler.
 	 */
 	spinlock_t       waiting_msgs_lock;
 	struct list_head waiting_msgs;
+	atomic_t	 watchdog_pretimeouts_to_deliver;
+	struct tasklet_struct recv_tasklet;
 
 	/*
 	 * The list of command receivers that are registered for commands
@@ -493,6 +499,8 @@ static void clean_up_interface_data(ipmi_smi_t intf)
 	struct cmd_rcvr  *rcvr, *rcvr2;
 	struct list_head list;
 
+	tasklet_kill(&intf->recv_tasklet);
+
 	free_smi_msg_list(&intf->waiting_msgs);
 	free_recv_msg_list(&intf->waiting_events);
 
@@ -2792,6 +2800,9 @@ void ipmi_poll_interface(ipmi_user_t user)
 
 	if (intf->handlers->poll)
 		intf->handlers->poll(intf->send_info);
+
+	/* In case something came in */
+	handle_new_recv_msgs(intf);
 }
 EXPORT_SYMBOL(ipmi_poll_interface);
 
@@ -2860,6 +2871,10 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 #endif
 	spin_lock_init(&intf->waiting_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_msgs);
+	tasklet_init(&intf->recv_tasklet,
+		     smi_recv_tasklet,
+		     (unsigned long) intf);
+	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
 	spin_lock_init(&intf->events_lock);
 	INIT_LIST_HEAD(&intf->waiting_events);
 	intf->waiting_events_count = 0;
@@ -3622,11 +3637,11 @@ static int handle_bmc_rsp(ipmi_smi_t          intf,
 }
 
 /*
- * Handle a new message.  Return 1 if the message should be requeued,
+ * Handle a received message.  Return 1 if the message should be requeued,
  * 0 if the message should be freed, or -1 if the message should not
  * be freed or requeued.
  */
-static int handle_new_recv_msg(ipmi_smi_t          intf,
+static int handle_one_recv_msg(ipmi_smi_t          intf,
 			       struct ipmi_smi_msg *msg)
 {
 	int requeue;
@@ -3784,12 +3799,72 @@ static int handle_new_recv_msg(ipmi_smi_t          intf,
 	return requeue;
 }
 
+/*
+ * If there are messages in the queue or pretimeouts, handle them.
+ */
+static void handle_new_recv_msgs(ipmi_smi_t intf)
+{
+	struct ipmi_smi_msg  *smi_msg;
+	unsigned long        flags = 0;
+	int                  rv;
+	int                  run_to_completion = intf->run_to_completion;
+
+	/* See if any waiting messages need to be processed. */
+	if (!run_to_completion)
+		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+	while (!list_empty(&intf->waiting_msgs)) {
+		smi_msg = list_entry(intf->waiting_msgs.next,
+				     struct ipmi_smi_msg, link);
+		list_del(&smi_msg->link);
+		if (!run_to_completion)
+			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		rv = handle_one_recv_msg(intf, smi_msg);
+		if (!run_to_completion)
+			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+		if (rv == 0) {
+			/* Message handled */
+			ipmi_free_smi_msg(smi_msg);
+		} else if (rv < 0) {
+			/* Fatal error on the message, del but don't free. */
+		} else {
+			/*
+			 * To preserve message order, quit if we
+			 * can't handle a message.
+			 */
+			list_add(&smi_msg->link, &intf->waiting_msgs);
+			break;
+		}
+	}
+	if (!run_to_completion)
+		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+
+	/*
+	 * If the pretimout count is non-zero, decrement one from it and
+	 * deliver pretimeouts to all the users.
+	 */
+	if (atomic_add_unless(&intf->watchdog_pretimeouts_to_deliver, -1, 0)) {
+		ipmi_user_t user;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(user, &intf->users, link) {
+			if (user->handler->ipmi_watchdog_pretimeout)
+				user->handler->ipmi_watchdog_pretimeout(
+					user->handler_data);
+		}
+		rcu_read_unlock();
+	}
+}
+
+static void smi_recv_tasklet(unsigned long val)
+{
+	handle_new_recv_msgs((ipmi_smi_t) val);
+}
+
 /* Handle a new message from the lower layer. */
 void ipmi_smi_msg_received(ipmi_smi_t          intf,
 			   struct ipmi_smi_msg *msg)
 {
 	unsigned long flags = 0; /* keep us warning-free. */
-	int           rv;
 	int           run_to_completion;
 
 
@@ -3843,31 +3918,11 @@ void ipmi_smi_msg_received(ipmi_smi_t          intf,
 	run_to_completion = intf->run_to_completion;
 	if (!run_to_completion)
 		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
-	if (!list_empty(&intf->waiting_msgs)) {
-		list_add_tail(&msg->link, &intf->waiting_msgs);
-		if (!run_to_completion)
-			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
-		goto out;
-	}
+	list_add_tail(&msg->link, &intf->waiting_msgs);
 	if (!run_to_completion)
 		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 
-	rv = handle_new_recv_msg(intf, msg);
-	if (rv > 0) {
-		/*
-		 * Could not handle the message now, just add it to a
-		 * list to handle later.
-		 */
-		run_to_completion = intf->run_to_completion;
-		if (!run_to_completion)
-			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
-		list_add_tail(&msg->link, &intf->waiting_msgs);
-		if (!run_to_completion)
-			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
-	} else if (rv == 0) {
-		ipmi_free_smi_msg(msg);
-	}
-
+	tasklet_schedule(&intf->recv_tasklet);
  out:
 	return;
 }
@@ -3875,16 +3930,8 @@ EXPORT_SYMBOL(ipmi_smi_msg_received);
 
 void ipmi_smi_watchdog_pretimeout(ipmi_smi_t intf)
 {
-	ipmi_user_t user;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(user, &intf->users, link) {
-		if (!user->handler->ipmi_watchdog_pretimeout)
-			continue;
-
-		user->handler->ipmi_watchdog_pretimeout(user->handler_data);
-	}
-	rcu_read_unlock();
+	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 1);
+	tasklet_schedule(&intf->recv_tasklet);
 }
 EXPORT_SYMBOL(ipmi_smi_watchdog_pretimeout);
 
@@ -3998,28 +4045,12 @@ static void ipmi_timeout_handler(long timeout_period)
 	ipmi_smi_t           intf;
 	struct list_head     timeouts;
 	struct ipmi_recv_msg *msg, *msg2;
-	struct ipmi_smi_msg  *smi_msg, *smi_msg2;
 	unsigned long        flags;
 	int                  i;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
-		/* See if any waiting messages need to be processed. */
-		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
-		list_for_each_entry_safe(smi_msg, smi_msg2,
-					 &intf->waiting_msgs, link) {
-			if (!handle_new_recv_msg(intf, smi_msg)) {
-				list_del(&smi_msg->link);
-				ipmi_free_smi_msg(smi_msg);
-			} else {
-				/*
-				 * To preserve message order, quit if we
-				 * can't handle a message.
-				 */
-				break;
-			}
-		}
-		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		tasklet_schedule(&intf->recv_tasklet);
 
 		/*
 		 * Go through the seq table and find any messages that
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 73ebbb1..01e53cd 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -320,16 +320,8 @@ static int register_xaction_notifier(struct notifier_block *nb)
 static void deliver_recv_msg(struct smi_info *smi_info,
 			     struct ipmi_smi_msg *msg)
 {
-	/* Deliver the message to the upper layer with the lock
-	   released. */
-
-	if (smi_info->run_to_completion) {
-		ipmi_smi_msg_received(smi_info->intf, msg);
-	} else {
-		spin_unlock(&(smi_info->si_lock));
-		ipmi_smi_msg_received(smi_info->intf, msg);
-		spin_lock(&(smi_info->si_lock));
-	}
+	/* Deliver the message to the upper layer. */
+	ipmi_smi_msg_received(smi_info->intf, msg);
 }
 
 static void return_hosed_msg(struct smi_info *smi_info, int cCode)
@@ -481,9 +473,7 @@ static void handle_flags(struct smi_info *smi_info)
 
 		start_clear_flags(smi_info);
 		smi_info->msg_flags &= ~WDT_PRE_TIMEOUT_INT;
-		spin_unlock(&(smi_info->si_lock));
 		ipmi_smi_watchdog_pretimeout(smi_info->intf);
-		spin_lock(&(smi_info->si_lock));
 	} else if (smi_info->msg_flags & RECEIVE_MSG_AVAIL) {
 		/* Messages available. */
 		smi_info->curr_msg = ipmi_alloc_smi_msg();
-- 
1.7.4.1

