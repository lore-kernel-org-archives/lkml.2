Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0CPVGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:06:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:62121 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0CPVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:06:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/5] usb-serialy,sysrq: Run the sysrq handler in a tasklet
Date: Tue, 16 Mar 2010 16:05:46 -0500
Message-Id: <1268773546-12457-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-2-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-4-git-send-email-jason.wessel@windriver.com>
 <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Mar 2010 21:06:02.0510 (UTC) FILETIME=[7C2EAAE0:01CAC54C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sysrq is processed on the while holding the usb hcd lock, it is
impossible to drain the queue of urbs via the polling interface and
all the printk output is lost.

Using a tasklet to schedule the sysrq allows the hcd device lock to
free up, and you can issue a sysrq-t to get the task list.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/sysrq.c         |   29 +++++++++++++++++++++++++++++
 drivers/usb/serial/generic.c |    2 +-
 include/linux/sysrq.h        |    4 ++++
 3 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 1ae2de7..ad62e53 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -584,6 +584,35 @@ int unregister_sysrq_key(int key, struct sysrq_key_op *op_p)
 }
 EXPORT_SYMBOL(unregister_sysrq_key);
 
+/* The sysrq tasklet is used only in the rare case that an
+ * input/output character device processes a sysrq in its input
+ * routine while holding a lock required for the output routine for
+ * the console device.
+ */
+static struct sysrq_tasklet_data {
+	struct tty_struct *tty;
+	unsigned int key;
+	int pending;
+} priv_sysrq_data;
+
+static void sysrq_task(unsigned long args)
+{
+	handle_sysrq(priv_sysrq_data.key, priv_sysrq_data.tty);
+	priv_sysrq_data.pending = 0;
+}
+static DECLARE_TASKLET(sysrq_tasklet, sysrq_task, 0);
+
+void handle_sysrq_tasklet(int key, struct tty_struct *tty)
+{
+	if (priv_sysrq_data.pending)
+		return;
+	priv_sysrq_data.pending = 1;
+	priv_sysrq_data.key = key;
+	priv_sysrq_data.tty = tty;
+	tasklet_schedule(&sysrq_tasklet);
+}
+EXPORT_SYMBOL(handle_sysrq_tasklet);
+
 #ifdef CONFIG_PROC_FS
 /*
  * writing 'C' to /proc/sysrq-trigger is like sysrq-C
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 4dea9d7..206f181 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -558,7 +558,7 @@ int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 {
 	if (port->sysrq && port->port.console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty);
+			handle_sysrq_tasklet(ch, tty);
 			port->sysrq = 0;
 			return 1;
 		}
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 99adcdc..0ff5fb4 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -52,6 +52,7 @@ extern int __sysrq_enabled;
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
+void handle_sysrq_tasklet(int key, struct tty_struct *tty);
 void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
@@ -70,6 +71,9 @@ static inline int __reterr(void)
 static inline void handle_sysrq(int key, struct tty_struct *tty)
 {
 }
+static inline void handle_sysrq_tasklet(int key, struct tty_struct *tty)
+{
+}
 
 #define register_sysrq_key(ig,nore) __reterr()
 #define unregister_sysrq_key(ig,nore) __reterr()
-- 
1.6.4.rc1

