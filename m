Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1BEO0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:26:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1BEOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IsTHZoJ47Oo7t1D/aHeflgdRX+JPxnu6ZIBdgWHDOOJ9dbs6dUJ636TSPiSWrlQAc5
         iDC2FXKFEMnG+vJKG6G7lH5dPGOqM6v3d5/xSDVFhXfNuAgT5NKbfxb3knxCKuCCUvx1
         WfXcLny5tp6k1U4QL5jpfqCDnGhgr3O/EpRU4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 31/52] kstrtox: convert drivers/net/
Date: Sat,  5 Feb 2011 16:20:34 +0200
Message-Id: <1296915654-7458-31-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/net/can/at91_can.c             |    9 +++------
 drivers/net/can/janz-ican3.c           |    5 +++--
 drivers/net/can/slcan.c                |    5 +----
 drivers/net/can/softing/softing_main.c |    2 +-
 drivers/net/netxen/netxen_nic_main.c   |    4 ++--
 drivers/net/qlcnic/qlcnic_main.c       |    4 ++--
 drivers/net/stmmac/stmmac_main.c       |   29 ++++++++++++++++-------------
 7 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 57d2ffb..5c71310 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1079,9 +1079,8 @@ static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
 {
 	struct net_device *ndev = to_net_dev(dev);
 	struct at91_priv *priv = netdev_priv(ndev);
-	unsigned long can_id;
+	u32 can_id;
 	ssize_t ret;
-	int err;
 
 	rtnl_lock();
 
@@ -1090,11 +1089,9 @@ static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
 		goto out;
 	}
 
-	err = strict_strtoul(buf, 0, &can_id);
-	if (err) {
-		ret = err;
+	ret = kstrtou32(buf, 0, &can_id);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (can_id & CAN_EFF_FLAG)
 		can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 366f5cc..eb70a1c 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1608,8 +1608,9 @@ static ssize_t ican3_sysfs_set_term(struct device *dev,
 	unsigned long enable;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &enable))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &enable);
+	if (ret < 0)
+		return ret;
 
 	ret = ican3_set_termination(mod, enable);
 	if (ret)
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index b423965..624059d 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -163,7 +163,6 @@ static void slc_bump(struct slcan *sl)
 	struct sk_buff *skb;
 	struct can_frame cf;
 	int i, dlc_pos, tmp;
-	unsigned long ultmp;
 	char cmd = sl->rbuff[0];
 
 	if ((cmd != 't') && (cmd != 'T') && (cmd != 'r') && (cmd != 'R'))
@@ -181,11 +180,9 @@ static void slc_bump(struct slcan *sl)
 
 	sl->rbuff[dlc_pos] = 0; /* terminate can_id string */
 
-	if (strict_strtoul(sl->rbuff+1, 16, &ultmp))
+	if (kstrtou32(sl->rbuff+1, 16, &cf.can_id))
 		return;
 
-	cf.can_id = ultmp;
-
 	if (!(cmd & 0x20)) /* NO tiny chars => extended frame format */
 		cf.can_id |= CAN_EFF_FLAG;
 
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 5157e15..ef6ff7a 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -594,7 +594,7 @@ static ssize_t store_output(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &val);
+	ret = kstrtoul(buf, 0, &val);
 	if (ret < 0)
 		return ret;
 	val &= 0xFF;
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 33fac32..585f701 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -2503,7 +2503,7 @@ netxen_store_bridged_mode(struct device *dev,
 	if (adapter->is_up != NETXEN_ADAPTER_UP_MAGIC)
 		goto err_out;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		goto err_out;
 
 	if (!netxen_config_bridged_mode(adapter, !!new))
@@ -2542,7 +2542,7 @@ netxen_store_diag_mode(struct device *dev,
 	struct netxen_adapter *adapter = dev_get_drvdata(dev);
 	unsigned long new;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		return -EINVAL;
 
 	if (!!new != !!(adapter->flags & NETXEN_NIC_DIAG_ENABLED))
diff --git a/drivers/net/qlcnic/qlcnic_main.c b/drivers/net/qlcnic/qlcnic_main.c
index 37c04b4..f511c33 100644
--- a/drivers/net/qlcnic/qlcnic_main.c
+++ b/drivers/net/qlcnic/qlcnic_main.c
@@ -3192,7 +3192,7 @@ qlcnic_store_bridged_mode(struct device *dev,
 	if (!test_bit(__QLCNIC_DEV_UP, &adapter->state))
 		goto err_out;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		goto err_out;
 
 	if (!adapter->nic_ops->config_bridged_mode(adapter, !!new))
@@ -3228,7 +3228,7 @@ qlcnic_store_diag_mode(struct device *dev,
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	unsigned long new;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		return -EINVAL;
 
 	if (!!new != !!(adapter->flags & QLCNIC_DIAG_ENABLED))
diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index 34a0af3..cb449f7 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1955,31 +1955,34 @@ static int __init stmmac_cmdline_opt(char *str)
 	if (!str || !*str)
 		return -EINVAL;
 	while ((opt = strsep(&str, ",")) != NULL) {
+		int rv;
+
 		if (!strncmp(opt, "debug:", 6))
-			strict_strtoul(opt + 6, 0, (unsigned long *)&debug);
+			rv = kstrtoint(opt + 6, 0, &debug);
 		else if (!strncmp(opt, "phyaddr:", 8))
-			strict_strtoul(opt + 8, 0, (unsigned long *)&phyaddr);
+			rv = kstrtoint(opt + 8, 0, &phyaddr);
 		else if (!strncmp(opt, "dma_txsize:", 11))
-			strict_strtoul(opt + 11, 0,
-				       (unsigned long *)&dma_txsize);
+			rv = kstrtoint(opt + 11, 0, &dma_txsize);
 		else if (!strncmp(opt, "dma_rxsize:", 11))
-			strict_strtoul(opt + 11, 0,
-				       (unsigned long *)&dma_rxsize);
+			rv = kstrtoint(opt + 11, 0, &dma_rxsize);
 		else if (!strncmp(opt, "buf_sz:", 7))
-			strict_strtoul(opt + 7, 0, (unsigned long *)&buf_sz);
+			rv = kstrtoint(opt + 7, 0, &buf_sz);
 		else if (!strncmp(opt, "tc:", 3))
-			strict_strtoul(opt + 3, 0, (unsigned long *)&tc);
+			rv = kstrtoint(opt + 3, 0, &tc);
 		else if (!strncmp(opt, "watchdog:", 9))
-			strict_strtoul(opt + 9, 0, (unsigned long *)&watchdog);
+			rv = kstrtoint(opt + 9, 0, &watchdog);
 		else if (!strncmp(opt, "flow_ctrl:", 10))
-			strict_strtoul(opt + 10, 0,
-				       (unsigned long *)&flow_ctrl);
+			rv = kstrtoint(opt + 10, 0, &flow_ctrl);
 		else if (!strncmp(opt, "pause:", 6))
-			strict_strtoul(opt + 6, 0, (unsigned long *)&pause);
+			rv = kstrtoint(opt + 6, 0, &pause);
 #ifdef CONFIG_STMMAC_TIMER
 		else if (!strncmp(opt, "tmrate:", 7))
-			strict_strtoul(opt + 7, 0, (unsigned long *)&tmrate);
+			rv = kstrtoint(opt + 7, 0, &tmrate);
 #endif
+		else
+			rv = -EINVAL;
+		if (rv < 0)
+			return rv;
 	}
 	return 0;
 }
-- 
1.7.3.4

