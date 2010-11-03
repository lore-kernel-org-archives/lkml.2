Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0KCPbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab0KCPbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 66] disable lumpy when compaction is enabled
X-Mercurial-Node: ca2fea6527833aad8adcff30cd662dc9b5ebc2ce
Message-Id: <ca2fea6527833aad8adc.1288798056@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:27:36 +0100
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

Compaction is more reliable than lumpy, and lumpy makes the system unusable
when it runs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -274,6 +274,7 @@ unsigned long shrink_slab(unsigned long 
 static void set_lumpy_reclaim_mode(int priority, struct scan_control *sc,
 				   bool sync)
 {
+#ifndef CONFIG_COMPACTION
 	enum lumpy_mode mode = sync ? LUMPY_MODE_SYNC : LUMPY_MODE_ASYNC;
 
 	/*
@@ -294,11 +295,14 @@ static void set_lumpy_reclaim_mode(int p
 		sc->lumpy_reclaim_mode = mode;
 	else
 		sc->lumpy_reclaim_mode = LUMPY_MODE_NONE;
+#endif
 }
 
 static void disable_lumpy_reclaim_mode(struct scan_control *sc)
 {
+#ifndef CONFIG_COMPACTION
 	sc->lumpy_reclaim_mode = LUMPY_MODE_NONE;
+#endif
 }
 
 static inline int is_page_cache_freeable(struct page *page)
@@ -321,9 +325,11 @@ static int may_write_to_queue(struct bac
 	if (bdi == current->backing_dev_info)
 		return 1;
 
+#ifndef CONFIG_COMPACTION
 	/* lumpy reclaim for hugepage often need a lot of write */
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
 		return 1;
+#endif
 	return 0;
 }
 
