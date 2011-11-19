Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1KST4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab1KSTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:55:06 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] mm: check if we isolated a compound page during lumpy scan
Date: Sat, 19 Nov 2011 20:54:15 +0100
Message-Id: <1321732460-14155-4-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321635524-8586-1-git-send-email-mgorman@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly take into account if we isolated a compound page during the
lumpy scan in reclaim and break the loop if we've isolated enough.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/vmscan.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a1893c0..3421746 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1183,13 +1183,16 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+				unsigned int isolated_pages;
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-				nr_taken += hpage_nr_pages(page);
-				nr_lumpy_taken++;
+				isolated_pages = hpage_nr_pages(page);
+				nr_taken += isolated_pages;
+				nr_lumpy_taken += isolated_pages;
 				if (PageDirty(cursor_page))
-					nr_lumpy_dirty++;
+					nr_lumpy_dirty += isolated_pages;
 				scan++;
+				pfn += isolated_pages-1;
 			} else {
 				/*
 				 * Check if the page is freed already.
