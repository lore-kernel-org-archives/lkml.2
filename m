Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab2B1OfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:35:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46356 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2B1OfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:35:15 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] vt:tackle kbd_table
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 14:49:23 +0000
Message-ID: <20120228144913.14943.49920.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Keyboard struct lifetime is easy, but the locking is not and is completely
ignored by the existing code. Tackle this one head on

- Make the kbd_table private so we can run down all direct users
- Hoick the relevant ioctl handlers into the keyboard layer
- Lock them with the keyboard lock so they don't change mid keypress
- Add helpers for things like console stop/start so we isolate the poking
  around properly
- Tweak the braille console so it still builds

There are a couple of FIXME locking cases left for ioctls that are so hideous
they should be addressed in a later patch. After this patch the kbd_table is
private and all the keyboard jiggery pokery is in one place.

This update fixes speakup and also a memory leak in the original.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/accessibility/braille/braille_console.c |    9 
 drivers/staging/speakup/main.c                  |    8 
 drivers/tty/sysrq.c                             |    6 
 drivers/tty/vt/keyboard.c                       |  621 ++++++++++++++++++++++-
 drivers/tty/vt/selection.c                      |    9 
 drivers/tty/vt/vt.c                             |   27 -
 drivers/tty/vt/vt_ioctl.c                       |  325 +-----------
 include/linux/kbd_kern.h                        |    7 
 include/linux/keyboard.h                        |    2 
 include/linux/vt_kern.h                         |   23 +
 10 files changed, 660 insertions(+), 377 deletions(-)


diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index c339a08..d21167b 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -244,16 +244,13 @@ static int keyboard_notifier_call(struct notifier_block *blk,
 
 			switch (val) {
 			case KVAL(K_CAPS):
-				on_off = vc_kbd_led(kbd_table + fg_console,
-						VC_CAPSLOCK);
+				on_off = vt_get_leds(fg_console, VC_CAPSLOCK);
 				break;
 			case KVAL(K_NUM):
-				on_off = vc_kbd_led(kbd_table + fg_console,
-						VC_NUMLOCK);
+				on_off = vt_get_leds(fg_console, VC_NUMLOCK);
 				break;
 			case KVAL(K_HOLD):
-				on_off = vc_kbd_led(kbd_table + fg_console,
-						VC_SCROLLOCK);
+				on_off = vt_get_leds(fg_console, VC_SCROLLOCK);
 				break;
 			}
 			if (on_off == 1)
diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index c7b03f0..92b34e2 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1731,15 +1731,15 @@ static void do_handle_spec(struct vc_data *vc, u_char value, char up_flag)
 	switch (value) {
 	case KVAL(K_CAPS):
 		label = msg_get(MSG_KEYNAME_CAPSLOCK);
-		on_off = (vc_kbd_led(kbd_table + vc->vc_num, VC_CAPSLOCK));
+		on_off = vt_get_leds(fg_console, VC_CAPSLOCK);
 		break;
 	case KVAL(K_NUM):
 		label = msg_get(MSG_KEYNAME_NUMLOCK);
-		on_off = (vc_kbd_led(kbd_table + vc->vc_num, VC_NUMLOCK));
+		on_off = vt_get_leds(fg_console, VC_NUMLOCK);
 		break;
 	case KVAL(K_HOLD):
 		label = msg_get(MSG_KEYNAME_SCROLLLOCK);
-		on_off = (vc_kbd_led(kbd_table + vc->vc_num, VC_SCROLLOCK));
+		on_off = vt_get_leds(fg_console, VC_SCROLLOCK);
 		if (speakup_console[vc->vc_num])
 			speakup_console[vc->vc_num]->tty_stopped = on_off;
 		break;
@@ -2020,7 +2020,7 @@ speakup_key(struct vc_data *vc, int shift_state, int keycode, u_short keysym,
 	if (type >= 0xf0)
 		type -= 0xf0;
 	if (type == KT_PAD
-		&& (vc_kbd_led(kbd_table + fg_console, VC_NUMLOCK))) {
+		&& (vt_get_leds(fg_console, VC_NUMLOCK))) {
 		if (up_flag) {
 			spk_keydown = 0;
 			goto out;
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 8db9125..ecb8e22 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -110,11 +110,9 @@ static struct sysrq_key_op sysrq_SAK_op = {
 #ifdef CONFIG_VT
 static void sysrq_handle_unraw(int key)
 {
-	struct kbd_struct *kbd = &kbd_table[fg_console];
-
-	if (kbd)
-		kbd->kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
+	vt_reset_unicode(fg_console);
 }
+
 static struct sysrq_key_op sysrq_unraw_op = {
 	.handler	= sysrq_handle_unraw,
 	.help_msg	= "unRaw",
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 0479114..4d138b8 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -67,8 +67,6 @@ extern void ctrl_alt_del(void);
 
 #define KBD_DEFLOCK 0
 
-void compute_shiftstate(void);
-
 /*
  * Handler Tables.
  */
@@ -99,35 +97,29 @@ static fn_handler_fn *fn_handler[] = { FN_HANDLERS };
  * Variables exported for vt_ioctl.c
  */
 
-/* maximum values each key_handler can handle */
-const int max_vals[] = {
-	255, ARRAY_SIZE(func_table) - 1, ARRAY_SIZE(fn_handler) - 1, NR_PAD - 1,
-	NR_DEAD - 1, 255, 3, NR_SHIFT - 1, 255, NR_ASCII - 1, NR_LOCK - 1,
-	255, NR_LOCK - 1, 255, NR_BRL - 1
-};
-
-const int NR_TYPES = ARRAY_SIZE(max_vals);
-
-struct kbd_struct kbd_table[MAX_NR_CONSOLES];
-EXPORT_SYMBOL_GPL(kbd_table);
-static struct kbd_struct *kbd = kbd_table;
-
 struct vt_spawn_console vt_spawn_con = {
 	.lock = __SPIN_LOCK_UNLOCKED(vt_spawn_con.lock),
 	.pid  = NULL,
 	.sig  = 0,
 };
 
-/*
- * Variables exported for vt.c
- */
-
-int shift_state = 0;
 
 /*
  * Internal Data.
  */
 
+static struct kbd_struct kbd_table[MAX_NR_CONSOLES];
+static struct kbd_struct *kbd = kbd_table;
+
+/* maximum values each key_handler can handle */
+static const int max_vals[] = {
+	255, ARRAY_SIZE(func_table) - 1, ARRAY_SIZE(fn_handler) - 1, NR_PAD - 1,
+	NR_DEAD - 1, 255, 3, NR_SHIFT - 1, 255, NR_ASCII - 1, NR_LOCK - 1,
+	255, NR_LOCK - 1, 255, NR_BRL - 1
+};
+
+static const int NR_TYPES = ARRAY_SIZE(max_vals);
+
 static struct input_handler kbd_handler;
 static DEFINE_SPINLOCK(kbd_event_lock);
 static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bitmap */
@@ -137,6 +129,8 @@ static int npadch = -1;					/* -1 or number assembled on pad */
 static unsigned int diacr;
 static char rep;					/* flag telling character repeat */
 
+static int shift_state = 0;
+
 static unsigned char ledstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
@@ -187,7 +181,7 @@ static int getkeycode_helper(struct input_handle *handle, void *data)
 	return d->error == 0; /* stop as soon as we successfully get one */
 }
 
-int getkeycode(unsigned int scancode)
+static int getkeycode(unsigned int scancode)
 {
 	struct getset_keycode_data d = {
 		.ke	= {
@@ -214,7 +208,7 @@ static int setkeycode_helper(struct input_handle *handle, void *data)
 	return d->error == 0; /* stop as soon as we successfully set one */
 }
 
-int setkeycode(unsigned int scancode, unsigned int keycode)
+static int setkeycode(unsigned int scancode, unsigned int keycode)
 {
 	struct getset_keycode_data d = {
 		.ke	= {
@@ -382,9 +376,11 @@ static void to_utf8(struct vc_data *vc, uint c)
 /*
  * Called after returning from RAW mode or when changing consoles - recompute
  * shift_down[] and shift_state from key_down[] maybe called when keymap is
- * undefined, so that shiftkey release is seen
+ * undefined, so that shiftkey release is seen. The caller must hold the
+ * kbd_event_lock.
  */
-void compute_shiftstate(void)
+
+static void do_compute_shiftstate(void)
 {
 	unsigned int i, j, k, sym, val;
 
@@ -417,6 +413,15 @@ void compute_shiftstate(void)
 	}
 }
 
+/* We still have to export this method to vt.c */
+void compute_shiftstate(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	do_compute_shiftstate();
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
 /*
  * We have a combining character DIACR here, followed by the character CH.
  * If the combination occurs in the table, return the corresponding value.
@@ -636,7 +641,7 @@ static void fn_SAK(struct vc_data *vc)
 
 static void fn_null(struct vc_data *vc)
 {
-	compute_shiftstate();
+	do_compute_shiftstate();
 }
 
 /*
@@ -989,6 +994,8 @@ unsigned char getledstate(void)
 
 void setledstate(struct kbd_struct *kbd, unsigned int led)
 {
+        unsigned long flags;
+        spin_lock_irqsave(&kbd_event_lock, flags);
 	if (!(led & ~7)) {
 		ledioctl = led;
 		kbd->ledmode = LED_SHOW_IOCTL;
@@ -996,6 +1003,7 @@ void setledstate(struct kbd_struct *kbd, unsigned int led)
 		kbd->ledmode = LED_SHOW_FLAGS;
 
 	set_leds();
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
 }
 
 static inline unsigned char getleds(void)
@@ -1035,6 +1043,75 @@ static int kbd_update_leds_helper(struct input_handle *handle, void *data)
 	return 0;
 }
 
+/**
+ *	vt_get_leds	-	helper for braille console
+ *	@console: console to read
+ *	@flag: flag we want to check
+ *
+ *	Check the status of a keyboard led flag and report it back
+ */
+int vt_get_leds(int console, int flag)
+{
+	unsigned long flags;
+	struct kbd_struct * kbd = kbd_table + console;
+	int ret;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	ret = vc_kbd_led(kbd, flag);
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vt_get_leds);
+
+/**
+ *	vt_set_led_state	-	set LED state of a console
+ *	@console: console to set
+ *	@leds: LED bits
+ *
+ *	Set the LEDs on a console. This is a wrapper for the VT layer
+ *	so that we can keep kbd knowledge internal
+ */
+void vt_set_led_state(int console, int leds)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	setledstate(kbd, leds);
+}
+
+/**
+ *	vt_kbd_con_start	-	Keyboard side of console start
+ *	@console: console
+ *
+ *	Handle console start. This is a wrapper for the VT layer
+ *	so that we can keep kbd knowledge internal
+ */
+void vt_kbd_con_start(int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	unsigned long flags;
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	clr_vc_kbd_led(kbd, VC_SCROLLOCK);
+	set_leds();
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
+/**
+ *	vt_kbd_con_stop		-	Keyboard side of console stop
+ *	@console: console
+ *
+ *	Handle console stop. This is a wrapper for the VT layer
+ *	so that we can keep kbd knowledge internal
+ */
+void vt_kbd_con_stop(int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	unsigned long flags;
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	set_vc_kbd_led(kbd, VC_SCROLLOCK);
+	set_leds();
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
 /*
  * This is the tasklet that updates LED state on all keyboards
  * attached to the box. The reason we use tasklet is that we
@@ -1254,7 +1331,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	if (rc == NOTIFY_STOP || !key_map) {
 		atomic_notifier_call_chain(&keyboard_notifier_list,
 					   KBD_UNBOUND_KEYCODE, &param);
-		compute_shiftstate();
+		do_compute_shiftstate();
 		kbd->slockstate = 0;
 		return;
 	}
@@ -1614,3 +1691,495 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 	}
 	return ret;
 }
+
+/**
+ *	vt_do_kdskbmode		-	set keyboard mode ioctl
+ *	@console: the console to use
+ *	@arg: the requested mode
+ *
+ *	Update the keyboard mode bits while holding the correct locks.
+ *	Return 0 for success or an error code.
+ */
+int vt_do_kdskbmode(int console, unsigned int arg)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	switch(arg) {
+	case K_RAW:
+		kbd->kbdmode = VC_RAW;
+		break;
+	case K_MEDIUMRAW:
+		kbd->kbdmode = VC_MEDIUMRAW;
+		break;
+	case K_XLATE:
+		kbd->kbdmode = VC_XLATE;
+		do_compute_shiftstate();
+		break;
+	case K_UNICODE:
+		kbd->kbdmode = VC_UNICODE;
+		do_compute_shiftstate();
+		break;
+	case K_OFF:
+		kbd->kbdmode = VC_OFF;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+	return ret;
+}
+
+/**
+ *	vt_do_kdskbmeta		-	set keyboard meta state
+ *	@console: the console to use
+ *	@arg: the requested meta state
+ *
+ *	Update the keyboard meta bits while holding the correct locks.
+ *	Return 0 for success or an error code.
+ */
+int vt_do_kdskbmeta(int console, unsigned int arg)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	switch(arg) {
+	case K_METABIT:
+		clr_vc_kbd_mode(kbd, VC_META);
+		break;
+	case K_ESCPREFIX:
+		set_vc_kbd_mode(kbd, VC_META);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+	return ret;
+}
+
+int vt_do_kbkeycode_ioctl(int cmd, struct kbkeycode __user *user_kbkc,
+								int perm)
+{
+	struct kbkeycode tmp;
+	int kc = 0;
+
+	if (copy_from_user(&tmp, user_kbkc, sizeof(struct kbkeycode)))
+		return -EFAULT;
+	switch (cmd) {
+	case KDGETKEYCODE:
+		kc = getkeycode(tmp.scancode);
+		if (kc >= 0)
+			kc = put_user(kc, &user_kbkc->keycode);
+		break;
+	case KDSETKEYCODE:
+		if (!perm)
+			return -EPERM;
+		kc = setkeycode(tmp.scancode, tmp.keycode);
+		break;
+	}
+	return kc;
+}
+
+#define i (tmp.kb_index)
+#define s (tmp.kb_table)
+#define v (tmp.kb_value)
+
+int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
+						int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	struct kbentry tmp;
+	ushort *key_map, *new_map, val, ov;
+	unsigned long flags;
+
+	if (copy_from_user(&tmp, user_kbe, sizeof(struct kbentry)))
+		return -EFAULT;
+
+	if (!capable(CAP_SYS_TTY_CONFIG))
+		perm = 0;
+
+	switch (cmd) {
+	case KDGKBENT:
+		/* Ensure another thread doesn't free it under us */
+		spin_lock_irqsave(&kbd_event_lock, flags);
+		key_map = key_maps[s];
+		if (key_map) {
+		    val = U(key_map[i]);
+		    if (kbd->kbdmode != VC_UNICODE && KTYP(val) >= NR_TYPES)
+			val = K_HOLE;
+		} else
+		    val = (i ? K_HOLE : K_NOSUCHMAP);
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+		return put_user(val, &user_kbe->kb_value);
+	case KDSKBENT:
+		if (!perm)
+			return -EPERM;
+		if (!i && v == K_NOSUCHMAP) {
+			spin_lock_irqsave(&kbd_event_lock, flags);
+			/* deallocate map */
+			key_map = key_maps[s];
+			if (s && key_map) {
+			    key_maps[s] = NULL;
+			    if (key_map[0] == U(K_ALLOCATED)) {
+					kfree(key_map);
+					keymap_count--;
+			    }
+			}
+			spin_unlock_irqrestore(&kbd_event_lock, flags);
+			break;
+		}
+
+		if (KTYP(v) < NR_TYPES) {
+		    if (KVAL(v) > max_vals[KTYP(v)])
+				return -EINVAL;
+		} else
+		    if (kbd->kbdmode != VC_UNICODE)
+				return -EINVAL;
+
+		/* ++Geert: non-PC keyboards may generate keycode zero */
+#if !defined(__mc68000__) && !defined(__powerpc__)
+		/* assignment to entry 0 only tests validity of args */
+		if (!i)
+			break;
+#endif
+
+		new_map = kmalloc(sizeof(plain_map), GFP_KERNEL);
+		if (!new_map)
+			return -ENOMEM;
+		spin_lock_irqsave(&kbd_event_lock, flags);
+		key_map = key_maps[s];
+		if (key_map == NULL) {
+			int j;
+
+			if (keymap_count >= MAX_NR_OF_USER_KEYMAPS &&
+			    !capable(CAP_SYS_RESOURCE)) {
+				spin_unlock_irqrestore(&kbd_event_lock, flags);
+				kfree(new_map);
+				return -EPERM;
+			}
+			key_maps[s] = new_map;
+			key_map[0] = U(K_ALLOCATED);
+			for (j = 1; j < NR_KEYS; j++)
+				key_map[j] = U(K_HOLE);
+			keymap_count++;
+		} else
+			kfree(new_map);
+
+		ov = U(key_map[i]);
+		if (v == ov)
+			goto out;
+		/*
+		 * Attention Key.
+		 */
+		if (((ov == K_SAK) || (v == K_SAK)) && !capable(CAP_SYS_ADMIN)) {
+			spin_unlock_irqrestore(&kbd_event_lock, flags);
+			return -EPERM;
+		}
+		key_map[i] = U(v);
+		if (!s && (KTYP(ov) == KT_SHIFT || KTYP(v) == KT_SHIFT))
+			do_compute_shiftstate();
+out:
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+		break;
+	}
+	return 0;
+}
+#undef i
+#undef s
+#undef v
+
+/* FIXME: This one needs untangling and locking */
+int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
+{
+	struct kbsentry *kbs;
+	char *p;
+	u_char *q;
+	u_char __user *up;
+	int sz;
+	int delta;
+	char *first_free, *fj, *fnw;
+	int i, j, k;
+	int ret;
+
+	if (!capable(CAP_SYS_TTY_CONFIG))
+		perm = 0;
+
+	kbs = kmalloc(sizeof(*kbs), GFP_KERNEL);
+	if (!kbs) {
+		ret = -ENOMEM;
+		goto reterr;
+	}
+
+	/* we mostly copy too much here (512bytes), but who cares ;) */
+	if (copy_from_user(kbs, user_kdgkb, sizeof(struct kbsentry))) {
+		ret = -EFAULT;
+		goto reterr;
+	}
+	kbs->kb_string[sizeof(kbs->kb_string)-1] = '\0';
+	i = kbs->kb_func;
+
+	switch (cmd) {
+	case KDGKBSENT:
+		sz = sizeof(kbs->kb_string) - 1; /* sz should have been
+						  a struct member */
+		up = user_kdgkb->kb_string;
+		p = func_table[i];
+		if(p)
+			for ( ; *p && sz; p++, sz--)
+				if (put_user(*p, up++)) {
+					ret = -EFAULT;
+					goto reterr;
+				}
+		if (put_user('\0', up)) {
+			ret = -EFAULT;
+			goto reterr;
+		}
+		kfree(kbs);
+		return ((p && *p) ? -EOVERFLOW : 0);
+	case KDSKBSENT:
+		if (!perm) {
+			ret = -EPERM;
+			goto reterr;
+		}
+
+		q = func_table[i];
+		first_free = funcbufptr + (funcbufsize - funcbufleft);
+		for (j = i+1; j < MAX_NR_FUNC && !func_table[j]; j++)
+			;
+		if (j < MAX_NR_FUNC)
+			fj = func_table[j];
+		else
+			fj = first_free;
+
+		delta = (q ? -strlen(q) : 1) + strlen(kbs->kb_string);
+		if (delta <= funcbufleft) { 	/* it fits in current buf */
+		    if (j < MAX_NR_FUNC) {
+			memmove(fj + delta, fj, first_free - fj);
+			for (k = j; k < MAX_NR_FUNC; k++)
+			    if (func_table[k])
+				func_table[k] += delta;
+		    }
+		    if (!q)
+		      func_table[i] = fj;
+		    funcbufleft -= delta;
+		} else {			/* allocate a larger buffer */
+		    sz = 256;
+		    while (sz < funcbufsize - funcbufleft + delta)
+		      sz <<= 1;
+		    fnw = kmalloc(sz, GFP_KERNEL);
+		    if(!fnw) {
+		      ret = -ENOMEM;
+		      goto reterr;
+		    }
+
+		    if (!q)
+		      func_table[i] = fj;
+		    if (fj > funcbufptr)
+			memmove(fnw, funcbufptr, fj - funcbufptr);
+		    for (k = 0; k < j; k++)
+		      if (func_table[k])
+			func_table[k] = fnw + (func_table[k] - funcbufptr);
+
+		    if (first_free > fj) {
+			memmove(fnw + (fj - funcbufptr) + delta, fj, first_free - fj);
+			for (k = j; k < MAX_NR_FUNC; k++)
+			  if (func_table[k])
+			    func_table[k] = fnw + (func_table[k] - funcbufptr) + delta;
+		    }
+		    if (funcbufptr != func_buf)
+		      kfree(funcbufptr);
+		    funcbufptr = fnw;
+		    funcbufleft = funcbufleft - delta + sz - funcbufsize;
+		    funcbufsize = sz;
+		}
+		strcpy(func_table[i], kbs->kb_string);
+		break;
+	}
+	ret = 0;
+reterr:
+	kfree(kbs);
+	return ret;
+}
+
+int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+        unsigned long flags;
+	unsigned char ucval;
+
+        switch(cmd) {
+	/* the ioctls below read/set the flags usually shown in the leds */
+	/* don't use them - they will go away without warning */
+	case KDGKBLED:
+                spin_lock_irqsave(&kbd_event_lock, flags);
+		ucval = kbd->ledflagstate | (kbd->default_ledflagstate << 4);
+                spin_unlock_irqrestore(&kbd_event_lock, flags);
+		return put_user(ucval, (char __user *)arg);
+
+	case KDSKBLED:
+		if (!perm)
+			return -EPERM;
+		if (arg & ~0x77)
+			return -EINVAL;
+                spin_lock_irqsave(&kbd_event_lock, flags);
+		kbd->ledflagstate = (arg & 7);
+		kbd->default_ledflagstate = ((arg >> 4) & 7);
+		set_leds();
+                spin_unlock_irqrestore(&kbd_event_lock, flags);
+		break;
+
+	/* the ioctls below only set the lights, not the functions */
+	/* for those, see KDGKBLED and KDSKBLED above */
+	case KDGETLED:
+		ucval = getledstate();
+		return put_user(ucval, (char __user *)arg);
+
+	case KDSETLED:
+		if (!perm)
+			return -EPERM;
+		setledstate(kbd, arg);
+		return 0;
+        }
+        return -ENOIOCTLCMD;
+}
+
+int vt_do_kdgkbmode(int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	/* This is a spot read so needs no locking */
+	switch (kbd->kbdmode) {
+	case VC_RAW:
+		return K_RAW;
+	case VC_MEDIUMRAW:
+		return K_MEDIUMRAW;
+	case VC_UNICODE:
+		return K_UNICODE;
+	case VC_OFF:
+		return K_OFF;
+	default:
+		return K_XLATE;
+	}
+}
+
+/**
+ *	vt_do_kdgkbmeta		-	report meta status
+ *	@console: console to report
+ *
+ *	Report the meta flag status of this console
+ */
+int vt_do_kdgkbmeta(int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+        /* Again a spot read so no locking */
+	return vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT;
+}
+
+/**
+ *	vt_reset_unicode	-	reset the unicode status
+ *	@console: console being reset
+ *
+ *	Restore the unicode console state to its default
+ */
+void vt_reset_unicode(int console)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	kbd_table[console].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
+/**
+ *	vt_get_shiftstate	-	shift bit state
+ *
+ *	Report the shift bits from the keyboard state. We have to export
+ *	this to support some oddities in the vt layer.
+ */
+int vt_get_shift_state(void)
+{
+        /* Don't lock as this is a transient report */
+        return shift_state;
+}
+
+/**
+ *	vt_reset_keyboard	-	reset keyboard state
+ *	@console: console to reset
+ *
+ *	Reset the keyboard bits for a console as part of a general console
+ *	reset event
+ */
+void vt_reset_keyboard(int console)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	set_vc_kbd_mode(kbd, VC_REPEAT);
+	clr_vc_kbd_mode(kbd, VC_CKMODE);
+	clr_vc_kbd_mode(kbd, VC_APPLIC);
+	clr_vc_kbd_mode(kbd, VC_CRLF);
+	kbd->lockstate = 0;
+	kbd->slockstate = 0;
+	kbd->ledmode = LED_SHOW_FLAGS;
+	kbd->ledflagstate = kbd->default_ledflagstate;
+	/* do not do set_leds here because this causes an endless tasklet loop
+	   when the keyboard hasn't been initialized yet */
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
+/**
+ *	vt_get_kbd_mode_bit	-	read keyboard status bits
+ *	@console: console to read from
+ *	@bit: mode bit to read
+ *
+ *	Report back a vt mode bit. We do this without locking so the
+ *	caller must be sure that there are no synchronization needs
+ */
+
+int vt_get_kbd_mode_bit(int console, int bit)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	return vc_kbd_mode(kbd, bit);
+}
+
+/**
+ *	vt_set_kbd_mode_bit	-	read keyboard status bits
+ *	@console: console to read from
+ *	@bit: mode bit to read
+ *
+ *	Set a vt mode bit. We do this without locking so the
+ *	caller must be sure that there are no synchronization needs
+ */
+
+void vt_set_kbd_mode_bit(int console, int bit)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	set_vc_kbd_mode(kbd, bit);
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
+
+/**
+ *	vt_clr_kbd_mode_bit	-	read keyboard status bits
+ *	@console: console to read from
+ *	@bit: mode bit to read
+ *
+ *	Report back a vt mode bit. We do this without locking so the
+ *	caller must be sure that there are no synchronization needs
+ */
+
+void vt_clr_kbd_mode_bit(int console, int bit)
+{
+	struct kbd_struct * kbd = kbd_table + console;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_event_lock, flags);
+	clr_vc_kbd_mode(kbd, bit);
+	spin_unlock_irqrestore(&kbd_event_lock, flags);
+}
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 7a0a12a..738e45a 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -30,6 +30,7 @@
 
 extern void poke_blanked_console(void);
 
+/* FIXME: all this needs locking */
 /* Variables for selection control. */
 /* Use a dynamic buffer, instead of static (Dec 1994) */
 struct vc_data *sel_cons;		/* must not be deallocated */
@@ -138,7 +139,7 @@ int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *t
 	char *bp, *obp;
 	int i, ps, pe, multiplier;
 	u16 c;
-	struct kbd_struct *kbd = kbd_table + fg_console;
+	int mode;
 
 	poke_blanked_console();
 
@@ -182,7 +183,11 @@ int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *t
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
 	}
-	use_unicode = kbd && kbd->kbdmode == VC_UNICODE;
+	mode = vt_do_kdgkbmode(fg_console);
+	if (mode == K_UNICODE)
+		use_unicode = 1;
+	else
+		use_unicode = 0;
 
 	switch (sel_mode)
 	{
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3c7c56b..8205578 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1028,9 +1028,9 @@ void vc_deallocate(unsigned int currcons)
  *	VT102 emulator
  */
 
-#define set_kbd(vc, x)	set_vc_kbd_mode(kbd_table + (vc)->vc_num, (x))
-#define clr_kbd(vc, x)	clr_vc_kbd_mode(kbd_table + (vc)->vc_num, (x))
-#define is_kbd(vc, x)	vc_kbd_mode(kbd_table + (vc)->vc_num, (x))
+#define set_kbd(vc, x)	vt_set_kbd_mode_bit((vc)->vc_num, (x))
+#define clr_kbd(vc, x)	vt_clr_kbd_mode_bit((vc)->vc_num, (x))
+#define is_kbd(vc, x)	vt_get_kbd_mode_bit((vc)->vc_num, (x))
 
 #define decarm		VC_REPEAT
 #define decckm		VC_CKMODE
@@ -1652,16 +1652,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_deccm		= global_cursor_default;
 	vc->vc_decim		= 0;
 
-	set_kbd(vc, decarm);
-	clr_kbd(vc, decckm);
-	clr_kbd(vc, kbdapplic);
-	clr_kbd(vc, lnm);
-	kbd_table[vc->vc_num].lockstate = 0;
-	kbd_table[vc->vc_num].slockstate = 0;
-	kbd_table[vc->vc_num].ledmode = LED_SHOW_FLAGS;
-	kbd_table[vc->vc_num].ledflagstate = kbd_table[vc->vc_num].default_ledflagstate;
-	/* do not do set_leds here because this causes an endless tasklet loop
-	   when the keyboard hasn't been initialized yet */
+	vt_reset_keyboard(vc->vc_num);
 
 	vc->vc_cursor_type = cur_default;
 	vc->vc_complement_mask = vc->vc_s_complement_mask;
@@ -1979,7 +1970,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 		case 'q': /* DECLL - but only 3 leds */
 			/* map 0,1,2,3 to 0,1,2,4 */
 			if (vc->vc_par[0] < 4)
-				setledstate(kbd_table + vc->vc_num,
+				vt_set_led_state(vc->vc_num,
 					    (vc->vc_par[0] < 3) ? vc->vc_par[0] : 4);
 			return;
 		case 'r':
@@ -2642,7 +2633,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 	 * kernel-internal variable; programs not closely
 	 * related to the kernel should not use this.
 	 */
-	 		data = shift_state;
+			data = vt_get_shift_state();
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_GETMOUSEREPORTING:
@@ -2753,8 +2744,7 @@ static void con_stop(struct tty_struct *tty)
 	console_num = tty->index;
 	if (!vc_cons_allocated(console_num))
 		return;
-	set_vc_kbd_led(kbd_table + console_num, VC_SCROLLOCK);
-	set_leds();
+	vt_kbd_con_stop(console_num);
 }
 
 /*
@@ -2768,8 +2758,7 @@ static void con_start(struct tty_struct *tty)
 	console_num = tty->index;
 	if (!vc_cons_allocated(console_num))
 		return;
-	clr_vc_kbd_led(kbd_table + console_num, VC_SCROLLOCK);
-	set_leds();
+	vt_kbd_con_start(console_num);
 }
 
 static void con_flush_chars(struct tty_struct *tty)
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 80af0f9..28ca0aa 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -195,232 +195,7 @@ int vt_waitactive(int n)
 #define GPLAST 0x3df
 #define GPNUM (GPLAST - GPFIRST + 1)
 
-#define i (tmp.kb_index)
-#define s (tmp.kb_table)
-#define v (tmp.kb_value)
-static inline int
-do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm, struct kbd_struct *kbd)
-{
-	struct kbentry tmp;
-	ushort *key_map, val, ov;
-
-	if (copy_from_user(&tmp, user_kbe, sizeof(struct kbentry)))
-		return -EFAULT;
-
-	if (!capable(CAP_SYS_TTY_CONFIG))
-		perm = 0;
-
-	switch (cmd) {
-	case KDGKBENT:
-		key_map = key_maps[s];
-		if (key_map) {
-		    val = U(key_map[i]);
-		    if (kbd->kbdmode != VC_UNICODE && KTYP(val) >= NR_TYPES)
-			val = K_HOLE;
-		} else
-		    val = (i ? K_HOLE : K_NOSUCHMAP);
-		return put_user(val, &user_kbe->kb_value);
-	case KDSKBENT:
-		if (!perm)
-			return -EPERM;
-		if (!i && v == K_NOSUCHMAP) {
-			/* deallocate map */
-			key_map = key_maps[s];
-			if (s && key_map) {
-			    key_maps[s] = NULL;
-			    if (key_map[0] == U(K_ALLOCATED)) {
-					kfree(key_map);
-					keymap_count--;
-			    }
-			}
-			break;
-		}
-
-		if (KTYP(v) < NR_TYPES) {
-		    if (KVAL(v) > max_vals[KTYP(v)])
-				return -EINVAL;
-		} else
-		    if (kbd->kbdmode != VC_UNICODE)
-				return -EINVAL;
-
-		/* ++Geert: non-PC keyboards may generate keycode zero */
-#if !defined(__mc68000__) && !defined(__powerpc__)
-		/* assignment to entry 0 only tests validity of args */
-		if (!i)
-			break;
-#endif
-
-		if (!(key_map = key_maps[s])) {
-			int j;
-
-			if (keymap_count >= MAX_NR_OF_USER_KEYMAPS &&
-			    !capable(CAP_SYS_RESOURCE))
-				return -EPERM;
-
-			key_map = kmalloc(sizeof(plain_map),
-						     GFP_KERNEL);
-			if (!key_map)
-				return -ENOMEM;
-			key_maps[s] = key_map;
-			key_map[0] = U(K_ALLOCATED);
-			for (j = 1; j < NR_KEYS; j++)
-				key_map[j] = U(K_HOLE);
-			keymap_count++;
-		}
-		ov = U(key_map[i]);
-		if (v == ov)
-			break;	/* nothing to do */
-		/*
-		 * Attention Key.
-		 */
-		if (((ov == K_SAK) || (v == K_SAK)) && !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		key_map[i] = U(v);
-		if (!s && (KTYP(ov) == KT_SHIFT || KTYP(v) == KT_SHIFT))
-			compute_shiftstate();
-		break;
-	}
-	return 0;
-}
-#undef i
-#undef s
-#undef v
-
-static inline int 
-do_kbkeycode_ioctl(int cmd, struct kbkeycode __user *user_kbkc, int perm)
-{
-	struct kbkeycode tmp;
-	int kc = 0;
-
-	if (copy_from_user(&tmp, user_kbkc, sizeof(struct kbkeycode)))
-		return -EFAULT;
-	switch (cmd) {
-	case KDGETKEYCODE:
-		kc = getkeycode(tmp.scancode);
-		if (kc >= 0)
-			kc = put_user(kc, &user_kbkc->keycode);
-		break;
-	case KDSETKEYCODE:
-		if (!perm)
-			return -EPERM;
-		kc = setkeycode(tmp.scancode, tmp.keycode);
-		break;
-	}
-	return kc;
-}
-
-static inline int
-do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
-{
-	struct kbsentry *kbs;
-	char *p;
-	u_char *q;
-	u_char __user *up;
-	int sz;
-	int delta;
-	char *first_free, *fj, *fnw;
-	int i, j, k;
-	int ret;
-
-	if (!capable(CAP_SYS_TTY_CONFIG))
-		perm = 0;
-
-	kbs = kmalloc(sizeof(*kbs), GFP_KERNEL);
-	if (!kbs) {
-		ret = -ENOMEM;
-		goto reterr;
-	}
-
-	/* we mostly copy too much here (512bytes), but who cares ;) */
-	if (copy_from_user(kbs, user_kdgkb, sizeof(struct kbsentry))) {
-		ret = -EFAULT;
-		goto reterr;
-	}
-	kbs->kb_string[sizeof(kbs->kb_string)-1] = '\0';
-	i = kbs->kb_func;
-
-	switch (cmd) {
-	case KDGKBSENT:
-		sz = sizeof(kbs->kb_string) - 1; /* sz should have been
-						  a struct member */
-		up = user_kdgkb->kb_string;
-		p = func_table[i];
-		if(p)
-			for ( ; *p && sz; p++, sz--)
-				if (put_user(*p, up++)) {
-					ret = -EFAULT;
-					goto reterr;
-				}
-		if (put_user('\0', up)) {
-			ret = -EFAULT;
-			goto reterr;
-		}
-		kfree(kbs);
-		return ((p && *p) ? -EOVERFLOW : 0);
-	case KDSKBSENT:
-		if (!perm) {
-			ret = -EPERM;
-			goto reterr;
-		}
 
-		q = func_table[i];
-		first_free = funcbufptr + (funcbufsize - funcbufleft);
-		for (j = i+1; j < MAX_NR_FUNC && !func_table[j]; j++) 
-			;
-		if (j < MAX_NR_FUNC)
-			fj = func_table[j];
-		else
-			fj = first_free;
-
-		delta = (q ? -strlen(q) : 1) + strlen(kbs->kb_string);
-		if (delta <= funcbufleft) { 	/* it fits in current buf */
-		    if (j < MAX_NR_FUNC) {
-			memmove(fj + delta, fj, first_free - fj);
-			for (k = j; k < MAX_NR_FUNC; k++)
-			    if (func_table[k])
-				func_table[k] += delta;
-		    }
-		    if (!q)
-		      func_table[i] = fj;
-		    funcbufleft -= delta;
-		} else {			/* allocate a larger buffer */
-		    sz = 256;
-		    while (sz < funcbufsize - funcbufleft + delta)
-		      sz <<= 1;
-		    fnw = kmalloc(sz, GFP_KERNEL);
-		    if(!fnw) {
-		      ret = -ENOMEM;
-		      goto reterr;
-		    }
-
-		    if (!q)
-		      func_table[i] = fj;
-		    if (fj > funcbufptr)
-			memmove(fnw, funcbufptr, fj - funcbufptr);
-		    for (k = 0; k < j; k++)
-		      if (func_table[k])
-			func_table[k] = fnw + (func_table[k] - funcbufptr);
-
-		    if (first_free > fj) {
-			memmove(fnw + (fj - funcbufptr) + delta, fj, first_free - fj);
-			for (k = j; k < MAX_NR_FUNC; k++)
-			  if (func_table[k])
-			    func_table[k] = fnw + (func_table[k] - funcbufptr) + delta;
-		    }
-		    if (funcbufptr != func_buf)
-		      kfree(funcbufptr);
-		    funcbufptr = fnw;
-		    funcbufleft = funcbufleft - delta + sz - funcbufsize;
-		    funcbufsize = sz;
-		}
-		strcpy(func_table[i], kbs->kb_string);
-		break;
-	}
-	ret = 0;
-reterr:
-	kfree(kbs);
-	return ret;
-}
 
 static inline int 
 do_fontx_ioctl(int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
@@ -497,7 +272,6 @@ int vt_ioctl(struct tty_struct *tty,
 {
 	struct vc_data *vc = tty->driver_data;
 	struct console_font_op op;	/* used in multiple places here */
-	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
 	unsigned int uival;
@@ -523,7 +297,6 @@ int vt_ioctl(struct tty_struct *tty,
 	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
 		perm = 1;
  
-	kbd = kbd_table + console;
 	switch (cmd) {
 	case TIOCLINUX:
 		ret = tioclinux(tty, arg);
@@ -565,7 +338,8 @@ int vt_ioctl(struct tty_struct *tty,
 		 * this is naive.
 		 */
 		ucval = KB_101;
-		goto setchar;
+		ret = put_user(ucval, (char __user *)arg);
+		break;
 
 		/*
 		 * These cannot be implemented on any machine that implements
@@ -670,68 +444,25 @@ int vt_ioctl(struct tty_struct *tty,
 	case KDSKBMODE:
 		if (!perm)
 			goto eperm;
-		switch(arg) {
-		  case K_RAW:
-			kbd->kbdmode = VC_RAW;
-			break;
-		  case K_MEDIUMRAW:
-			kbd->kbdmode = VC_MEDIUMRAW;
-			break;
-		  case K_XLATE:
-			kbd->kbdmode = VC_XLATE;
-			compute_shiftstate();
-			break;
-		  case K_UNICODE:
-			kbd->kbdmode = VC_UNICODE;
-			compute_shiftstate();
-			break;
-		  case K_OFF:
-			kbd->kbdmode = VC_OFF;
-			break;
-		  default:
-			ret = -EINVAL;
-			goto out;
-		}
-		tty_ldisc_flush(tty);
+		ret = vt_do_kdskbmode(console, arg);
+		if (ret == 0)
+			tty_ldisc_flush(tty);
 		break;
 
 	case KDGKBMODE:
-		switch (kbd->kbdmode) {
-		case VC_RAW:
-			uival = K_RAW;
-			break;
-		case VC_MEDIUMRAW:
-			uival = K_MEDIUMRAW;
-			break;
-		case VC_UNICODE:
-			uival = K_UNICODE;
-			break;
-		case VC_OFF:
-			uival = K_OFF;
-			break;
-		default:
-			uival = K_XLATE;
-			break;
-		}
-		goto setint;
+		uival = vt_do_kdgkbmode(console);
+		ret = put_user(uival, (int __user *)arg);
+		break;
 
 	/* this could be folded into KDSKBMODE, but for compatibility
 	   reasons it is not so easy to fold KDGKBMETA into KDGKBMODE */
 	case KDSKBMETA:
-		switch(arg) {
-		  case K_METABIT:
-			clr_vc_kbd_mode(kbd, VC_META);
-			break;
-		  case K_ESCPREFIX:
-			set_vc_kbd_mode(kbd, VC_META);
-			break;
-		  default:
-			ret = -EINVAL;
-		}
+		ret = vt_do_kdskbmeta(console, arg);
 		break;
 
 	case KDGKBMETA:
-		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		/* FIXME: should review whether this is worth locking */
+		uival = vt_do_kdgkbmeta(console);
 	setint:
 		ret = put_user(uival, (int __user *)arg);
 		break;
@@ -740,17 +471,17 @@ int vt_ioctl(struct tty_struct *tty,
 	case KDSETKEYCODE:
 		if(!capable(CAP_SYS_TTY_CONFIG))
 			perm = 0;
-		ret = do_kbkeycode_ioctl(cmd, up, perm);
+		ret = vt_do_kbkeycode_ioctl(cmd, up, perm);
 		break;
 
 	case KDGKBENT:
 	case KDSKBENT:
-		ret = do_kdsk_ioctl(cmd, up, perm, kbd);
+		ret = vt_do_kdsk_ioctl(cmd, up, perm, console);
 		break;
 
 	case KDGKBSENT:
 	case KDSKBSENT:
-		ret = do_kdgkb_ioctl(cmd, up, perm);
+		ret = vt_do_kdgkb_ioctl(cmd, up, perm);
 		break;
 
 	/* Diacritical processing. Handled in keyboard.c as it has
@@ -765,33 +496,10 @@ int vt_ioctl(struct tty_struct *tty,
 	/* the ioctls below read/set the flags usually shown in the leds */
 	/* don't use them - they will go away without warning */
 	case KDGKBLED:
-		ucval = kbd->ledflagstate | (kbd->default_ledflagstate << 4);
-		goto setchar;
-
 	case KDSKBLED:
-		if (!perm)
-			goto eperm;
-		if (arg & ~0x77) {
-			ret = -EINVAL;
-			break;
-		}
-		kbd->ledflagstate = (arg & 7);
-		kbd->default_ledflagstate = ((arg >> 4) & 7);
-		set_leds();
-		break;
-
-	/* the ioctls below only set the lights, not the functions */
-	/* for those, see KDGKBLED and KDSKBLED above */
 	case KDGETLED:
-		ucval = getledstate();
-	setchar:
-		ret = put_user(ucval, (char __user *)arg);
-		break;
-
 	case KDSETLED:
-		if (!perm)
-			goto eperm;
-		setledstate(kbd, arg);
+		ret = vt_do_kdskled(console, cmd, arg, perm);
 		break;
 
 	/*
@@ -1286,7 +994,7 @@ eperm:
 void reset_vc(struct vc_data *vc)
 {
 	vc->vc_mode = KD_TEXT;
-	kbd_table[vc->vc_num].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
+	vt_reset_unicode(vc->vc_num);
 	vc->vt_mode.mode = VT_AUTO;
 	vc->vt_mode.waitv = 0;
 	vc->vt_mode.relsig = 0;
@@ -1309,6 +1017,7 @@ void vc_SAK(struct work_struct *work)
 	console_lock();
 	vc = vc_con->d;
 	if (vc) {
+		/* FIXME: review tty ref counting */
 		tty = vc->port.tty;
 		/*
 		 * SAK should also work in all raw modes and reset
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index ec2d17b..daf4a3a 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -7,8 +7,6 @@
 
 extern struct tasklet_struct keyboard_tasklet;
 
-extern int shift_state;
-
 extern char *func_table[MAX_NR_FUNC];
 extern char func_buf[];
 extern char *funcbufptr;
@@ -65,8 +63,6 @@ struct kbd_struct {
 #define VC_META		4	/* 0 - meta, 1 - meta=prefix with ESC */
 };
 
-extern struct kbd_struct kbd_table[];
-
 extern int kbd_init(void);
 
 extern unsigned char getledstate(void);
@@ -79,6 +75,7 @@ extern void (*kbd_ledfunc)(unsigned int led);
 extern int set_console(int nr);
 extern void schedule_console_callback(void);
 
+/* FIXME: review locking for vt.c callers */
 static inline void set_leds(void)
 {
 	tasklet_schedule(&keyboard_tasklet);
@@ -142,8 +139,6 @@ static inline void chg_vc_kbd_led(struct kbd_struct * kbd, int flag)
 
 struct console;
 
-int getkeycode(unsigned int scancode);
-int setkeycode(unsigned int scancode, unsigned int keycode);
 void compute_shiftstate(void);
 
 /* defkeymap.c */
diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
index 33a63f6..86e5214 100644
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -24,8 +24,6 @@
 
 #ifdef __KERNEL__
 struct notifier_block;
-extern const int NR_TYPES;
-extern const int max_vals[];
 extern unsigned short *key_maps[MAX_NR_KEYMAPS];
 extern unsigned short plain_map[NR_KEYS];
 
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 5d8726a..e33d77f 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -169,5 +169,28 @@ extern void hide_boot_cursor(bool hide);
 
 /* keyboard  provided interfaces */
 extern int vt_do_diacrit(unsigned int cmd, void __user *up, int eperm);
+extern int vt_do_kdskbmode(int console, unsigned int arg);
+extern int vt_do_kdskbmeta(int console, unsigned int arg);
+extern int vt_do_kbkeycode_ioctl(int cmd, struct kbkeycode __user *user_kbkc,
+								int perm);
+extern int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe,
+					int perm, int console);
+extern int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb,
+                                        int perm);
+extern int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm);
+extern int vt_do_kdgkbmode(int console);
+extern int vt_do_kdgkbmeta(int console);
+extern void vt_reset_unicode(int console);
+extern int vt_get_shift_state(void);
+extern void vt_reset_keyboard(int console);
+extern int vt_get_leds(int console, int flag);
+extern int vt_get_kbd_mode_bit(int console, int bit);
+extern void vt_set_kbd_mode_bit(int console, int bit);
+extern void vt_clr_kbd_mode_bit(int console, int bit);
+extern void vt_set_led_state(int console, int leds);
+extern void vt_set_led_state(int console, int leds);
+extern void vt_kbd_con_start(int console);
+extern void vt_kbd_con_stop(int console);
+
 
 #endif /* _VT_KERN_H */

