Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1FAR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:26:24 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:49087 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759314Ab1FAR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 8PQD7EcVM1mQpQqCylvVf7NM9MbliKdIr3mYC071i3mzqeU
 2kJ5Uoi9odvgo4jbWEGZ_UaRwo4LCKg3v80x2KEKSHK9ChBjOHEZPTA4vz2m
 WgCu8fkd9iq96x6IsIHVwOJX_60reKikd17GI4le_t1eZ9nvUTs6_vEqCPZO
 x52UEeMbbhmgFezLzk2NdDdbm5f4pLrhK1_IDmvrMZ1rU3V_tk0GZckKjoWI
 phOVj9XnP1W7Ix75nUfuhsy8OQk.qVdFXZqhD3_URGtRZyNZfYALAZRWUK4m
 rkvt4c4_fziz..kPoeUSurJEyzkHfTfd4UaL_u1IxuBpjOu_mS0aKhf0YJ.d
 kjj2A4SOHdjGUH0zeotDvAxCP
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172618.686673189@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:55 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 12/17] slub: Avoid disabling interrupts in free slowpath
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=slab_free_without_irqoff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling interrupts can be avoided now. However, list operation still require
disabling interrupts since allocations can occur from interrupt
contexts and there is no way to perform atomic list operations.

The acquition of the list_lock therefore has to disable interrupts as well.

Dropping interrupt handling significantly simplifies the slowpath.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 10:20:09.792975006 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 10:20:15.502974969 -0500
@@ -2197,11 +2197,10 @@ static void __slab_free(struct kmem_cach
 	struct kmem_cache_node *n = NULL;
 	unsigned long uninitialized_var(flags);
 
-	local_irq_save(flags);
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+		return;
 
 	do {
 		prior = page->freelist;
@@ -2220,7 +2219,7 @@ static void __slab_free(struct kmem_cach
 			 * Otherwise the list_lock will synchronize with
 			 * other processors updating the list of slabs.
 			 */
-                        spin_lock(&n->list_lock);
+                        spin_lock_irqsave(&n->list_lock, flags);
 		}
 		inuse = new.inuse;
 
@@ -2236,7 +2235,7 @@ static void __slab_free(struct kmem_cach
 		 */
                 if (was_frozen)
                         stat(s, FREE_FROZEN);
-                goto out_unlock;
+                return;
         }
 
 	/*
@@ -2259,11 +2258,7 @@ static void __slab_free(struct kmem_cach
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
@@ -2275,8 +2270,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 
-	spin_unlock(&n->list_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }

