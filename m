Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1B1KRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:17:17 -0500
Received: from trinity.develer.com ([83.149.158.210]:52817 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1B1KRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:17:14 -0500
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Righi <arighi@develer.com>
Subject: [PATCH 3/3] blkio-throttle: async write io instrumentation
Date: Mon, 28 Feb 2011 11:15:05 +0100
Message-Id: <1298888105-3778-4-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298888105-3778-1-git-send-email-arighi@develer.com>
References: <1298888105-3778-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce IO throttling policy to asynchronous IO writes at the time tasks
write pages in the page cache.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 mm/page-writeback.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2cb01f6..e3f5f4f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -607,6 +607,19 @@ void set_page_dirty_balance(struct page *page, int page_mkwrite)
 	}
 }
 
+/*
+ * Get a request_queue of the underlying superblock device from an
+ * address_space.
+ */
+static struct request_queue *as_to_rq(struct address_space *mapping)
+{
+	struct block_device *bdev;
+
+	bdev = (mapping->host && mapping->host->i_sb->s_bdev) ?
+				mapping->host->i_sb->s_bdev : NULL;
+	return bdev ? bdev_get_queue(bdev) : NULL;
+}
+
 static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
 
 /**
@@ -628,6 +641,7 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 {
 	unsigned long ratelimit;
 	unsigned long *p;
+	struct request_queue *q;
 
 	ratelimit = ratelimit_pages;
 	if (mapping->backing_dev_info->dirty_exceeded)
@@ -644,6 +658,9 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 		ratelimit = sync_writeback_pages(*p);
 		*p = 0;
 		preempt_enable();
+		q = as_to_rq(mapping);
+		if (q)
+			blk_throtl_async(q, ratelimit << PAGE_SHIFT);
 		balance_dirty_pages(mapping, ratelimit);
 		return;
 	}
-- 
1.7.1

