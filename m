Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2HaUCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:02:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34737 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2HaUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:01:04 -0400
From: dongsu.park@profitbricks.com
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, JBottomley@parallels.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH 1/5] ib_srp: free memory correctly in srp_free_iu()
Date: Fri, 31 Aug 2012 22:00:37 +0200
Message-Id: <1346443241-24844-2-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

As a potential fix for a race condition in srp_free_iu(),
hold a mutex in srp_free_target_ib() before calling srp_free_iu().

In addition, also clear rx/tx ring after freeing memory.
Both rx_ring[] and tx_ring[] should be reinitialized to NULL,
to prevent other tasks from accessing the freed memory.

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7ae5a00..a0d0ca2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -291,10 +291,16 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	ib_destroy_cq(target->send_cq);
 	ib_destroy_cq(target->recv_cq);
 
-	for (i = 0; i < SRP_RQ_SIZE; ++i)
+	mutex_lock(&target->mutex);
+	for (i = 0; i < SRP_RQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE; ++i)
+		target->rx_ring[i] = NULL;
+	}
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
+		target->tx_ring[i] = NULL;
+	}
+	mutex_unlock(&target->mutex);
 }
 
 static void srp_path_rec_completion(int status,
-- 
1.7.11.1

