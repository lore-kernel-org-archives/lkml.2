Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1DVNQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:16:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59262 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1DVNQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ngoj7QuQ2ZSc8q5Hw45tkrYhIyCcvmIa/xGdT+FB7OpF5ra4z4VR3KChuMmdyv2Yam
         Rcw+NXQNshAwB6o8mWEzQrlTXmneMEbEgXptp1eYSCnkZD+/gaWcoIcqGzE9/lExKxqt
         nMB3dS6lGgY504F6QEaobofJmXvZ7R62r/Q1w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LPPC <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 3/5] powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Fri, 22 Apr 2011 15:16:27 +0200
Message-Id: <1303478187-2367-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend with ppc list in cc)

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: v2.6.33.. <stable@kernel.org>
---
 arch/powerpc/kernel/ptrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 55613e3..4edeeb3 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1591,7 +1591,10 @@ long arch_ptrace(struct task_struct *child, long request,
 	}
 
 	case PTRACE_SET_DEBUGREG:
+		if (ptrace_get_breakpoints(child) < 0)
+			return -ESRCH;
 		ret = ptrace_set_debugreg(child, addr, data);
+		ptrace_put_breakpoints(child);
 		break;
 
 #ifdef CONFIG_PPC64
-- 
1.7.3.2

