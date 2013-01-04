Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3ADIuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:50:00 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:51854 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3ADItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:49:47 -0500
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: [patch net-next V6 09/15] qlcnic: guard __vlan_find_dev_deep() by rcu_read_lock
Date: Fri,  4 Jan 2013 09:48:57 +0100
Message-Id: <1357289343-817-10-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1357289343-817-1-git-send-email-jiri@resnulli.us>
References: <1357289343-817-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock was missing here

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Sony Chacko <sony.chacko@qlogic.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 137ca13..3655ca2 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3186,12 +3186,14 @@ void qlcnic_restore_indev_addr(struct net_device *netdev, unsigned long event)
 
 	qlcnic_config_indev_addr(adapter, netdev, event);
 
+	rcu_read_lock();
 	for_each_set_bit(vid, adapter->vlans, VLAN_N_VID) {
 		dev = __vlan_find_dev_deep(netdev, vid);
 		if (!dev)
 			continue;
 		qlcnic_config_indev_addr(adapter, dev, event);
 	}
+	rcu_read_unlock();
 }
 
 static int qlcnic_netdev_event(struct notifier_block *this,
-- 
1.8.0

