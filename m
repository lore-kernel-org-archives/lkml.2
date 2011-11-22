Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1KVQxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:53:12 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:42139 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754121Ab1KVQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:53:11 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SkLTNzIVM1meAYkjFxnPREAU31xXsJJIGkEHUbLQE.jOkAj
 pxzCTwVgv8Eukt0bovS3RsImLusJheZfGpMkVWCMuL3R2IbYyjjCb50P4ey8
 1d38GY_qiPqoJohiV_vYAwpGRQsdG8pSYxWOBuNbPN4SD_XjrUXs8aWZLgzi
 IHg2ad3yH3WnUbhkNbvgE7YqLTOmULLrSNquegfuOYYHoGoVhijbYMBAaXnf
 aNOw9jGqH2YHB7DExMYfbxDVBD.NK0pa6NSxGNSjEUqSnsZF9QNM3zD3HWtn
 5yrhxs337qzOSraucuKkd0XZjVvjhn67gxPw.CP29EtKQKvDxJusKflO8oRv
 wnQ1hyn.zl5ny9Igekp9yShwE1NDDykpLulYBqTb61kDPxw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 10:53:06 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: slub: Lockout validation scans during freeing of object
In-Reply-To: <alpine.DEB.2.00.1111221040300.28197@router.home>
Message-ID: <alpine.DEB.2.00.1111221052130.28197@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home> <alpine.DEB.2.00.1111221040300.28197@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit heavy handed locking but this should do the trick.

Subject: slub: Lockout validation scans during freeing of object

Slab validation can run right now while the slab free paths prepare
the redzone fields etc around the objects in preparation of the
actual freeing of the object. This can lead to false positives.

Take the node lock unconditionally during free so that the validation
can examine objects without them being disturbed by freeing operations.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-11-22 10:42:19.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-11-22 10:44:34.000000000 -0600
@@ -2391,8 +2391,15 @@ static void __slab_free(struct kmem_cach

 	stat(s, FREE_SLOWPATH);

-	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
-		return;
+	if (kmem_cache_debug(s)) {
+
+		/* Lock out any concurrent validate_slab calls */
+		n = get_node(s, page_to_nid(page));
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		if (!free_debug_processing(s, page, x, addr))
+			goto out;
+	}

 	do {
 		prior = page->freelist;
@@ -2471,6 +2478,7 @@ static void __slab_free(struct kmem_cach
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
+out:
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return;

