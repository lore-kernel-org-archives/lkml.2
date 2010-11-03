Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0KCPdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0KCPbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 65 of 66] transparent hugepage sysfs meminfo
X-Mercurial-Node: ce57a3a626bd03bb9a084d4d67b4405e3ea81294
Message-Id: <ce57a3a626bd03bb9a08.1288798120@v2.random>
In-Reply-To: <patchbomb.1288798055@v2.random>
References: <patchbomb.1288798055@v2.random>
User-Agent: Mercurial-patchbomb/1.4.1
Date: Wed, 03 Nov 2010 16:28:40 +0100
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

From: David Rientjes <rientjes@google.com>

Add hugepage statistics to per-node sysfs meminfo

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -117,12 +117,21 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d WritebackTmp:   %8lu kB\n"
 		       "Node %d Slab:           %8lu kB\n"
 		       "Node %d SReclaimable:   %8lu kB\n"
-		       "Node %d SUnreclaim:     %8lu kB\n",
+		       "Node %d SUnreclaim:     %8lu kB\n"
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       "Node %d AnonHugePages:  %8lu kB\n"
+#endif
+			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			HPAGE_PMD_NR
+#endif
+		       ),
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
@@ -133,7 +142,13 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			, nid,
+			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			HPAGE_PMD_NR)
+#endif
+		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
