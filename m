Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2LSUXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:23:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46291 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2LSUXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:23:37 -0500
Date: Wed, 19 Dec 2012 12:22:53 -0800
Message-Id: <201212192022.qBJKMrJ6021946@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for v3.8-rc1
Cc: <stable@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of very small fixes, mostly pure documentation.

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is cd34ab8b16ffaa9753d85adb4fb6cd98e7e1d22a.

H. Peter Anvin (2):
      x86, doc: Add a formal bootloader ID for kexec-tools
      x86, doc: Document that bootloader ID 4 is used also by iPXE

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

 Documentation/x86/boot.txt            | 3 ++-
 drivers/input/serio/i8042-x86ia64io.h | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..9a89e01 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -373,7 +373,7 @@ Protocol:	2.00+
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
 	3  Syslinux
-	4  Etherboot/gPXE
+	4  Etherboot/gPXE/iPXE
 	5  ELILO
 	7  GRUB
 	8  U-Boot
@@ -381,6 +381,7 @@ Protocol:	2.00+
 	A  Gujin
 	B  Qemu
 	C  Arcturus Networks uCbootloader
+	D  kexec-tools
 	E  Extended		(see ext_loader_type)
 	F  Special		(0xFF = undefined)
        10  Reserved
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index d6cc77a..5f306f7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
 	int retval;
 
 #ifdef CONFIG_X86
+	u8 a20_on = 0xdf;
 	/* Just return if pre-detection shows no i8042 controller exist */
 	if (!x86_platform.i8042_detect())
 		return -ENODEV;
@@ -960,6 +961,14 @@ static int __init i8042_platform_init(void)
 
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
+
+	/*
+	 * A20 was already enabled during early kernel init. But some buggy
+	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
+	 * resume from S3. So we do it here and hope that nothing breaks.
+	 */
+	i8042_command(&a20_on, 0x10d1);
+	i8042_command(NULL, 0x00ff);	/* Null command for SMM firmware */
 #endif /* CONFIG_X86 */
 
 	return retval;
