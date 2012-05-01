Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2EAO5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:57:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54753 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2EAO5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:57:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCHv2] vt: Fix deadlock on scroll-lock
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 01 May 2012 16:12:19 +0100
Message-ID: <20120501151213.14233.81060.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fixing the locking accidentally replaced a race in the scroll
lock handling with a deadlock. Turn it back into a race for
now.

The basic problem is that there are two paths into the tty
stop/start helpers. One via the tty layer ^S/^Q handling
where we need to take the kbd_event_lock and one via the
special keyboard handler for fn_hold where we already hold
it. Probably we need to split out into a separate LED lock
but for now just go back to the race as it's a bit close
to release.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/keyboard.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 86dd1e3..29ca20d 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1085,15 +1085,21 @@ void vt_set_led_state(int console, int leds)
  *
  *	Handle console start. This is a wrapper for the VT layer
  *	so that we can keep kbd knowledge internal
+ *
+ *	FIXME: We eventually need to hold the kbd lock here to protect
+ *	the LED updating. We can't do it yet because fn_hold calls stop_tty
+ *	and start_tty under the kbd_event_lock, while normal tty paths
+ *	don't hold the lock. We probably need to split out an LED lock
+ *	but not during an -rc release!
  */
 void vt_kbd_con_start(int console)
 {
 	struct kbd_struct * kbd = kbd_table + console;
-	unsigned long flags;
-	spin_lock_irqsave(&kbd_event_lock, flags);
+/*	unsigned long flags; */
+/*	spin_lock_irqsave(&kbd_event_lock, flags); */
 	clr_vc_kbd_led(kbd, VC_SCROLLOCK);
 	set_leds();
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
+/*	spin_unlock_irqrestore(&kbd_event_lock, flags); */
 }
 
 /**
@@ -1102,22 +1108,28 @@ void vt_kbd_con_start(int console)
  *
  *	Handle console stop. This is a wrapper for the VT layer
  *	so that we can keep kbd knowledge internal
+ *
+ *	FIXME: We eventually need to hold the kbd lock here to protect
+ *	the LED updating. We can't do it yet because fn_hold calls stop_tty
+ *	and start_tty under the kbd_event_lock, while normal tty paths
+ *	don't hold the lock. We probably need to split out an LED lock
+ *	but not during an -rc release!
  */
 void vt_kbd_con_stop(int console)
 {
 	struct kbd_struct * kbd = kbd_table + console;
-	unsigned long flags;
-	spin_lock_irqsave(&kbd_event_lock, flags);
+/*	unsigned long flags; */
+/*	spin_lock_irqsave(&kbd_event_lock, flags); */
 	set_vc_kbd_led(kbd, VC_SCROLLOCK);
 	set_leds();
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
+/*	spin_unlock_irqrestore(&kbd_event_lock, flags); */
 }
 
 /*
  * This is the tasklet that updates LED state on all keyboards
  * attached to the box. The reason we use tasklet is that we
  * need to handle the scenario when keyboard handler is not
- * registered yet but we already getting updates form VT to
+ * registered yet but we already getting updates from the VT to
  * update led state.
  */
 static void kbd_bh(unsigned long dummy)

