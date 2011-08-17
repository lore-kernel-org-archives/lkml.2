Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1HQNaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:30:52 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:50434 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab1HQNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:30:51 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 09:30:51 EDT
X-AuditID: b753bd60-9fe84ba000000655-91-4e4bc0e7a203
X-AuditID: b753bd60-9fe84ba000000655-91-4e4bc0e7a203
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] avoid null pointer access in vm_struct
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 17 Aug 2011 22:28:48 +0900
Message-ID: <20110817132848.2352.80544.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
that is a linklist of vm_struct. It, however, may access pages field of
vm_struct where a page was not allocated, which results in a null pointer
access and leads to a kernel panic.

Why this happen:
For example, in __vmalloc_area_node, the nr_pages field of vm_struct are
set to the expected number of pages to be allocated, before the actual
pages allocations. At the same time, when the /proc/vmallocinfo is read, it
accesses the pages field of vm_struct according to the nr_pages field at
show_numa_info(). Thus, a null pointer access happens.

Patch:
This patch avoids accessing the pages field with unallocated page when
show_numa_info() is called. So, it can solve this problem.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---

 mm/vmalloc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ef0903..e2ec5b0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2472,13 +2472,16 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 	if (NUMA_BUILD) {
 		unsigned int nr, *counters = m->private;
 
-		if (!counters)
+		if (!counters || !v->nr_pages || !v->pages)
 			return;
 
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-		for (nr = 0; nr < v->nr_pages; nr++)
+		for (nr = 0; nr < v->nr_pages; nr++) {
+			if (!v->pages[nr])
+				break;
 			counters[page_to_nid(v->pages[nr])]++;
+		}
 
 		for_each_node_state(nr, N_HIGH_MEMORY)
 			if (counters[nr])

