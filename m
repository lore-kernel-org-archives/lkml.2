Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2AVEAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 23:00:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2AVEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 23:00:16 -0500
Date: Sat, 21 Jan 2012 20:00:00 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-cb8095bba6d24118135a5683a956f4f4fb5f17bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, luca@luca-barbieri.com, jbeulich@suse.com,
        JBeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, luca@luca-barbieri.com, JBeulich@suse.com,
        jbeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4F19A2BC020000780006E0DC@nat28.tlf.novell.com>
References: <4F19A2BC020000780006E0DC@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86: atomic64 assembly improvements
Git-Commit-ID: cb8095bba6d24118135a5683a956f4f4fb5f17bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jan 2012 20:00:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb8095bba6d24118135a5683a956f4f4fb5f17bb
Gitweb:     http://git.kernel.org/tip/cb8095bba6d24118135a5683a956f4f4fb5f17bb
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 20 Jan 2012 16:22:04 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Jan 2012 17:29:49 -0800

x86: atomic64 assembly improvements

In the "xchg" implementation, %ebx and %ecx don't need to be copied
into %eax and %edx respectively (this is only necessary when desiring
to only read the stored value).

In the "add_unless" implementation, swapping the use of %ecx and %esi
for passing arguments allows %esi to become an input only (i.e.
permitting the register to be re-used to address the same object
without reload).

In "{add,sub}_return", doing the initial read64 through the passed in
%ecx decreases a register dependency.

In "inc_not_zero", a branch can be eliminated by or-ing together the
two halves of the current (64-bit) value, and code size can be further
reduced by adjusting the arithmetic slightly.

v2: Undo the folding of "xchg" and "set".

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F19A2BC020000780006E0DC@nat28.tlf.novell.com
Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/atomic64_32.h |    5 ++---
 arch/x86/lib/atomic64_386_32.S     |    6 +++---
 arch/x86/lib/atomic64_cx8_32.S     |   29 +++++++++++------------------
 3 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 908303f..1981199 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -288,9 +288,8 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	unsigned low = (unsigned)u;
 	unsigned high = (unsigned)(u >> 32);
 	alternative_atomic64(add_unless,
-			     ASM_OUTPUT2("+A" (a), "+c" (v),
-					 "+S" (low), "+D" (high)),
-			     ASM_NO_INPUT_CLOBBER("memory"));
+			     ASM_OUTPUT2("+A" (a), "+c" (low), "+D" (high)),
+			     "S" (v) : "memory");
 	return (int)a;
 }
 
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index e8e7e0d..00933d5 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -137,13 +137,13 @@ BEGIN(dec_return)
 RET_ENDP
 #undef v
 
-#define v %ecx
+#define v %esi
 BEGIN(add_unless)
-	addl %eax, %esi
+	addl %eax, %ecx
 	adcl %edx, %edi
 	addl  (v), %eax
 	adcl 4(v), %edx
-	cmpl %eax, %esi
+	cmpl %eax, %ecx
 	je 3f
 1:
 	movl %eax,  (v)
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index 391a083..f5cc9eb 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -55,8 +55,6 @@ ENDPROC(atomic64_set_cx8)
 ENTRY(atomic64_xchg_cx8)
 	CFI_STARTPROC
 
-	movl %ebx, %eax
-	movl %ecx, %edx
 1:
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
@@ -78,7 +76,7 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %edi
 	movl %ecx, %ebp
 
-	read64 %ebp
+	read64 %ecx
 1:
 	movl %eax, %ebx
 	movl %edx, %ecx
@@ -159,23 +157,22 @@ ENTRY(atomic64_add_unless_cx8)
 	SAVE ebx
 /* these just push these two parameters on the stack */
 	SAVE edi
-	SAVE esi
+	SAVE ecx
 
-	movl %ecx, %ebp
-	movl %eax, %esi
+	movl %eax, %ebp
 	movl %edx, %edi
 
-	read64 %ebp
+	read64 %esi
 1:
 	cmpl %eax, 0(%esp)
 	je 4f
 2:
 	movl %eax, %ebx
 	movl %edx, %ecx
-	addl %esi, %ebx
+	addl %ebp, %ebx
 	adcl %edi, %ecx
 	LOCK_PREFIX
-	cmpxchg8b (%ebp)
+	cmpxchg8b (%esi)
 	jne 1b
 
 	movl $1, %eax
@@ -199,13 +196,13 @@ ENTRY(atomic64_inc_not_zero_cx8)
 
 	read64 %esi
 1:
-	testl %eax, %eax
-	je 4f
-2:
+	movl %eax, %ecx
+	orl %edx, %ecx
+	jz 3f
 	movl %eax, %ebx
-	movl %edx, %ecx
+	xorl %ecx, %ecx
 	addl $1, %ebx
-	adcl $0, %ecx
+	adcl %edx, %ecx
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -214,9 +211,5 @@ ENTRY(atomic64_inc_not_zero_cx8)
 3:
 	RESTORE ebx
 	ret
-4:
-	testl %edx, %edx
-	jne 2b
-	jmp 3b
 	CFI_ENDPROC
 ENDPROC(atomic64_inc_not_zero_cx8)
