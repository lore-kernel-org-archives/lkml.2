Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1DOUwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:52:37 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:35140 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756091Ab1DOUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: P_6tvvAVM1lus4cBpauH9lkSYcMMbjQRuZ1cImliHR3DwNz
 DrJ2Tj3qJJPPvD5V3geu0h_1xSlJKgAa1Ixkn8m6.vAR9F8.DSDOyT4OM.X_
 1iESSiv7gSZHpTZetBIMGREhAJ_HghP6MygS3ucaHg9K7LMNYDwA99ZG_Zyv
 H7hZhjCQoSdgo5.3xGqJxYDrkskH9sxjmgtjRNP5nAcT_D3.cyfYsshfH7tF
 YgNExKuN01HjzcnEryAopPUH0pmgZxYSYspKuzKZdeRYmpvqg07hItJg1AyX
 AzGuq3w9fuD9ihqis_07g98YPgDI6Nr5162ZY8XkVr5y8Iijxe68MmMTvYEu
 yj_1oviAjzUB._2gj
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204748.372362764@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:34 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 04/21] slub: Move node determination out of hotpath
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=move_slab_node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the node does not change then there is no need to recalculate
the node from the page struct. So move the node determination
into the places where we acquire a new slab page.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 12:52:17.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 12:54:15.000000000 -0500
@@ -1828,7 +1828,6 @@ load_freelist:
 	c->freelist = get_freepointer(s, object);
 	page->inuse = page->objects;
 	page->freelist = NULL;
-	c->node = page_to_nid(page);
 
 unlock_out:
 	slab_unlock(page);
@@ -1845,8 +1844,10 @@ another_slab:
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
-		c->page = page;
 		stat(s, ALLOC_FROM_PARTIAL);
+load_from_page:
+		c->node = page_to_nid(page);
+		c->page = page;
 		goto load_freelist;
 	}
 
@@ -1867,8 +1868,8 @@ new_slab:
 
 		slab_lock(page);
 		__SetPageSlubFrozen(page);
-		c->page = page;
-		goto load_freelist;
+
+		goto load_from_page;
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 		slab_out_of_memory(s, gfpflags, node);

