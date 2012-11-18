Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2KRHKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 02:10:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2KRHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 02:09:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 12/13] x86, boot: add fields to support load bzImage and ramdisk high
Date: Sat, 17 Nov 2012 23:09:30 -0800
Message-Id: <1353222571-31544-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
References: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext_ramdisk_image/size will record high 32bits for ramdisk info.

code64_start_offset will be set for bzImage that support 64bit.

Let get_ramdisk_image/size to use ext_ramdisk_image/size to get
right positon for ramdisk.

bootloader will fill value to ext_ramdisk_image/size when it load
ramdisk high.

Also bootloader will check if code64_start_offset set to decicde if
it could load ramdisk high above 4G.

Update header version to 2.12.

-v2: add ext_cmd_line_ptr for above 4G support.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/boot.txt         |   39 ++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/cmdline.c |    3 ++
 arch/x86/boot/header.S             |    8 ++++++-
 arch/x86/include/asm/bootparam.h   |    4 +++
 arch/x86/kernel/head64.c           |    3 ++
 arch/x86/kernel/setup.c            |    6 +++++
 6 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..bec29e1 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -57,6 +57,9 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
 Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
+Protocol 2.12:	(Kernel 3.9) Added three fields for loading bzImage and
+		 ramdisk above 4G with 64bit.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -193,6 +196,10 @@ Offset	Proto	Name		Meaning
 0258/8	2.10+	pref_address	Preferred loading address
 0260/4	2.10+	init_size	Linear memory required during initialization
 0264/4	2.11+	handover_offset	Offset of handover entry point
+0268/4	2.12+	ext_ramdisk_image ramdisk_image 32 bits
+026C/4	2.12+	ext_ramdisk_size ramdisk_size high 32 bits
+0270/4	2.12+   code64_start_offset 64bit start offset for bzImage
+0274/4	2.12+   ext_cmd_line_ptr cmd_line_ptr high 32 bits
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -707,6 +714,38 @@ Offset/size:	0x264/4
 
   See EFI HANDOVER PROTOCOL below for more details.
 
+Field name:	ext_ramdisk_image
+Type:		write
+Offset/size:	0x268/4
+Protocol:	2.12+
+
+  The high 32-bit linear address of the initial ramdisk or ramfs.  Leave at
+  zero if there is no initial ramdisk/ramfs, or under 4G.
+
+Field name:	ext_ramdisk_size
+Type:		write
+Offset/size:	0x26c/4
+Protocol:	2.12+
+
+  High 32-bit size of the initial ramdisk or ramfs.  Leave at zero if there
+  is no initial ramdisk/ramfs.
+
+Field name:	code64_start_offset
+Type:		modify (reloc)
+Offset/size:	0x270/4
+Protocol:	2.12+
+
+  The offset of 64bit code to start.  It is offset to the load address
+  of the kernel, and can be used by the boot loader to determine if
+  the bzImage is for 64bit. 64bit loader could jump to load address
+  plus the offset directly.
+
+Field name:	ext_cmd_line_ptr
+Type:		write
+Offset/size:	0x274/4
+Protocol:	2.12+
+
+  cmd_line_ptr high 32 bits. Leave at zero if under 4G.
 
 **** THE IMAGE CHECKSUM
 
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index b4c913c..00678d3 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -17,6 +17,9 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
 
+	if (real_mode->hdr.version >= 0x020c)
+		cmd_line_ptr |= (u64)real_mode->hdr.ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 2a01744..0fcff87 100644
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
@@ -400,6 +400,12 @@ init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0x30		# offset to the handover
 						# protocol entry point
 
+ext_ramdisk_image:	.long	0	# ramdisk_image high 32 bits
+ext_ramdisk_size:	.long	0	# ramdisk_size high 32 bits
+code64_start_offset:	.long	BOOT_CODE64_START_OFFSET	# startup_64 in
+					# arch/x86/boot/compressed/head_64.S
+ext_cmd_line_ptr:	.long	0	# cmd_line_ptr high 32 bits.
+
 # End of setup header #####################################################
 
 	.section ".entrytext", "ax"
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2ad874c..8068191 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -67,6 +67,10 @@ struct setup_header {
 	__u64	pref_address;
 	__u32	init_size;
 	__u32	handover_offset;
+	__u32	ext_ramdisk_image;
+	__u32	ext_ramdisk_size;
+	__u32	code64_start_offset;
+	__u32	ext_cmd_line_ptr;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index ca00d73..e82001e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -45,6 +45,9 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
+	if (boot_params.hdr.version >= 0x020c)
+		cmd_line_ptr |= (u64)boot_params.hdr.ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 573fa7d7..6a0ffa3 100644
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

