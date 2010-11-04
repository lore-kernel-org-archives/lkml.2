Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0KDIoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:44:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:34881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab0KDIoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,294,1286175600"; 
   d="scan'208";a="570251214"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v14 10/17] If device is in zero-copy mode first, bonding will fail.
Date: Thu,  4 Nov 2010 17:05:06 +0800
Message-Id: <8364055ac2b8674da9df73869ea26f96f621e126.1288860477.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

If device is in this zero-copy mode first, we cannot handle this,
so fail it. This patch is for this.

If bonding is created first, and one of the device will be in zero-copy
mode, this will be handled by mp device. It will first check if all the
slaves have the zero-copy capability. If no, fail too. Otherwise make
all the slaves in zero-copy mode.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
---
 drivers/net/bonding/bond_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3b16f62..dfb6a2c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1428,6 +1428,10 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 			   bond_dev->name);
 	}
 
+	/* if the device is in zero-copy mode before bonding, fail it. */
+	if (dev_is_mpassthru(slave_dev))
+		return -EBUSY;
+
 	/* already enslaved */
 	if (slave_dev->flags & IFF_SLAVE) {
 		pr_debug("Error, Device was already enslaved\n");
-- 
1.7.3

