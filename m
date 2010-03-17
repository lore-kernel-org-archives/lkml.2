Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0CQGUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:20:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33656 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0CQGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BXq3zjIJnpLAu7GP1bjhHOcLJwn1VN4wuSkYPVKQwXbRjzgLhbnDxx1aFiWPRyY33Y
         HFBgduyuDJ3vbPZy8LbAmbFOZ8pPsR/HFzCSwxnMkobZgM7l4KAb/4i9r3fbQBf+qbUp
         OFL6/8L8KoSfr6Dto8KeQiID5ACuwLGkCeNnk=
Date: Tue, 16 Mar 2010 23:19:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100317061952.GA19789@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of keeping SysRq support inside of legacy keyboard driver split
it out into a separate input handler (filter). This stops most SysRq input
events from leaking into evdev clients (some events, such as first SysRq
scancode - not keycode - event, are still leaked into both legacy keyboard
and evdev).

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/char/keyboard.c |   40 +-------
 drivers/char/sysrq.c    |  222 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/sysrq.h   |   23 +----
 kernel/sysctl.c         |   23 +++++
 4 files changed, 224 insertions(+), 84 deletions(-)


diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index ada25bb..50f6c01 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -38,7 +38,6 @@
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <linux/vt_kern.h>
-#include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
@@ -82,8 +81,7 @@ void compute_shiftstate(void);
 typedef void (k_handler_fn)(struct vc_data *vc, unsigned char value,
 			    char up_flag);
 static k_handler_fn K_HANDLERS;
-k_handler_fn *k_handler[16] = { K_HANDLERS };
-EXPORT_SYMBOL_GPL(k_handler);
+static k_handler_fn *k_handler[16] = { K_HANDLERS };
 
 #define FN_HANDLERS\
 	fn_null,	fn_enter,	fn_show_ptregs,	fn_show_mem,\
@@ -147,22 +145,6 @@ static struct ledptr {
 	unsigned char valid:1;
 } ledptrs[3];
 
-/* Simple translation table for the SysRq keys */
-
-#ifdef CONFIG_MAGIC_SYSRQ
-unsigned char kbd_sysrq_xlate[KEY_MAX + 1] =
-        "\000\0331234567890-=\177\t"                    /* 0x00 - 0x0f */
-        "qwertyuiop[]\r\000as"                          /* 0x10 - 0x1f */
-        "dfghjkl;'`\000\\zxcv"                          /* 0x20 - 0x2f */
-        "bnm,./\000*\000 \000\201\202\203\204\205"      /* 0x30 - 0x3f */
-        "\206\207\210\211\212\000\000789-456+1"         /* 0x40 - 0x4f */
-        "230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000" /* 0x50 - 0x5f */
-        "\r\000/";                                      /* 0x60 - 0x6f */
-static int sysrq_down;
-static int sysrq_alt_use;
-#endif
-static int sysrq_alt;
-
 /*
  * Notifier list for console keyboard events
  */
@@ -1108,7 +1090,8 @@ static int emulate_raw(struct vc_data *vc, unsigned int keycode,
 			 * pressing PrtSc/SysRq alone, but simply 0x54
 			 * when pressing Alt+PrtSc/SysRq.
 			 */
-			if (sysrq_alt) {
+			if (test_bit(KEY_LEFTALT, key_down) ||
+			    test_bit(KEY_RIGHTALT, key_down)) {
 				put_queue(vc, 0x54 | up_flag);
 			} else {
 				put_queue(vc, 0xe0);
@@ -1176,8 +1159,6 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 
 	kbd = kbd_table + vc->vc_num;
 
-	if (keycode == KEY_LEFTALT || keycode == KEY_RIGHTALT)
-		sysrq_alt = down ? keycode : 0;
 #ifdef CONFIG_SPARC
 	if (keycode == KEY_STOP)
 		sparc_l1_a_state = down;
@@ -1190,21 +1171,6 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
-#ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
-	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
-		if (!sysrq_down) {
-			sysrq_down = down;
-			sysrq_alt_use = sysrq_alt;
-		}
-		return;
-	}
-	if (sysrq_down && !down && keycode == sysrq_alt_use)
-		sysrq_down = 0;
-	if (sysrq_down && down && !rep) {
-		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
-		return;
-	}
-#endif
 #ifdef CONFIG_SPARC
 	if (keycode == KEY_A && sparc_l1_a_state) {
 		sparc_l1_a_state = 0;
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 1ae2de7..1883dd8 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -1,7 +1,4 @@
-/* -*- linux-c -*-
- *
- *	$Id: sysrq.c,v 1.15 1998/08/23 14:56:41 mj Exp $
- *
+/*
  *	Linux Magic System Request Key Hacks
  *
  *	(c) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
@@ -10,8 +7,13 @@
  *	(c) 2000 Crutcher Dunnavant <crutcher+kernel@datastacks.com>
  *	overhauled to use key registration
  *	based upon discusions in irc://irc.openprojects.net/#kernelnewbies
+ *
+ *	Copyright (c) 2010 Dmitry Torokhov
+ *	Input handler conversion
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
@@ -38,33 +40,34 @@
 #include <linux/workqueue.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
+#include <linux/input.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
 
 /* Whether we react on sysrq keys or just ignore them */
-int __read_mostly __sysrq_enabled = 1;
+static int __read_mostly sysrq_enabled = 1;
+static bool __read_mostly sysrq_always_enabled;
 
-static int __read_mostly sysrq_always_enabled;
-
-int sysrq_on(void)
+static bool sysrq_on(void)
 {
-	return __sysrq_enabled || sysrq_always_enabled;
+	return sysrq_enabled || sysrq_always_enabled;
 }
 
 /*
  * A value of 1 means 'all', other nonzero values are an op mask:
  */
-static inline int sysrq_on_mask(int mask)
+static bool sysrq_on_mask(int mask)
 {
-	return sysrq_always_enabled || __sysrq_enabled == 1 ||
-						(__sysrq_enabled & mask);
+	return sysrq_always_enabled ||
+	       sysrq_enabled == 1 ||
+	       (sysrq_enabled & mask);
 }
 
 static int __init sysrq_always_enabled_setup(char *str)
 {
-	sysrq_always_enabled = 1;
-	printk(KERN_INFO "debug: sysrq always enabled.\n");
+	sysrq_always_enabled = true;
+	pr_info("sysrq always enabled.\n");
 
 	return 1;
 }
@@ -75,6 +78,7 @@ __setup("sysrq_always_enabled", sysrq_always_enabled_setup);
 static void sysrq_handle_loglevel(int key, struct tty_struct *tty)
 {
 	int i;
+
 	i = key - '0';
 	console_loglevel = 7;
 	printk("Loglevel set to %d\n", i);
@@ -100,7 +104,7 @@ static struct sysrq_key_op sysrq_SAK_op = {
 	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
 };
 #else
-#define sysrq_SAK_op (*(struct sysrq_key_op *)0)
+#define sysrq_SAK_op (*(struct sysrq_key_op *)NULL)
 #endif
 
 #ifdef CONFIG_VT
@@ -118,7 +122,7 @@ static struct sysrq_key_op sysrq_unraw_op = {
 	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
 };
 #else
-#define sysrq_unraw_op (*(struct sysrq_key_op *)0)
+#define sysrq_unraw_op (*(struct sysrq_key_op *)NULL)
 #endif /* CONFIG_VT */
 
 static void sysrq_handle_crash(int key, struct tty_struct *tty)
@@ -194,7 +198,7 @@ static struct sysrq_key_op sysrq_showlocks_op = {
 	.action_msg	= "Show Locks Held",
 };
 #else
-#define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
+#define sysrq_showlocks_op (*(struct sysrq_key_op *)NULL)
 #endif
 
 #ifdef CONFIG_SMP
@@ -297,7 +301,7 @@ static struct sysrq_key_op sysrq_ftrace_dump_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 #else
-#define sysrq_ftrace_dump_op (*(struct sysrq_key_op *)0)
+#define sysrq_ftrace_dump_op (*(struct sysrq_key_op *)NULL)
 #endif
 
 static void sysrq_handle_showmem(int key, struct tty_struct *tty)
@@ -476,6 +480,7 @@ struct sysrq_key_op *__sysrq_get_key_op(int key)
 	i = sysrq_key_table_key2index(key);
 	if (i != -1)
 	        op_p = sysrq_key_table[i];
+
         return op_p;
 }
 
@@ -487,11 +492,7 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
                 sysrq_key_table[i] = op_p;
 }
 
-/*
- * This is the non-locking version of handle_sysrq.  It must/can only be called
- * by sysrq key handlers, as they are inside of the lock
- */
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
+static void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
@@ -543,10 +544,6 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
-/*
- * This function is called by the keyboard handler when SysRq is pressed
- * and any other keycode arrives.
- */
 void handle_sysrq(int key, struct tty_struct *tty)
 {
 	if (sysrq_on())
@@ -554,6 +551,148 @@ void handle_sysrq(int key, struct tty_struct *tty)
 }
 EXPORT_SYMBOL(handle_sysrq);
 
+/* Simple translation table for the SysRq keys */
+static const unsigned char sysrq_xlate[KEY_MAX + 1] =
+        "\000\0331234567890-=\177\t"                    /* 0x00 - 0x0f */
+        "qwertyuiop[]\r\000as"                          /* 0x10 - 0x1f */
+        "dfghjkl;'`\000\\zxcv"                          /* 0x20 - 0x2f */
+        "bnm,./\000*\000 \000\201\202\203\204\205"      /* 0x30 - 0x3f */
+        "\206\207\210\211\212\000\000789-456+1"         /* 0x40 - 0x4f */
+        "230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000" /* 0x50 - 0x5f */
+        "\r\000/";                                      /* 0x60 - 0x6f */
+
+static bool sysrq_down;
+static int sysrq_alt_use;
+static int sysrq_alt;
+
+static bool sysrq_filter(struct input_handle *handle, unsigned int type,
+		         unsigned int code, int value)
+{
+
+	if (type != EV_KEY)
+		goto out;
+
+	switch (code) {
+
+	case KEY_LEFTALT:
+	case KEY_RIGHTALT:
+		if (value)
+			sysrq_alt = code;
+		else if (sysrq_down && code == sysrq_alt_use)
+			sysrq_down = false;
+		break;
+
+	case KEY_SYSRQ:
+		if (value == 1 && sysrq_alt) {
+			sysrq_down = true;
+			sysrq_alt_use = sysrq_alt;
+		}
+
+		break;
+
+	default:
+		if (sysrq_down && value && value != 2) {
+			struct vc_data *vc = vc_cons[fg_console].d;
+
+			__handle_sysrq(sysrq_xlate[code], vc->vc_tty, 1);
+		}
+	}
+
+out:
+	return sysrq_down;
+}
+
+static int sysrq_connect(struct input_handler *handler,
+			 struct input_dev *dev,
+			 const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int error;
+
+	sysrq_down = false;
+	sysrq_alt = 0;
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "sysrq";
+
+	error = input_register_handle(handle);
+	if (error) {
+		pr_err("Failed to register input sysrq handler, error %d\n",
+			error);
+		goto err_free;
+	}
+
+	error = input_open_device(handle);
+	if (error) {
+		pr_err("Failed to open input device, error %d\n", error);
+		goto err_unregister;
+	}
+
+	return 0;
+
+ err_unregister:
+	input_unregister_handle(handle);
+ err_free:
+	kfree(handle);
+	return error;
+}
+
+static void sysrq_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+/*
+ * We are matching on KEY_LEFTALT insteard of KEY_SYSRQ because not all
+ * keyboards have SysRq ikey predefined and so user may add it to keymap
+ * later, but we expect all such keyboards to have left alt.
+ */
+static const struct input_device_id sysrq_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
+				INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { BIT_MASK(KEY_LEFTALT) },
+	},
+	{ },
+};
+
+static struct input_handler sysrq_handler = {
+	.filter		= sysrq_filter,
+	.connect	= sysrq_connect,
+	.disconnect	= sysrq_disconnect,
+	.name		= "sysrq",
+	.id_table	= sysrq_ids,
+};
+
+int sysrq_toggle_support(int enable_mask)
+{
+	bool was_enabled = sysrq_on();
+	int error;
+
+	sysrq_enabled = enable_mask;
+
+	if (was_enabled != sysrq_on()) {
+		if (sysrq_on()) {
+			error = input_register_handler(&sysrq_handler);
+			if (error)
+				pr_err("Failed to register input handler, error %d",
+					error);
+
+		} else
+			input_unregister_handler(&sysrq_handler);
+	}
+
+	return 0;
+}
+
 static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
                                 struct sysrq_key_op *remove_op_p)
 {
@@ -598,6 +737,7 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
 			return -EFAULT;
 		__handle_sysrq(c, NULL, 0);
 	}
+
 	return count;
 }
 
@@ -605,10 +745,34 @@ static const struct file_operations proc_sysrq_trigger_operations = {
 	.write		= write_sysrq_trigger,
 };
 
+static void sysrq_init_procfs(void)
+{
+	if (!proc_create("sysrq-trigger", S_IWUSR, NULL,
+			 &proc_sysrq_trigger_operations))
+		pr_err("Failed to register proc interface\n");
+}
+
+#else
+
+static inline void sysrq_init_procfs(void)
+{
+}
+
+#endif
+
 static int __init sysrq_init(void)
 {
-	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
+	int error;
+
+	sysrq_init_procfs();
+
+	if (sysrq_on()) {
+		error = input_register_handler(&sysrq_handler);
+		if (error)
+			pr_err("Failed to register input handler, error %d",
+				error);
+	}
+
 	return 0;
 }
 module_init(sysrq_init);
-#endif
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 99adcdc..5f2bdef 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -39,41 +39,30 @@ struct sysrq_key_op {
 
 #ifdef CONFIG_MAGIC_SYSRQ
 
-extern int sysrq_on(void);
-
-/*
- * Do not use this one directly:
- */
-extern int __sysrq_enabled;
-
 /* Generic SysRq interface -- you may call it from any device driver, supplying
  * ASCII code of the key, pointer to registers and kbd/tty structs (if they
  * are available -- else NULL's).
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
-void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
 
+int sysrq_toggle_support(int enable_mask);
+
 #else
 
-static inline int sysrq_on(void)
-{
-	return 0;
-}
-static inline int __reterr(void)
+static inline int register_sysrq_key(int key, struct sysrq_key_op *op)
 {
 	return -EINVAL;
 }
-static inline void handle_sysrq(int key, struct tty_struct *tty)
+
+static inline int unregister_sysrq_key(int key, struct sysrq_key_op *op)
 {
+	return -EINVAL;
 }
 
-#define register_sysrq_key(ig,nore) __reterr()
-#define unregister_sysrq_key(ig,nore) __reterr()
-
 #endif
 
 #endif /* _LINUX_SYSRQ_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..ce724a0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -163,6 +163,27 @@ static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_MAGIC_SYSRQ
+static int __sysrq_enabled; /* Note: sysrq code ises it's own private copy */
+
+static int sysrq_sysctl_handler(ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	int error;
+
+	error = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (error)
+		return error;
+
+	if (write)
+		sysrq_toggle_support(__sysrq_enabled);
+
+	return 0;
+}
+
+#endif
+
 static struct ctl_table root_table[];
 static struct ctl_table_root sysctl_table_root;
 static struct ctl_table_header root_table_header = {
@@ -567,7 +588,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= sysrq_sysctl_handler,
 	},
 #endif
 #ifdef CONFIG_PROC_SYSCTL

-- 
Dmitry
