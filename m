Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1G1JlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:41:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49417 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1G1JlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:41:11 -0400
Date: Thu, 28 Jul 2011 11:41:05 +0200
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        gxt@mprc.pku.edu.cn, linux@arm.linux.org.uk, monstr@monstr.eu
Cc: mingo@redhat.com
Subject: [PATCH 0.5/23] memblock: Fix include breakages caused by 24aa07882b
Message-ID: <20110728094105.GF2622@htj.dyndns.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 99a6a7931f73eadcd3639b4561f27aa14219e39f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 28 Jul 2011 10:56:58 +0200

24aa07882b (memblock, x86: Replace memblock_x86_reserve/free_range()
with generic ones) removed arch/x86/include/asm/memblock.h and dropped
its inclusion from include/linux/memblock.h which breaks other
architectures which depended on the generic memblock.h pulling in the
arch specific one.

However, the proper fix isn't adding back the asm inclusion.  memblock
doesn't have any arch dependent part and doesn't need arch specific
header file and asm/memblock.h files are either practically empty or
contain mostly unrelated arch specific stuff.

* In microblaze, sh, powerpc and sparc, asm/memblock.h is either empty
  or just contains unused MEMBLOCK_DBG() macro.  Remove it.

* In arm and unicore32, asm/memblock.h contains arch specific stuff.
  Include it directly from its users.  It might be a good idea to
  rename the header file to avoid confusion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
Build fix for arm and unicore32 for the current tip:x86/memblock.  Not
really part of this series but should be applied first, so...  This
patch doesn't affect further patches other than triggering some offset
warnings.

I've updated the following git branch to contain this patch and one
more updated patch (soon to be posted).

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock

Commit ID should be 46c66825fc9a398f06f72732ed1a9d4fe89f6805.

Thanks.

 arch/arm/kernel/setup.c                |    1 +
 arch/arm/mm/init.c                     |    1 +
 arch/microblaze/include/asm/memblock.h |   14 --------------
 arch/powerpc/include/asm/memblock.h    |    8 --------
 arch/sh/include/asm/memblock.h         |    4 ----
 arch/sparc/include/asm/memblock.h      |    8 --------
 arch/unicore32/kernel/setup.c          |    1 +
 arch/unicore32/mm/init.c               |    1 +
 arch/unicore32/mm/mmu.c                |    1 +
 9 files changed, 5 insertions(+), 34 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/memblock.h
 delete mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/memblock.h

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index acbb447..88fbf4e 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -49,6 +49,7 @@
 #include <asm/mach/time.h>
 #include <asm/traps.h>
 #include <asm/unwind.h>
+#include <asm/memblock.h>
 
 #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
 #include "compat.h"
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c19571c..77281b2 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -31,6 +31,7 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/memblock.h>
 
 #include "mm.h"
 
diff --git a/arch/microblaze/include/asm/memblock.h b/arch/microblaze/include/asm/memblock.h
deleted file mode 100644
index 20a8e25..0000000
--- a/arch/microblaze/include/asm/memblock.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_MEMBLOCK_H
-#define _ASM_MICROBLAZE_MEMBLOCK_H
-
-#endif /* _ASM_MICROBLAZE_MEMBLOCK_H */
-
-
diff --git a/arch/powerpc/include/asm/memblock.h b/arch/powerpc/include/asm/memblock.h
deleted file mode 100644
index 43efc34..0000000
--- a/arch/powerpc/include/asm/memblock.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_POWERPC_MEMBLOCK_H
-#define _ASM_POWERPC_MEMBLOCK_H
-
-#include <asm/udbg.h>
-
-#define MEMBLOCK_DBG(fmt...) udbg_printf(fmt)
-
-#endif /* _ASM_POWERPC_MEMBLOCK_H */
diff --git a/arch/sh/include/asm/memblock.h b/arch/sh/include/asm/memblock.h
deleted file mode 100644
index e87063f..0000000
--- a/arch/sh/include/asm/memblock.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASM_SH_MEMBLOCK_H
-#define __ASM_SH_MEMBLOCK_H
-
-#endif /* __ASM_SH_MEMBLOCK_H */
diff --git a/arch/sparc/include/asm/memblock.h b/arch/sparc/include/asm/memblock.h
deleted file mode 100644
index c67b047..0000000
--- a/arch/sparc/include/asm/memblock.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _SPARC64_MEMBLOCK_H
-#define _SPARC64_MEMBLOCK_H
-
-#include <asm/oplib.h>
-
-#define MEMBLOCK_DBG(fmt...) prom_printf(fmt)
-
-#endif /* !(_SPARC64_MEMBLOCK_H) */
diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 471b6bc..673d7a8 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -37,6 +37,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
+#include <asm/memblock.h>
 
 #include "setup.h"
 
diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
index 2d3e711..d6edc6d 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -25,6 +25,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/memblock.h>
 #include <mach/map.h>
 
 #include "mm.h"
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
index 3e5c3e5..43c20b4 100644
--- a/arch/unicore32/mm/mmu.c
+++ b/arch/unicore32/mm/mmu.c
@@ -25,6 +25,7 @@
 #include <asm/setup.h>
 #include <asm/sizes.h>
 #include <asm/tlb.h>
+#include <asm/memblock.h>
 
 #include <mach/map.h>
 
-- 
1.7.6

