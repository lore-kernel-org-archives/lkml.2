Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1EFSHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:07:09 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:25163 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756636Ab1EFSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tftojXUVM1lsZmMylwpG.xWHgiO_u8aIV_RHgyyJ8n_7MMP
 ueARgj8R6LwulMsg6jkF9T4WwxdFw49YHeSDGdOeHeF9Ne5b8ncO476JLNSG
 RKIkAw99._gRs1HCpqjM6PJtuvvT0kZOWaUaVfPG1C8gg_1euv_X.HI_3UkS
 MJrpqSzL2C92n8JmBa93xtwqageQKweei8ZO7._Pg92nfEnsZubGv1v57zVF
 JOwe2SwscuboHMzoRbxBxJVWMUXPRHs3DuX4sBhixDK__ij2mMKdQ9.HG_JD
 epHAOAFjW8kI9mtpOhG1.Fp.F4SDIn5J86vZ3XmWlnBU6HKWDe.pCNNmV3Vo
 xhSc3B9Z5dGYyVP9R
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180702.336084286@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:55 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 14/16] slub: fast release on full slab
References: <20110506180541.990069206@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-05-06 12:56:13.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-06 12:56:38.000000000 -0500
@@ -1943,9 +1943,21 @@ static void *__slab_alloc(struct kmem_ca
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
@@ -1955,8 +1967,10 @@ static void *__slab_alloc(struct kmem_ca
 load_freelist:
 	VM_BUG_ON(!page->frozen);
 
-	if (unlikely(!object))
+	if (unlikely(!object)) {
+		c->page = NULL;
 		goto new_slab;
+	}
 
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);

