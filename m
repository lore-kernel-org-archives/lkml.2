Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2JBGxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:53:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2JBGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:53:02 -0400
Date: Mon, 1 Oct 2012 23:52:45 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
References: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, suspend: Correct the restore of CR4, EFER;
  skip computing EFLAGS.ID
Git-Commit-ID: 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 01 Oct 2012 23:52:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
Gitweb:     http://git.kernel.org/tip/1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 1 Oct 2012 14:34:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 2 Oct 2012 08:42:31 +0200

x86, suspend: Correct the restore of CR4, EFER; skip computing EFLAGS.ID

The patch:

    73201dbe x86, suspend: On wakeup always initialize cr4 and EFER

... was incorrectly committed in an intermediate (unfinished) form.

- We need to test CF, not ZF, for a bit test with btl.
- We don't actually need to compute the existence of EFLAGS.ID,
  since we set a flag at suspend time if CR4 should be restored.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/1348529239-17943-1-git-send-email-hpa@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/realmode/rm/wakeup_asm.S |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index e56479e..9e7e147 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -74,18 +74,9 @@ ENTRY(wakeup_start)
 
 	lidtl	wakeup_idt
 
-	/* Clear the EFLAGS but remember if we have EFLAGS.ID */
-	movl $X86_EFLAGS_ID, %ecx
-	pushl %ecx
-	popfl
-	pushfl
-	popl %edi
+	/* Clear the EFLAGS */
 	pushl $0
 	popfl
-	pushfl
-	popl %edx
-	xorl %edx, %edi
-	andl %ecx, %edi		/* %edi is zero iff CPUID & %cr4 are missing */
 
 	/* Check header signature... */
 	movl	signature, %eax
@@ -120,12 +111,12 @@ ENTRY(wakeup_start)
 	movl	%eax, %cr3
 
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_cr4, %eax
 	movl	%eax, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
 	movl	$MSR_EFER, %ecx
