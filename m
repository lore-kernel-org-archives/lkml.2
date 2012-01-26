Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2AZVjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:39:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2AZVjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:39:03 -0500
Date: Thu, 26 Jan 2012 13:38:46 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-9d8e22777e66f420e46490e9fc6f8cb7e0e2222b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F218584020000780006F422@nat28.tlf.novell.com>
References: <4F218584020000780006F422@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Handle byte-wise tail copying in memcpy()
  without a loop
Git-Commit-ID: 9d8e22777e66f420e46490e9fc6f8cb7e0e2222b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:38:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d8e22777e66f420e46490e9fc6f8cb7e0e2222b
Gitweb:     http://git.kernel.org/tip/9d8e22777e66f420e46490e9fc6f8cb7e0e2222b
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 26 Jan 2012 15:55:32 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:19:20 +0100

x86-64: Handle byte-wise tail copying in memcpy() without a loop

While hard to measure, reducing the number of possibly/likely
mis-predicted branches can generally be expected to be slightly
better.

Other than apparent at the first glance, this also doesn't grow
the function size (the alignment gap to the next function just
gets smaller).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F218584020000780006F422@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/memcpy_64.S |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 1235b04..1c273be 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -164,18 +164,19 @@ ENTRY(memcpy)
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
