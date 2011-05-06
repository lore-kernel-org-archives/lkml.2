Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1EFSId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:08:33 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:21475 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756499Ab1EFSHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: rqE2Q_AVM1ko1zHV1yK6IF1cX2hzVFBufPZGTOqTmvtk1Ka
 A0XXuchaZBvSVT_bblkERKZ62Kz97emynr4yrTidE1bdIOSe_X1rwLro_JYI
 y1cdzTtFFeIRTWgeUmIQZGfXg4UXoEsuXRaP7CbVJHeywenIZwMDE9nkNa99
 z6QFS9UL9uVRZKPE735Z4ZnshigsBvfvM388VGy9xkyeQZOiyZCZ3JNHAmTa
 XP1rgKBp3RbfHVjtl.WFJXR4sIzSe_3jdplO0q89pSTGh6F4ZvK5riyiARpb
 IP9FNARtHF7HMxB5mxg7_doesBbFm86gn0RPok45FZfZLBljDT1X3xn.Ganw
 jxWjKeBAGYfQLczNqECaFj_P4
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180701.182790280@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:53 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 12/16] slub: Avoid disabling interrupts in free slowpath
References: <20110506180541.990069206@linux.com>
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
 mm/slub.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-06 12:55:26.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-06 12:55:42.000000000 -0500
@@ -2190,11 +2190,10 @@ static void __slab_free(struct kmem_cach
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
 
-	local_irq_save(flags);
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+		return;
 
 	do {
 		prior = page->freelist;
@@ -2213,7 +2212,7 @@ static void __slab_free(struct kmem_cach
 			 * Otherwise the list_lock will synchronize with
 			 * other processors updating the list of slabs.
 			 */
-                        spin_lock(&n->list_lock);
+                        spin_lock_irqsave(&n->list_lock, flags);
 		}
 		inuse = new.inuse;
 
@@ -2229,7 +2228,7 @@ static void __slab_free(struct kmem_cach
 		 */
                 if (was_frozen)
                         stat(s, FREE_FROZEN);
-                goto out_unlock;
+                return;
         }
 
 	/*
@@ -2252,11 +2251,7 @@ static void __slab_free(struct kmem_cach
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
-
-	spin_unlock(&n->list_lock);
-
-out_unlock:
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	return;
 
 slab_empty:
@@ -2268,8 +2263,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 
-	spin_unlock(&n->list_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }

