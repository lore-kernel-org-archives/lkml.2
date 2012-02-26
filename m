Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2BZUFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 15:05:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57841 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2BZUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 15:05:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.175.36 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
Date: Sun, 26 Feb 2012 21:05:15 +0100
Message-ID: <CAKL7Q7o9HYjw-C4JK9JHwMC-k6uM373UkfxT5D5nv_k07SY-Bw@mail.gmail.com>
Subject: [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a discussion back in 2007 about using a BIOS Keyboard
variable to set the Numlock state. It's available here:
http://lkml.indiana.edu/hypermail/linux/kernel/0707.1/1834.html. I
know the pros and cons that were mentioned back then and decided to
modified the porposed patch so that it provies a kernel parameter
"numlock" which allows to manually disable the NumLock state even if
it is set by the bios. In this case all users without a separeta block
can just pass the parameter in grub and won't be affected by the
change. I know that windows doesn't override the state set by the bios
and would like to see the same behavoir also in linux. Here is the
modified patch by Bodo Eggert rebased on the current kernel-3.2.7:

----------------

--- a/drivers/tty/vt/keyboard.c	2012-02-26 20:30:14.895899072 +0100
+++ b/drivers/tty/vt/keyboard.c	2012-02-26 20:29:24.359896510 +0100
@@ -24,6 +24,7 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

+#include <asm/io.h>
 #include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -59,7 +60,13 @@
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
@@ -1432,7 +1439,17 @@
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
--- a/drivers/input/keyboard/Kconfig	2012-02-26 20:35:38.941915542 +0100
+++ b/drivers/input/keyboard/Kconfig	2012-02-26 20:38:40.890924803 +0100
@@ -84,6 +84,20 @@
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
+	  numlock (1 = enable, 0 = disable).
+
+	  If you have an alternative firmware like OpenFirmware or LinuxBios,
+	  this flag might not be set correctly, which results in a random state
+	  of the Numlock key.
+
 config KEYBOARD_ATKBD_HP_KEYCODES
 	bool "Use HP keyboard scancodes"
 	depends on PARISC && KEYBOARD_ATKBD

------
