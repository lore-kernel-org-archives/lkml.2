Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2AZNkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:40:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2AZNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:40:43 -0500
Date: Thu, 26 Jan 2012 05:40:18 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-5d7244e7c984cecead412bde6395ce18618a4a37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F05D992020000780006AA09@nat28.tlf.novell.com>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Fix memset()
  to support sizes of 4Gb and above
Git-Commit-ID: 5d7244e7c984cecead412bde6395ce18618a4a37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:40:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d7244e7c984cecead412bde6395ce18618a4a37
Gitweb:     http://git.kernel.org/tip/5d7244e7c984cecead412bde6395ce18618a4a37
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 5 Jan 2012 16:10:42 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 11:50:04 +0100

x86-64: Fix memset() to support sizes of 4Gb and above

While currently there doesn't appear to be any reachable in-tree
case where such large memory blocks may be passed to memset()
(alloc_bootmem() being the primary non-reachable one, as it gets
called with suitably large sizes in FLATMEM configurations), we
have recently hit the problem a second time in our Xen kernels.

Rather than working around it a second time, prevent others from
falling into the same trap by fixing this long standing
limitation.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F05D992020000780006AA09@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/memset_64.S |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 79bd454..2dcb380 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -19,16 +19,15 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemset_c:
 	movq %rdi,%r9
-	movl %edx,%r8d
-	andl $7,%r8d
-	movl %edx,%ecx
-	shrl $3,%ecx
+	movq %rdx,%rcx
+	andl $7,%edx
+	shrq $3,%rcx
 	/* expand byte value  */
 	movzbl %sil,%esi
 	movabs $0x0101010101010101,%rax
-	mulq %rsi		/* with rax, clobbers rdx */
+	imulq %rsi,%rax
 	rep stosq
-	movl %r8d,%ecx
+	movl %edx,%ecx
 	rep stosb
 	movq %r9,%rax
 	ret
@@ -50,7 +49,7 @@
 .Lmemset_c_e:
 	movq %rdi,%r9
 	movb %sil,%al
-	movl %edx,%ecx
+	movq %rdx,%rcx
 	rep stosb
 	movq %r9,%rax
 	ret
@@ -61,12 +60,11 @@ ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
 	movq %rdi,%r10
-	movq %rdx,%r11
 
 	/* expand byte value  */
 	movzbl %sil,%ecx
 	movabs $0x0101010101010101,%rax
-	mul    %rcx		/* with rax, clobbers rdx */
+	imulq  %rcx,%rax
 
 	/* align dst */
 	movl  %edi,%r9d
@@ -75,13 +73,13 @@ ENTRY(__memset)
 	CFI_REMEMBER_STATE
 .Lafter_bad_alignment:
 
-	movl %r11d,%ecx
-	shrl $6,%ecx
+	movq  %rdx,%rcx
+	shrq  $6,%rcx
 	jz	 .Lhandle_tail
 
 	.p2align 4
 .Lloop_64:
-	decl   %ecx
+	decq  %rcx
 	movq  %rax,(%rdi)
 	movq  %rax,8(%rdi)
 	movq  %rax,16(%rdi)
@@ -97,7 +95,7 @@ ENTRY(__memset)
 	   to predict jump tables. */
 	.p2align 4
 .Lhandle_tail:
-	movl	%r11d,%ecx
+	movl	%edx,%ecx
 	andl    $63&(~7),%ecx
 	jz 		.Lhandle_7
 	shrl	$3,%ecx
@@ -109,12 +107,11 @@ ENTRY(__memset)
 	jnz    .Lloop_8
 
 .Lhandle_7:
-	movl	%r11d,%ecx
-	andl	$7,%ecx
+	andl	$7,%edx
 	jz      .Lende
 	.p2align 4
 .Lloop_1:
-	decl    %ecx
+	decl    %edx
 	movb 	%al,(%rdi)
 	leaq	1(%rdi),%rdi
 	jnz     .Lloop_1
@@ -125,13 +122,13 @@ ENTRY(__memset)
 
 	CFI_RESTORE_STATE
 .Lbad_alignment:
-	cmpq $7,%r11
+	cmpq $7,%rdx
 	jbe	.Lhandle_7
 	movq %rax,(%rdi)	/* unaligned store */
 	movq $8,%r8
 	subq %r9,%r8
 	addq %r8,%rdi
-	subq %r8,%r11
+	subq %r8,%rdx
 	jmp .Lafter_bad_alignment
 .Lfinal:
 	CFI_ENDPROC
