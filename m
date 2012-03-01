Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2CATmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:42:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60257 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2CATmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:42:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.101.106.11 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <CAKL7Q7rZyUNNP+jy5ajL2KSbC8S4LEQZWG3vuPVSvSOCd_ZGQg@mail.gmail.com>
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
Date: Thu, 1 Mar 2012 20:42:34 +0100
Message-ID: <CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 Joshua C. <joshuacov@googlemail.com>:
> 2012/3/1 H. Peter Anvin <hpa@zytor.com>:
>> On 02/29/2012 04:21 PM, Joshua C. wrote:
>>>
>>>
>>> Thanks for the help. You can better figure out where this code should
>>> go into. Can you prepare the patch for merging in the mainline kernel?
>>>
>>
>> Yes, although "when" would be a very open question.
>>
>> I realize it is frustrating to do these kinds of things for the first time
>> and getting what feels like a lot of very picky feedback.  The hope is that
>> the learning experience makes the second, and third, and fourth time a lot
>> less painful.
>>
>>        -hpa
>
> Your're right. I wasn't sure about some parts of the code but it
> finally worked out. I haven't worked with any non x86 system and I was
> guessing what should be fixed. In the meantime I'll ask for this to be
> merged in the fedora kernel. Thanks once again.

I think this is the final version of the patch:

---
 arch/x86/boot/main.c             |   18 +++++++++++-----
 arch/x86/include/asm/bootparam.h |    3 +-
 arch/x86/include/asm/kbdleds.h   |   41 ++++++++++++++++++++++++++++++++++++++
 drivers/tty/vt/keyboard.c        |   13 +++--------
 4 files changed, 59 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/include/asm/kbdleds.h

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
index 0000000..1446a65
--- /dev/null
+++ b/arch/x86/include/asm/kbdleds.h
@@ -0,0 +1,41 @@
+#ifndef _ASM_X86_KBDLEDS_H
+#define _ASM_X86_KBDLEDS_H
+
+/*
+ * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
+ * This seems a good reason to start with NumLock off. On HIL keyboards
+ * of PARISC machines however there is no NumLock key and everyone expects
+ * the keypad to be used for numbers. That's why on X86 we ask the bios for
+ * the correct state.
+ */
+
+#ifdef CONFIG_X86
+
+#include <asm/setup.h>
+
+static inline int kbd_defleds(void)
+{
+	return boot_params.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0;
+}
+
+#elif defined(CONFIG_PARISC)
+
+static inline int kbd_defleds(void)
+{
+#if defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD)
+	return 1 << VC_NUMLOCK;
+#else
+	return 0;
+#endif
+}
+
+#else
+
+static inline int kbd_defleds(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_X86 */
+
+#endif /* _ASM_X86_KBDLEDS_H */
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..4474d18 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -43,6 +43,7 @@
 #include <linux/jiffies.h>

 #include <asm/irq_regs.h>
+#include <asm/kbdleds.h>

 extern void ctrl_alt_del(void);

@@ -59,12 +60,6 @@ extern void ctrl_alt_del(void);
  * to be used for numbers.
  */

-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
defined(CONFIG_KEYBOARD_HIL_OLD))
-#define KBD_DEFLEDS (1 << VC_NUMLOCK)
-#else
-#define KBD_DEFLEDS 0
-#endif
-
 #define KBD_DEFLOCK 0

 void compute_shiftstate(void);
@@ -1433,9 +1428,9 @@ int __init kbd_init(void)
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
1.7.7.6
