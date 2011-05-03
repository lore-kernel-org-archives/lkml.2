Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1ECNZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:25:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65460 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1ECNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WP45U1wjz2qee4w0NcLUo/6uz7nBVqnYYSP3cIqeI09WnzRfNQYGO5gIr0HZt9AwLK
         dXhFxv6/FeI1HV+o/w/jNL7rj40ruCKN1C9heID5SGIpDFUgXZXrqduB4yUOwTnVxIaX
         TLiiqt0n3nx0ie5v/vFhGzywRN33N8InrwRvQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 5/5] sh, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Tue,  3 May 2011 15:25:24 +0200
Message-Id: <1304429124-2376-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
References: <1304429124-2376-1-git-send-email-fweisbec@gmail.com>
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
-- 
1.7.3.2

