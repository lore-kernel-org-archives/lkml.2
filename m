Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1DOUsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:48:11 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:38603 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756804Ab1DOUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: jF6yW7wVM1kLha83r9r.2CB5cIZVDEVz.XVbR3iIVXYtyiM
 SwoTyJk37KH1wb3K_Jit.Phu2DtJ9_lUk2By3DMtSdp7lU2.CKYtlhFRrbvg
 avmaYqvDmOJ9CwUSs2ILnlHUz3M.osTyTZabPgco2YNh_YTr8k9ABf4.X.oB
 ZvvTrRS_ASaTvrcHv.MPHiZPlYHIDC37GNTHtbLgFPhHbwiTGuPvT_9607ib
 Qq4KhmgWEl8pLNpxKG_5WEbr0frTMwtr.IpwY1_bhleKLaghQFK.K_XWjvhU
 c3gM25nvPv5mSDcsS19fxisGYqHHsjfliXWLirygnhe_KEw8jDhm4XT6uKvF
 z9E5qMAM0s8a5481t9whn9g--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204756.505586853@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:48 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 18/21] slub: Get rid of the another_slab label
References: <20110415204730.326790555@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-04-15 14:30:06.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 14:30:10.000000000 -0500
@@ -1938,8 +1938,10 @@ static void *__slab_alloc(struct kmem_ca
 	if (!page)
 		goto new_slab;
 
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
+	if (unlikely(!node_match(c, node))) {
+		deactivate_slab(s, c);
+		goto new_slab;
+	}
 
 	stat(s, ALLOC_REFILL);
 
@@ -1964,7 +1966,7 @@ load_freelist:
 	VM_BUG_ON(!page->frozen);
 
 	if (unlikely(!object))
-		goto another_slab;
+		goto new_slab;
 
 	c->freelist = get_freepointer(s, object);
 
@@ -1975,9 +1977,6 @@ load_freelist:
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
-another_slab:
-	deactivate_slab(s, c);
-
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {

