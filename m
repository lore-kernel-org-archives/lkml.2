Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1FEDRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 23:17:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43621 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1FEDRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 23:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yFFSQyAks/cYAzcE94wFdfp21JWsuYPLiEE49GKGx1uLAXSVHqoL1h3WqkUdggXOga
         bkk2YIJSUclBLtdxCMGW/zQzb7rvRDdhVUrAwmQ1NV63ZL91R4DeDg+Emukgtb0FliEI
         A4hoiMrVJ0oWiGZx2HlrjR4TsWNL++bd/9Rec=
From: Weiping Pan <panweiping3@gmail.com>
Cc: Weiping Pan <panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] bonding: make 802.3ad use update lacp_rate (v2)
Date: Sun,  5 Jun 2011 11:16:33 +0800
Message-Id: <1307243793-31007-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <19046.1307130148@death>
References: <19046.1307130148@death>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug that when you modify lacp_rate via sysfs,
802.3ad won't use the new value of lacp_rate to transmit packets.
That is because port->actor_oper_port_state isn't changed.

Change Notes:
v2)
1 Hold read_lock(&bond->lock) when iterate slaves, suggested by Jiri Pirko.
2 Modify actor_oper_port_state via a helper function in bond_3ad.c,
suggested by Jay Vosburgh.
3 Hold slave->state_machine_lock,
so we can modify port->actor_oper_port_state, no matter bond is up or down.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_3ad.c   |   27 +++++++++++++++++++++++++++
 drivers/net/bonding/bond_3ad.h   |    1 +
 drivers/net/bonding/bond_sysfs.c |    1 +
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index c7537abc..5111e0d 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2473,3 +2473,30 @@ void bond_3ad_lacpdu_recv(struct sk_buff *skb, struct bonding *bond,
 	bond_3ad_rx_indication((struct lacpdu *) skb->data, slave, skb->len);
 	read_unlock(&bond->lock);
 }
+
+/*
+ * When modify lacp_rate parameter via sysfs,
+ * update actor_oper_port_state of each port.
+ *
+ * Hold slave->state_machine_lock,
+ * so we can modify port->actor_oper_port_state,
+ * no matter bond is up or down.
+ */
+void bond_3ad_update_lacp_rate(struct bonding *bond)
+{
+	int i;
+	struct slave *slave;
+	struct port *port = NULL;
+
+	read_lock(&bond->lock);
+	bond_for_each_slave(bond, slave, i) {
+		port = &(slave->ad_info.port);
+		__get_state_machine_lock(port);
+		if (bond->params.lacp_fast)
+			port->actor_oper_port_state |= AD_STATE_LACP_TIMEOUT;
+		else
+			port->actor_oper_port_state &= ~AD_STATE_LACP_TIMEOUT;
+		__release_state_machine_lock(port);
+	}
+	read_unlock(&bond->lock);
+}
diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 0ee3f16..e466faf 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -282,5 +282,6 @@ int bond_3ad_xmit_xor(struct sk_buff *skb, struct net_device *dev);
 void bond_3ad_lacpdu_recv(struct sk_buff *skb, struct bonding *bond,
 			  struct slave *slave);
 int bond_3ad_set_carrier(struct bonding *bond);
+void bond_3ad_update_lacp_rate(struct bonding *bond);
 #endif //__BOND_3AD_H__
 
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 88fcb25..03d1196 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -804,6 +804,7 @@ static ssize_t bonding_store_lacp(struct device *d,
 
 	if ((new_value == 1) || (new_value == 0)) {
 		bond->params.lacp_fast = new_value;
+		bond_3ad_update_lacp_rate(bond);
 		pr_info("%s: Setting LACP rate to %s (%d).\n",
 			bond->dev->name, bond_lacp_tbl[new_value].modename,
 			new_value);
-- 
1.7.4

