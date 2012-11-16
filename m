Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab2KPIyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:54:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22849 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2KPIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:39 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Rob Landley <rob@landley.net>, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 7/9] x86, boot: add field to support load bzImage and ramdisk high
Date: Fri, 16 Nov 2012 00:53:07 -0800
Message-Id: <1353055989-31939-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext_ramdisk_image/size will record high 32bits for ramdisk info.

code64_start_offset will be set for bzImage that support 64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/boot.txt       |    4 ++++
 arch/x86/boot/header.S           |   11 ++++++++++-
 arch/x86/include/asm/bootparam.h |    3 +++
 arch/x86/kernel/setup.c          |    6 ++++++
 4 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..26c7dcc 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -193,6 +193,10 @@ Offset	Proto	Name		Meaning
 0258/8	2.10+	pref_address	Preferred loading address
 0260/4	2.10+	init_size	Linear memory required during initialization
 0264/4	2.11+	handover_offset	Offset of handover entry point
+0268/4	2.12+	ext_ramdisk_image initrd load address high 32 bits
+				(set by boot loader)
+026C/4	2.12+	ext_ramdisk_size initrd size high 32 bits (set by boot loader)
+0270/4	2.12+   code64_start_offset 64bit start offset for bzImage
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 2a01744..85ce1a4 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -279,7 +279,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020b		# header version number (>= 0x0105)
+		.word	0x020c		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -400,6 +400,15 @@ init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0x30		# offset to the handover
 						# protocol entry point
 
+ext_ramdisk_image:	.long	0	# address of loaded ramdisk image
+					# Here the loader puts the high 32 bits
+					# address where it loaded the image.
+					# This only will be read by the kernel.
+
+ext_ramdisk_size:	.long	0	# its size in bytes high 32 bits.
+code64_start_offset:	.long	BOOT_CODE64_START_OFFSET	# startup_64 in
+					# arch/x86/boot/compressed/head_64.S
+
 # End of setup header #####################################################
 
 	.section ".entrytext", "ax"
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2ad874c..4e42fd1 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -67,6 +67,9 @@ struct setup_header {
 	__u64	pref_address;
 	__u32	init_size;
 	__u32	handover_offset;
+	__u32	ext_ramdisk_image;
+	__u32	ext_ramdisk_size;
+	__u32	code64_start_offset;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 194e151..c2eb535 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,12 +302,18 @@ static u64 __init get_ramdisk_image(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 
+	if (boot_params.hdr.version >= 0x020c)
+		ramdisk_image |= (u64)boot_params.hdr.ext_ramdisk_image << 32;
+
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
 {
 	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
 
+	if (boot_params.hdr.version >= 0x020c)
+		ramdisk_size |= (u64)boot_params.hdr.ext_ramdisk_size << 32;
+
 	return ramdisk_size;
 }
 
-- 
1.7.7

