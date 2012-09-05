Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2IEHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:09:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53443 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2IEHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:09:25 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 15:09:25 +0800
Message-ID: <CAPgLHd_HTYgzRJWvM7wekcm+EiVj24WzrhcOXkj9c1k33z+ARg@mail.gmail.com>
Subject: [PATCH] drbd: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: drbd-dev@lists.linbit.com
Cc: yongjun_wei@trendmicro.com.cn, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/drbd/drbd_worker.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 6bce2cc..a196281 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -141,8 +141,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	mdev->writ_cnt += e->size >> 9;
-	list_del(&e->w.list); /* has been on active_ee or sync_ee */
-	list_add_tail(&e->w.list, &mdev->done_ee);
+	list_move_tail(&e->w.list, &mdev->done_ee);
 
 	/* No hlist_del_init(&e->collision) here, we did not send the Ack yet,
 	 * neither did we wake possibly waiting conflicting requests.


