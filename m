Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1ECNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:25:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61196 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1ECNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CxF4xXjsb1C8znihkKhuAxy2AhWTwBaBYaVSzynj2R8/ZyO0qxGe17O1hgwY1S3ypw
         VkH9ueVQwKaQM7A9P272B4K/zGp8JR+SvmWLn9EmCPRIHeY8SH0J/mSBdhPDrQ6+O46t
         g4qxgzrrUjaIcRzecY+xTgsoyoJy64R+jbLBU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/5] arm, hw_breakpoints: Fix racy access to ptrace breakpoints
Date: Tue,  3 May 2011 15:25:23 +0200
Message-Id: <1304429124-2376-5-git-send-email-fweisbec@gmail.com>
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
 
-- 
1.7.3.2

