Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0G2JGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:06:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab0G2JEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:04:46 -0400
Message-ID: <4C513BF6.5030906@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 16:29:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] Btrfs: fix increasing num_workers_starting twice
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_workers_starting is increased twice when the btrfs uses generic workers
to create a new kthread.

The reason is following:
start_new_worker_func() calls btrfs_start_workers() to start a new kthread,
this function will add 1 to ->num_workers_starting, but ->num_workers_starting
has been increased by check_pending_worker_creates()

we use __btrfs_start_workers() instead of btrfs_start_workers() to fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..eb3ec2d 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -84,11 +84,14 @@ struct worker_start {
 	struct btrfs_workers *queue;
 };
 
+static int __btrfs_start_workers(struct btrfs_workers *workers,
+					int num_workers);
+
 static void start_new_worker_func(struct btrfs_work *work)
 {
 	struct worker_start *start;
 	start = container_of(work, struct worker_start, work);
-	btrfs_start_workers(start->queue, 1);
+	__btrfs_start_workers(start->queue, 1);
 	kfree(start);
 }
 
-- 
1.7.0.1
