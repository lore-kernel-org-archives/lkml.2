Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab2DMTIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:08:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51632 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2DMTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:08:27 -0400
MIME-Version: 1.0
Date: Fri, 13 Apr 2012 21:08:26 +0200
Message-ID: <CAKL7Q7rvq87TNS1T_Km8fW_5OzS+SbYazLXKxW-6ztOxo3zorg@mail.gmail.com>
Subject: [PATCH v2] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I re-worked the prosed patch and moved the code around to better fit
some architectural requirements. I hope it can be merged now.

--Joshua

-----------------------------------

>From 6f49bbce0aa65384ce8dc9cb2e7ca26a94497406 Mon Sep 17 00:00:00 2001
From: Joshua Cov <joshuacov@googlemail.com>
Date: Fri, 13 Apr 2012 22:53:37 +0200
Subject: [PATCH v2] Use BIOS Keyboard variable to set Numlock

The PC BIOS does provide a NUMLOCK flag containing the desired state
of this LED. This patch sets the current state according to the data
in the bios.

Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 arch/parisc/include/asm/kbdleds.h |   19 +++++++++++++++++++
 arch/x86/boot/main.c              |   18 ++++++++++++------
 arch/x86/include/asm/bootparam.h  |    3 ++-
 arch/x86/include/asm/kbdleds.h    |   17 +++++++++++++++++
 drivers/tty/vt/keyboard.c         |   21 +++++++--------------
 5 files changed, 57 insertions(+), 21 deletions(-)
 create mode 100644 arch/parisc/include/asm/kbdleds.h
 create mode 100644 arch/x86/include/asm/kbdleds.h

diff --git a/arch/parisc/include/asm/kbdleds.h
b/arch/parisc/include/asm/kbdleds.h
new file mode 100644
index 0000000..2a23ca9
--- /dev/null
+++ b/arch/parisc/include/asm/kbdleds.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_PARISC_KBDLEDS_H
+#define _ASM_PARISC_KBDLEDS_H
+
+/*
+ * On HIL keyboards of PARISC machines there is no NumLock key and
+ * everyone expects the keypad to be used for numbers. That's why
+ * we can safely turn on the NUMLOCK bit.
+ */
+
+inline int kbd_defleds(void)
+{
+#if defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD)
+	return 1 << VC_NUMLOCK;
+#else
+	return 0;
+#endif
+}
+
+#endif /* _ASM_PARISC_KBDLEDS_H */
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 40358c8..cf6083d 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -57,14 +57,20 @@ static void copy_boot_params(void)
 }

 /*
- * Set the keyboard repeat rate to maximum.  Unclear why this
+ * Query the keyboard lock status as given by the BIOS, and
+ * set the keyboard repeat rate to maximum.  Unclear why the latter
  * is done here; this might be possible to kill off as stale code.
  */
-static void keyboard_set_repeat(void)
+static void keyboard_init(void)
 {
-	struct biosregs ireg;
+	struct biosregs ireg, oreg;
 	initregs(&ireg);
-	ireg.ax = 0x0305;
+
+	ireg.ah = 0x02;		/* Get keyboard status */
+	intcall(0x16, &ireg, &oreg);
+	boot_params.kbd_status = oreg.al;
+
+	ireg.ax = 0x0305;	/* Set keyboard repeat rate */
 	intcall(0x16, &ireg, NULL);
 }

@@ -151,8 +157,8 @@ void main(void)
 	/* Detect memory layout */
 	detect_memory();

-	/* Set keyboard repeat rate (why?) */
-	keyboard_set_repeat();
+	/* Set keyboard repeat rate (why?) and query the lock flags */
+	keyboard_init();

 	/* Query MCA information */
 	query_mca();
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2f90c51..eb45aa6 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -112,7 +112,8 @@ struct boot_params {
 	__u8  e820_entries;				/* 0x1e8 */
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
-	__u8  _pad6[6];					/* 0x1eb */
+	__u8  kbd_status;				/* 0x1eb */
+	__u8  _pad6[5];					/* 0x1ec */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
 	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
 	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
diff --git a/arch/x86/include/asm/kbdleds.h b/arch/x86/include/asm/kbdleds.h
new file mode 100644
index 0000000..2f6fa42
--- /dev/null
+++ b/arch/x86/include/asm/kbdleds.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_X86_KBDLEDS_H
+#define _ASM_X86_KBDLEDS_H
+
+/*
+ * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
+ * This seems a good reason to start with NumLock off. That's why on X86 we
+ * ask the bios for the correct state.
+ */
+
+#include <asm/setup.h>
+
+inline int kbd_defleds(void)
+{
+	return boot_params.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0;
+}
+
+#endif /* _ASM_X86_KBDLEDS_H */
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..5ea4359 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -52,19 +52,12 @@ extern void ctrl_alt_del(void);

 #define KBD_DEFMODE ((1 << VC_REPEAT) | (1 << VC_META))

-/*
- * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
- * This seems a good reason to start with NumLock off. On HIL keyboards
- * of PARISC machines however there is no NumLock key and everyone
expects the keypad
- * to be used for numbers.
- */
-
-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
-#define KBD_DEFLEDS (1 << VC_NUMLOCK)
-#else
-#define KBD_DEFLEDS 0
+#if defined(CONFIG_X86) || defined(CONFIG_PARISC)
+#include <asm/kbdleds.h>
 #endif

+extern __weak int kbd_defleds(void);
+
 #define KBD_DEFLOCK 0

 void compute_shiftstate(void);
@@ -1433,9 +1426,9 @@ int __init kbd_init(void)
 	int i;
 	int error;

-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		kbd_table[i].ledflagstate = KBD_DEFLEDS;
-		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
+		kbd_table[i].ledflagstate = kbd_defleds();
+		kbd_table[i].default_ledflagstate = kbd_defleds();
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
 		kbd_table[i].lockstate = KBD_DEFLOCK;
 		kbd_table[i].slockstate = 0;
-- 
1.7.10
