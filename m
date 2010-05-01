Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab0EACyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:54:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129Ab0EACx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=vvZC+EdAd73Os6NIouZZwpJ7T68aS2s/6bgsQJLuKtmfOqqF6JiFZlc6L3n8JlFJ2k
         Kbuvh1dxPPTTkB54Q8jubAdRo+voy5w7gQ0qDC6EeOLrl5EaAS1v5wNuBv8y/0+KWAsl
         KEn4BNPRtU6dBl/Fp4cOapDzUyryhVwrJtAJ8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/8] hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
Date: Sat,  1 May 2010 04:53:50 +0200
Message-Id: <1272682436-10682-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tag ptrace breakpoints with the exclude_kernel attribute set. This
will make it easier to set generic policies on breakpoints, when it
comes to ensure nobody unpriviliged try to breakpoint on the kernel.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/sh/kernel/ptrace_32.c    |    2 +-
 arch/x86/kernel/ptrace.c      |    2 +-
 include/linux/hw_breakpoint.h |    6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 7759a9a..d4104ce 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -85,7 +85,7 @@ static int set_single_step(struct task_struct *tsk, unsigned long addr)
 
 	bp = thread->ptrace_bps[0];
 	if (!bp) {
-		hw_breakpoint_init(&attr);
+		ptrace_breakpoint_init(&attr);
 
 		attr.bp_addr = addr;
 		attr.bp_len = HW_BREAKPOINT_LEN_2;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 055be0a..70c4872 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -688,7 +688,7 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 	struct perf_event_attr attr;
 
 	if (!t->ptrace_bps[nr]) {
-		hw_breakpoint_init(&attr);
+		ptrace_breakpoint_init(&attr);
 		/*
 		 * Put stub len and type to register (reserve) an inactive but
 		 * correct bp
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index c70d27a..a0aa5a9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -34,6 +34,12 @@ static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 	attr->sample_period = 1;
 }
 
+static inline void ptrace_breakpoint_init(struct perf_event_attr *attr)
+{
+	hw_breakpoint_init(attr);
+	attr->exclude_kernel = 1;
+}
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
-- 
1.6.2.3

