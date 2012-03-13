Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab2CMJSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:18:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43161 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab2CMJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:18:07 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: axboe@kernel.dk, tj@kernel.org, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>,
        Xiaotian Feng <dannyfeng@tencent.com>
Subject: [PATCH v2] block: fix ioc leak in put_io_context
Date: Tue, 13 Mar 2012 13:21:06 -0400
Message-Id: <1331659266-21940-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120312142226.GD17288@redhat.com>
References: <20120312142226.GD17288@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When put_io_context is called, if ioc->icq_list is empty and refcount
    is 1, kernel will not free the ioc.

    This is caught by following kmemleak:

    unreferenced object 0xffff880036349fe0 (size 216):
      comm "sh", pid 2137, jiffies 4294931140 (age 290579.412s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
        01 00 01 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
      backtrace:
        [<ffffffff8169f926>] kmemleak_alloc+0x26/0x50
        [<ffffffff81195a9c>] kmem_cache_alloc_node+0x1cc/0x2a0
        [<ffffffff81356b67>] create_io_context_slowpath+0x27/0x130
        [<ffffffff81356d2b>] get_task_io_context+0xbb/0xf0
        [<ffffffff81055f0e>] copy_process+0x188e/0x18b0
        [<ffffffff8105609b>] do_fork+0x11b/0x420
        [<ffffffff810247f8>] sys_clone+0x28/0x30
        [<ffffffff816d3373>] stub_clone+0x13/0x20
        [<ffffffffffffffff>] 0xffffffffffffffff

    ioc should be freed if ioc->icq_list is empty.
Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
---
 block/blk-ioc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 8b782a6..9690f27 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -145,6 +145,7 @@ static void ioc_release_fn(struct work_struct *work)
 void put_io_context(struct io_context *ioc)
 {
 	unsigned long flags;
+	bool free_ioc = false;
 
 	if (ioc == NULL)
 		return;
@@ -159,8 +160,13 @@ void put_io_context(struct io_context *ioc)
 		spin_lock_irqsave(&ioc->lock, flags);
 		if (!hlist_empty(&ioc->icq_list))
 			schedule_work(&ioc->release_work);
+		else
+			free_ioc = true;
 		spin_unlock_irqrestore(&ioc->lock, flags);
 	}
+
+	if (free_ioc)
+		kmem_cache_free(iocontext_cachep, ioc);
 }
 EXPORT_SYMBOL(put_io_context);
 
-- 
1.7.5.4

