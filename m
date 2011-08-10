Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1HJCYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:24:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35298 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HJCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:24:24 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, joe@perches.com, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
Date: Wed, 10 Aug 2011 10:29:59 +0800
Message-Id: <1312943399-14435-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/net/gianfar_ethtool.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 6e35069..a4777d2 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -686,10 +686,21 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
 {
 	unsigned int last_rule_idx = priv->cur_filer_idx;
 	unsigned int cmp_rqfpr;
-	unsigned int local_rqfpr[MAX_FILER_IDX + 1];
-	unsigned int local_rqfcr[MAX_FILER_IDX + 1];
+	unsigned int *local_rqfpr;
+	unsigned int *local_rqfcr;
 	int i = 0x0, k = 0x0;
 	int j = MAX_FILER_IDX, l = 0x0;
+	int ret = 1;
+
+	local_rqfpr = kmalloc(sizeof(unsigned int) * (MAX_FILER_IDX + 1),
+		GFP_KERNEL);
+	local_rqfcr = kmalloc(sizeof(unsigned int) * (MAX_FILER_IDX + 1),
+		GFP_KERNEL);
+	if (!local_rqfpr || !local_rqfcr) {
+		pr_err("Out of memory\n");
+		ret = 0;
+		got err;
+	}
 
 	switch (class) {
 	case TCP_V4_FLOW:
@@ -706,7 +717,8 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
 		break;
 	default:
 		pr_err("Right now this class is not supported\n");
-		return 0;
+		ret = 0;
+		goto err;
 	}
 
 	for (i = 0; i < MAX_FILER_IDX + 1; i++) {
@@ -721,7 +733,8 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
 
 	if (i == MAX_FILER_IDX + 1) {
 		pr_err("No parse rule found, can't create hash rules\n");
-		return 0;
+		ret = 0;
+		goto err;
 	}
 
 	/* If a match was found, then it begins the starting of a cluster rule
@@ -765,7 +778,10 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
 		priv->cur_filer_idx = priv->cur_filer_idx - 1;
 	}
 
-	return 1;
+err:
+	kfree(local_rqfcr);
+	kfree(local_rqfpr);
+	return ret;
 }
 
 static int gfar_set_hash_opts(struct gfar_private *priv, struct ethtool_rxnfc *cmd)
-- 
1.7.4.1

