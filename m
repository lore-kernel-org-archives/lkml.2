Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030977Ab2CVIoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:44:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64251 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898Ab2CVIna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:43:30 -0400
From: Weiping Pan <panweiping3@gmail.com>
To: netdev@vger.kernel.org
Cc: fubar@us.ibm.com, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net V2 1/2] bonding:delete rlb entry if bond's ip is deleted
Date: Thu, 22 Mar 2012 16:37:50 +0800
Message-Id: <a63c50701cc26f4cba7867513adfe6803092b038.1332405098.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1332405098.git.panweiping3@gmail.com>
References: <cover.1332405098.git.panweiping3@gmail.com>
In-Reply-To: <cover.1332405098.git.panweiping3@gmail.com>
References: <cover.1332405098.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ip of bonding is deleted, its rlb table still contains old invalid
mappings, just delete them to avoid poisoning other clients arp cache.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.c  |   35 +++++++++++++++++++++++++++++++++++
 drivers/net/bonding/bond_alb.h  |    2 ++
 drivers/net/bonding/bond_main.c |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index f820b26..bca1039 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -853,6 +853,41 @@ static void rlb_clear_vlan(struct bonding *bond, unsigned short vlan_id)
 	_unlock_rx_hashtbl_bh(bond);
 }
 
+/* delete all rlb entries whose ip_src equals ip */
+void bond_alb_delete_entry(struct bonding *bond, __be32 ip)
+{
+	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
+	u32 curr_index;
+
+	_lock_rx_hashtbl_bh(bond);
+
+	curr_index = bond_info->rx_hashtbl_head;
+	while (curr_index != RLB_NULL_INDEX) {
+		struct rlb_client_info *curr = &(bond_info->rx_hashtbl[curr_index]);
+		u32 next_index = bond_info->rx_hashtbl[curr_index].next;
+		u32 prev_index = bond_info->rx_hashtbl[curr_index].prev;
+		if (curr->assigned && (curr->ip_src == ip)) {
+			if (curr_index == bond_info->rx_hashtbl_head) {
+				bond_info->rx_hashtbl_head = next_index;
+			}
+
+			if (prev_index != RLB_NULL_INDEX) {
+				bond_info->rx_hashtbl[prev_index].next = next_index;
+			}
+
+			if (next_index != RLB_NULL_INDEX) {
+				bond_info->rx_hashtbl[next_index].prev = prev_index;
+			}
+
+			rlb_init_table_entry(curr);
+		}
+
+		curr_index = next_index;
+	}
+
+	_unlock_rx_hashtbl_bh(bond);
+}
+
 /*********************** tlb/rlb shared functions *********************/
 
 static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[])
diff --git a/drivers/net/bonding/bond_alb.h b/drivers/net/bonding/bond_alb.h
index 90f140a..38863fc 100644
--- a/drivers/net/bonding/bond_alb.h
+++ b/drivers/net/bonding/bond_alb.h
@@ -163,5 +163,7 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 void bond_alb_monitor(struct work_struct *);
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr);
 void bond_alb_clear_vlan(struct bonding *bond, unsigned short vlan_id);
+
+void bond_alb_delete_entry(struct bonding *bond, __be32 ip);
 #endif /* __BOND_ALB_H__ */
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 435984a..ec071b9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3315,6 +3315,7 @@ static int bond_inetaddr_event(struct notifier_block *this, unsigned long event,
 				return NOTIFY_OK;
 			case NETDEV_DOWN:
 				bond->master_ip = 0;
+				bond_alb_delete_entry(bond, ifa->ifa_local);
 				return NOTIFY_OK;
 			default:
 				return NOTIFY_DONE;
-- 
1.7.4

