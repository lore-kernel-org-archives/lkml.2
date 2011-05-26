Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab1EZSQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:16:48 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:41226 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757810Ab1EZSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Xubu.wcVM1muW5qKLxMzyXxwu0cgfHKJhU5rl9Uc0pd6uP6
 VbX.84yy9BGy3xdy96.mVDPWLVNjlDFk0wTDAzjptKWU9rzT12kanv4ihbDp
 CJ3coMTUzE2jK2UPkuE7YDfSJyYHRpHdWegM2IbiRTsoWD2aCwjSGaeQnKCH
 ieyWgS_UGKSV__MvnufEviO3boKml1KUBvLNpRXaffPecOa8XuM0UgVTgSsE
 caJ0LotrxB2wmG6wrIC8QVBXfWMsWRg_CzuxWCs89ZbyYc68a6KRP7FDop96
 aMykUF3P5bgQ.p_vMos_xKR4jCxW7lMMw0kQ2u5JnLjyouKID
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181508.302886720@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:54 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 12/17] slub: Avoid disabling interrupts in free slowpath
References: <20110526181442.789868308@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:40:57.434875035 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:41:00.194875015 -0500
@@ -2183,11 +2183,10 @@ static void __slab_free(struct kmem_cach
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
 
-	local_irq_save(flags);
 	stat(s, FREE_SLOWPATH);
 
 	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
-		goto out_unlock;
+		return;
 
 	do {
 		prior = page->freelist;
@@ -2206,7 +2205,7 @@ static void __slab_free(struct kmem_cach
 			 * Otherwise the list_lock will synchronize with
 			 * other processors updating the list of slabs.
 			 */
-                        spin_lock(&n->list_lock);
+                        spin_lock_irqsave(&n->list_lock, flags);
 		}
 		inuse = new.inuse;
 
@@ -2222,7 +2221,7 @@ static void __slab_free(struct kmem_cach
 		 */
                 if (was_frozen)
                         stat(s, FREE_FROZEN);
-                goto out_unlock;
+                return;
         }
 
 	/*
@@ -2245,11 +2244,7 @@ static void __slab_free(struct kmem_cach
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
@@ -2261,8 +2256,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 
-	spin_unlock(&n->list_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }

