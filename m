Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1AVBSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:18:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:45821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1AVBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:44 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 09/10] fs: make mpage read/write_pages() plug
Date: Sat, 22 Jan 2011 01:17:28 +0000
Message-Id: <1295659049-2688-10-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 fs/mpage.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index d78455a..0afc809 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -364,6 +364,9 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
@@ -385,6 +388,7 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		mpage_bio_submit(READ, bio);
+	blk_finish_plug(&plug);
 	return 0;
 }
 EXPORT_SYMBOL(mpage_readpages);
@@ -666,8 +670,11 @@ int
 mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block)
 {
+	struct blk_plug plug;
 	int ret;
 
+	blk_start_plug(&plug);
+
 	if (!get_block)
 		ret = generic_writepages(mapping, wbc);
 	else {
@@ -682,6 +689,7 @@ mpage_writepages(struct address_space *mapping,
 		if (mpd.bio)
 			mpage_bio_submit(WRITE, mpd.bio);
 	}
+	blk_finish_plug(&plug);
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepages);
-- 
1.7.3.2.146.gca209

