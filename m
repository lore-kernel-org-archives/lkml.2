Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1DHRfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:35:19 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43065 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab1DHRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gsN9N+npGVgyGyNarnleuAs95ljV+tRTWKn+qKE4H4mdik5hzOURM9sq4DtYgeJIDK
         fANn8n8GypCrA/bXS6RTHbAp26JmkLi6NWGLAD8DXX4yGlw7I24U/6hZXSN8kOIV9e2F
         Z+wWHO6YcXUU1dscInsJW+HI1fMQYO5tPyCfE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 3/5] powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Fri,  8 Apr 2011 19:34:25 +0200
Message-Id: <1302284067-7860-4-git-send-email-fweisbec@gmail.com>
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: v2.6.33.. <stable@kernel.org>
---
 arch/powerpc/kernel/ptrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 895b082..330df91 100644
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

