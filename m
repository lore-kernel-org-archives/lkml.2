Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2B2W4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:56:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61795 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2B2W4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:56:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.175.36 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4E6B98.2090306@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
	<CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
	<4F4E6B98.2090306@zytor.com>
Date: Wed, 29 Feb 2012 23:56:51 +0100
Message-ID: <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/29 H. Peter Anvin <hpa@zytor.com>:
> On 02/29/2012 03:43 AM, Joshua C. wrote:
>>
>>
>> I got the idea that we should somehow check the kbd_state and set the
>> numlock accordingly but this is behind my capabilities. I tried
>> several times to read those boot_params but I have no idea how to do
>> it. Where are they stored, how to access them? Help anyone?
>>
>
> There is a global variable called boot_params; the prototype for it is
> defined in <asm/setup.h>.
>
> So as long as you are on an x86 architecture you can just #include
> <asm/setup.h> and just access the boot_params structure directly (with the
> patch provided to add the new field.)
>
>        -hpa

I think I figured it out. This is the patch I tested on a desktop and
a laptop and it works the way it should.
--------------

>From 0e3f1393132fd61f43e950065ae888b5ee103a96 Mon Sep 17 00:00:00 2001
From: Joshua Cov <joshuacov@googlemail.com>
Date: Thu, 1 Mar 2012 00:21:55 +0100
Subject: [PATCH] Use BIOS Keyboard variable to set Numlock

The PC BIOS does provide a NUMLOCK flag containing the desired state
of the LED. This patch sets the current state according to the data in
the bios and introduces a module parameter "numlock" which can be used
to explicitely ignore the BIOS Setting (1 = use BIOS Setting, 0 =
don't use it).

Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>

---
 arch/x86/boot/main.c             |   18 ++++++++++++------
 arch/x86/include/asm/bootparam.h |    3 ++-
 drivers/tty/vt/keyboard.c        |   37 +++++++++++++++++++++++--------------
 3 files changed, 37 insertions(+), 21 deletions(-)

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
index a605549..40a33bf 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -24,6 +24,8 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

+#include <asm/io.h>
+#include <asm/setup.h>
 #include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -52,19 +54,6 @@ extern void ctrl_alt_del(void);

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
-#endif
-
 #define KBD_DEFLOCK 0

 void compute_shiftstate(void);
@@ -1428,12 +1417,32 @@ static struct input_handler kbd_handler = {
 	.id_table	= kbd_ids,
 };

+/* Let the user decide if we should use the value from the BIOS. */
+static int numlock = 1;
+MODULE_PARM_DESC(numlock, "Should we use the NumLock state returned
by the BIOS? \
+				(1 = use BIOS Setting, 0 = don't use it)");
+module_param_named(numlock, numlock, int, 0400);
+
 int __init kbd_init(void)
 {
 	int i;
 	int error;

-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+	/*
+	* Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
+	* This seems a good reason to start with NumLock off. On HIL keyboards
+	* of PARISC machines however there is no NumLock key and everyone
expects the keypad
+	* to be used for numbers. That's why we start with NumLock off and
ask the bios
+	* for the correct state.
+	*/
+
+	int KBD_DEFLEDS = 0 << VC_NUMLOCK;
+
+	/* Numlock status bit set? */
+	if ((boot_params.kbd_status & 0x20) && numlock)
+		KBD_DEFLEDS = 1 << VC_NUMLOCK;
+
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
-- 
1.7.7.6
