Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0DWFPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:15:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42318 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0DWFNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Yco+nWlZZAGU5tCinOpG7DTFxqbjecF2kZ+x6IEnBAyiWkvz4t+M2s5U1ww2OxTCxL
         pjz9NZ8LBlf8kIIK9UXu/yiop6eb2XLxLdcQcweGdXGI0f/b5xejt4IzTL/qJNOHS3uv
         ZYY5d4sP01c4UuSTiRVZCDACW234sMqEvGeTg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/6] hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
Date: Fri, 23 Apr 2010 07:13:54 +0200
Message-Id: <1271999639-23605-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com>
References: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tag ptrace breakpoints with the exclude_kernel attribute set. This
will make it easier to set generic policies on breakpoints, when it
comes to ensure nobody unpriviliged try to breakpoint on the kernel.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
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

