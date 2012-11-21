Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2KUHQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:16:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42646 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2KUHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:16:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v3 11/12] x86, boot: add fields to support load bzImage and ramdisk high
Date: Tue, 20 Nov 2012 23:16:09 -0800
Message-Id: <1353482170-10160-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext_ramdisk_image/size will record high 32bits for ramdisk info.

xloadflags bit0 will be set if relocatable with 64bit.

Let get_ramdisk_image/size to use ext_ramdisk_image/size to get
right positon for ramdisk.

bootloader will fill value to ext_ramdisk_image/size when it load
ramdisk high.

Also bootloader will check if xloadflags bit0 is set to decicde if
it could load ramdisk high above 4G.

Update header version to 2.12.

-v2: add ext_cmd_line_ptr for above 4G support.
-v3: update to xloadflags from HPA

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/boot.txt         |   40 +++++++++++++++++++++++++++++++++++-
 arch/x86/boot/compressed/cmdline.c |    3 ++
 arch/x86/boot/header.S             |   16 ++++++++++++-
 arch/x86/include/asm/bootparam.h   |    6 ++++-
 arch/x86/kernel/head64.c           |    3 ++
 arch/x86/kernel/setup.c            |    6 +++++
 6 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..a8263f7 100644
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
@@ -182,7 +185,7 @@ Offset	Proto	Name		Meaning
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
-0236/2	N/A	pad3		Unused
+0236/2	2.12+	xloadflags	Boot protocal option flags
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
@@ -193,6 +196,9 @@ Offset	Proto	Name		Meaning
 0258/8	2.10+	pref_address	Preferred loading address
 0260/4	2.10+	init_size	Linear memory required during initialization
 0264/4	2.11+	handover_offset	Offset of handover entry point
+0268/4	2.12+	ext_ramdisk_image ramdisk_image 32 bits
+026C/4	2.12+	ext_ramdisk_size ramdisk_size high 32 bits
+0270/4	2.12+   ext_cmd_line_ptr cmd_line_ptr high 32 bits
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -581,6 +587,16 @@ Protocol:	2.10+
   misaligned kernel.  Therefore, a loader should typically try each
   power-of-two alignment from kernel_alignment down to this alignment.
 
+Field name:     xloadflags
+Type:           modify (obligatory)
+Offset/size:    0x236/2
+Protocol:       2.12+
+
+  This field is a bitmask.
+
+  Bit 0 (read): LOADED_ABOVE_4G
+        - If 1, kernel/boot_params/cmdline/ramdisk could be above 4g
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
@@ -707,6 +723,28 @@ Offset/size:	0x264/4
 
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
+Field name:	ext_cmd_line_ptr
+Type:		write
+Offset/size:	0x270/4
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
index 2a01744..598cba5 100644
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
@@ -369,7 +369,15 @@ relocatable_kernel:    .byte 1
 relocatable_kernel:    .byte 0
 #endif
 min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
-pad3:			.word 0
+
+xloadflags:
+LOADED_ABOVE_4G	= 1			# If set, the kernel/boot_param/
+					# ramdisk could be loaded above 4g
+#if defined(CONFIG_X86_64) && defined(CONFIG_RELOCATABLE)
+			.word LOADED_ABOVE_4G
+#else
+			.word 0
+#endif
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
@@ -400,6 +408,10 @@ init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0x30		# offset to the handover
 						# protocol entry point
 
+ext_ramdisk_image:	.long	0	# ramdisk_image high 32 bits
+ext_ramdisk_size:	.long	0	# ramdisk_size high 32 bits
+ext_cmd_line_ptr:	.long	0	# cmd_line_ptr high 32 bits.
+
 # End of setup header #####################################################
 
 	.section ".entrytext", "ax"
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2ad874c..036a278 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -57,7 +57,8 @@ struct setup_header {
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
 	__u8	relocatable_kernel;
-	__u8	_pad2[3];
+	__u8	min_alignment;
+	__u16	xloadflags;
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
@@ -67,6 +68,9 @@ struct setup_header {
 	__u64	pref_address;
 	__u32	init_size;
 	__u32	handover_offset;
+	__u32	ext_ramdisk_image;
+	__u32	ext_ramdisk_size;
+	__u32	ext_cmd_line_ptr;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 735cd47..7a969a7 100644
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

