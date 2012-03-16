Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab2CPDFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:05:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CPDFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:05:05 -0400
Message-ID: <4F62ADC8.1030502@gmail.com>
Date: Fri, 16 Mar 2012 11:04:40 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/async-thread.c: decrease workers->num_workers only
 on worker can be freed in btrfs_stop_workers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the worker cannot be freed, decrease workers->num_workers can
corrupt the statistics. The workers->num_workers should be decreased
only when the worker can be stopped and freed in btrfs_stop_workers.


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 0cc20b3..5a7d756 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -413,9 +413,9 @@ int btrfs_stop_workers(struct btrfs_workers *workers)
 				    worker_list);
 
 		atomic_inc(&worker->refs);
-		workers->num_workers -= 1;
 		if (!list_empty(&worker->worker_list)) {
 			list_del_init(&worker->worker_list);
+			workers->num_workers--;
 			put_worker(worker);
 			can_stop = 1;
 		} else
-- 
1.7.1
