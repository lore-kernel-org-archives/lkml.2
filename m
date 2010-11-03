Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0KCPfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0KCPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 62 of 66] disable transparent hugepages by default on small
	systems
X-Mercurial-Node: 5791385d8111de4b51437dec92a8688dfdbcbd00
Message-Id: <5791385d8111de4b5143.1288798117@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:37 +0100
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

On small systems, the extra memory used by the anti-fragmentation
memory reserve and simply because huge pages are smaller than large
pages can easily outweigh the benefits of less TLB misses.

In case of the crashdump kernel, OOMs have been observed due to
the anti-fragmentation memory reserve taking up a large fraction
of the crashdump image.

This patch disables transparent hugepages on systems with less
than 1GB of RAM, but the hugepage subsystem is fully initialized
so administrators can enable THP through /sys if desired.

v2: reduce the limit to 512MB

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Avi Kiviti <avi@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -527,6 +527,14 @@ static int __init hugepage_init(void)
 		goto out;
 	}
 
+	/*
+	 * By default disable transparent hugepages on smaller systems,
+	 * where the extra memory used could hurt more than TLB overhead
+	 * is likely to save.  The admin can still enable it through /sys.
+	 */
+	if (totalram_pages < (512 << (20 - PAGE_SHIFT)))
+		transparent_hugepage_flags = 0;
+
 	start_khugepaged();
 
 	set_recommended_min_free_kbytes();
