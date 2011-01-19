Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1ASQ6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:58:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1ASQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:58:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l8TNnU27mrbFQ9gcNsPuDD1g8t9qiJcE8HsL0jVnbCpsI/x7QAnQG2afycGV91bprU
         elUVp/rG8iyYK4Yuijo7fD+SEFbA+xGqg9qiPo936TRAOzOlx7q6gdEzVpuaJ2g0L7KT
         Uod5A0VRxAzdowN8RhxIDcukB8eBr5SAaAt80=
Date: Wed, 19 Jan 2011 18:58:37 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Btrfs: remove unneeded allocation in
	load_free_space_cache()
Message-ID: <20110119165836.GB1358@kwango.lan.net>
References: <20110119153436.GA1358@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119153436.GA1358@kwango.lan.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I messed up size argument of kzalloc() and consequently memcpy().  Here
is an updated version.


The checksums array is unused, remove it.  We only need disk_crcs array
to verify checksums.

There is no need to allocate first_page_offset bytes for disk_crcs
array.  It's enough to allocate (sizeof(u32) * num_checksums) bytes
because disk_crcs should only hold checksums.  gen is fetched
directly from the page.

cur_crc is initialized later in the code.  Don't initialize it in a
declaration.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/free-space-cache.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 60d6842..ee0af41 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -215,14 +215,14 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *leaf;
 	struct page *page;
 	struct btrfs_path *path;
-	u32 *checksums = NULL, *crc;
+	u32 *crc = NULL;
 	char *disk_crcs = NULL;
 	struct btrfs_key key;
 	struct list_head bitmaps;
 	u64 num_entries;
 	u64 num_bitmaps;
 	u64 generation;
-	u32 cur_crc = ~(u32)0;
+	u32 cur_crc;
 	pgoff_t index = 0;
 	unsigned long first_page_offset;
 	int num_checksums;
@@ -298,11 +298,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	/* Setup everything for doing checksumming */
 	num_checksums = i_size_read(inode) / PAGE_CACHE_SIZE;
-	checksums = crc = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
-	if (!checksums)
-		goto out;
 	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
-	disk_crcs = kzalloc(first_page_offset, GFP_NOFS);
+	disk_crcs = kzalloc(sizeof(u32) * num_checksums, GFP_NOFS);
 	if (!disk_crcs)
 		goto out;
 
@@ -352,7 +349,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 		if (index == 0) {
 			u64 *gen;
 
-			memcpy(disk_crcs, addr, first_page_offset);
+			memcpy(disk_crcs, addr, sizeof(u32) * num_checksums);
 			gen = addr + (sizeof(u32) * num_checksums);
 			if (*gen != BTRFS_I(inode)->generation) {
 				printk(KERN_ERR "btrfs: space cache generation"
@@ -467,7 +464,6 @@ next:
 
 	ret = 1;
 out:
-	kfree(checksums);
 	kfree(disk_crcs);
 	iput(inode);
 	return ret;
-- 
1.7.2.3

