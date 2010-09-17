Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0IQCsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:48:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab0IQCs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=UbUSmFWBy186jlNcIqTSjXXWo0vzo2jOk7Ub1pXnx2HLfsCjaEcGCK/2ZHKD4Enlke
         0F0hbyNE9UlQvXj7WDWUjbP66/BmzsX/q/X4UWy/cmg2jTmhRJoMYAsxjTlLQv5gXC0V
         7QVQj0a6hfQGmy8Pip2kN/V9LE5wK3wChKt+M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kelvie Wong <kelvie@ieee.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] x86: Fix instruction breakpoint encoding
Date: Fri, 17 Sep 2010 04:48:21 +0200
Message-Id: <1284691702-32269-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
References: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lengths and types of breakpoints are encoded in a half byte
into CPU registers. However when we extract these values
and store them, we add a high half byte part to them: 0x40 to the
length and 0x80 to the type.
When that gets reloaded to the CPU registers, the high part
is masked.

While making the instruction breakpoints available for perf,
I zapped that high part on instruction breakpoint encoding
and that broke the arch -> generic translation used by ptrace
instruction breakpoints. Writing dr7 to set an inst breakpoint
was then failing.

There is no apparent reason for these high parts so we could get
rid of them altogether. That's an invasive change though so let's
do that later and for now fix the problem by restoring that inst
breakpoint high part encoding in this sole patch.

Reported-by: Kelvie Wong <kelvie@ieee.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |   40 ++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 528a11e..824ca07 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -20,7 +20,7 @@ struct arch_hw_breakpoint {
 #include <linux/list.h>
 
 /* Available HW breakpoint length encodings */
-#define X86_BREAKPOINT_LEN_X		0x00
+#define X86_BREAKPOINT_LEN_X		0x40
 #define X86_BREAKPOINT_LEN_1		0x40
 #define X86_BREAKPOINT_LEN_2		0x44
 #define X86_BREAKPOINT_LEN_4		0x4c
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a474ec3..ff15c9d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -206,11 +206,27 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 int arch_bp_generic_fields(int x86_len, int x86_type,
 			   int *gen_len, int *gen_type)
 {
-	/* Len */
-	switch (x86_len) {
-	case X86_BREAKPOINT_LEN_X:
+	/* Type */
+	switch (x86_type) {
+	case X86_BREAKPOINT_EXECUTE:
+		if (x86_len != X86_BREAKPOINT_LEN_X)
+			return -EINVAL;
+
+		*gen_type = HW_BREAKPOINT_X;
 		*gen_len = sizeof(long);
+		return 0;
+	case X86_BREAKPOINT_WRITE:
+		*gen_type = HW_BREAKPOINT_W;
 		break;
+	case X86_BREAKPOINT_RW:
+		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Len */
+	switch (x86_len) {
 	case X86_BREAKPOINT_LEN_1:
 		*gen_len = HW_BREAKPOINT_LEN_1;
 		break;
@@ -229,21 +245,6 @@ int arch_bp_generic_fields(int x86_len, int x86_type,
 		return -EINVAL;
 	}
 
-	/* Type */
-	switch (x86_type) {
-	case X86_BREAKPOINT_EXECUTE:
-		*gen_type = HW_BREAKPOINT_X;
-		break;
-	case X86_BREAKPOINT_WRITE:
-		*gen_type = HW_BREAKPOINT_W;
-		break;
-	case X86_BREAKPOINT_RW:
-		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -316,9 +317,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	ret = -EINVAL;
 
 	switch (info->len) {
-	case X86_BREAKPOINT_LEN_X:
-		align = sizeof(long) -1;
-		break;
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
 		break;
-- 
1.6.2.3

