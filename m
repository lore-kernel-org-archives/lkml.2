Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2HaVwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:52:01 -0400
Received: from [66.192.166.38] ([66.192.166.38]:44830 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755128Ab2HaVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:51:39 -0400
Date: Fri, 31 Aug 2012 17:51:38 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] nbd: clear waiting_queue on shutdown
Message-ID: <504131ea.3+adybT2Cu/nzX3r%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Paul Clements <paul.clements@steeleye.com>


Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d07c9f7..0c03411 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -449,6 +449,14 @@ static void nbd_clear_que(struct nbd_device *nbd)
 		req->errors++;
 		nbd_end_request(req);
 	}
+
+	while (!list_empty(&nbd->waiting_queue)) {
+		req = list_entry(nbd->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		req->errors++;
+		nbd_end_request(req);
+	}
 }
 
 
@@ -598,6 +606,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
+		BUG_ON(!list_empty(&nbd->waiting_queue));
 		if (file)
 			fput(file);
 		return 0;
