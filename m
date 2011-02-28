Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1CATl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:41:56 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab1CAThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:21 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYc6t010302@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:01:53 -0500
Subject: [PATCH] arch/tile: avoid a simulator warning during bootup
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:38.0623 (UTC) FILETIME=[B41C6AF0:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the added comment says, we can sometimes see a coherence warning
from our simulator if the "swapper_pgprot" variable on the boot cpu
has not been evicted from cache by the time the other cpus come up.
Force it to be evicted so we never see the warning.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/init.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index e34597e..9a62479 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -653,6 +653,17 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	memcpy(pgd_base, pgtables, sizeof(pgtables));
 	__install_page_table(pgd_base, __get_cpu_var(current_asid),
 			     swapper_pgprot);
+
+	/*
+	 * We just read swapper_pgprot and thus brought it into the cache,
+	 * with its new home & caching mode.  When we start the other CPUs,
+	 * they're going to reference swapper_pgprot via their initial fake
+	 * VA-is-PA mappings, which cache everything locally.  At that
+	 * time, if it's in our cache with a conflicting home, the
+	 * simulator's coherence checker will complain.  So, flush it out
+	 * of our cache; we're not going to ever use it again anyway.
+	 */
+	__insn_finv(&swapper_pgprot);
 }
 
 /*
-- 
1.6.5.2

