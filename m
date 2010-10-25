Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0JYRha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:37:30 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:5700 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094Ab0JYRh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:37:29 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-2.6] cxgb3: fix device opening error path
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        swise@opengridcomputing.com
Date: Mon, 25 Oct 2010 10:35:02 -0700
Message-ID: <20101025173502.27055.847.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Only negative return from bind_qsets() should be considered an error and
propagated.
It fixes an issue reported by IBM on P Series platform.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index a04ce6a..4e3c123 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -1266,11 +1266,13 @@ static int cxgb_up(struct adapter *adap)
 	}
 
 	if (!(adap->flags & QUEUES_BOUND)) {
-		err = bind_qsets(adap);
-		if (err) {
-			CH_ERR(adap, "failed to bind qsets, err %d\n", err);
+		int ret = bind_qsets(adap);
+
+		if (ret < 0) {
+			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
 			free_irq_resources(adap);
+			err = ret;
 			goto out;
 		}
 		adap->flags |= QUEUES_BOUND;

