Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0HPQZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:25:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34668 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab0HPQZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:25:02 -0400
Date: Mon, 16 Aug 2010 18:25:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/16] drivers/infiniband/hw/cxgb4: Remove unnecessary error
 code assignment
Message-ID: <Pine.LNX.4.64.1008161824420.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code initializes ret to -ENOMEM, but actually ret is not used in the
code starting at err7, and -ENOMEM is always returned in this case, so the
initialization of ret is unnecessary.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/cxgb4/qp.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 93f6e5b..73e00ed 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -130,11 +130,9 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	/* build fw_ri_res_wr */
 	wr_len = sizeof *res_wr + 2 * sizeof *res;
 
-	skb = alloc_skb(wr_len, GFP_KERNEL);
-	if (!skb) {
-		ret = -ENOMEM;
+	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	if (!skb)
 		goto err7;
-	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
