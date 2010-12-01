Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0LAHqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:46:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:19205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab0LAHqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:46:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="682672377"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v16 10/17] If device is in zero-copy mode first, bonding will fail.
Date: Wed,  1 Dec 2010 16:08:21 +0800
Message-Id: <8975fe27df1b0bc2da53c579a05648507153fd85.1291187695.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
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

