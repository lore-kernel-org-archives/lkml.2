Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0KCPmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab0KCPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:30:01 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 66] don't alloc harder for gfp nomemalloc even if nowait
X-Mercurial-Node: ed6c78af29bc105fcee3b363a7ab9fdc873c901d
Message-Id: <ed6c78af29bc105fcee3.1288798084@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:04 +0100
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

Not worth throwing away the precious reserved free memory pool for allocations
that can fail gracefully (either through mempool or because they're transhuge
allocations later falling back to 4k allocations).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1941,7 +1941,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
-		alloc_flags |= ALLOC_HARDER;
+		/*
+		 * Not worth trying to allocate harder for
+		 * __GFP_NOMEMALLOC even if it can't schedule.
+		 */
+		if  (!(gfp_mask & __GFP_NOMEMALLOC))
+			alloc_flags |= ALLOC_HARDER;
 		/*
 		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
