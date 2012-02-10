Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab2BJWIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:08:04 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:25439 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932440Ab2BJWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:08:01 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 78Oj.TUVM1lUqUoWbPAPYzYCnwHJKzFjfy97dGRKCtSOpea
 ZtYvNzuFNCGUT7i1CKgli6h_OEuBK3dMxdtnW0uKZvCnUsuePfc5thClBrtF
 ULb97LybQSz7Pg3ctsOC.IPRhnrOff2JF9cEXuA.UzzjJShO_lcI3ynRjtkk
 ZXlaEaMABAQ69chHLIfWcD2as6xub_93xHfAnpR1S_Rb01N7J.x8aSoYykXS
 yOi3W4dsrTjSlpv9l1yDcGwoZACp1UrlwHkshA_.QSyyhsPunDQfKGG7pgHj
 xPyFS5f0.dahT.NjAlrCe.giUd7dleW7nTsMtieij.y6IripPo3HUailaJew
 FrjHCEOpofxWu31IFQmT9zzjELJ1V9DNzLruCzPKft8VgYoE2s8BPmP1zrWW
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 10 Feb 2012 16:07:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <alpine.DEB.2.00.1202101443570.31424@router.home>
Message-ID: <alpine.DEB.2.00.1202101606530.3840@router.home>
References: <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de> <alpine.DEB.2.00.1202080907320.30248@router.home> <20120208163421.GL5938@suse.de> <alpine.DEB.2.00.1202081338210.32060@router.home>
 <20120208212323.GM5938@suse.de> <alpine.DEB.2.00.1202081557540.5970@router.home> <20120209125018.GN5938@suse.de> <alpine.DEB.2.00.1202091345540.4413@router.home> <20120210102605.GO5938@suse.de> <alpine.DEB.2.00.1202101443570.31424@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposal for a patch for slub to move the pfmemalloc handling out of the
fastpath by simply not assigning a per cpu slab when pfmemalloc processing
is going on.



Subject: [slub] Fix so that no mods are required for the fast path

Remove the check for pfmemalloc from the alloc hotpath and put the logic after
the election of a new per cpu slab.

For a pfmemalloc page do not use the fast path but force use of the slow
path (which is also used for the debug case).

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-02-10 09:58:13.066125970 -0600
+++ linux-2.6/mm/slub.c	2012-02-10 10:06:07.114113000 -0600
@@ -2273,11 +2273,12 @@ new_slab:
 		}
 	}

-	if (likely(!kmem_cache_debug(s)))
+	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(c, gfpflags)))
 		goto load_freelist;

+
 	/* Only entered in the debug case */
-	if (!alloc_debug_processing(s, c->page, object, addr))
+	if (kmem_cache_debug(s) && !alloc_debug_processing(s, c->page, object, addr))
 		goto new_slab;	/* Slab failed checks. Next slab needed */

 	c->freelist = get_freepointer(s, object);
@@ -2327,8 +2328,7 @@ redo:
 	barrier();

 	object = c->freelist;
-	if (unlikely(!object || !node_match(c, node) ||
-					!pfmemalloc_match(c, gfpflags)))
+	if (unlikely(!object || !node_match(c, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);

 	else {
