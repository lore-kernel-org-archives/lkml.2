Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1EDUaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:30:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:43420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab1EDU37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:29:59 -0400
Date: Wed, 4 May 2011 20:29:19 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-07fa7a0a8a586c01a8b416358c7012dcb9dc688d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, tglx@linutronix.de,
        oleg@redhat.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        fweisbec@gmail.com, stable@kernel.org, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
Git-Commit-ID: 07fa7a0a8a586c01a8b416358c7012dcb9dc688d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 20:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07fa7a0a8a586c01a8b416358c7012dcb9dc688d
Gitweb:     http://git.kernel.org/tip/07fa7a0a8a586c01a8b416358c7012dcb9dc688d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 8 Apr 2011 17:29:36 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 25 Apr 2011 17:33:54 +0200

powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Prasad <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: v2.6.33.. <stable@kernel.org>
Link: http://lkml.kernel.org/r/1302284067-7860-4-git-send-email-fweisbec@gmail.com
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
