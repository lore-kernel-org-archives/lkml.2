Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab0KCPfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab0KCPbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 51 of 66] set recommended min free kbytes
X-Mercurial-Node: e4c3f336872db7bfbf58f7fa000053906b78e80f
Message-Id: <e4c3f336872db7bfbf58.1288798106@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:26 +0100
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

If transparent hugepage is enabled initialize min_free_kbytes to an optimal
value by default. This moves the hugeadm algorithm in kernel.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -85,6 +85,47 @@ struct khugepaged_scan {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+
+static int set_recommended_min_free_kbytes(void)
+{
+	struct zone *zone;
+	int nr_zones = 0;
+	unsigned long recommended_min;
+	extern int min_free_kbytes;
+
+	if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) &&
+	    !test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags))
+		return 0;
+
+	for_each_populated_zone(zone)
+		nr_zones++;
+
+	/* Make sure at least 2 hugepages are free for MIGRATE_RESERVE */
+	recommended_min = HPAGE_PMD_NR * nr_zones * 2;
+
+	/*
+	 * Make sure that on average at least two pageblocks are almost free
+	 * of another type, one for a migratetype to fall back to and a
+	 * second to avoid subsequent fallbacks of other types There are 3
+	 * MIGRATE_TYPES we care about.
+	 */
+	recommended_min += HPAGE_PMD_NR * nr_zones * 3 * 3;
+
+	/* don't ever allow to reserve more than 5% of the lowmem */
+	recommended_min = min(recommended_min,
+			      (unsigned long) nr_free_buffer_pages() / 20);
+	recommended_min <<= (PAGE_SHIFT-10);
+
+	if (recommended_min > min_free_kbytes) {
+		min_free_kbytes = recommended_min;
+		setup_per_zone_wmarks();
+	}
+	return 0;
+}
+late_initcall(set_recommended_min_free_kbytes);
+
 static int start_khugepaged(void)
 {
 	int err = 0;
@@ -108,6 +149,8 @@ static int start_khugepaged(void)
 		mutex_unlock(&khugepaged_mutex);
 		if (wakeup)
 			wake_up_interruptible(&khugepaged_wait);
+
+		set_recommended_min_free_kbytes();
 	} else
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
@@ -177,6 +220,13 @@ static ssize_t enabled_store(struct kobj
 			ret = err;
 	}
 
+	if (ret > 0 &&
+	    (test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) ||
+	     test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags)))
+		set_recommended_min_free_kbytes();
+
 	return ret;
 }
 static struct kobj_attribute enabled_attr =
@@ -464,6 +514,8 @@ static int __init hugepage_init(void)
 
 	start_khugepaged();
 
+	set_recommended_min_free_kbytes();
+
 out:
 	return err;
 }
