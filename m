Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2FCUdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 16:33:13 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50688 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2FCUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 16:33:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87fwacb0jq.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 03 Jun 2012 13:30:49 -0700")
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sun, 03 Jun 2012 13:32:59 -0700
Message-ID: <877gvob0g4.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18owi9MtQxClAnhxNivQ3gM29q41e5p8SQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0074]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 2/2] x86, boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Create a space for the elf headers at the begginng of the
kernels image in memory.  Removing the need for an extra
copy of the kernel during boot.  Making things faster
and making vmlinux smaller.

- Allow room for the elf headers in the vmlinux.
  This removes the need to insert padding between
  the elf headers and the start of text.  Reducing
  the size of vmlinux by 2MB on x86_64 and removing
  the need for parse_elf in boot.c to move the code.

- Return the relocated entry point address from parse_elf
  as the kernel's entry point is no long at a fixed address.

- Remove the now unnecessary copies in arch/x86/compress/misc.c:parse_elf
  The ELF headers are now guaranteed to not conflict with the program
  data in the uncompressed image.

- In cleanup_highmap keep all pages starting with __START_KERNEL_map
  instead of _text.  Those values used to be the same but with the
  insertion of the hole for the ELF headers they differ and cause us
  to nuke our first 2MB of text ouch!  So use the __START_KERNEL_map
  which includes the elf headers.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/boot/compressed/misc.c    |   60 +++++++++++------------------------
 arch/x86/kernel/vmlinux.lds.S      |    4 +-
 arch/x86/mm/init_64.c              |    3 +-
 5 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index c85e3ac..1b15e2c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -211,7 +211,7 @@ relocated:
  * Jump to the decompressed kernel.
  */
 	xorl	%ebx, %ebx
-	jmp	*%ebp
+	jmp	*%eax
 
 /*
  * Stack and heap for uncompression
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 87e03a1..9b8d782 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -337,7 +337,7 @@ relocated:
 /*
  * Jump to the decompressed kernel.
  */
-	jmp	*%rbp
+	jmp	*%rax
 
 	.data
 gdt:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 5b04b66..fc34e8a 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -198,23 +198,23 @@ static void error(char *x)
 		asm("hlt");
 }
 
-static void parse_elf(void *output)
+static void *parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
-	Elf64_Ehdr ehdr;
-	Elf64_Phdr *phdrs, *phdr;
+	Elf64_Ehdr *ehdr;
+	Elf64_Phdr *phdrs;
 #else
-	Elf32_Ehdr ehdr;
-	Elf32_Phdr *phdrs, *phdr;
+	Elf32_Ehdr *ehdr;
+	Elf32_Phdr *phdrs;
 #endif
 	void *dest;
 	int i;
 
-	memcpy(&ehdr, output, sizeof(ehdr));
-	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
-	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
-	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
-	   ehdr.e_ident[EI_MAG3] != ELFMAG3) {
+	ehdr = output;
+	if (ehdr->e_ident[EI_MAG0] != ELFMAG0 ||
+	    ehdr->e_ident[EI_MAG1] != ELFMAG1 ||
+	    ehdr->e_ident[EI_MAG2] != ELFMAG2 ||
+	    ehdr->e_ident[EI_MAG3] != ELFMAG3) {
 		error("Kernel is not a valid ELF file");
 		return;
 	}
@@ -222,39 +222,17 @@ static void parse_elf(void *output)
 	if (!quiet)
 		putstr("Parsing ELF... ");
 
-	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
-	if (!phdrs)
-		error("Failed to allocate space for phdrs");
+	phdrs = output + ehdr->e_phoff;
 
-	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
-
-	for (i = 0; i < ehdr.e_phnum; i++) {
-		phdr = &phdrs[i];
-
-		switch (phdr->p_type) {
-		case PT_LOAD:
-#ifdef CONFIG_RELOCATABLE
-			dest = output;
-			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
-#else
-			dest = (void *)(phdr->p_paddr);
-#endif
-			memcpy(dest,
-			       output + phdr->p_offset,
-			       phdr->p_filesz);
-			break;
-		default: /* Ignore other PT_* */ break;
-		}
-	}
-
-	free(phdrs);
+	return output + (ehdr->e_entry - LOAD_PHYSICAL_ADDR);
 }
 
-asmlinkage void decompress_kernel(void *rmode, memptr heap,
-				  unsigned char *input_data,
-				  unsigned long input_len,
-				  unsigned char *output)
+asmlinkage void *decompress_kernel(void *rmode, memptr heap,
+				   unsigned char *input_data,
+				   unsigned long input_len,
+				   unsigned char *output)
 {
+	void *entry;
 	real_mode = rmode;
 
 	if (cmdline_find_option_bool("quiet"))
@@ -297,8 +275,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	if (!quiet)
 		putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
-	parse_elf(output);
+	entry = parse_elf(output);
 	if (!quiet)
 		putstr("done.\nBooting the kernel.\n");
-	return;
+	return entry;
 }
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..af6fb8a 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -82,10 +82,10 @@ PHDRS {
 SECTIONS
 {
 #ifdef CONFIG_X86_32
-        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR + SIZEOF_HEADERS;
         phys_startup_32 = startup_32 - LOAD_OFFSET;
 #else
-        . = __START_KERNEL;
+        . = __START_KERNEL + SIZEOF_HEADERS;
         phys_startup_64 = startup_64 - LOAD_OFFSET;
 #endif
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..e8599cd 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -303,13 +303,14 @@ void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
 	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long text = __START_KERNEL_map;
 	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 
 	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
-		if (vaddr < (unsigned long) _text || vaddr > end)
+		if (vaddr < text || vaddr > end)
 			set_pmd(pmd, __pmd(0));
 	}
 }
-- 
1.7.5.4

