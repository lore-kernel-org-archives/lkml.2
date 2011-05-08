Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1EHJSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 05:18:06 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:39446 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1EHJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 05:17:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        Michael Schmitz <schmitz@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] input/atari: Use the correct mouse interrupt hook
Date: Sun,  8 May 2011 11:17:25 +0200
Message-Id: <1304846247-12401-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
References: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

The Atari keyboard driver calls atari_mouse_interrupt_hook if it's set, not
atari_input_mouse_interrupt_hook. Fix below.

[geert] Killed off atari_mouse_interrupt_hook completely, after fixing another
incorrect assignment in atarimouse.c.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c        |    7 ++-----
 arch/m68k/include/asm/atarikb.h  |    2 --
 drivers/input/mouse/atarimouse.c |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index db26f0e..95022b0 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -36,13 +36,10 @@
 
 /* Hook for MIDI serial driver */
 void (*atari_MIDI_interrupt_hook) (void);
-/* Hook for mouse driver */
-void (*atari_mouse_interrupt_hook) (char *);
 /* Hook for keyboard inputdev  driver */
 void (*atari_input_keyboard_interrupt_hook) (unsigned char, char);
 /* Hook for mouse inputdev  driver */
 void (*atari_input_mouse_interrupt_hook) (char *);
-EXPORT_SYMBOL(atari_mouse_interrupt_hook);
 EXPORT_SYMBOL(atari_input_keyboard_interrupt_hook);
 EXPORT_SYMBOL(atari_input_mouse_interrupt_hook);
 
@@ -263,8 +260,8 @@ repeat:
 			kb_state.buf[kb_state.len++] = scancode;
 			if (kb_state.len == 3) {
 				kb_state.state = KEYBOARD;
-				if (atari_mouse_interrupt_hook)
-					atari_mouse_interrupt_hook(kb_state.buf);
+				if (atari_input_mouse_interrupt_hook)
+					atari_input_mouse_interrupt_hook(kb_state.buf);
 			}
 			break;
 
diff --git a/arch/m68k/include/asm/atarikb.h b/arch/m68k/include/asm/atarikb.h
index 546e7da..68f3622 100644
--- a/arch/m68k/include/asm/atarikb.h
+++ b/arch/m68k/include/asm/atarikb.h
@@ -34,8 +34,6 @@ void ikbd_joystick_disable(void);
 
 /* Hook for MIDI serial driver */
 extern void (*atari_MIDI_interrupt_hook) (void);
-/* Hook for mouse driver */
-extern void (*atari_mouse_interrupt_hook) (char *);
 /* Hook for keyboard inputdev  driver */
 extern void (*atari_input_keyboard_interrupt_hook) (unsigned char, char);
 /* Hook for mouse inputdev  driver */
diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index adf45b3..a57143c 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -108,7 +108,7 @@ static int atamouse_open(struct input_dev *dev)
 static void atamouse_close(struct input_dev *dev)
 {
 	ikbd_mouse_disable();
-	atari_mouse_interrupt_hook = NULL;
+	atari_input_mouse_interrupt_hook = NULL;
 }
 
 static int __init atamouse_init(void)
-- 
1.7.0.4

