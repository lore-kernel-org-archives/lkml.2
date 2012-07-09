Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2GIGxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:53:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60832 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2GIGxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:53:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com>
	<4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
	<4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
	<4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com>
	<4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com>
	<4FF0A399.8070207@zytor.com> <87txxr6wre.fsf@xmission.com>
	<4FF0B891.8080804@zytor.com> <87k3yd5sxt.fsf@xmission.com>
	<87fw915sv4.fsf_-_@xmission.com>
Date: Sun, 08 Jul 2012 23:53:15 -0700
In-Reply-To: <87fw915sv4.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 08 Jul 2012 23:52:15 -0700")
Message-ID: <87bojp5stg.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18EZnhA+D3f4ZEMeVni3nWdftQHIEq1WX0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1201]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 2/4] x86 boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Create a space for the elf headers at the begginng of the kernels
image in memory.

- Rework arch/x86/kernel/vmlinux.lds.S so that we allow room for
  the ELF header in the loaded image.  This removes the need in
  the ELF executalbe to insert padding between the ELf headers
  and the data of the first program segment.  This reduces the
  size of vmlinux by 2MB on x86_64.  This removes an overlap
  of the ELF header and kernel text in arch/x86/boot/compressed
  that required code to moved.

- Move the symbol _text outside of the .text section, and add the
  fixups in relocs.c to add relocations against _text.  This allows
  the symbol _text to come before the ELF header and effectively
  including the ELF header in the text section.

  If this isn't done _text moves 344 bytes in memory on x86_64 and
  creates subtle breakage in routines like cleanup_highmap, which
  assume _text is at the beginning of the kernels memory and that
  _text is 4K+ aligned.

  The current usage of the symbol _text is already that _text
  specifies the beginning of the kernel's memory and that _stext
  specifies where the kernel's code actually starts.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/vmlinux.lds.S |    9 +++++----
 arch/x86/tools/relocs.c       |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..d6e1a44 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -68,7 +68,7 @@ jiffies_64 = jiffies;
 #endif
 
 PHDRS {
-	text PT_LOAD FLAGS(5);          /* R_E */
+	text PT_LOAD FLAGS(5) FILEHDR;  /* R_E */
 	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_SMP
@@ -82,16 +82,17 @@ PHDRS {
 SECTIONS
 {
 #ifdef CONFIG_X86_32
-        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+	_text = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR + SIZEOF_HEADERS;
         phys_startup_32 = startup_32 - LOAD_OFFSET;
 #else
-        . = __START_KERNEL;
+	_text = __START_KERNEL;
+        . = __START_KERNEL + SIZEOF_HEADERS;
         phys_startup_64 = startup_64 - LOAD_OFFSET;
 #endif
 
 	/* Text and read-only data */
 	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
-		_text = .;
 		/* bootstrapping code */
 		HEAD_TEXT
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 5a1847d..6f32b7b 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -72,6 +72,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__end_rodata|"
 	"__initramfs_start|"
 	"(jiffies|jiffies_64)|"
+	"_text|"
 	"_end)$"
 };
 
-- 
1.7.5.4

