Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1DOUsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:48:12 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:35218 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756806Ab1DOUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Xvf0JBoVM1n6fiYjmCmn7Z5mBM3XFrml8jwShLedMlFmvlS
 OA5hpgupFKlXr0kpONfYHNRAvg6vSoBK8Y2etnIJM1ArZrUR3xqGvh4xlZVQ
 DVq9gVZ9ez3DB._X556DsYFlYQPGP2ARlxNCEkiYHMmTKe8VLa4tEYnft3ho
 cXkWBpnx8zHAWLrqpBDg4sMLHfXk4hLMd8Y_abQo1EWZwZJwdwDs5ylcO9QR
 a4TrQ2pZZTW4Mua3o6GnLFQKIKywfgzn1y7vg1opindj14fHE8pItwGarYx.
 cFBmEM8D3goEBf8GMcQIaar.1.5kL08uBIqDCt_UJB.L5YG10syZ_EkU3NRQ
 -
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204757.083852753@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:49 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 19/21] slub: fast release on full slab
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=slab_alloc_fast_release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make deactivation occur implicitly while checking out the current freelist.

This avoids one cmpxchg operation on a slab that is now fully in use.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 14:30:10.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 14:30:12.000000000 -0500
@@ -1953,9 +1953,21 @@ static void *__slab_alloc(struct kmem_ca
 			object = page->freelist;
 			counters = page->counters;
 			new.counters = counters;
-			new.inuse = page->objects;
 			VM_BUG_ON(!new.frozen);
 
+			/*
+			 * If there is no object left then we use this loop to
+			 * deactivate the slab which is simple since no objects
+			 * are left in the slab and therefore we do not need to
+			 * put the page back onto the partial list.
+			 *
+			 * If there are objects left then we retrieve them
+			 * and use them to refill the per cpu queue.
+			*/
+
+			new.inuse = page->objects;
+			new.frozen = object != NULL;
+
 		} while (!cmpxchg_double_slab(s, page,
 				object, counters,
 				NULL, new.counters,
@@ -1965,8 +1977,10 @@ static void *__slab_alloc(struct kmem_ca
 load_freelist:
 	VM_BUG_ON(!page->frozen);
 
-	if (unlikely(!object))
+	if (unlikely(!object)) {
+		c->page = NULL;
 		goto new_slab;
+	}
 
 	c->freelist = get_freepointer(s, object);
 

