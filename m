Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2BAMyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 07:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab2BAMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 07:54:31 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Fix perf stack to non executable on x86_64
Date: Wed,  1 Feb 2012 13:54:08 +0100
Message-Id: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By adding following objects:
  bench/mem-memset-x86-64-asm.o
  bench/mem-memcpy-x86-64-asm.o
the x86_64 perf binary ended up with executable stack.

The reason was that above objects are assembler sourced and
are missing the GNU-stack note section. In such case the linker
assumes that the final binary should not be restricted at all
and mark the stack as RWX.

Adding section ".note.GNU-stack" definition to mentioned objects,
with all flags disabled, thus omiting those objects from linker
stack flags decision.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    7 +++++++
 tools/perf/bench/mem-memset-x86-64-asm.S |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index a20780b..a6c8909 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -4,3 +4,10 @@
 #define Lmemcpy_c globl memcpy_c; memcpy_c
 #define Lmemcpy_c_e globl memcpy_c_e; memcpy_c_e
 #include "../../../arch/x86/lib/memcpy_64.S"
+
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/bench/mem-memset-x86-64-asm.S b/tools/perf/bench/mem-memset-x86-64-asm.S
index cb92170..9e5af89 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm.S
+++ b/tools/perf/bench/mem-memset-x86-64-asm.S
@@ -4,3 +4,10 @@
 #define Lmemset_c globl memset_c; memset_c
 #define Lmemset_c_e globl memset_c_e; memset_c_e
 #include "../../../arch/x86/lib/memset_64.S"
+
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
-- 
1.7.1
