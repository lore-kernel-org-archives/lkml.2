Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2AFMtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:49:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62607 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab2AFMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:49:36 -0500
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 20:49:34 +0800
Message-ID: <CAJd=RBDLT54HGuM7+=rM7yKi1ziSxLBsnT2Rm2VjRPTSc8OkFg@mail.gmail.com>
Subject: [PATCH v2] mm: vmscan: check page order in isolating lru pages
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before attempting to take all pages in the order aligned region, check for
page order is added for minor optimization, since the pfn-based isolation
could be bypassed if the newly isolated page is no less than that region.

v1->v2 changes
1, the reason to add the check is described in change log,
2, the check is corrected,
3, comment for the check is corrected.

Thanks for all comments recieved.


Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Fri Jan  6 20:28:22 2012
@@ -1162,6 +1162,7 @@ static unsigned long isolate_lru_pages(u
 		unsigned long end_pfn;
 		unsigned long page_pfn;
 		int zone_id;
+		unsigned int isolated_pages = 1;

 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -1172,7 +1173,8 @@ static unsigned long isolate_lru_pages(u
 		case 0:
 			mem_cgroup_lru_del(page);
 			list_move(&page->lru, dst);
-			nr_taken += hpage_nr_pages(page);
+			isolated_pages = hpage_nr_pages(page);
+			nr_taken += isolated_pages;
 			break;

 		case -EBUSY:
@@ -1188,6 +1190,14 @@ static unsigned long isolate_lru_pages(u
 			continue;

 		/*
+		 * To save a few cycles, the following pfn-based isolation
+		 * could be bypassed if the newly isolated page is no less
+		 * than the order aligned region.
+		 */
+		if (isolated_pages >= (1 << order))
+			continue;
+
+		/*
 		 * Attempt to take all pages in the order aligned region
 		 * surrounding the tag page.  Only take those pages of
 		 * the same active state as that tag page.  We may safely
@@ -1227,7 +1237,6 @@ static unsigned long isolate_lru_pages(u
 				break;

 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
-				unsigned int isolated_pages;

 				mem_cgroup_lru_del(cursor_page);
 				list_move(&cursor_page->lru, dst);
