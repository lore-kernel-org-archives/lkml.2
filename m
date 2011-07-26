Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1GZPjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:39:41 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:56152 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1GZPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:09 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>, linux-sh@vger.kernel.org
Subject: [PATCH 17/23] SuperH: Use HAVE_MEMBLOCK_NODE_MAP
Date: Tue, 26 Jul 2011 17:35:28 +0200
Message-Id: <1311694534-5161-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sh doesn't access early_node_map[] directly and enabling
HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
enough.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
Paul, memblock now can carry node information itself without relying
on early_node_map[], which makes operations which make use of both
information much saner and generally makes NUMA memory init simpler.
For more details, please read the following thread.

 http://thread.gmane.org/gmane.linux.kernel.cross-arch/10354

I couldn't get the cross-compiler from korg to build configuration
with CPU w/ NUMA support but given the trivial nature of the change, I
don't think it would cause build failures on different configs, but
this definitely needs testing on actual NUMA configuration.

The patches implementing HAVE_MEMBLOCK_NODE_MAP is currently in
tip:x86/memblock branch on which this patch is based on.

Thanks.

 arch/sh/Kconfig        |    1 +
 arch/sh/kernel/setup.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index bbdeb48..8c10d85 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -4,6 +4,7 @@ config SUPERH
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 58bff45..e3942ca 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -227,7 +227,8 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	add_active_range(nid, start_pfn, end_pfn);
+	memblock_set_node(PFN_PHYS(start_pfn),
+			  PFN_PHYS(end_pfn - start_pfn), nid);
 }
 
 void __init __weak plat_early_device_setup(void)
-- 
1.7.6

