Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439Ab2DKVnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:43:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17728 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2DKVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:43:31 -0400
Date: Wed, 11 Apr 2012 23:43:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-rdma@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
Message-ID: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in ib_link_query_port(), the call to mlx4_MAD_IFC() fails we will
currently do 'return err;' which will leak 'in_mad' and 'out_mad' that
we previously allocated. I believe we should instead do 'goto out;'
where we'll properly free the memory we previously allocated.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75d3056..cc88c9c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -247,7 +247,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
 				   NULL, NULL, in_mad, out_mad);
 		if (err)
-			return err;
+			goto out;
 
 		/* Checking LinkSpeedActive for FDR-10 */
 		if (out_mad->data[15] & 0x1)
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

