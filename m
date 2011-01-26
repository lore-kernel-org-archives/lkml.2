Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1AZLWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:22:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1AZLWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sW2NpK8gtcv8gOmXWu6MQdikQ/DXvPvnzs1NIfCnELNGXC4GTAp8zHhs3/Sre7815h
         MLPxLewgHsvcP0J1oKifnCaTDz974Lpg//b7m4bFyQXZHuzq7V7PEbDg9Lktvyys9Eiw
         5PXtVdix97aODsqUllCXJ4lMGhX00uxKgIE1k=
Date: Wed, 26 Jan 2011 12:21:54 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org
Subject: [PATCH UPDATED 21/32] fs/aio: aio_wq isn't used in memory reclaim
 path
Message-ID: <20110126112154.GM12520@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-22-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294062595-30097-22-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
the number of work items is determined from userland and the work item
may block, enforcing strict concurrency limit would be a good idea.

Also, move fput_work to system_wq so that aio_wq is used soley to
throttle the max concurrency of aio work items and fput_work doesn't
interact with other work items.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org
---
Patch description updated to describe fput_work change.  If there's no
further objection, I'll push it through workqueue#for-2.6.39.  Thanks.

 fs/aio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/fs/aio.c
===================================================================
--- work.orig/fs/aio.c
+++ work/fs/aio.c
@@ -85,7 +85,7 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	aio_wq = create_workqueue("aio");
+	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
 	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
 	BUG_ON(!aio_wq || !abe_pool);
 
@@ -569,7 +569,7 @@ static int __aio_put_req(struct kioctx *
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
 		spin_unlock(&fput_lock);
-		queue_work(aio_wq, &fput_work);
+		schedule_work(&fput_work);
 	} else {
 		req->ki_filp = NULL;
 		really_put_req(ctx, req);
