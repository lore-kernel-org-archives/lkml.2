Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0HKX6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:44 -0400
Received: from kroah.org ([198.145.64.141]:43375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab0HKX63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:29 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235500.596789516@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [055/111] Btrfs: dont add extent 0 to the free space cache v2
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 06b2331f8333ec6edf41662757ce8882cc1747d5 upstream.

If block group 0 is completely free, btrfs_read_block_groups will
add extent [0, BTRFS_SUPER_INFO_OFFSET) to the free space cache.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/extent-tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -195,6 +195,14 @@ static int exclude_super_stripes(struct
 	int stripe_len;
 	int i, nr, ret;
 
+	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
+		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
+		cache->bytes_super += stripe_len;
+		ret = add_excluded_extent(root, cache->key.objectid,
+					  stripe_len);
+		BUG_ON(ret);
+	}
+
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
@@ -255,7 +263,7 @@ static u64 add_new_free_space(struct btr
 		if (ret)
 			break;
 
-		if (extent_start == start) {
+		if (extent_start <= start) {
 			start = extent_end + 1;
 		} else if (extent_start > start && extent_start < end) {
 			size = extent_start - start;


