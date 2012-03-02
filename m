Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965038Ab2CBVVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:21:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56649 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab2CBVVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:21:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.101.144.2 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F51114D.80704@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
	<CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
	<4F4E6B98.2090306@zytor.com>
	<CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
	<4F4EB0B9.2080906@zytor.com>
	<CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
	<4F4EBF44.60208@zytor.com>
	<CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com>
	<4F4EC19F.4050002@zytor.com>
	<CAKL7Q7rZyUNNP+jy5ajL2KSbC8S4LEQZWG3vuPVSvSOCd_ZGQg@mail.gmail.com>
	<CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com>
	<4F4FE1FA.1040008@zytor.com>
	<CAKL7Q7owDCs0=RyhY7gLpyYgOJ9gisdH=p2+qvZ043dDFMN76Q@mail.gmail.com>
	<4F51114D.80704@zytor.com>
Date: Fri, 2 Mar 2012 22:21:32 +0100
Message-ID: <CAKL7Q7rKVu-5OkKWoO3ZiCakiKsC=MAugRTXWB+rnudqUzvPvw@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/2 H. Peter Anvin <hpa@zytor.com>:
>
> Yeah, it seems a bit excessive in this case.
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>

This is the final version. It works fine here on one laptop and a desktop.

@Alan
Can you, please, queue this for the mainline and also push it to
stable? The patch is straight forward and set the NumLock on a
keyboard according to the data in the BIOS.

---
>From f061c2caeb98b34be41dc1d5ddda03658a7b3555 Mon Sep 17 00:00:00 2001
From: Joshua Cov <joshuacov@googlemail.com>
Date: Fri, 2 Mar 2012 22:44:33 +0100
Subject: [PATCH] Use BIOS Keyboard variable to set Numlock

The PC BIOS does provide a NUMLOCK flag containing the desired state
of this LED. This patch sets the current state according to the data
in the bios.

Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@linux.intel.com>

---
 arch/x86/boot/main.c             |   18 ++++++++++++------
 arch/x86/include/asm/bootparam.h |    3 ++-
 drivers/tty/vt/keyboard.c        |    9 ++++++---
 3 files changed, 20 insertions(+), 10 deletions(-)

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
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..7a95faf 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -56,10 +56,13 @@ extern void ctrl_alt_del(void);
  * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
  * This seems a good reason to start with NumLock off. On HIL keyboards
  * of PARISC machines however there is no NumLock key and everyone
expects the keypad
- * to be used for numbers.
+ * to be used for numbers. That's why on X86 we ask the bios for the
correct state.
  */

-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
+#ifdef CONFIG_X86
+#include <asm/setup.h>
+#define KBD_DEFLEDS (boot_params.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0)
+#elif defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
 #define KBD_DEFLEDS (1 << VC_NUMLOCK)
 #else
 #define KBD_DEFLEDS 0
@@ -1433,7 +1436,7 @@ int __init kbd_init(void)
 	int i;
 	int error;

-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
-- 
1.7.7.6
