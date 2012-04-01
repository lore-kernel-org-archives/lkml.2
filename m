Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2DAUjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:54147 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab2DAUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 07/11] sh: fix several build failures from system.h fallout
Date: Sun,  1 Apr 2012 16:38:43 -0400
Message-Id: <1333312727-11428-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e839ca528718e68cad32a307dc9aabf01ef3eb05

    "Disintegrate asm/system.h for SH"

created the new file asm/cache_insns.h but it didn't add
an include for all the users of it.

The failure on fpu.c (also seen below) showed up roughly
at the same time, and since the fix is trivial (include traps.h)
I did not bother to bisect to 100% confirm it was caused by
the system.h disintegration.

arch/sh/mm/flush-sh4.c:16:2: error: implicit declaration of function 'register_align' [-Werror=implicit-function-declaration]
arch/sh/mm/flush-sh4.c:23:3: error: implicit declaration of function '__ocbwb' [-Werror=implicit-function-declaration]
arch/sh/mm/flush-sh4.c:57:3: error: implicit declaration of function '__ocbp' [-Werror=implicit-function-declaration]
arch/sh/mm/flush-sh4.c:87:3: error: implicit declaration of function '__ocbi' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/sh/mm/flush-sh4.o] Error 1
arch/sh/mm/cache-sh4.c:70:3: error: implicit declaration of function '__ocbwb' [-Werror=implicit-function-declaration]
cc1: all warnings being treated as errors
make[2]: *** [arch/sh/mm/cache-sh4.o] Error 1
arch/sh/kernel/cpu/fpu.c:81:2: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function)
arch/sh/kernel/cpu/fpu.c:83:20: error: 'regs' undeclared (first use in this function)
arch/sh/kernel/cpu/fpu.c:83:19: error: called object 'fpu_state_restore' is not a function
make[3]: *** [arch/sh/kernel/cpu/fpu.o] Error 1
arch/sh/kernel/cpu/sh4/fpu.c:407:2: error: 'TRAP_HANDLER_DECL' undeclared (first use in this function)
arch/sh/kernel/cpu/sh4/fpu.c:409:20: error: 'regs' undeclared (first use in this function)
make[4]: *** [arch/sh/kernel/cpu/sh4/fpu.o] Error 1

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sh/kernel/cpu/fpu.c     |    1 +
 arch/sh/kernel/cpu/sh4/fpu.c |    1 +
 arch/sh/mm/cache-sh4.c       |    1 +
 arch/sh/mm/flush-sh4.c       |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/cpu/fpu.c b/arch/sh/kernel/cpu/fpu.c
index 7f1b70c..07fb02f 100644
--- a/arch/sh/kernel/cpu/fpu.c
+++ b/arch/sh/kernel/cpu/fpu.c
@@ -1,6 +1,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/fpu.h>
 
 int init_fpu(struct task_struct *tsk)
diff --git a/arch/sh/kernel/cpu/sh4/fpu.c b/arch/sh/kernel/cpu/sh4/fpu.c
index e74cd6c..36538ff 100644
--- a/arch/sh/kernel/cpu/sh4/fpu.c
+++ b/arch/sh/kernel/cpu/sh4/fpu.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <cpu/fpu.h>
 #include <asm/processor.h>
+#include <asm/traps.h>
 #include <asm/fpu.h>
 
 /* The PR (precision) bit in the FP Status Register must be clear when
diff --git a/arch/sh/mm/cache-sh4.c b/arch/sh/mm/cache-sh4.c
index 112fea1..c9667d9 100644
--- a/arch/sh/mm/cache-sh4.c
+++ b/arch/sh/mm/cache-sh4.c
@@ -19,6 +19,7 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
+#include <asm/cache_insns.h>
 
 /*
  * The maximum number of pages we support up to when doing ranged dcache
diff --git a/arch/sh/mm/flush-sh4.c b/arch/sh/mm/flush-sh4.c
index 75a17f5..59acd8a 100644
--- a/arch/sh/mm/flush-sh4.c
+++ b/arch/sh/mm/flush-sh4.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
+#include <asm/cache_insns.h>
 #include <asm/traps.h>
 
 /*
-- 
1.7.9.1

