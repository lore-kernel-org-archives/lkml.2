Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1GZPip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:38:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1GZPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:14 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 21/23] score: Use HAVE_MEMBLOCK_NODE_MAP
Date: Tue, 26 Jul 2011 17:35:32 +0200
Message-Id: <1311694534-5161-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

score used early_node_map[] just to prime free_area_init_nodes().  Now
memblock can be used for the same purpose and early_node_map[] is
scheduled to be dropped.  Use memblock instead.

While at it, replace 7 space indentations w/ tabs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
Sorry, not even compile tested.  Couldn't find working cross compiler.

 arch/score/Kconfig        |    9 ++++++---
 arch/score/kernel/setup.c |    4 +++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 288add8..bbd0f91 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -1,9 +1,12 @@
 menu "Machine selection"
 
 config SCORE
-       def_bool y
-       select HAVE_GENERIC_HARDIRQS
-       select GENERIC_IRQ_SHOW
+	def_bool y
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_SHOW
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 
 choice
 	prompt "System type"
diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
index 6f898c0..b48459a 100644
--- a/arch/score/kernel/setup.c
+++ b/arch/score/kernel/setup.c
@@ -26,6 +26,7 @@
 #include <linux/bootmem.h>
 #include <linux/initrd.h>
 #include <linux/ioport.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
@@ -54,7 +55,8 @@ static void __init bootmem_init(void)
 	/* Initialize the boot-time allocator with low memory only. */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), start_pfn,
 					 min_low_pfn, max_low_pfn);
-	add_active_range(0, min_low_pfn, max_low_pfn);
+	memblock_add_node(PFN_PHYS(min_low_pfn),
+			  PFN_PHYS(max_low_pfn - min_low_pfn), 0);
 
 	free_bootmem(PFN_PHYS(start_pfn),
 		     (max_low_pfn - start_pfn) << PAGE_SHIFT);
-- 
1.7.6

