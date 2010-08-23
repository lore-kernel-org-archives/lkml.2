Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0HWBSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:18:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0HWBSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:18:21 -0400
Message-ID: <4C71CD84.1000809@cn.fujitsu.com>
Date: Mon, 23 Aug 2010 09:23:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] btrfs: free fully occupied bitmap in cluster
References: <4C71CD4B.10606@cn.fujitsu.com>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's no more free space in a bitmap, we should free it,
otherwise seems it won't get freed until we free the block group.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 017fd55..631e14f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1035,6 +1035,8 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 
 	ret = search_start;
 	bitmap_clear_bits(block_group, entry, ret, bytes);
+	if (entry->bytes == 0)
+		free_bitmap(block_group, entry);
 out:
 	spin_unlock(&cluster->lock);
 	spin_unlock(&block_group->tree_lock);
-- 
1.7.0.1

