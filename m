Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2BCQss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:48:48 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:45386 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab2BCQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:48:46 -0500
X-Greylist: delayed 3606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Feb 2012 11:48:46 EST
From: Corey Minyard <cminyard@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/6] ipmi: Fix message handling during panics
Date: Fri, 03 Feb 2012 09:47:57 -0600
Message-id: <1328284079-5489-4-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The part of the IPMI driver that delivered panic information to the
event log and extended the watchdog timeout during a panic was not
properly handling the messages.  It used static messages to avoid
allocation, but wasn't properly waiting for these, or wasn't properly
handling the refcounts.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |  103 ++++++++++++++++-------------------
 drivers/char/ipmi/ipmi_watchdog.c   |   17 ++++---
 2 files changed, 56 insertions(+), 64 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 289ab50..5c1820c 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2794,16 +2794,18 @@ channel_handler(ipmi_smi_t intf, struct ipmi_recv_msg *msg)
 	return;
 }
 
-void ipmi_poll_interface(ipmi_user_t user)
+static void ipmi_poll(ipmi_smi_t intf)
 {
-	ipmi_smi_t intf = user->intf;
-
 	if (intf->handlers->poll)
 		intf->handlers->poll(intf->send_info);
-
 	/* In case something came in */
 	handle_new_recv_msgs(intf);
 }
+
+void ipmi_poll_interface(ipmi_user_t user)
+{
+	ipmi_poll(user->intf);
+}
 EXPORT_SYMBOL(ipmi_poll_interface);
 
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
@@ -4204,12 +4206,48 @@ EXPORT_SYMBOL(ipmi_free_recv_msg);
 
 #ifdef CONFIG_IPMI_PANIC_EVENT
 
+static atomic_t panic_done_count = ATOMIC_INIT(0);
+
 static void dummy_smi_done_handler(struct ipmi_smi_msg *msg)
 {
+	atomic_dec(&panic_done_count);
 }
 
 static void dummy_recv_done_handler(struct ipmi_recv_msg *msg)
 {
+	atomic_dec(&panic_done_count);
+}
+
+/*
+ * Inside a panic, send a message and wait for a response.
+ */
+static void ipmi_panic_request_and_wait(ipmi_smi_t           intf,
+					struct ipmi_addr     *addr,
+					struct kernel_ipmi_msg *msg)
+{
+	struct ipmi_smi_msg  smi_msg;
+	struct ipmi_recv_msg recv_msg;
+	int rv;
+
+	smi_msg.done = dummy_smi_done_handler;
+	recv_msg.done = dummy_recv_done_handler;
+	atomic_add(2, &panic_done_count);
+	rv = i_ipmi_request(NULL,
+			    intf,
+			    addr,
+			    0,
+			    msg,
+			    intf,
+			    &smi_msg,
+			    &recv_msg,
+			    0,
+			    intf->channels[0].address,
+			    intf->channels[0].lun,
+			    0, 1); /* Don't retry, and don't wait. */
+	if (rv)
+		atomic_sub(2, &panic_done_count);
+	while (atomic_read(&panic_done_count) != 0)
+		ipmi_poll(intf);
 }
 
 #ifdef CONFIG_IPMI_PANIC_STRING
@@ -4248,8 +4286,6 @@ static void send_panic_events(char *str)
 	unsigned char                     data[16];
 	struct ipmi_system_interface_addr *si;
 	struct ipmi_addr                  addr;
-	struct ipmi_smi_msg               smi_msg;
-	struct ipmi_recv_msg              recv_msg;
 
 	si = (struct ipmi_system_interface_addr *) &addr;
 	si->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
@@ -4277,9 +4313,6 @@ static void send_panic_events(char *str)
 		data[7] = str[2];
 	}
 
-	smi_msg.done = dummy_smi_done_handler;
-	recv_msg.done = dummy_recv_done_handler;
-
 	/* For every registered interface, send the event. */
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
 		if (!intf->handlers)
@@ -4289,18 +4322,7 @@ static void send_panic_events(char *str)
 		intf->run_to_completion = 1;
 		/* Send the event announcing the panic. */
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
-		i_ipmi_request(NULL,
-			       intf,
-			       &addr,
-			       0,
-			       &msg,
-			       intf,
-			       &smi_msg,
-			       &recv_msg,
-			       0,
-			       intf->channels[0].address,
-			       intf->channels[0].lun,
-			       0, 1); /* Don't retry, and don't wait. */
+		ipmi_panic_request_and_wait(intf, &addr, &msg);
 	}
 
 #ifdef CONFIG_IPMI_PANIC_STRING
@@ -4348,18 +4370,7 @@ static void send_panic_events(char *str)
 		msg.data = NULL;
 		msg.data_len = 0;
 		intf->null_user_handler = device_id_fetcher;
-		i_ipmi_request(NULL,
-			       intf,
-			       &addr,
-			       0,
-			       &msg,
-			       intf,
-			       &smi_msg,
-			       &recv_msg,
-			       0,
-			       intf->channels[0].address,
-			       intf->channels[0].lun,
-			       0, 1); /* Don't retry, and don't wait. */
+		ipmi_panic_request_and_wait(intf, &addr, &msg);
 
 		if (intf->local_event_generator) {
 			/* Request the event receiver from the local MC. */
@@ -4368,18 +4379,7 @@ static void send_panic_events(char *str)
 			msg.data = NULL;
 			msg.data_len = 0;
 			intf->null_user_handler = event_receiver_fetcher;
-			i_ipmi_request(NULL,
-				       intf,
-				       &addr,
-				       0,
-				       &msg,
-				       intf,
-				       &smi_msg,
-				       &recv_msg,
-				       0,
-				       intf->channels[0].address,
-				       intf->channels[0].lun,
-				       0, 1); /* no retry, and no wait. */
+			ipmi_panic_request_and_wait(intf, &addr, &msg);
 		}
 		intf->null_user_handler = NULL;
 
@@ -4436,18 +4436,7 @@ static void send_panic_events(char *str)
 			strncpy(data+5, p, 11);
 			p += size;
 
-			i_ipmi_request(NULL,
-				       intf,
-				       &addr,
-				       0,
-				       &msg,
-				       intf,
-				       &smi_msg,
-				       &recv_msg,
-				       0,
-				       intf->channels[0].address,
-				       intf->channels[0].lun,
-				       0, 1); /* no retry, and no wait. */
+			ipmi_panic_request_and_wait(intf, &addr, &msg);
 		}
 	}
 #endif /* CONFIG_IPMI_PANIC_STRING */
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 34767a6..57a53ba 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -520,6 +520,7 @@ static void panic_halt_ipmi_heartbeat(void)
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -528,8 +529,8 @@ static void panic_halt_ipmi_heartbeat(void)
 				      &panic_halt_heartbeat_smi_msg,
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
-	if (!rv)
-		atomic_add(2, &panic_done_count);
+	if (rv)
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -553,16 +554,18 @@ static void panic_halt_ipmi_set_timeout(void)
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
+	atomic_add(2, &panic_done_count);
 	rv = i_ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
-	if (!rv) {
-		atomic_add(2, &panic_done_count);
-		if (send_heartbeat_now)
-			panic_halt_ipmi_heartbeat();
-	} else
+	if (rv) {
+		atomic_sub(2, &panic_done_count);
 		printk(KERN_WARNING PFX
 		       "Unable to extend the watchdog timeout.");
+	} else {
+		if (send_heartbeat_now)
+			panic_halt_ipmi_heartbeat();
+	}
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
 }
-- 
1.7.4.1

