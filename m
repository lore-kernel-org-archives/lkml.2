Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0LERyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:54:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab0LERvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YFgmpD6pGw5WFCUs3it/UAX0XiiA4solva5fskzk6WQQ7rRdMwToWJSELTedybC7H8
         eKlE7j7foaWjJjqXOTQmAVD7HmR6C2X2N9Xy+euSCeD9+AA7zZLnDB3HCFe1yBGebEbm
         VcasemkmgKWRwx46hp4RUdYhXjiVIcbBPsx54=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 32/45] kstrtox: convert drivers/net/
Date: Sun,  5 Dec 2010 19:49:29 +0200
Message-Id: <1291571382-2719-32-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/net/can/janz-ican3.c         |    5 +++--
 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 drivers/net/qlcnic/qlcnic_main.c     |    4 ++--
 drivers/net/stmmac/stmmac_main.c     |   29 ++++++++++++++++-------------
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 6e533dc..51fd497 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1617,8 +1617,9 @@ static ssize_t ican3_sysfs_set_term(struct device *dev,
 	unsigned long enable;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &enable))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &enable);
+	if (ret < 0)
+		return ret;
 
 	ret = ican3_set_termination(mod, enable);
 	if (ret)
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index e1d30d7..b2c79e7 100644
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
index a3dcd04..5c4e2db 100644
--- a/drivers/net/qlcnic/qlcnic_main.c
+++ b/drivers/net/qlcnic/qlcnic_main.c
@@ -3262,7 +3262,7 @@ qlcnic_store_bridged_mode(struct device *dev,
 	if (!test_bit(__QLCNIC_DEV_UP, &adapter->state))
 		goto err_out;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		goto err_out;
 
 	if (!adapter->nic_ops->config_bridged_mode(adapter, !!new))
@@ -3298,7 +3298,7 @@ qlcnic_store_diag_mode(struct device *dev,
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	unsigned long new;
 
-	if (strict_strtoul(buf, 2, &new))
+	if (kstrtoul(buf, 2, &new))
 		return -EINVAL;
 
 	if (!!new != !!(adapter->flags & QLCNIC_DIAG_ENABLED))
diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index 06bc603..8190289 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1934,31 +1934,34 @@ static int __init stmmac_cmdline_opt(char *str)
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
1.7.2.2

