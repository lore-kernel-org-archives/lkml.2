Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0HWBRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:17:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab0HWBRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:17:48 -0400
Message-ID: <4C71CD60.5050507@cn.fujitsu.com>
Date: Mon, 23 Aug 2010 09:22:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] btrfs: fix threshold calculation for block groups smaller
 than 1GB
References: <4C71CD4B.10606@cn.fujitsu.com>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a block group is smaller than 1GB, the extent entry threadhold
calculation will always set the threshold to 0.

So as free space gets fragmented, btrfs will switch to use bitmap
to manage free space, but then will never switch back to extents
due to this bug.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f488fac..7edbef6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -263,14 +263,18 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	u64 max_bytes;
 	u64 bitmap_bytes;
 	u64 extent_bytes;
+	u64 size = block_group->key.offset;
 
 	/*
 	 * The goal is to keep the total amount of memory used per 1gb of space
 	 * at or below 32k, so we need to adjust how much memory we allow to be
 	 * used by extent based free space tracking
 	 */
-	max_bytes = MAX_CACHE_BYTES_PER_GIG *
-		(div64_u64(block_group->key.offset, 1024 * 1024 * 1024));
+	if (size < 1024 * 1024 * 1024)
+		max_bytes = MAX_CACHE_BYTES_PER_GIG;
+	else
+		max_bytes = MAX_CACHE_BYTES_PER_GIG *
+			div64_u64(size, 1024 * 1024 * 1024);
 
 	/*
 	 * we want to account for 1 more bitmap than what we have so we can make
-- 
1.7.0.1

