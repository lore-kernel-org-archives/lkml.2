Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0JWVKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:10:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56025 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0JWVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=v2e8dQgH0/iWeG+TwqiVtxIczbiczkSVQUic7aFgplbwpP4LXAsUCZwUIUiNWk4txT
         sQjqSlwj5RObChK00x/ql2XlHY5nxXNeemCK/AqImKiZQEDo2BTEZ7YR1N83I5RbwaEI
         q7qpVk+6OHCD/zWz6OvbJFdahHqkOKh7idRuQ=
Subject: [BUG] disk_free_ptbl_rcu_cb() crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Oct 2010 23:10:01 +0200
Message-ID: <1287868201.2658.563.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Linus tree makes my machine crash in disk_free_ptbl_rcu_cb(),
while booting...

commit 7681bfeeccff5ef seems the problem ?

Following patch solves the NULL dereference, but this is only to show
you where the problem is, not a real fix, of course.

Thanks

 block/genhd.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a8adf96..b63d401 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -930,14 +930,16 @@ static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
 	struct disk_part_tbl *ptbl =
 		container_of(head, struct disk_part_tbl, rcu_head);
 	struct gendisk *disk = ptbl->disk;
-	struct request_queue *q = disk->queue;
+	struct request_queue *q = disk ? disk->queue : NULL;
 	unsigned long flags;
 
 	kfree(ptbl);
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	elv_quiesce_end(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	if (q) {
+		spin_lock_irqsave(q->queue_lock, flags);
+		elv_quiesce_end(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 }
 
 /**


