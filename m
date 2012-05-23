Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab2EWHym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:54:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61742 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2EWHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:54:40 -0400
Date: Wed, 23 May 2012 09:54:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.5
Message-ID: <20120523075433.GA12526@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   HEAD: a9aff3eaaf0966c2a1bb3717d811363d81e52c76 Merge branch x86/build into x86/efi and fix up arch/x86/boot/tools/build.c

(This is the tree hpa sent two weeks ago.)

This patchset makes changes to the bzImage EFI header, so that 
it can be signed with a secure boot signature tool. It should 
not affect anyone who is not using the EFI self-boot feature in 
any way.

Thanks,

	Ingo

----------------->

H. Peter Anvin (1):
      Merge branch x86/build into x86/efi and fix up arch/x86/boot/tools/build.c

Jordan Justen (1):
      x86, efi: Fix issue of overlapping .reloc section for EFI_STUB

Matt Fleming (2):
      x86, efi: Fix .text section overlapping image header for EFI_STUB
      x86, efi: Fix NumberOfRvaAndSizes field in PE32 header for EFI_STUB

 arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
 arch/x86/boot/header.S           |   26 +++++++++-----------------
 arch/x86/boot/tools/build.c      |   24 +++++++++++++++++++++---
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..01cbb87 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -904,11 +904,19 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table)
 
 	memset(boot_params, 0x0, 0x4000);
 
-	/* Copy first two sectors to boot_params */
-	memcpy(boot_params, image->image_base, 1024);
-
 	hdr = &boot_params->hdr;
 
+	/* Copy the second sector to boot_params */
+	memcpy(&hdr->jump, image->image_base + 512, 512);
+
+	/*
+	 * Fill out some of the header fields ourselves because the
+	 * EFI firmware loader doesn't load the first sector.
+	 */
+	hdr->root_flags = 1;
+	hdr->vid_mode = 0xffff;
+	hdr->boot_flag = 0xAA55;
+
 	/*
 	 * The EFI firmware loader could have placed the kernel image
 	 * anywhere in memory, but the kernel has various restrictions
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index f1bbeeb..8bbea6a 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -147,7 +147,7 @@ optional_header:
 	# Filled in by build.c
 	.long	0x0000				# AddressOfEntryPoint
 
-	.long	0x0000				# BaseOfCode
+	.long	0x0200				# BaseOfCode
 #ifdef CONFIG_X86_32
 	.long	0				# data
 #endif
@@ -189,7 +189,7 @@ extra_header_fields:
 	.quad	0				# SizeOfHeapCommit
 #endif
 	.long	0				# LoaderFlags
-	.long	0x1				# NumberOfRvaAndSizes
+	.long	0x6				# NumberOfRvaAndSizes
 
 	.quad	0				# ExportTable
 	.quad	0				# ImportTable
@@ -217,18 +217,17 @@ section_table:
 
 	#
 	# The EFI application loader requires a relocation section
-	# because EFI applications are relocatable and not having
-	# this section seems to confuse it. But since we don't need
-	# the loader to fixup any relocs for us just fill it with a
-	# single dummy reloc.
+	# because EFI applications must be relocatable. But since
+	# we don't need the loader to fixup any relocs for us, we
+	# just create an empty (zero-length) .reloc section header.
 	#
 	.ascii	".reloc"
 	.byte	0
 	.byte	0
-	.long	reloc_end - reloc_start
-	.long	reloc_start
-	.long	reloc_end - reloc_start		# SizeOfRawData
-	.long	reloc_start			# PointerToRawData
+	.long	0
+	.long	0
+	.long	0				# SizeOfRawData
+	.long	0				# PointerToRawData
 	.long	0				# PointerToRelocations
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
@@ -469,10 +468,3 @@ setup_corrupt:
 
 	.data
 dummy:	.long	0
-
-	.section .reloc
-reloc_start:
-	.long	dummy - reloc_start
-	.long	10
-	.word	0
-reloc_end:
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index ed54976..4596388 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -198,12 +198,19 @@ int main(int argc, char ** argv)
 
 	pe_header = get_unaligned_le32(&buf[0x3c]);
 
-	/* Size of code */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0x1c]);
-
 	/* Size of image */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
 
+	/*
+	 * Subtract the size of the first section (512 bytes) which
+	 * includes the header and .reloc section. The remaining size
+	 * is that of the .text section.
+	 */
+	file_sz -= 512;
+
+	/* Size of code */
+	put_unaligned_le32(file_sz, &buf[pe_header + 0x1c]);
+
 #ifdef CONFIG_X86_32
 	/* Address of entry point */
 	put_unaligned_le32(i, &buf[pe_header + 0x28]);
@@ -211,8 +218,14 @@ int main(int argc, char ** argv)
 	/* .text size */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xb0]);
 
+	/* .text vma */
+	put_unaligned_le32(0x200, &buf[pe_header + 0xb4]);
+
 	/* .text size of initialised data */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xb8]);
+
+	/* .text file offset */
+	put_unaligned_le32(0x200, &buf[pe_header + 0xbc]);
 #else
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
@@ -224,9 +237,14 @@ int main(int argc, char ** argv)
 	/* .text size */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xc0]);
 
+	/* .text vma */
+	put_unaligned_le32(0x200, &buf[pe_header + 0xc4]);
+
 	/* .text size of initialised data */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xc8]);
 
+	/* .text file offset */
+	put_unaligned_le32(0x200, &buf[pe_header + 0xcc]);
 #endif /* CONFIG_X86_32 */
 #endif /* CONFIG_EFI_STUB */
 
