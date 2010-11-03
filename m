Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0KCPaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:30:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab0KCP35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:29:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 66] _GFP_NO_KSWAPD
X-Mercurial-Node: b1b95be209a2927d21c769268208fa0fe3d27be0
Message-Id: <b1b95be209a2927d21c7.1288798083@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:03 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

Transparent hugepage allocations must be allowed not to invoke kswapd or any
other kind of indirect reclaim (especially when the defrag sysfs is control
disabled). It's unacceptable to swap out anonymous pages (potentially
anonymous transparent hugepages) in order to create new transparent hugepages.
This is true for the MADV_HUGEPAGE areas too (swapping out a kvm virtual
machine and so having it suffer an unbearable slowdown, so another one with
guest physical memory marked MADV_HUGEPAGE can run 30% faster if it is running
memory intensive workloads, makes no sense). If a transparent hugepage
allocation fails the slowdown is minor and there is total fallback, so kswapd
should never be asked to swapout memory to allow the high order allocation to
succeed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
---

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -81,13 +81,15 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
+#define __GFP_NO_KSWAPD	((__force gfp_t)0x400000u)
+
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
  * allocations that simply cannot be supported (e.g. page tables).
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
-#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1996,7 +1996,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	wake_all_kswapd(order, zonelist, high_zoneidx);
+	if (!(gfp_mask & __GFP_NO_KSWAPD))
+		wake_all_kswapd(order, zonelist, high_zoneidx);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
