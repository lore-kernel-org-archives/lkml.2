Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1IELuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60004 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1IELqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 30/54] drbd: _drbd_send_zc_ee(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:21 +0200
Message-Id: <1315223145-20640-31-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 39d1cd1..1b61727 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1502,16 +1502,19 @@ static int _drbd_send_zc_ee(struct drbd_conf *mdev,
 {
 	struct page *page = peer_req->pages;
 	unsigned len = peer_req->i.size;
+	int err;
 
 	/* hint all but last page with MSG_MORE */
 	page_chain_for_each(page) {
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
-		if (_drbd_send_page(mdev, page, 0, l,
-				    page_chain_next(page) ? MSG_MORE : 0))
-			return 0;
+
+		err = _drbd_send_page(mdev, page, 0, l,
+				      page_chain_next(page) ? MSG_MORE : 0);
+		if (err)
+			return err;
 		len -= l;
 	}
-	return 1;
+	return 0;
 }
 
 static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
@@ -1636,7 +1639,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 		ok = dgs == drbd_send(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok)
-		ok = _drbd_send_zc_ee(mdev, peer_req);
+		ok = !_drbd_send_zc_ee(mdev, peer_req);
 
 	drbd_put_data_sock(mdev->tconn);
 
-- 
1.7.4.1

