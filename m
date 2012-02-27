Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2B0TXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:23:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46208 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2B0TXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:23:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.192.137 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
Date: Mon, 27 Feb 2012 20:23:11 +0100
Message-ID: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
Subject: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rebased this on the latest kernel-3.3-rc5 so that it can be properly applied.
------------------

>From 36e15b8d9d491817a3bada5ef9375aabe9439d9b Mon Sep 17 00:00:00 2012
From: Joshua Cov <joshuacov@googlemail.com>
Date: Mon, 27 Feb 2012 20:49:18 +0100
Subject: [PATCH] Use BIOS Keyboard variable to set Numlock

The PC BIOS does provide a NUMLOCK flag containing the desired state
of this LED. Bit 0x417 has the current keyboard modifier state. This
patch sets the current state according to the data in the bios and
introduces a module parameter "numlock" which can be used to
explicitely disable the NumLock (1 = enable, 0 = disable).

See first discussion back in 2007 at:
http://lkml.indiana.edu/hypermail/linux/kernel/0707.1/1834.html

Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>

---
 drivers/input/keyboard/Kconfig |   14 ++++++++++++++
 drivers/tty/vt/keyboard.c      |   21 +++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index cdc385b..1dd1965 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -84,6 +84,20 @@ config KEYBOARD_ATKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called atkbd.

+config KBD_DEFLEDS_PCBIOS
+	bool "Enable Num-Lock based on BIOS settings"
+	depends on KEYBOARD_ATKBD && X86
+	default y
+	help
+	  Turns on Numlock depending on the BIOS settings.
+	  This works by reading the BIOS data area as defined for IBM PCs (1981).
+	  You can also controll the NumLock state with the kernel parameter
+	  numlock.
+
+	  If you have an alternative firmware like OpenFirmware or LinuxBios,
+	  this flag might not be set correctly, which results in a random state
+	  of the Numlock key.
+
 config KEYBOARD_ATKBD_HP_KEYCODES
 	bool "Use HP keyboard scancodes"
 	depends on PARISC && KEYBOARD_ATKBD
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..d254396 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -24,6 +24,7 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

+#include <asm/io.h>
 #include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -59,7 +60,13 @@ extern void ctrl_alt_del(void);
  * to be used for numbers.
  */

-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+/* KBD_DEFLEDS is a variable */
+#undef KBD_DEFLEDS
+	static int numlock = 1;
+	MODULE_PARM_DESC(numlock, "Toggle Numlock (1 = enable, 0 = disable)");
+	module_param_named(numlock, numlock, int, 0400);
+#elif defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
 #define KBD_DEFLEDS (1 << VC_NUMLOCK)
 #else
 #define KBD_DEFLEDS 0
@@ -1432,7 +1439,17 @@ int __init kbd_init(void)
 {
 	int i;
 	int error;
-
+	
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+	int KBD_DEFLEDS = 0;
+	/* address 0x40:0x17 */
+	char * bios_kbd_status=xlate_dev_mem_ptr(0x417);
+	
+	/* Numlock status bit set? */
+	if ((*bios_kbd_status & 0x20) && numlock)
+	KBD_DEFLEDS = 1 << VC_NUMLOCK;
+#endif
+	
         for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
-- 
1.7.7.6
