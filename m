Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2DAHQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:16:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37239 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2DAHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:16:01 -0400
Message-ID: <4F7800A3.4010504@gmail.com>
Date: Sun, 01 Apr 2012 15:15:47 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/extent_io.c: fix btrfs_release_extent_buffer_page with
 the right usage of num_extent_pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


num_extent_pages returns the number of pages in the specific range, not
the index of the last page in the eb range. btrfs_release_extent_buffer_page
is called with start_idx set 0 in current codes, so it's not a problem yet.
But the logic is indeed wrong. Fix it with this patch.


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6099261..941f0ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3976,11 +3976,13 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 						unsigned long start_idx)
 {
 	unsigned long index;
+	unsigned long num_pages;
 	struct page *page;
 
 	BUG_ON(extent_buffer_under_io(eb));
 
-	index = num_extent_pages(eb->start, eb->len);
+	num_pages = num_extent_pages(eb->start, eb->len);
+	index = start_idx + num_pages;
 	if (start_idx >= index)
 		return;
 
-- 
1.7.1


