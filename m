Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0F2Le4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:34:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42825 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0F2Lex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:34:53 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 01/14] vmscan: Fix mapping use after free
Date: Tue, 29 Jun 2010 12:34:35 +0100
Message-Id: <1277811288-5195-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Use lock_page_nosync in handle_write_error as after writepage we have no
reference to the mapping when taking the page lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c7e57c..62a30fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -296,7 +296,7 @@ static int may_write_to_queue(struct backing_dev_info *bdi)
 static void handle_write_error(struct address_space *mapping,
 				struct page *page, int error)
 {
-	lock_page(page);
+	lock_page_nosync(page);
 	if (page_mapping(page) == mapping)
 		mapping_set_error(mapping, error);
 	unlock_page(page);
-- 
1.7.1

