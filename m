Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1DOUsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:48:08 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25135 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756799Ab1DOUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Y3badRAVM1mwoXzBLMPCCuKcLHzDjuLacQQwNTqByN6WwiR
 dxo_VqPsBkYnDvKyc3kvABTXUDWSw73WX0wTfUsuFXGjOwsX1SVNoVCUy4Rl
 Qy8Vrtj1XYCHkdYg.UB.Ur53gOfDbMFfcALxGbe7xKr7WajYbLeaFc_hXQBb
 jaDtYpURk5xbR9XXFVhGhl49MnMDwCp4m8vMx0lkpD37e3nWRt4mlO7NC7ql
 v34yoVRb.chyznwtEkDnl_n375DCj25jj32.1h3fn7DXl8_LGLsrkISoGs.7
 xccIZ0AcBWHvjl9pL2G1fFf6reU_csLVB_.9S6HGJ0_nzGX5L3RJ0a5SU1ZH
 0cwpZPR5sdpMyBB4r
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204755.934341102@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:47 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 17/21] slub: Avoid disabling interrupts in free slowpath
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=slab_free_without_irqoff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling interrupts can be avoided now. However, list operation still require
disabling interrupts since allocations can occur from interrupt
contexts and there is no way to perform atomic list operations. So
acquire the list lock opportunistically if there is a chance
that list operations would be needed. This may result in
needless synchronizations but allows the avoidance of synchronization
in the majority of the cases.

Dropping interrupt handling significantly simplifies the slowpath.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 14:30:05.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 14:30:06.000000000 -0500
@@ -2225,13 +2225,11 @@ static void __slab_free(struct kmem_cach
 	struct kmem_cache_node *n = NULL;
 #ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long flags;
-
-	local_irq_save(flags);
 #endif
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+		return;
 
 	do {
 		prior = page->freelist;
@@ -2250,7 +2248,11 @@ static void __slab_free(struct kmem_cach
 			 * Otherwise the list_lock will synchronize with
 			 * other processors updating the list of slabs.
 			 */
+#ifdef CONFIG_CMPXCHG_LOCAL
+                        spin_lock_irqsave(&n->list_lock, flags);
+#else
                         spin_lock(&n->list_lock);
+#endif
 		}
 		inuse = new.inuse;
 
@@ -2266,7 +2268,7 @@ static void __slab_free(struct kmem_cach
 		 */
                 if (was_frozen)
                         stat(s, FREE_FROZEN);
-                goto out_unlock;
+                return;
         }
 
 	/*
@@ -2289,12 +2291,10 @@ static void __slab_free(struct kmem_cach
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
-
-	spin_unlock(&n->list_lock);
-
-out_unlock:
 #ifdef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+#else
+	spin_unlock(&n->list_lock);
 #endif
 	return;
 
@@ -2307,9 +2307,10 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 
-	spin_unlock(&n->list_lock);
 #ifdef CONFIG_CMPXCHG_LOCAL
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+#else
+	spin_unlock(&n->list_lock);
 #endif
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);

