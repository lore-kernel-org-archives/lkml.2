Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2CZWUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:20:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab2CZWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:20:39 -0400
Date: Mon, 26 Mar 2012 15:20:29 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-e31be363df3092821bf179cf4baa076f501b8ae6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1332520506-6472-3-git-send-email-jordan.l.justen@intel.com>
References: <1332520506-6472-3-git-send-email-jordan.l.justen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Fix .
 text section overlapping image header for EFI_STUB
Git-Commit-ID: e31be363df3092821bf179cf4baa076f501b8ae6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 26 Mar 2012 15:20:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e31be363df3092821bf179cf4baa076f501b8ae6
Gitweb:     http://git.kernel.org/tip/e31be363df3092821bf179cf4baa076f501b8ae6
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 23 Mar 2012 09:35:05 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 26 Mar 2012 13:10:01 -0700

x86, efi: Fix .text section overlapping image header for EFI_STUB

This change modifes the PE .text section to start after
the first sector of the kernel image.

The header may be modified by the UEFI secure boot signing,
so it is not appropriate for it to be included in one of the
image sections. Since the sections are part of the secure
boot hash, this modification to the .text section contents
would invalidate the secure boot signed hash.

Note: UEFI secure boot does hash the image header, but
fields that are changed by the signing process are excluded
from the hash calculation.  This exclusion process is only
handled for the image header, and not image sections.

Luckily, we can still easily boot without the first sector
by initializing a few fields in arch/x86/boot/compressed/eboot.c.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1332520506-6472-3-git-send-email-jordan.l.justen@intel.com
[jordan.l.justen@intel.com: set .text vma & file offset]
Signed-off-by: Jordan Justen <jordan.l.justen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
 arch/x86/boot/header.S           |    2 +-
 arch/x86/boot/tools/build.c      |   25 ++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 7 deletions(-)

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
index 4e9124b..4ceb56e 100644
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
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4e9bd6b..2aeab3d 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -202,12 +202,19 @@ int main(int argc, char ** argv)
 
 	pe_header = *(unsigned int *)&buf[0x3c];
 
-	/* Size of code */
-	*(unsigned int *)&buf[pe_header + 0x1c] = file_sz;
-
 	/* Size of image */
 	*(unsigned int *)&buf[pe_header + 0x50] = file_sz;
 
+	/*
+	 * Subtract the size of the first section (512 bytes) which
+	 * includes the header and .reloc section. The remaining size
+	 * is that of the .text section.
+	 */
+	file_sz -= 512;
+
+	/* Size of code */
+	*(unsigned int *)&buf[pe_header + 0x1c] = file_sz;
+
 #ifdef CONFIG_X86_32
 	/* Address of entry point */
 	*(unsigned int *)&buf[pe_header + 0x28] = i;
@@ -215,8 +222,14 @@ int main(int argc, char ** argv)
 	/* .text size */
 	*(unsigned int *)&buf[pe_header + 0xb0] = file_sz;
 
+	/* .text vma */
+	*(unsigned int *)&buf[pe_header + 0xb4] = 0x200;
+
 	/* .text size of initialised data */
 	*(unsigned int *)&buf[pe_header + 0xb8] = file_sz;
+
+	/* .text file offset */
+	*(unsigned int *)&buf[pe_header + 0xbc] = 0x200;
 #else
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
@@ -228,8 +241,14 @@ int main(int argc, char ** argv)
 	/* .text size */
 	*(unsigned int *)&buf[pe_header + 0xc0] = file_sz;
 
+	/* .text vma */
+	*(unsigned int *)&buf[pe_header + 0xc4] = 0x200;
+
 	/* .text size of initialised data */
 	*(unsigned int *)&buf[pe_header + 0xc8] = file_sz;
+
+	/* .text file offset */
+	*(unsigned int *)&buf[pe_header + 0xcc] = 0x200;
 #endif /* CONFIG_X86_32 */
 #endif /* CONFIG_EFI_STUB */
 
