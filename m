Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab1DHRfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:35:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55671 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab1DHRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:35:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jvxHZjgjqUMF8bkRSAgWFI3zRjWq1oFxl5FcTW5/0bLmP/hoXMncR2RdKFJgq9gDMs
         L6BCuP7hXZl8to73QKy+3OdVWBqrxF8bxkdDufM3+NOV+WHtRRAhX0u5huRGF7K8bQkc
         CZEHXdGvjAUCRUov+1f5mL6fYLFQJ7BhSC5xM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 5/5] sh, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Fri,  8 Apr 2011 19:34:27 +0200
Message-Id: <1302284067-7860-6-git-send-email-fweisbec@gmail.com>
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

