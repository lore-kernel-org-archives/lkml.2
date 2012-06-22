Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762581Ab2FVPam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:30:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40785 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367Ab2FVPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:30:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/12] vt: fix the keyboard/led locking
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:46:34 +0100
Message-ID: <20120622154625.1405.89444.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We touch the LED from both keyboard callback and direct paths. In
one case we've got the lock held way up the call chain and in the
other we haven't. This leads to complete insanity so fix it by giving
the LED bits their own lock.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/keyboard.c |   42 ++++++++++++++++++++++--------------------
 include/linux/kbd_kern.h  |    1 -
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 48cc6f2..816cbbd 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -119,6 +119,7 @@ static const int NR_TYPES = ARRAY_SIZE(max_vals);
 
 static struct input_handler kbd_handler;
 static DEFINE_SPINLOCK(kbd_event_lock);
+static DEFINE_SPINLOCK(led_lock);
 static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bitmap */
 static unsigned char shift_down[NR_SHIFT];		/* shift state counters.. */
 static bool dead_key_next;
@@ -984,7 +985,7 @@ static void k_brl(struct vc_data *vc, unsigned char value, char up_flag)
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
  * or (iii) specified bits of specified words in kernel memory.
  */
-unsigned char getledstate(void)
+static unsigned char getledstate(void)
 {
 	return ledstate;
 }
@@ -992,7 +993,7 @@ unsigned char getledstate(void)
 void setledstate(struct kbd_struct *kbd, unsigned int led)
 {
         unsigned long flags;
-        spin_lock_irqsave(&kbd_event_lock, flags);
+        spin_lock_irqsave(&led_lock, flags);
 	if (!(led & ~7)) {
 		ledioctl = led;
 		kbd->ledmode = LED_SHOW_IOCTL;
@@ -1000,7 +1001,7 @@ void setledstate(struct kbd_struct *kbd, unsigned int led)
 		kbd->ledmode = LED_SHOW_FLAGS;
 
 	set_leds();
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
+	spin_unlock_irqrestore(&led_lock, flags);
 }
 
 static inline unsigned char getleds(void)
@@ -1053,9 +1054,9 @@ int vt_get_leds(int console, int flag)
 	struct kbd_struct * kbd = kbd_table + console;
 	int ret;
 
-	spin_lock_irqsave(&kbd_event_lock, flags);
+	spin_lock_irqsave(&led_lock, flags);
 	ret = vc_kbd_led(kbd, flag);
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
+	spin_unlock_irqrestore(&led_lock, flags);
 
 	return ret;
 }
@@ -1091,11 +1092,11 @@ void vt_set_led_state(int console, int leds)
 void vt_kbd_con_start(int console)
 {
 	struct kbd_struct * kbd = kbd_table + console;
-/*	unsigned long flags; */
-/*	spin_lock_irqsave(&kbd_event_lock, flags); */
+	unsigned long flags;
+	spin_lock_irqsave(&led_lock, flags);
 	clr_vc_kbd_led(kbd, VC_SCROLLOCK);
 	set_leds();
-/*	spin_unlock_irqrestore(&kbd_event_lock, flags); */
+	spin_unlock_irqrestore(&led_lock, flags);
 }
 
 /**
@@ -1104,21 +1105,15 @@ void vt_kbd_con_start(int console)
  *
  *	Handle console stop. This is a wrapper for the VT layer
  *	so that we can keep kbd knowledge internal
- *
- *	FIXME: We eventually need to hold the kbd lock here to protect
- *	the LED updating. We can't do it yet because fn_hold calls stop_tty
- *	and start_tty under the kbd_event_lock, while normal tty paths
- *	don't hold the lock. We probably need to split out an LED lock
- *	but not during an -rc release!
  */
 void vt_kbd_con_stop(int console)
 {
 	struct kbd_struct * kbd = kbd_table + console;
-/*	unsigned long flags; */
-/*	spin_lock_irqsave(&kbd_event_lock, flags); */
+	unsigned long flags;
+	spin_lock_irqsave(&led_lock, flags);
 	set_vc_kbd_led(kbd, VC_SCROLLOCK);
 	set_leds();
-/*	spin_unlock_irqrestore(&kbd_event_lock, flags); */
+	spin_unlock_irqrestore(&led_lock, flags);
 }
 
 /*
@@ -1130,7 +1125,12 @@ void vt_kbd_con_stop(int console)
  */
 static void kbd_bh(unsigned long dummy)
 {
-	unsigned char leds = getleds();
+	unsigned char leds;
+	unsigned long flags;
+	
+	spin_lock_irqsave(&led_lock, flags);
+	leds = getleds();
+	spin_unlock_irqrestore(&led_lock, flags);
 
 	if (leds != ledstate) {
 		input_handler_for_each_handle(&kbd_handler, &leds,
@@ -2035,11 +2035,11 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 			return -EPERM;
 		if (arg & ~0x77)
 			return -EINVAL;
-                spin_lock_irqsave(&kbd_event_lock, flags);
+                spin_lock_irqsave(&led_lock, flags);
 		kbd->ledflagstate = (arg & 7);
 		kbd->default_ledflagstate = ((arg >> 4) & 7);
 		set_leds();
-                spin_unlock_irqrestore(&kbd_event_lock, flags);
+                spin_unlock_irqrestore(&led_lock, flags);
 		return 0;
 
 	/* the ioctls below only set the lights, not the functions */
@@ -2134,8 +2134,10 @@ void vt_reset_keyboard(int console)
 	clr_vc_kbd_mode(kbd, VC_CRLF);
 	kbd->lockstate = 0;
 	kbd->slockstate = 0;
+	spin_lock(&led_lock);
 	kbd->ledmode = LED_SHOW_FLAGS;
 	kbd->ledflagstate = kbd->default_ledflagstate;
+	spin_unlock(&led_lock);
 	/* do not do set_leds here because this causes an endless tasklet loop
 	   when the keyboard hasn't been initialized yet */
 	spin_unlock_irqrestore(&kbd_event_lock, flags);
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index daf4a3a..37d5877 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -65,7 +65,6 @@ struct kbd_struct {
 
 extern int kbd_init(void);
 
-extern unsigned char getledstate(void);
 extern void setledstate(struct kbd_struct *kbd, unsigned int led);
 
 extern int do_poke_blanked_console;

