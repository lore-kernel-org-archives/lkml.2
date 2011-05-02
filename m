Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1EBXLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:11:38 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1EBXJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:32 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsQaw030355@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:35:06 -0400
Subject: [PATCH] arch/tile: properly flush the I$ when unloading kernel modules
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:26.0565 (UTC) FILETIME=[E317B350:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, in principle, there could be stale I$ data present
next time the page that previously held the kernel module code was
used to run some new code.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/module.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index e2ab82b..f68df69 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <asm/opcode-tile.h>
 #include <asm/pgtable.h>
+#include <asm/homecache.h>
 
 #ifdef __tilegx__
 # define Elf_Rela Elf64_Rela
@@ -86,8 +87,13 @@ error:
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
+
+	/* Globally flush the L1 icache. */
+	flush_remote(0, HV_FLUSH_EVICT_L1I, cpu_online_mask,
+		     0, 0, 0, NULL, NULL, 0);
+
 	/*
-	 * FIXME: If module_region == mod->init_region, trim exception
+	 * FIXME: If module_region == mod->module_init, trim exception
 	 * table entries.
 	 */
 }
-- 
1.6.5.2

