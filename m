Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0FXVlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0FXVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=vZGe5WZH3NuOrJmUoIM6GGYvXnrvGGX2MsOLAsStDzciXE5Agm8XwZn2UWfVH1VWP6
         ncSqTE6XwQN3JdBzJpA+qWNW4iLd97uI0VCaed3U4ZtU0DfcezD7JoGdBjTW/0KXzVVE
         W8+k+m1dGvRZk2DqmnjKworJiOfwzPtlwA5+E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Will Deacon <will.deacon@arm.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/7] x86: Support for instruction breakpoints
Date: Thu, 24 Jun 2010 23:40:55 +0200
Message-Id: <1277415658-10036-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction breakpoints need to have a specific length of 0 to
be working. Bring this support but also take care the user is not
trying to set an unsupported length, like a range breakpoint for
example.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |   44 ++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 9422553..528a11e 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -20,10 +20,10 @@ struct arch_hw_breakpoint {
 #include <linux/list.h>
 
 /* Available HW breakpoint length encodings */
+#define X86_BREAKPOINT_LEN_X		0x00
 #define X86_BREAKPOINT_LEN_1		0x40
 #define X86_BREAKPOINT_LEN_2		0x44
 #define X86_BREAKPOINT_LEN_4		0x4c
-#define X86_BREAKPOINT_LEN_EXECUTE	0x40
 
 #ifdef CONFIG_X86_64
 #define X86_BREAKPOINT_LEN_8		0x48
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index eaa6ae2..a474ec3 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -208,6 +208,9 @@ int arch_bp_generic_fields(int x86_len, int x86_type,
 {
 	/* Len */
 	switch (x86_len) {
+	case X86_BREAKPOINT_LEN_X:
+		*gen_len = sizeof(long);
+		break;
 	case X86_BREAKPOINT_LEN_1:
 		*gen_len = HW_BREAKPOINT_LEN_1;
 		break;
@@ -251,6 +254,29 @@ static int arch_build_bp_info(struct perf_event *bp)
 
 	info->address = bp->attr.bp_addr;
 
+	/* Type */
+	switch (bp->attr.bp_type) {
+	case HW_BREAKPOINT_W:
+		info->type = X86_BREAKPOINT_WRITE;
+		break;
+	case HW_BREAKPOINT_W | HW_BREAKPOINT_R:
+		info->type = X86_BREAKPOINT_RW;
+		break;
+	case HW_BREAKPOINT_X:
+		info->type = X86_BREAKPOINT_EXECUTE;
+		/*
+		 * x86 inst breakpoints need to have a specific undefined len.
+		 * But we still need to check userspace is not trying to setup
+		 * an unsupported length, to get a range breakpoint for example.
+		 */
+		if (bp->attr.bp_len == sizeof(long)) {
+			info->len = X86_BREAKPOINT_LEN_X;
+			return 0;
+		}
+	default:
+		return -EINVAL;
+	}
+
 	/* Len */
 	switch (bp->attr.bp_len) {
 	case HW_BREAKPOINT_LEN_1:
@@ -271,21 +297,6 @@ static int arch_build_bp_info(struct perf_event *bp)
 		return -EINVAL;
 	}
 
-	/* Type */
-	switch (bp->attr.bp_type) {
-	case HW_BREAKPOINT_W:
-		info->type = X86_BREAKPOINT_WRITE;
-		break;
-	case HW_BREAKPOINT_W | HW_BREAKPOINT_R:
-		info->type = X86_BREAKPOINT_RW;
-		break;
-	case HW_BREAKPOINT_X:
-		info->type = X86_BREAKPOINT_EXECUTE;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	return 0;
 }
 /*
@@ -305,6 +316,9 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	ret = -EINVAL;
 
 	switch (info->len) {
+	case X86_BREAKPOINT_LEN_X:
+		align = sizeof(long) -1;
+		break;
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
 		break;
-- 
1.6.2.3

