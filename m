Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2K1Hvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:51:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40446 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2K1Hvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v5 10/13] x86, boot: add fields to support load bzImage and ramdisk above 4G
Date: Tue, 27 Nov 2012 23:50:39 -0800
Message-Id: <1354089042-10023-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext_ramdisk_image/size will record high 32bits for ramdisk info.

xloadflags bit0 will be set if relocatable with 64bit.

Let get_ramdisk_image/size to use ext_ramdisk_image/size to get
right positon for ramdisk.

bootloader will fill value to ext_ramdisk_image/size when it load
ramdisk above 4G.

Also bootloader will check if xloadflags bit0 is set to decicde if
it could load ramdisk high above 4G.

xloadflags bit15 is used for bootloader to notify kernel if new added
ext_* in boot_params could be used or not.

Update header version to 2.12.

-v2: add ext_cmd_line_ptr for above 4G support.
-v3: update to xloadflags from HPA.
-v4: use fields from bootparam instead setup_header accoring to HPA.
-v5: add checking for USE_EXT_BOOT_PARAMS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Rob Landley <rob@landley.net>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/x86/boot.txt         |   19 ++++++++++++++++++-
 Documentation/x86/zero-page.txt    |    3 +++
 arch/x86/boot/compressed/cmdline.c |    3 +++
 arch/x86/boot/header.S             |   12 ++++++++++--
 arch/x86/include/asm/bootparam.h   |   10 ++++++++--
 arch/x86/kernel/head64.c           |    3 +++
 arch/x86/kernel/setup.c            |    6 ++++++
 7 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9efceff..51954d7 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -57,6 +57,9 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
 Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
+Protocol 2.12:	(Kernel 3.9) Added three fields for loading bzImage and
+		 ramdisk above 4G with 64bit in bootparam.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -182,7 +185,7 @@ Offset	Proto	Name		Meaning
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
-0236/2	N/A	pad3		Unused
+0236/2	2.12+	xloadflags	Boot protocol option flags
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
@@ -581,6 +584,20 @@ Protocol:	2.10+
   misaligned kernel.  Therefore, a loader should typically try each
   power-of-two alignment from kernel_alignment down to this alignment.
 
+Field name:     xloadflags
+Type:           modify (obligatory)
+Offset/size:    0x236/2
+Protocol:       2.12+
+
+  This field is a bitmask.
+
+  Bit 0 (read): CAN_BE_LOADED_ABOVE_4G
+        - If 1, kernel/boot_params/cmdline/ramdisk can be above 4g,
+
+  Bit 15 (write): USE_EXT_BOOT_PARAMS
+	- If 1, set by bootloader, and kernel could check new fields
+		in boot_params that are added from 2.12 safely.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index cf5437d..0e19657 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -19,6 +19,9 @@ Offset	Proto	Name		Meaning
 090/010	ALL	hd1_info	hd1 disk parameter, OBSOLETE!!
 0A0/010	ALL	sys_desc_table	System description table (struct sys_desc_table)
 0B0/010	ALL	olpc_ofw_header	OLPC's OpenFirmware CIF and friends
+0C0/004 ALL	ext_ramdisk_image ramdisk_image high 32bits
+0C4/004 ALL	ext_ramdisk_size  ramdisk_size high 32bits
+0C8/004 ALL	ext_cmd_line_ptr  cmd_line_ptr high 32bits
 140/080	ALL	edid_info	Video mode setup (struct edid_info)
 1C0/020	ALL	efi_info	EFI 32 information (struct efi_info)
 1E0/004	ALL	alk_mem_k	Alternative mem check, in KB
diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
index b4c913c..43e4ec7 100644
--- a/arch/x86/boot/compressed/cmdline.c
+++ b/arch/x86/boot/compressed/cmdline.c
@@ -17,6 +17,9 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
 
+	if (real_mode->hdr.xloadflags & USE_EXT_BOOT_PARAMS)
+		cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 int cmdline_find_option(const char *option, char *buffer, int bufsize)
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 2a01744..156f664 100644
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
+CAN_BE_LOADED_ABOVE_4G	= 1		# If set, the kernel/boot_param/
+					# ramdisk could be loaded above 4g
+#if defined(CONFIG_X86_64) && defined(CONFIG_RELOCATABLE)
+			.word CAN_BE_LOADED_ABOVE_4G
+#else
+			.word 0
+#endif
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 2ad874c..57dd85b 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -57,7 +57,10 @@ struct setup_header {
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
 	__u8	relocatable_kernel;
-	__u8	_pad2[3];
+	__u8	min_alignment;
+	__u16	xloadflags;
+#define CAN_BE_LOADED_ABOVE_4G	(1<<0)
+#define USE_EXT_BOOT_PARAMS		(1<<15)
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
@@ -105,7 +108,10 @@ struct boot_params {
 	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
 	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
 	struct olpc_ofw_header olpc_ofw_header;		/* 0x0b0 */
-	__u8  _pad4[128];				/* 0x0c0 */
+	__u32 ext_ramdisk_image;			/* 0x0c0 */
+	__u32 ext_ramdisk_size;				/* 0x0c4 */
+	__u32 ext_cmd_line_ptr;				/* 0x0c8 */
+	__u8  _pad4[116];				/* 0x0cc */
 	struct edid_info edid_info;			/* 0x140 */
 	struct efi_info efi_info;			/* 0x1c0 */
 	__u32 alt_mem_k;				/* 0x1e0 */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 735cd47..8ea1bc9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -45,6 +45,9 @@ static unsigned long get_cmd_line_ptr(void)
 {
 	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
 
+	if (boot_params.hdr.xloadflags & USE_EXT_BOOT_PARAMS)
+		cmd_line_ptr |= (u64)boot_params.ext_cmd_line_ptr << 32;
+
 	return cmd_line_ptr;
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 573fa7d7..2dbe2ce 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,12 +302,18 @@ static u64 __init get_ramdisk_image(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 
+	if (boot_params.hdr.xloadflags & USE_EXT_BOOT_PARAMS)
+		ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
+
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
 {
 	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
 
+	if (boot_params.hdr.xloadflags & USE_EXT_BOOT_PARAMS)
+		ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
+
 	return ramdisk_size;
 }
 
-- 
1.7.7

