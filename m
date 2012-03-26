Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2CZWTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:19:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CZWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:19:54 -0400
Date: Mon, 26 Mar 2012 15:19:42 -0700
From: tip-bot for Jordan Justen <jordan.l.justen@intel.com>
Message-ID: <tip-2e064b1e131eba262c0ba4268cb79dbc72edeece@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, matt.fleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1332520506-6472-2-git-send-email-jordan.l.justen@intel.com>
References: <1332520506-6472-2-git-send-email-jordan.l.justen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Fix issue of overlapping .
 reloc section for EFI_STUB
Git-Commit-ID: 2e064b1e131eba262c0ba4268cb79dbc72edeece
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 26 Mar 2012 15:19:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e064b1e131eba262c0ba4268cb79dbc72edeece
Gitweb:     http://git.kernel.org/tip/2e064b1e131eba262c0ba4268cb79dbc72edeece
Author:     Jordan Justen <jordan.l.justen@intel.com>
AuthorDate: Fri, 23 Mar 2012 09:35:04 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 26 Mar 2012 13:08:33 -0700

x86, efi: Fix issue of overlapping .reloc section for EFI_STUB

Previously the .reloc section was embedded in the .text
section.

No relocations are required during the PE/COFF loading phase
for the kernel using the EFI_STUB UEFI loader. To fix the
issue of overlapping sections, create a .reloc section with a
zero length.

The .reloc section header must exist to make sure the image
will be loaded by the UEFI firmware, but a zero-length
section header seems to be sufficient.

Signed-off-by: Jordan Justen <jordan.l.justen@intel.com>
Link: http://lkml.kernel.org/r/1332520506-6472-2-git-send-email-jordan.l.justen@intel.com
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/header.S |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index f1bbeeb..4e9124b 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
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
