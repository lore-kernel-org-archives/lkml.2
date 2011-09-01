Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1IAMxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:53:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55667 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1IAMtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/18] drbd: get rid of drbd_bcast_ee, it is of no use anymore
Date: Thu,  1 Sep 2011 14:48:54 +0200
Message-Id: <1314881345-6420-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This function was used to broadcast the (leading part of the)
bio payload in case we see a data integrity error.  It could be received
from userland with the drbdsetup events subcommand,
to have a peek into the payload that caused the checksum mismatch,
and guess from there what may have caused the mismatch,
mainly to guess wether it was modification of in-flight data,
or data corruption by broken hardware or software bugs.

Meanwhile we support bios that are larger than the maximum payload a
netlink datagram can carry.
And we have means to reliably detect modification of in-flight data by
calculating, and comparing, the checksum before and after sendmsg.
There is no need to carry this around anymore.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 12b1533..6dfea2f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1356,8 +1356,6 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
-			drbd_bcast_ee(mdev, "digest failed",
-					dgs, dig_in, dig_vv, peer_req);
 			drbd_free_ee(mdev, peer_req);
 			return NULL;
 		}
-- 
1.7.4.1

