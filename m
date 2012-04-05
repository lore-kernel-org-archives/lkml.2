Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2DEPLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:11:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52161 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2DEPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:11:37 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Alex Duyck <alexander.h.duyck@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        John Ronciak <john.ronciak@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH 2/2] ixgbe: add missing rtnl_lock in PM resume path
Date: Thu,  5 Apr 2012 11:11:04 -0400
Message-Id: <1333638664-17062-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333638664-17062-1-git-send-email-bpoirier@suse.de>
References: <1333638664-17062-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon resume from standby, ixgbe may trigger the ASSERT_RTNL() in
netif_set_real_num_tx_queues(). The call stack is:
	netif_set_real_num_tx_queues
	ixgbe_set_num_queues
	ixgbe_init_interrupt_scheme
	ixgbe_resume

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

---
Unlike patch 1 for igb, we cannot lock rtnl closer to the point where
netif_set_real_num_tx_queues() is called because ixgbe_init_interrupt_scheme()
is also called by the dcb code, already under rtnl.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 3e26b1f..ff6edab 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4836,7 +4836,9 @@ static int ixgbe_resume(struct pci_dev *pdev)
 
 	pci_wake_from_d3(pdev, false);
 
+	rtnl_lock();
 	err = ixgbe_init_interrupt_scheme(adapter);
+	rtnl_unlock();
 	if (err) {
 		e_dev_err("Cannot initialize interrupts for device\n");
 		return err;
-- 
1.7.7

