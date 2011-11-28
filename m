Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1K1Tbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:31:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34641 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1K1Tbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:31:37 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 01/23] memblock: Fix include breakages caused by 24aa07882b
Date: Mon, 28 Nov 2011 11:31:03 -0800
Message-Id: <1322508685-32532-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24aa07882b (memblock, x86: Replace memblock_x86_reserve/free_range()
with generic ones) removed arch/x86/include/asm/memblock.h and dropped
its inclusion from include/linux/memblock.h which breaks other
architectures which depended on the generic memblock.h pulling in the
arch specific one.

However, the proper fix isn't adding back the asm inclusion.  memblock
doesn't have any arch dependent part and doesn't need arch specific
header file and asm/memblock.h files are either practically empty or
contain mostly unrelated arch specific stuff.

* In microblaze, sh, powerpc, sparc and openrisc, asm/memblock.h is
  either empty or just contains unused MEMBLOCK_DBG() macro.  Remove
  them.

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
 arch/arm/kernel/setup.c                |    1 +
 arch/arm/mm/init.c                     |    1 +
 arch/microblaze/include/asm/memblock.h |   14 --------------
 arch/openrisc/include/asm/memblock.h   |   24 ------------------------
 arch/powerpc/include/asm/memblock.h    |    8 --------
 arch/sh/include/asm/memblock.h         |    4 ----
 arch/sparc/include/asm/memblock.h      |    8 --------
 arch/unicore32/kernel/setup.c          |    1 +
 arch/unicore32/mm/init.c               |    1 +
 arch/unicore32/mm/mmu.c                |    1 +
 10 files changed, 5 insertions(+), 58 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/memblock.h
 delete mode 100644 arch/openrisc/include/asm/memblock.h
 delete mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/memblock.h

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3448a3f..6701ba9 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -52,6 +52,7 @@
 #include <asm/mach/time.h>
 #include <asm/traps.h>
 #include <asm/unwind.h>
+#include <asm/memblock.h>
 
 #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
 #include "compat.h"
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index fbdd12e..9863f03 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -32,6 +32,7 @@
 
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
diff --git a/arch/openrisc/include/asm/memblock.h b/arch/openrisc/include/asm/memblock.h
deleted file mode 100644
index bbe5a1c..0000000
--- a/arch/openrisc/include/asm/memblock.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_MEMBLOCK_H
-#define __ASM_OPENRISC_MEMBLOCK_H
-
-/* empty */
-
-#endif /* __ASM_OPENRISC_MEMBLOCK_H */
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
index 3b379cd..5fb09e2 100644
--- a/arch/unicore32/mm/init.c
+++ b/arch/unicore32/mm/init.c
@@ -26,6 +26,7 @@
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
1.7.3.1

