Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2ACWlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2ACWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.770959980@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>
Subject: [21/75] IB/mlx4: Fix shutdown crash accessing a non-existent bitmap
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 4af3ce0de0c12e5c17811eaefad36ab8e146c0fd upstream.

Commit cfcde11c3d7a ("IB/mlx4: Use flow counters on IBoE ports") added
code that sets elements of counters[] to -1 if no counter is allocated,
but then goes ahead and passes every entry to mlx4_counter_free() on
shutdown.  This is a bad idea, especially if MLX4_DEV_CAP_FLAG_COUNTERS
isn't set so there isn't even an underlying bitmap to free from.

Tested-by: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mlx4/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1144,7 +1144,8 @@ err_reg:
 
 err_counter:
 	for (; i; --i)
-		mlx4_counter_free(ibdev->dev, ibdev->counters[i - 1]);
+		if (ibdev->counters[i - 1] != -1)
+			mlx4_counter_free(ibdev->dev, ibdev->counters[i - 1]);
 
 err_map:
 	iounmap(ibdev->uar_map);
@@ -1175,7 +1176,8 @@ static void mlx4_ib_remove(struct mlx4_d
 	}
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
-		mlx4_counter_free(ibdev->dev, ibdev->counters[p]);
+		if (ibdev->counters[p] != -1)
+			mlx4_counter_free(ibdev->dev, ibdev->counters[p]);
 	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);
 


