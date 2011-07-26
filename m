Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1GZPhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:37:34 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:54562 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1GZPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:12 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>, linux-mips@linux-mips.org
Subject: [PATCH 19/23] mips: Use HAVE_MEMBLOCK_NODE_MAP
Date: Tue, 26 Jul 2011 17:35:30 +0200
Message-Id: <1311694534-5161-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mips used early_node_map[] just to prime free_area_init_nodes().  Now
memblock can be used for the same purpose and early_node_map[] is
scheduled to be dropped.  Use memblock instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
Only compile tested.  Thanks.

 arch/mips/Kconfig                |    3 +++
 arch/mips/kernel/setup.c         |    3 ++-
 arch/mips/sgi-ip27/ip27-memory.c |    5 +++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..368b2ec 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -24,6 +24,9 @@ config MIPS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
+	select ARCH_DISCARD_MEMBLOCK
 
 menu "Machine selection"
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 8ad1d56..c25bce4 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/ioport.h>
 #include <linux/module.h>
 #include <linux/screen_info.h>
+#include <linux/memblock.h>
 #include <linux/bootmem.h>
 #include <linux/initrd.h>
 #include <linux/root_dev.h>
@@ -352,7 +353,7 @@ static void __init bootmem_init(void)
 			continue;
 #endif
 
-		add_active_range(0, start, end);
+		memblock_add_node(PFN_PHYS(start), PFN_PHYS(end - start), 0);
 	}
 
 	/*
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index bc12971..b105eca 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -12,6 +12,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
@@ -381,8 +382,8 @@ static void __init szmem(void)
 				continue;
 			}
 			num_physpages += slot_psize;
-			add_active_range(node, slot_getbasepfn(node, slot),
-					 slot_getbasepfn(node, slot) + slot_psize);
+			memblock_add_node(PFN_PHYS(slot_getbasepfn(node, slot)),
+					  PFN_PHYS(slot_psize), node);
 		}
 	}
 }
-- 
1.7.6

