Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1EDUan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:30:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:43471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab1EDUak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:30:40 -0400
Date: Wed, 4 May 2011 20:30:13 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-e0ac8457d020c0289ea566917267da9e5e6d9865@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
        fweisbec@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        fweisbec@gmail.com, oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        prasad@linux.vnet.ibm.com
In-Reply-To: <1302284067-7860-6-git-send-email-fweisbec@gmail.com>
References: <1302284067-7860-6-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] sh, hw_breakpoints: Fix racy access to ptrace breakpoints
Git-Commit-ID: e0ac8457d020c0289ea566917267da9e5e6d9865
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 20:30:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0ac8457d020c0289ea566917267da9e5e6d9865
Gitweb:     http://git.kernel.org/tip/e0ac8457d020c0289ea566917267da9e5e6d9865
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 8 Apr 2011 17:29:36 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 25 Apr 2011 17:36:12 +0200

sh, hw_breakpoints: Fix racy access to ptrace breakpoints

While the tracer accesses ptrace breakpoints, the child task may
concurrently exit due to a SIGKILL and thus release its breakpoints
at the same time. We can then dereference some freed pointers.

To fix this, hold a reference on the child breakpoints before
manipulating them.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1302284067-7860-6-git-send-email-fweisbec@gmail.com
---
 arch/sh/kernel/ptrace_32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 2130ca6..3d7b209 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -117,7 +117,11 @@ void user_enable_single_step(struct task_struct *child)
 
 	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 
+	if (ptrace_get_breakpoints(child) < 0)
+		return;
+
 	set_single_step(child, pc);
+	ptrace_put_breakpoints(child);
 }
 
 void user_disable_single_step(struct task_struct *child)
