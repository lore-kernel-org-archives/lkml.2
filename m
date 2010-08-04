Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0HDCxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:53:08 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:35852 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932499Ab0HDCwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .bYna5EVM1ksPwi5LMskRzv1O16aNlDFxhLS1r2q2skkhGE
 GnQvSUufzGrzd5rqak8CbbhKaLPcsvTgQb8wz88UqlxC_iScmAmXbNPYC9hd
 2bLiv9Q.T1FEl1i.tj3yE8_GytuG.oLOQMttiTHXsTPgkJKjtjrxpKfZbbKm
 5VzHGaUAUaI7fXvcgq.pua74XaFooutmsjVg1NuPSITMw7KEYNXNHNHDIkhr
 HhMUUK_fC1dZTVARMzXT.v4CjpgfLc.AP40832jueOahHih2MzY_QyK.6.Bq
 fT3g-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024529.039215901@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:23 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 09/23] slub: Remove static kmem_cache_cpu array for boot
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=maybe_remove_static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu allocator can now handle allocations during early boot.
So drop the static kmem_cache_cpu array.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-26 14:26:17.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-26 14:26:20.000000000 -0500
@@ -2063,23 +2063,14 @@ init_kmem_cache_node(struct kmem_cache_n
 #endif
 }
 
-static DEFINE_PER_CPU(struct kmem_cache_cpu, kmalloc_percpu[KMALLOC_CACHES]);
-
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
-	if (s < kmalloc_caches + KMALLOC_CACHES && s >= kmalloc_caches)
-		/*
-		 * Boot time creation of the kmalloc array. Use static per cpu data
-		 * since the per cpu allocator is not available yet.
-		 */
-		s->cpu_slab = kmalloc_percpu + (s - kmalloc_caches);
-	else
-		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);
+	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
+			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache));
 
-	if (!s->cpu_slab)
-		return 0;
+	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
 
-	return 1;
+	return s->cpu_slab != NULL;
 }
 
 #ifdef CONFIG_NUMA

