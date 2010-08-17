Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab0HQU5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:57:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0HQU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:57:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rFOGrQh9oUu7Al2TEbOHuYcmD8yTW0CP7Utc0VV5QOp72BnPHUP17793Tml6yDUtL
	mHWxt1O2W7KSgw7fLkD1g==
Date: Tue, 17 Aug 2010 13:56:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] transparent hugepage sysfs meminfo
In-Reply-To: <20100803135615.GG6071@random.random>
Message-ID: <alpine.DEB.2.00.1008171343570.972@chino.kir.corp.google.com>
References: <20100803135615.GG6071@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hugepage statistics to per-node sysfs meminfo

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/node.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -98,7 +98,11 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       "Node %d WritebackTmp:   %8lu kB\n"
 		       "Node %d Slab:           %8lu kB\n"
 		       "Node %d SReclaimable:   %8lu kB\n"
-		       "Node %d SUnreclaim:     %8lu kB\n",
+		       "Node %d SUnreclaim:     %8lu kB\n"
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       "Node %d AnonHugePages:  %8lu kB\n"
+#endif
+			,
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
@@ -122,7 +126,12 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
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
+				HPAGE_PMD_NR)
+#endif
+		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
