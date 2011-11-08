Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1KHJkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:40:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1KHJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:40:31 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: davem@davemloft.net, ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] net/ll_temac: FIX : Wait for indirect wait to end
Date: Tue,  8 Nov 2011 10:39:57 +0100
Message-Id: <1320745197-11053-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While tracing down a connectivity problem on the temac I connected a
probe to the Cross bar irq, and it was triggered when doing
ifdown->ifup.

This is fixed once waiting for the indirect write to end. Since it is
not on the hot path there is no performance loss.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 4d1658e..cf59dac 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -114,6 +114,7 @@ void temac_indirect_out32(struct temac_local *lp, int reg, u32 value)
 		return;
 	temac_iow(lp, XTE_LSW0_OFFSET, value);
 	temac_iow(lp, XTE_CTL0_OFFSET, CNTLREG_WRITE_ENABLE_MASK | reg);
+	temac_indirect_busywait(lp);
 }
 
 /**
-- 
1.7.7.1

