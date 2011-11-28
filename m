Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1K1TdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:33:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1K1TdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:09 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH 20/23] s390: Use HAVE_MEMBLOCK_NODE_MAP
Date: Mon, 28 Nov 2011 11:31:22 -0800
Message-Id: <1322508685-32532-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 used early_node_map[] just to prime free_area_init_nodes().  Now
memblock can be used for the same purpose and early_node_map[] is
scheduled to be dropped.  Use memblock instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/Kconfig        |    3 +++
 arch/s390/kernel/setup.c |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 373679b..e383caf 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -92,6 +92,9 @@ config S390
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_RCU_TABLE_FREE if SMP
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e58a462..a2850df 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
@@ -820,7 +821,8 @@ setup_memory(void)
 		end_chunk = min(end_chunk, end_pfn);
 		if (start_chunk >= end_chunk)
 			continue;
-		add_active_range(0, start_chunk, end_chunk);
+		memblock_add_node(PFN_PHYS(start_chunk),
+				  PFN_PHYS(end_chunk - start_chunk), 0);
 		pfn = max(start_chunk, start_pfn);
 		for (; pfn < end_chunk; pfn++)
 			page_set_storage_key(PFN_PHYS(pfn),
-- 
1.7.3.1

