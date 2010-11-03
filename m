Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab0KCPbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab0KCPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:04 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 64 of 66] scale nr_rotated to balance memory pressure
X-Mercurial-Node: 54b5b2d012ff38e341ad9dab3f781707e133f1c2
Message-Id: <54b5b2d012ff38e341ad.1288798119@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:39 +0100
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

From: Rik van Riel <riel@redhat.com>

Make sure we scale up nr_rotated when we encounter a referenced
transparent huge page.  This ensures pageout scanning balance
is not distorted when there are huge pages on the LRU.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1259,7 +1259,8 @@ putback_lru_pages(struct zone *zone, str
 		add_page_to_lru_list(zone, page, lru);
 		if (is_active_lru(lru)) {
 			int file = is_file_lru(lru);
-			reclaim_stat->recent_rotated[file]++;
+			int numpages = hpage_nr_pages(page);
+			reclaim_stat->recent_rotated[file] += numpages;
 		}
 		if (!pagevec_add(&pvec, page)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1535,7 +1536,7 @@ static void shrink_active_list(unsigned 
 		}
 
 		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
-			nr_rotated++;
+			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
