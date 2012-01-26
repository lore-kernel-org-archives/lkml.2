Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2AZPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:54:23 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38420 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2AZPyV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 26 Jan 2012 10:54:21 -0500
Message-Id: <4F218584020000780006F422@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jan 2012 15:55:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: handle byte-wise tail copying in memcpy()
 without a loop
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While hard to measure, reducing the number of possibly/likely
mis-predicted branches can generally be expected to be slightly better.

Other than apparent at the first glance, this also doesn't grow the
function size (the alignment gap to the next function just gets
smaller).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/lib/memcpy_64.S |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- 3.3-rc1/arch/x86/lib/memcpy_64.S
+++ 3.3-rc1-x86_64-memcpy-tail/arch/x86/lib/memcpy_64.S
@@ -169,18 +169,19 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_3bytes:
-	cmpl $0, %edx
-	je .Lend
+	subl $1, %edx
+	jb .Lend
 	/*
 	 * Move data from 1 bytes to 3 bytes.
 	 */
-.Lloop_1:
-	movb (%rsi), %r8b
-	movb %r8b, (%rdi)
-	incq %rdi
-	incq %rsi
-	decl %edx
-	jnz .Lloop_1
+	movzbl (%rsi), %ecx
+	jz .Lstore_1byte
+	movzbq 1(%rsi), %r8
+	movzbq (%rsi, %rdx), %r9
+	movb %r8b, 1(%rdi)
+	movb %r9b, (%rdi, %rdx)
+.Lstore_1byte:
+	movb %cl, (%rdi)
 
 .Lend:
 	retq



