Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0HDCwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:52:19 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28806 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932123Ab0HDCwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: b9dNWPYVM1mQ3XHafjwHRvIaupnTeXTuy6FDGR8s39MBUhr
 QSNU69AcyX09PM_8TirCH5eqe4E_O6FsMkIMI8emNc.igNvS3ATA92L77PL0
 ynf4Drcip6lkXKMYt3154Spye1XcpiHB6W3ar8k5kb41V21ulDJjN0wV8YYs
 CeYBW_I49w3oHfjmrh752INeYwBLrbNby9jIA88bs.6I50duoKNnqbYRglHq
 vW4wTsGIrAekU5N3xcDX.H9V0c0zO9_Io8lXsXQMZtQowuBQs6JFX.pXH2f2
 g4UsEZFDDkN9OMCnu
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024527.315890239@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:20 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [S+Q3 06/23] slub: Check kasprintf results in kmem_cache_init()
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_check_kasprintf_result
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small allocations may fail during slab bringup which is fatal. Add a BUG_ON()
so that we fail immediately rather than failing later during sysfs
processing.

CC: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 15:12:14.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:13:48.000000000 -0500
@@ -3118,9 +3118,12 @@ void __init kmem_cache_init(void)
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
-	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++)
-		kmalloc_caches[i]. name =
-			kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
+	for (i = KMALLOC_SHIFT_LOW; i < SLUB_PAGE_SHIFT; i++) {
+		char *s = kasprintf(GFP_NOWAIT, "kmalloc-%d", 1 << i);
+
+		BUG_ON(!s);
+		kmalloc_caches[i].name = s;
+	}
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);

