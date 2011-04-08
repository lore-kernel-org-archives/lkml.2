Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab1DHRfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:35:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60223 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab1DHRfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tD1ARQ7ktImiKptV950BO6+hLIBe3/sgCz2fEH6WIOg1cG2N1AsTjrvhpJfV+V2aOn
         d+o+fCzB5+G8bv4xAHfsGzTjqS+p4WAryVhs8POJrJnf+RhLAfeuxKLiZRGRuQaL3QOR
         r+cFW9isqc3t6n721AePpkx58NALnMIJckEbM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/5] arm, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Fri,  8 Apr 2011 19:34:26 +0200
Message-Id: <1302284067-7860-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/kernel/ptrace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 2bf27f3..8182f45 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -767,12 +767,20 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
+			if (ptrace_get_breakpoints(child) < 0)
+				return -ESRCH;
+
 			ret = ptrace_gethbpregs(child, addr,
 						(unsigned long __user *)data);
+			ptrace_put_breakpoints(child);
 			break;
 		case PTRACE_SETHBPREGS:
+			if (ptrace_get_breakpoints(child) < 0)
+				return -ESRCH;
+
 			ret = ptrace_sethbpregs(child, addr,
 						(unsigned long __user *)data);
+			ptrace_put_breakpoints(child);
 			break;
 #endif
 
-- 
1.7.3.2

