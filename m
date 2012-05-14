Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2ENOlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab2ENOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:41:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, gregkh@linuxfoundation.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, lwoodman@redhat.com,
        jbaron@redhat.com, dzickus@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] tty, add kref to sysrq handlers
Date: Mon, 14 May 2012 10:41:07 -0400
Message-Id: <1337006467-28816-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a large system with a large number of tasks, the output of

echo t > /proc/sysrq-trigger

can take a long period of time.  If this period is greater than the period
of the current clocksource, the clocksource watchdog will mark the
clocksource as unstable and fail the clocksource over.

The problem with sysrq is that __handle_sysrq() takes a spin_lock with
interrupts disabled and disables interrupts for the duration of the
handler.  If this happens during sysrq-t on a large system with a large
number of tasks, the result is a "brown-out" of the system.

The spin_lock in question, sysrq_key_table_lock, is in place to prevent
the removal of a sysrq handler while it is being executed in
__handle_sysrq().

A kref is added to each sysrq handler and is incremented and decremented
in __handle_sysrq().  This, while more complicated than a lock , leads to
minimizing the time that the sysrq_key_table_lock is acquired and results
in a functional sysrq-t.

I've tested both options and I no longer see the clocksource watchdog
marking the TSC clocksource as unstable.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: gregkh@linuxfoundation.org
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: lwoodman@redhat.com
Cc: jbaron@redhat.com
Cc: dzickus@redhat.com
Cc: alan@lxorguk.ukuu.org.uk
---
 drivers/tty/sysrq.c   |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/sysrq.h |    2 ++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 0572889..38c6ae6 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -458,6 +458,20 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	&sysrq_ftrace_dump_op,		/* z */
 };
 
+void sysrq_release(struct kref *kref)
+{
+	struct sysrq_key_op *release_op;
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	release_op = container_of(kref, struct sysrq_key_op, kref);
+	for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++)
+		if (sysrq_key_table[i] == release_op)
+			sysrq_key_table[i] = NULL;
+	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+}
+
 /* key2index calculation, -1 on invalid index */
 static int sysrq_key_table_key2index(int key)
 {
@@ -502,7 +516,6 @@ void __handle_sysrq(int key, bool check_mask)
 	int i;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
 	 * is shown to provide the user with positive feedback.  We do not
@@ -513,7 +526,12 @@ void __handle_sysrq(int key, bool check_mask)
 	console_loglevel = 7;
 	printk(KERN_INFO "SysRq : ");
 
+	spin_lock_irqsave(&sysrq_key_table_lock, flags);
         op_p = __sysrq_get_key_op(key);
+	if (op_p)
+		kref_get(&op_p->kref);
+	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+
         if (op_p) {
 		/*
 		 * Should we check for enabled operations (/proc/sysrq-trigger
@@ -526,9 +544,14 @@ void __handle_sysrq(int key, bool check_mask)
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}
+
+		spin_lock_irqsave(&sysrq_key_table_lock, flags);
+		kref_put(&op_p->kref, sysrq_release);
+		spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 	} else {
 		printk("HELP : ");
 		/* Only print the help msg once per handler */
+		spin_lock_irqsave(&sysrq_key_table_lock, flags);
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
 				int j;
@@ -541,10 +564,10 @@ void __handle_sysrq(int key, bool check_mask)
 				printk("%s ", sysrq_key_table[i]->help_msg);
 			}
 		}
+		spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
 void handle_sysrq(int key)
@@ -837,7 +860,12 @@ static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
 	if (__sysrq_get_key_op(key) == remove_op_p) {
-		__sysrq_put_key_op(key, insert_op_p);
+		if (!remove_op_p) { /* register */
+			__sysrq_put_key_op(key, insert_op_p);
+			kref_init(&insert_op_p->kref);
+		}
+		if (!insert_op_p) /* unregister */
+			kref_put(&remove_op_p->kref, sysrq_release);
 		retval = 0;
 	} else {
 		retval = -1;
@@ -898,6 +926,14 @@ static inline void sysrq_init_procfs(void)
 
 static int __init sysrq_init(void)
 {
+	int i;
+
+	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++)
+		if (sysrq_key_table[i])
+			kref_init(&sysrq_key_table[i]->kref);
+	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
+
 	sysrq_init_procfs();
 
 	if (sysrq_on())
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 7faf933..d458f39 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -16,6 +16,7 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/kref.h>
 
 /* Enable/disable SYSRQ support by default (0==no, 1==yes). */
 #define SYSRQ_DEFAULT_ENABLE	1
@@ -36,6 +37,7 @@ struct sysrq_key_op {
 	char *help_msg;
 	char *action_msg;
 	int enable_mask;
+	struct kref kref;
 };
 
 #ifdef CONFIG_MAGIC_SYSRQ
-- 
1.7.1

