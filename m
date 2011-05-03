Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1ECN03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:26:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1ECNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I/yOYLx6924dFhngQqf1TwQ3C6Wha0Xtbwf+Vd9WXhWNFYUukcc3bnbJV0V+gbW3Br
         0LOn4zpNeMawTnVyOG6elajxXQx3+tys+DL8tavkIdxTvoDZJXHOmyWc+CqC1bZ3VGm7
         4+1wnD9zq1xADNY0hboryWqKzd/dzao5sbJkQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: [PATCH 3/5] powerpc, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Tue,  3 May 2011 15:25:22 +0200
Message-Id: <1304429124-2376-4-git-send-email-fweisbec@gmail.com>
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
-- 
1.7.3.2

