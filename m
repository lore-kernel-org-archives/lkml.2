Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0HDH7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:59:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0HDH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=H+YBFpgIWqTg5k9M5zYwZJGwHVTZSrXf43d0Z2yroL49W5Tz1oqqD6kIZRkxMS/qzw
         TVNOBHDnttjO7mWJqh+K6dIsbTYx7ruiHpwUh3IPHphh2WcfpAUPPcfwIEDNuoXyZqNm
         tfZaHyjsO/+bt3NY6ySbGWWDLI1nMh0BxEzCg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/3] Input: sysrq - drop tty argument form handle_sysrq()
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Date: Wed, 04 Aug 2010 00:59:06 -0700
Message-ID: <20100804075906.30647.97136.stgit@localhost.localdomain>
In-Reply-To: <20100804075602.30647.91462.stgit@localhost.localdomain>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysrq operations do not accept tty argument anymore so no need to pass
it to us.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/ia64/hp/sim/simserial.c    |    2 +-
 arch/um/drivers/mconsole_kern.c |    2 +-
 drivers/char/hangcheck-timer.c  |    2 +-
 drivers/char/hvc_console.c      |    2 +-
 drivers/char/hvsi.c             |    2 +-
 drivers/char/sysrq.c            |   11 +++++------
 drivers/s390/char/ctrlchar.c    |    4 +---
 drivers/serial/sn_console.c     |    2 +-
 drivers/usb/serial/generic.c    |    2 +-
 drivers/xen/manage.c            |    2 +-
 include/linux/serial_core.h     |    2 +-
 include/linux/sysrq.h           |   11 ++++-------
 kernel/debug/kdb/kdb_main.c     |    2 +-
 13 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 2bef526..1e8d71a 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -149,7 +149,7 @@ static  void receive_chars(struct tty_struct *tty)
 						ch = ia64_ssc(0, 0, 0, 0,
 							      SSC_GETCHAR);
 					while (!ch);
-					handle_sysrq(ch, NULL);
+					handle_sysrq(ch);
 				}
 #endif
 				seen_esc = 0;
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index de317d0..ebc6807 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -690,7 +690,7 @@ static void with_console(struct mc_request *req, void (*proc)(void *),
 static void sysrq_proc(void *arg)
 {
 	char *op = arg;
-	handle_sysrq(*op, NULL);
+	handle_sysrq(*op);
 }
 
 void mconsole_sysrq(struct mc_request *req)
diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index e024972..f953c96 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -159,7 +159,7 @@ static void hangcheck_fire(unsigned long data)
 		if (hangcheck_dump_tasks) {
 			printk(KERN_CRIT "Hangcheck: Task state:\n");
 #ifdef CONFIG_MAGIC_SYSRQ
-			handle_sysrq('t', NULL);
+			handle_sysrq('t');
 #endif  /* CONFIG_MAGIC_SYSRQ */
 		}
 		if (hangcheck_reboot) {
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 35cca4c..1f99a6f 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -651,7 +651,7 @@ int hvc_poll(struct hvc_struct *hp)
 					if (sysrq_pressed)
 						continue;
 				} else if (sysrq_pressed) {
-					handle_sysrq(buf[i], tty);
+					handle_sysrq(buf[i]);
 					sysrq_pressed = 0;
 					continue;
 				}
diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index d4b14ff..8620f7d 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -403,7 +403,7 @@ static void hvsi_insert_chars(struct hvsi_struct *hp, const char *buf, int len)
 			hp->sysrq = 1;
 			continue;
 		} else if (hp->sysrq) {
-			handle_sysrq(c, hp->tty);
+			handle_sysrq(c);
 			hp->sysrq = 0;
 			continue;
 		}
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index a892a3c..ef31bb8 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
-#include <linux/tty.h>
 #include <linux/mount.h>
 #include <linux/kdev_t.h>
 #include <linux/major.h>
@@ -493,7 +492,7 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
                 sysrq_key_table[i] = op_p;
 }
 
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
+void __handle_sysrq(int key, bool check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
@@ -545,10 +544,10 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
-void handle_sysrq(int key, struct tty_struct *tty)
+void handle_sysrq(int key)
 {
 	if (sysrq_on())
-		__handle_sysrq(key, tty, 1);
+		__handle_sysrq(key, true);
 }
 EXPORT_SYMBOL(handle_sysrq);
 
@@ -597,7 +596,7 @@ static bool sysrq_filter(struct input_handle *handle, unsigned int type,
 
 	default:
 		if (sysrq_down && value && value != 2)
-			__handle_sysrq(sysrq_xlate[code], NULL, 1);
+			__handle_sysrq(sysrq_xlate[code], true);
 		break;
 	}
 
@@ -765,7 +764,7 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
 
 		if (get_user(c, buf))
 			return -EFAULT;
-		__handle_sysrq(c, NULL, 0);
+		__handle_sysrq(c, false);
 	}
 
 	return count;
diff --git a/drivers/s390/char/ctrlchar.c b/drivers/s390/char/ctrlchar.c
index c6cbcb3..0e9a309 100644
--- a/drivers/s390/char/ctrlchar.c
+++ b/drivers/s390/char/ctrlchar.c
@@ -16,12 +16,11 @@
 
 #ifdef CONFIG_MAGIC_SYSRQ
 static int ctrlchar_sysrq_key;
-static struct tty_struct *sysrq_tty;
 
 static void
 ctrlchar_handle_sysrq(struct work_struct *work)
 {
-	handle_sysrq(ctrlchar_sysrq_key, sysrq_tty);
+	handle_sysrq(ctrlchar_sysrq_key);
 }
 
 static DECLARE_WORK(ctrlchar_work, ctrlchar_handle_sysrq);
@@ -54,7 +53,6 @@ ctrlchar_handle(const unsigned char *buf, int len, struct tty_struct *tty)
 	/* racy */
 	if (len == 3 && buf[1] == '-') {
 		ctrlchar_sysrq_key = buf[2];
-		sysrq_tty = tty;
 		schedule_work(&ctrlchar_work);
 		return CTRLCHAR_SYSRQ;
 	}
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 9794e0c..4924108 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -492,7 +492,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
                         sysrq_requested = 0;
                         if (ch && time_before(jiffies, sysrq_timeout)) {
                                 spin_unlock_irqrestore(&port->sc_port.lock, flags);
-                                handle_sysrq(ch, NULL);
+                                handle_sysrq(ch);
                                 spin_lock_irqsave(&port->sc_port.lock, flags);
                                 /* ignore actual sysrq command char */
                                 continue;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index a817ced..9587c22 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -448,7 +448,7 @@ int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 {
 	if (port->sysrq && port->port.console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty);
+			handle_sysrq(ch);
 			port->sysrq = 0;
 			return 1;
 		}
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 07e857b..3896719 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -212,7 +212,7 @@ static void sysrq_handler(struct xenbus_watch *watch, const char **vec,
 		goto again;
 
 	if (sysrq_key != '\0')
-		handle_sysrq(sysrq_key, NULL);
+		handle_sysrq(sysrq_key);
 }
 
 static struct xenbus_watch sysrq_watch = {
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f10db6e..1faf49d 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -453,7 +453,7 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 #ifdef SUPPORT_SYSRQ
 	if (port->sysrq) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, port->state->port.tty);
+			handle_sysrq(ch);
 			port->sysrq = 0;
 			return 1;
 		}
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 4ee6503..32d360a 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -16,9 +16,6 @@
 
 #include <linux/errno.h>
 
-struct pt_regs;
-struct tty_struct;
-
 /* Possible values of bitmask for enabling sysrq functions */
 /* 0x0001 is reserved for enable everything */
 #define SYSRQ_ENABLE_LOG	0x0002
@@ -44,8 +41,8 @@ struct sysrq_key_op {
  * are available -- else NULL's).
  */
 
-void handle_sysrq(int key, struct tty_struct *tty);
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
+void handle_sysrq(int key);
+void __handle_sysrq(int key, bool check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
@@ -54,11 +51,11 @@ int sysrq_toggle_support(int enable_mask);
 
 #else
 
-static inline void handle_sysrq(int key, struct tty_struct *tty)
+static inline void handle_sysrq(int key)
 {
 }
 
-static inline void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
+static inline void __handle_sysrq(int key, bool check_mask)
 {
 }
 
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index ebe4a28..4768998 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1821,7 +1821,7 @@ static int kdb_sr(int argc, const char **argv)
 	if (argc != 1)
 		return KDB_ARGCOUNT;
 	kdb_trap_printk++;
-	__handle_sysrq(*argv[1], NULL, 0);
+	__handle_sysrq(*argv[1], false);
 	kdb_trap_printk--;
 
 	return 0;

