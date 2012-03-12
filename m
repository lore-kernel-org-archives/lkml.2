Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2CLAxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:53:34 -0400
Received: from 1wt.eu ([62.212.114.60]:63117 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab2CLAtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:49:00 -0400
Message-Id: <20120312004411.403253799@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jack Morgenstein <jackm@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Ira Weiny <weiny2@llnl.gov>, Roland Dreier <roland@purestorage.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 02/13] IB/mlx4: pass SMP vendor-specific attribute MADs to firmware
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@mellanox.com>

commit a6f7feae6d19e84253918d88b04153af09d3a243 upstream.

In the current code, vendor-specific MADs (e.g with the FDR-10
attribute) are silently dropped by the driver, resulting in timeouts
at the sending side and inability to query/configure the relevant
feature.  However, the ConnectX firmware is able to handle such MADs.
For unsupported attributes, the firmware returns a GET_RESPONSE MAD
containing an error status.

For example, for a FDR-10 node with LID 11:

    # ibstat mlx4_0 1

    CA: 'mlx4_0'
    Port 1:
    State: Active
    Physical state: LinkUp
    Rate: 40 (FDR10)
    Base lid: 11
    LMC: 0
    SM lid: 24
    Capability mask: 0x02514868
    Port GUID: 0x0002c903002e65d1
    Link layer: InfiniBand

Extended Port Query (EPI) vendor mad timeouts before the patch:

    # smpquery MEPI 11 -d

    ibwarn: [4196] smp_query_via: attr 0xff90 mod 0x0 route Lid 11
    ibwarn: [4196] _do_madrpc: retry 1 (timeout 1000 ms)
    ibwarn: [4196] _do_madrpc: retry 2 (timeout 1000 ms)
    ibwarn: [4196] _do_madrpc: timeout after 3 retries, 3000 ms
    ibwarn: [4196] mad_rpc: _do_madrpc failed; dport (Lid 11)
    smpquery: iberror: [pid 4196] main: failed: operation EPI: ext port info query failed

EPI query works OK with the patch:

    # smpquery MEPI 11 -d

    ibwarn: [6548] smp_query_via: attr 0xff90 mod 0x0 route Lid 11
    ibwarn: [6548] mad_rpc: data offs 64 sz 64
    mad data
    0000 0000 0000 0001 0000 0001 0000 0001
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
    # Ext Port info: Lid 11 port 0
    StateChangeEnable:...............0x00
    LinkSpeedSupported:..............0x01
    LinkSpeedEnabled:................0x01
    LinkSpeedActive:.................0x01

Signed-off-by: Jack Morgenstein <jackm@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Acked-by: Ira Weiny <weiny2@llnl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/mad.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 19e68ab..c0206dc 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -252,12 +252,9 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
 			return IB_MAD_RESULT_SUCCESS;
 
 		/*
-		 * Don't process SMInfo queries or vendor-specific
-		 * MADs -- the SMA can't handle them.
+		 * Don't process SMInfo queries -- the SMA can't handle them.
 		 */
-		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_SM_INFO ||
-		    ((in_mad->mad_hdr.attr_id & IB_SMP_ATTR_VENDOR_MASK) ==
-		     IB_SMP_ATTR_VENDOR_MASK))
+		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_SM_INFO)
 			return IB_MAD_RESULT_SUCCESS;
 	} else if (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT ||
 		   in_mad->mad_hdr.mgmt_class == MLX4_IB_VENDOR_CLASS1   ||
-- 
1.7.2.1.45.g54fbc



