Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0FXVmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:42:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0FXVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ucMhRQIT3+CFnlZQzV1EMIagH8z+6Z9kX7t3qKja0GHtktsdNekmO3u4UxuSXRZ/y3
         E6kz+RFO9VJZt4UeVtesWsfvpckbz5bYJf53aYravv/IfZ+Yx9nzWWFUEb0a3Rh8IuA+
         EkLztL9TSa19p3tRcLwp85k7eQhSGjtuAU35o=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/7] x86: Set resume bit before returning from breakpoint exception
Date: Thu, 24 Jun 2010 23:40:54 +0200
Message-Id: <1277415658-10036-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction breakpoints trigger before the instruction executes,
and returning back from the breakpoint handler brings us again
to the instruction that breakpointed. This naturally bring to
a breakpoint recursion.

To solve this, x86 has the Resume Bit trick. When the cpu flags
have the RF flag set, the next instruction won't trigger any
instruction breakpoint, and once this instruction is executed,
RF is cleared back.

This let's us jump back to the instruction that triggered the
breakpoint without recursion.

Use this when an instruction breakpoint triggers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/hw_breakpoint.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a8f1b80..eaa6ae2 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -466,6 +466,13 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 
 		perf_bp_event(bp, args->regs);
 
+		/*
+		 * Set up resume flag to avoid breakpoint recursion when
+		 * returning back to origin.
+		 */
+		if (bp->hw.info.type == X86_BREAKPOINT_EXECUTE)
+			args->regs->flags |= X86_EFLAGS_RF;
+
 		rcu_read_unlock();
 	}
 	/*
-- 
1.6.2.3

