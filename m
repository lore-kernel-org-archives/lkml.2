Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1LESAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:00:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab1LESAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:00:32 -0500
Date: Mon, 5 Dec 2011 10:00:14 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-70ea6855d368588a7f1b0242ab83ca6fe2e2ff16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ED4C7EE0200007800064028@nat28.tlf.novell.com>
References: <4ED4C7EE0200007800064028@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Slightly shorten int_ret_from_sys_call
Git-Commit-ID: 70ea6855d368588a7f1b0242ab83ca6fe2e2ff16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:00:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70ea6855d368588a7f1b0242ab83ca6fe2e2ff16
Gitweb:     http://git.kernel.org/tip/70ea6855d368588a7f1b0242ab83ca6fe2e2ff16
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 29 Nov 2011 10:54:22 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:24:37 +0100

x86-64: Slightly shorten int_ret_from_sys_call

Testing for a return to ring 0 was necessary here solely because
of the branch out of ret_from_fork. That branch, however, can be
directed to retint_restore_args, and thus the test-and-branch
can be eliminated here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/4ED4C7EE0200007800064028@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index faf8d5e..ab4b7ff 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -411,7 +411,7 @@ ENTRY(ret_from_fork)
 	RESTORE_REST
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
-	je   int_ret_from_sys_call
+	jz   retint_restore_args
 
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
@@ -612,8 +612,6 @@ tracesys:
 GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $3,CS-ARGOFFSET(%rsp)
-	je retint_restore_args
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	mask to check */
 GLOBAL(int_with_check)
