Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2DKSMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:12:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34734 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2DKSML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:12:11 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: glommer@parallels.com, <devel@openvz.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove BUG() in possible but rare condition
Date: Wed, 11 Apr 2012 15:10:24 -0300
Message-Id: <1334167824-19142-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While stressing the kernel with with failing allocations today,
I hit the following chain of events:

alloc_page_buffers():

	bh = alloc_buffer_head(GFP_NOFS);
	if (!bh)
		goto no_grow; <= path taken

grow_dev_page():
        bh = alloc_page_buffers(page, size, 0);
        if (!bh)
                goto failed;  <= taken, consequence of the above

and then the failed path BUG()s the kernel.

The failure is inserted a litte bit artificially, but even then,
I see no reason why it should be deemed impossible in a real box.

Even though this is not a condition that we expect to see
around every time, failed allocations are expected to be handled,
and BUG() sounds just too much. As a matter of fact, grow_dev_page()
can return NULL just fine in other circumstances, so I propose we just
remove it, then.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 fs/buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 36d6665..351e18e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -985,7 +985,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	return page;
 
 failed:
-	BUG();
 	unlock_page(page);
 	page_cache_release(page);
 	return NULL;
-- 
1.7.7.6

