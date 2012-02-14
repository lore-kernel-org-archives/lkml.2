Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab2BNOsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:48:16 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56961 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760781Ab2BNOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:48:14 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Roland Dreier <roland@kernel.org>
Cc: Danny Kukawka <dkukawka@suse.de>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.co.il>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mlx4: fix -Wuninitialized warning
Date: Tue, 14 Feb 2012 15:47:57 +0100
Message-Id: <1329230877-27457-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230894;8ecf4ae2;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/infiniband/hw/mlx4/qp.c: In function ‘build_mlx_header’:
drivers/infiniband/hw/mlx4/qp.c:1441:30: warning: ‘vlan’ may be
  used uninitialized in this function [-Wuninitialized]

Initialize vlan with 0. Check return value of ib_get_cached_gid()
and return out of build_mlx_header() in error case.

v2: handle also error cases

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/infiniband/hw/mlx4/qp.c |   18 +++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index aa2aefa..4b889d9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1363,7 +1363,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	int is_eth;
 	int is_vlan = 0;
 	int is_grh;
-	u16 vlan;
+	u16 vlan = 0;
+	int ret;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
@@ -1372,8 +1373,12 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+		ret = ib_get_cached_gid(ib_dev,
+				  be32_to_cpu(ah->av.ib.port_pd) >> 24,
 				  ah->av.ib.gid_index, &sgid);
+		if (ret)
+			return ret;
+
 		vlan = rdma_get_vlan_id(&sgid);
 		is_vlan = vlan < 0x1000;
 	}
@@ -1392,8 +1396,13 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		sqp->ud_header.grh.flow_label    =
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
-				  ah->av.ib.gid_index, &sqp->ud_header.grh.source_gid);
+		ret = ib_get_cached_gid(ib_dev,
+					be32_to_cpu(ah->av.ib.port_pd) >> 24,
+					ah->av.ib.gid_index,
+					&sqp->ud_header.grh.source_gid);
+		if (ret)
+			return ret;
+
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
 	}
-- 
1.7.7.3

