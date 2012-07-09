Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2GIGwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:52:23 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60128 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2GIGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:52:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <4FCAD590.8000506@zytor.com>
	<87obp0bxdv.fsf@xmission.com> <4FCB602B.70907@zytor.com>
	<87fwacb0jq.fsf_-_@xmission.com> <877gvob0g4.fsf_-_@xmission.com>
	<4FF06701.6010004@zytor.com> <4FF06DF4.4000006@zytor.com>
	<87wr2nsbvi.fsf@xmission.com> <4FF0769F.8090105@zytor.com>
	<87sjdbsb0v.fsf@xmission.com> <4FF07E66.2020706@zytor.com>
	<87d34fs914.fsf@xmission.com> <4FF085B1.6070604@zytor.com>
	<87a9zj9w43.fsf@xmission.com> <4FF098E2.3040307@zytor.com>
	<87sjdb8f0m.fsf@xmission.com> <4FF0A399.8070207@zytor.com>
	<87txxr6wre.fsf@xmission.com> <4FF0B891.8080804@zytor.com>
	<87k3yd5sxt.fsf@xmission.com>
Date: Sun, 08 Jul 2012 23:52:15 -0700
In-Reply-To: <87k3yd5sxt.fsf@xmission.com> (Eric W. Biederman's message of
	"Sun, 08 Jul 2012 23:50:38 -0700")
Message-ID: <87fw915sv4.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/St3grq6IGHlbGFWCKTA08w92qQpZLlgw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0055]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 1/4] x86 boot: Jump to the entry point address in the elf header.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since we have the kernel's entry point stored in the ELF header use it,
and stop hardcoding the value.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 arch/x86/boot/compressed/head_64.S |    2 +-
 arch/x86/boot/compressed/misc.c    |   16 +++++++++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

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
index 7116dcb..fc96c3e 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -273,7 +273,7 @@ static void error(char *x)
 		asm("hlt");
 }
 
-static void parse_elf(void *output)
+static void *parse_elf(void *output)
 {
 #ifdef CONFIG_X86_64
 	Elf64_Ehdr ehdr;
@@ -323,13 +323,15 @@ static void parse_elf(void *output)
 	}
 
 	free(phdrs);
+	return output + (ehdr.e_entry - LOAD_PHYSICAL_ADDR);
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
@@ -372,8 +374,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
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
-- 
1.7.5.4

