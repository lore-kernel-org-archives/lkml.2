Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1ACNxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:53:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1ACNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cFAge24dgrqr8MP2uATahJjcok7yFZhtvEyQ3/Al6N1+faD1pY6ZkYfAvsqSrWp5iH
         ZFx+FCwuc5x0tGSIPIyTVLudnGEGJwAPDCZpk08ztYM6+yFTREqgIr/F6Ao1N5R4827i
         SwoEGp5yLcNSCeNcSxpDPQODtzwqqomV6Jez4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
Date: Mon,  3 Jan 2011 14:49:44 +0100
Message-Id: <1294062595-30097-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
the number of work items is determined from userland and the work item
may block, enforcing strict concurrency limit would be a good idea.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org
---
Please feel free to take it into the subsystem tree or simply ack -
I'll route it through the wq tree.

Thanks.

 fs/aio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8c8f6c5..dc3fcbb 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -85,7 +85,7 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	aio_wq = create_workqueue("aio");
+	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
 	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
 	BUG_ON(!abe_pool);
 
@@ -569,7 +569,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
 		spin_unlock(&fput_lock);
-		queue_work(aio_wq, &fput_work);
+		schedule_work(&fput_work);
 	} else {
 		req->ki_filp = NULL;
 		really_put_req(ctx, req);
-- 
1.7.1

