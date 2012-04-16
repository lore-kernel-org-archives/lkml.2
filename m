Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2DPSjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:39:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2DPSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:39:11 -0400
Date: Mon, 16 Apr 2012 11:37:40 -0700
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-c206d672150e7abbb5c14a70665abca24ea87ea5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, matt.hfleming@intel.com,
        matt.fleming@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com, matt.hfleming@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1334584744.26997.14.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1334584744.26997.14.camel@mfleming-mobl1.ger.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Add dedicated EFI stub entry point
Git-Commit-ID: c206d672150e7abbb5c14a70665abca24ea87ea5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Apr 2012 11:37:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c206d672150e7abbb5c14a70665abca24ea87ea5
Gitweb:     http://git.kernel.org/tip/c206d672150e7abbb5c14a70665abca24ea87ea5
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Sun, 15 Apr 2012 16:06:04 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 Apr 2012 10:22:44 -0700

x86, efi: Add dedicated EFI stub entry point

The method used to work out whether we were booted by EFI firmware or
via a boot loader is broken. Because efi_main() is always executed
when booting from a boot loader we will dereference invalid pointers
either on the stack (CONFIG_X86_32) or contained in %rdx
(CONFIG_X86_64) when searching for an EFI System Table signature.

Instead of dereferencing these invalid system table pointers, add a
new entry point that is only used when booting from EFI firmware, when
we know the pointer arguments will be valid. With this change legacy
boot loaders will no longer execute efi_main(), but will instead skip
EFI stub initialisation completely.

[ hpa: Marking this for urgent/stable since it is a regression when
  the option is enabled; without the option the patch has no effect ]

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.hfleming@intel.com>
Link: http://lkml.kernel.org/r/1334584744.26997.14.camel@mfleming-mobl1.ger.corp.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> v3.3
---
 arch/x86/boot/compressed/head_32.S |   14 +++++++++++---
 arch/x86/boot/compressed/head_64.S |   22 ++++++++++++++++------
 arch/x86/boot/tools/build.c        |   15 +++++++++++----
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index a055993..c85e3ac 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -33,6 +33,9 @@
 	__HEAD
 ENTRY(startup_32)
 #ifdef CONFIG_EFI_STUB
+	jmp	preferred_addr
+
+	.balign	0x10
 	/*
 	 * We don't need the return address, so set up the stack so
 	 * efi_main() can find its arugments.
@@ -41,12 +44,17 @@ ENTRY(startup_32)
 
 	call	efi_main
 	cmpl	$0, %eax
-	je	preferred_addr
 	movl	%eax, %esi
-	call	1f
+	jne	2f
 1:
+	/* EFI init failed, so hang. */
+	hlt
+	jmp	1b
+2:
+	call	3f
+3:
 	popl	%eax
-	subl	$1b, %eax
+	subl	$3b, %eax
 	subl	BP_pref_address(%esi), %eax
 	add	BP_code32_start(%esi), %eax
 	leal	preferred_addr(%eax), %eax
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 558d76c..87e03a1 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -200,18 +200,28 @@ ENTRY(startup_64)
 	 * entire text+data+bss and hopefully all of memory.
 	 */
 #ifdef CONFIG_EFI_STUB
-	pushq	%rsi
+	/*
+	 * The entry point for the PE/COFF executable is 0x210, so only
+	 * legacy boot loaders will execute this jmp.
+	 */
+	jmp	preferred_addr
+
+	.org 0x210
 	mov	%rcx, %rdi
 	mov	%rdx, %rsi
 	call	efi_main
-	popq	%rsi
-	cmpq	$0,%rax
-	je	preferred_addr
 	movq	%rax,%rsi
-	call	1f
+	cmpq	$0,%rax
+	jne	2f
 1:
+	/* EFI init failed, so hang. */
+	hlt
+	jmp	1b
+2:
+	call	3f
+3:
 	popq	%rax
-	subq	$1b, %rax
+	subq	$3b, %rax
 	subq	BP_pref_address(%rsi), %rax
 	add	BP_code32_start(%esi), %eax
 	leaq	preferred_addr(%rax), %rax
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index ed54976..24443a3 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -205,8 +205,13 @@ int main(int argc, char ** argv)
 	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
 
 #ifdef CONFIG_X86_32
-	/* Address of entry point */
-	put_unaligned_le32(i, &buf[pe_header + 0x28]);
+	/*
+	 * Address of entry point.
+	 *
+	 * The EFI stub entry point is +16 bytes from the start of
+	 * the .text section.
+	 */
+	put_unaligned_le32(i + 16, &buf[pe_header + 0x28]);
 
 	/* .text size */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xb0]);
@@ -217,9 +222,11 @@ int main(int argc, char ** argv)
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
 	 * the 64-bit entry point (startup_64) is always 512 bytes
-	 * after.
+	 * after. The EFI stub entry point is 16 bytes after that, as
+	 * the first instruction allows legacy loaders to jump over
+	 * the EFI stub initialisation
 	 */
-	put_unaligned_le32(i + 512, &buf[pe_header + 0x28]);
+	put_unaligned_le32(i + 528, &buf[pe_header + 0x28]);
 
 	/* .text size */
 	put_unaligned_le32(file_sz, &buf[pe_header + 0xc0]);
