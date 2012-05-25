Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2EYV4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:56:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51340 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2EYV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:56:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, axboe@kernel.dk
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/blkfront: Add BUG_ON to deal with misbehaving backends.
Date: Fri, 25 May 2012 17:50:03 -0400
Message-Id: <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the ring structure is the 'id' field which is under
control of the frontend. The frontend stamps it with "some"
value (this some in this implementation being a value less
than BLK_RING_SIZE), and when it gets a response expects
said value to be in the response structure. We have a check
for the id field when spolling new requests but not when
de-spolling responses.

We also add an extra check in add_id_to_freelist to make
sure that the 'struct request' was not NULL - as we cannot
pass a NULL to __blk_end_request_all, otherwise that crashes
(and all the operations that the response is dealing with
end up with __blk_end_request_all).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 60eed4b..8e177ca 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -145,6 +145,7 @@ static void add_id_to_freelist(struct blkfront_info *info,
 			       unsigned long id)
 {
 	info->shadow[id].req.u.rw.id  = info->shadow_free;
+	BUG_ON(info->shadow[id].request == NULL);
 	info->shadow[id].request = NULL;
 	info->shadow_free = id;
 }
@@ -746,6 +747,12 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 
 		bret = RING_GET_RESPONSE(&info->ring, i);
 		id   = bret->id;
+		/*
+		 * The backend has messed up and given us an id that we would
+		 * never have given to it (we stamp it up to BLK_RING_SIZE -
+		 * look in get_id_from_freelist.
+		 */
+		BUG_ON(id >= BLK_RING_SIZE);
 		req  = info->shadow[id].request;
 
 		if (bret->operation != BLKIF_OP_DISCARD)
-- 
1.7.7.6

