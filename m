Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab0GVA6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:58:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0GVA6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:58:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <aviro@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: auditsyscall: fix fastpath return value after reschedule
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Amber pencils
   (2) Meretricious casino suicides
   (3) Diabetic lenient soft-serve
   (4) Reminiscent tape
Message-Id: <20100722005758.7AD8E400B8@magilla.sf.frob.com>
Date: Wed, 21 Jul 2010 17:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd5b8f8755a89a57fc8c408d284b8b613f090345:

  Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6 (2010-07-21 09:31:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/auditsyscall

Roland McGrath (1):
      x86: auditsyscall: fix fastpath return value after reschedule

 arch/x86/kernel/entry_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Thanks,
Roland
---
In the CONFIG_AUDITSYSCALL fast-path for x86 64-bit system calls,
we can pass a bad return value and/or error indication for the
system call to audit_syscall_exit().  This happens when
TIF_NEED_RESCHED was set as the system call returned, so we went
out to schedule() and came back to the exit-audit fast-path.  The
fix is to reload the user return value register from the pt_regs
before using it for audit_syscall_exit().

Both the 32-bit kernel's fast path and the 64-bit kernel's 32-bit
system call fast paths work slightly differently, so that they
always leave the fast path entirely to reschedule and don't return
there, so they don't have the analogous bugs.

Reported-by: Alexander Viro <aviro@redhat.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..4db7c4d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -571,8 +571,8 @@ auditsys:
 	 * masked off.
 	 */
 sysret_audit:
-	movq %rax,%rsi		/* second arg, syscall return value */
-	cmpq $0,%rax		/* is it < 0? */
+	movq RAX-ARGOFFSET(%rsp),%rsi	/* second arg, syscall return value */
+	cmpq $0,%rsi		/* is it < 0? */
 	setl %al		/* 1 if so, 0 if not */
 	movzbl %al,%edi		/* zero-extend that into %edi */
 	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
-- 
1.7.1.1
