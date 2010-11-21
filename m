Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0KUCs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:48:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1687 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab0KUCkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:12 -0500
From: Joe Perches <joe@perches.com>
To: Amit Kumar Salecha <amit.salecha@qlogic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/62] netxen: Use static const
Date: Sat, 20 Nov 2010 18:38:32 -0800
Message-Id: <4c21ad852e21302a14cc6bf743695a2b6e18b560.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  18658	  16443	   4312	  39413	   99f5	drivers/net/netxen/netxen_nic_hw.o.new
  18714	  16443	   4312	  39469	   9a2d	drivers/net/netxen/netxen_nic_hw.o.old

Changed nx_p3_nic_add_mac to take a const u8 *
Used ARRAY_SIZE instead of magic number.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/netxen/netxen_nic_hw.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 37d3ebd..e42d26e 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -655,7 +655,7 @@ nx_p3_sre_macaddr_change(struct netxen_adapter *adapter, u8 *addr, unsigned op)
 }
 
 static int nx_p3_nic_add_mac(struct netxen_adapter *adapter,
-		u8 *addr, struct list_head *del_list)
+		const u8 *addr, struct list_head *del_list)
 {
 	struct list_head *head;
 	nx_mac_list_t *cur;
@@ -686,7 +686,9 @@ static void netxen_p3_nic_set_multi(struct net_device *netdev)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 	struct netdev_hw_addr *ha;
-	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	static const u8 bcast_addr[ETH_ALEN] = {
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	};
 	u32 mode = VPORT_MISS_MODE_DROP;
 	LIST_HEAD(del_list);
 	struct list_head *head;
@@ -869,9 +871,11 @@ int netxen_config_rss(struct netxen_adapter *adapter, int enable)
 	u64 word;
 	int i, rv;
 
-	u64 key[] = { 0xbeac01fa6a42b73bULL, 0x8030f20c77cb2da3ULL,
-			0xae7b30b4d0ca2bcbULL, 0x43a38fb04167253dULL,
-			0x255b0ec26d5a56daULL };
+	static const u64 key[] = {
+		0xbeac01fa6a42b73bULL, 0x8030f20c77cb2da3ULL,
+		0xae7b30b4d0ca2bcbULL, 0x43a38fb04167253dULL,
+		0x255b0ec26d5a56daULL
+	};
 
 
 	memset(&req, 0, sizeof(nx_nic_req_t));
@@ -895,7 +899,7 @@ int netxen_config_rss(struct netxen_adapter *adapter, int enable)
 		((u64)(enable & 0x1) << 8) |
 		((0x7ULL) << 48);
 	req.words[0] = cpu_to_le64(word);
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < ARRAY_SIZE(key); i++)
 		req.words[i+1] = cpu_to_le64(key[i]);
 
 
-- 
1.7.3.2.245.g03276.dirty

