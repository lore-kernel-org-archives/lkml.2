Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab2CMFou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:44:50 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53854 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2CMFos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:44:48 -0400
From: Avery Pennarun <apenwarr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Avery Pennarun <apenwarr@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai LU <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/5] mm: bootmem: BUG() if you try to allocate bootmem too late.
Date: Tue, 13 Mar 2012 01:36:37 -0400
Message-Id: <1331617001-20906-2-git-send-email-apenwarr@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you try to allocate or reserve bootmem after the bootmem subsystem has
already been shut down and replaced with the real VM system, it would
succeed, but then your memory would silently get freed and could be
reallocated by the normal VM.

Add a few lines of code to catch this condition immediately rather than
manifesting as memory corruption.

Signed-off-by: Avery Pennarun <apenwarr@gmail.com>
---
 mm/bootmem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 668e94d..7a9f505 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -39,6 +39,7 @@ bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
 
 static int bootmem_debug;
+static int bootmem_stopped;
 
 static int __init bootmem_debug_setup(char *buf)
 {
@@ -182,6 +183,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 
 	bdebug("nid=%td start=%lx end=%lx\n",
 		bdata - bootmem_node_data, start, end);
+	bootmem_stopped = 1;
 
 	while (start < end) {
 		unsigned long *map, idx, vec;
@@ -279,6 +281,7 @@ static int __init __reserve(bootmem_data_t *bdata, unsigned long sidx,
 	unsigned long idx;
 	int exclusive = flags & BOOTMEM_EXCLUSIVE;
 
+	BUG_ON(bootmem_stopped);
 	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
 		bdata - bootmem_node_data,
 		sidx + bdata->node_min_pfn,
-- 
1.7.7.3

