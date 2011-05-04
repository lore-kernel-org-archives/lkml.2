Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1EDUaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:30:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:43459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab1EDUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:30:20 -0400
Date: Wed, 4 May 2011 20:29:46 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-bf0b8f4b55e591ba417c2dbaff42769e1fc773b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        fweisbec@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
        fweisbec@gmail.com, oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        prasad@linux.vnet.ibm.com
In-Reply-To: <1302284067-7860-5-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-5-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] arm, hw_breakpoints: Fix racy access to ptrace breakpoints
Git-Commit-ID: bf0b8f4b55e591ba417c2dbaff42769e1fc773b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 20:29:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf0b8f4b55e591ba417c2dbaff42769e1fc773b0
Gitweb:     http://git.kernel.org/tip/bf0b8f4b55e591ba417c2dbaff42769e1fc773b0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 8 Apr 2011 17:29:36 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 25 Apr 2011 17:35:18 +0200

arm, hw_breakpoints: Fix racy access to ptrace breakpoints

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1302284067-7860-5-git-send-email-fweisbec@gmail.com
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
 
