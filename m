Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1EFSHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:07:13 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:45305 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756630Ab1EFSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dIjy6_8VM1kEm1O8bag3V.yKx40igM.gAJjtXR37bhdDh2X
 cU42ZEqpQcGRiRpG9piHtKKdR9wZtJvQK8NxTIcp6DlO22GxbzhP71gdroMI
 NT6S6cUorw8tVZ5TBR1r8rpSC40U69UK.JiiCtCzaeYmCimix0TWAiwl1TXf
 QTztSGVCj69ONjGtb2iP8m47aDL57z3JvbZqVhsbpM16G9orsSdliWYzTbl4
 mSuNfjxB.tGEY6iftFougsmbEOnrlJismWlqQOJ29oEybELTxYwzAczJclaf
 CBv.eF4fmn45oGkzuEZtwMtqJeRxVXRws_oFX.LdvsYPCZ.cuTFTg6BOm71Q
 DAY8BNC34oguj9LP76zU0t7Uf
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180701.776075673@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:54 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 13/16] slub: Get rid of the another_slab label
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=eliminate_another_slab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid deactivate slab in special cases if we do the
deactivation of slabs in each code flow that leads to new_slab.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-06 12:55:42.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-06 12:56:13.000000000 -0500
@@ -1928,8 +1928,10 @@ static void *__slab_alloc(struct kmem_ca
 	if (!page)
 		goto new_slab;
 
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
+	if (unlikely(!node_match(c, node))) {
+		deactivate_slab(s, c);
+		goto new_slab;
+	}
 
 	stat(s, ALLOC_REFILL);
 
@@ -1954,7 +1956,7 @@ load_freelist:
 	VM_BUG_ON(!page->frozen);
 
 	if (unlikely(!object))
-		goto another_slab;
+		goto new_slab;
 
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
@@ -1962,9 +1964,6 @@ load_freelist:
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
-another_slab:
-	deactivate_slab(s, c);
-
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {

