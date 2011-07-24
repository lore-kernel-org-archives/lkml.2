Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1GXKvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:51:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36934 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1GXKvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:51:24 -0400
Date: Sun, 24 Jul 2011 12:51:19 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH tip:x86/memblock RFC] SuperH: Use HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20110724105119.GP2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: work/arch/sh/Kconfig
===================================================================
--- work.orig/arch/sh/Kconfig
+++ work/arch/sh/Kconfig
@@ -4,6 +4,7 @@ config SUPERH
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_ARCH_TRACEHOOK
Index: work/arch/sh/kernel/setup.c
===================================================================
--- work.orig/arch/sh/kernel/setup.c
+++ work/arch/sh/kernel/setup.c
@@ -227,7 +227,8 @@ void __init __add_active_range(unsigned 
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
 
-	add_active_range(nid, start_pfn, end_pfn);
+	memblock_set_node(PFN_PHYS(start_pfn),
+			  PFN_PHYS(end_pfn - start_pfn), nid);
 }
 
 void __init __weak plat_early_device_setup(void)
