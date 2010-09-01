Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0IAToq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:44:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab0IATop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:44:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yxo4mFE3AVM3VB/ueJv6N6cxw7mJEEV3eUI70TlBfGejZ6foIliKm/GJmecJalioq
	SFV4BiMLmKad+YF/F+2ig==
Date: Wed, 1 Sep 2010 12:44:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Izik Eidus <ieidus@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
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
Subject: [patch] transparent hugepage sysfs meminfo
In-Reply-To: <20100901190859.GA20316@random.random>
Message-ID: <alpine.DEB.2.00.1009011244130.4951@chino.kir.corp.google.com>
References: <20100901190859.GA20316@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hugepage statistics to per-node sysfs meminfo

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/node.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -117,12 +117,21 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
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
@@ -133,7 +142,13 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
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
