Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab0KQEXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:23:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab0KQEXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:23:35 -0500
Message-ID: <4CE358C3.7070903@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:23:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Ito <t-itoh@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] btrfs: restructure btrfs_merge_bio_hook()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:23:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:23:58,
	Serialize complete at 2010-11-17 12:23:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We restructured btrfs_merge_bio_hook(). And the new function will be used to
fix a panic problem that caused by direct IO.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3906e48..32b68fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1353,6 +1353,22 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	return 0;
 }
 
+static int __btrfs_can_merge_page_to_bio(struct btrfs_mapping_tree *map_tree,
+					 size_t size, struct bio *bio)
+{
+	u64 logical = (u64)bio->bi_sector << 9;
+	u64 map_length;
+	int ret;
+
+	map_length = bio->bi_size;
+	ret = btrfs_map_block(map_tree, READ, logical,
+			      &map_length, NULL, 0);
+
+	if (map_length < bio->bi_size + size)
+		return 1;
+	return ret;
+}
+
 /*
  * extent_io.c merge_bio_hook, this must check the chunk tree to make sure
  * we don't create bios that span stripes or chunks
@@ -1363,23 +1379,12 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 {
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	struct btrfs_mapping_tree *map_tree;
-	u64 logical = (u64)bio->bi_sector << 9;
-	u64 length = 0;
-	u64 map_length;
-	int ret;
 
 	if (bio_flags & EXTENT_BIO_COMPRESSED)
 		return 0;
 
-	length = bio->bi_size;
 	map_tree = &root->fs_info->mapping_tree;
-	map_length = length;
-	ret = btrfs_map_block(map_tree, READ, logical,
-			      &map_length, NULL, 0);
-
-	if (map_length < length + size)
-		return 1;
-	return ret;
+	return __btrfs_can_merge_page_to_bio(map_tree, size, bio);
 }
 
 /*
-- 
1.7.0.1
