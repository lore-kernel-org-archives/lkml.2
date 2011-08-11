Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1HKGzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:55:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36598 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1HKGzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:55:06 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, sebastian.poehn@belden.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: =?UTF-8?q?=5BPATCH=20RESEND=5D=20gianfar=3A=20reduce=20stack=20usage=20in=20gianfar=5Fethtool=2Ec?=
Date: Thu, 11 Aug 2011 15:00:37 +0800
Message-Id: <1313046037-21655-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Reviewed-and-tested-by: Sebastian Pöhn <sebastian.poehn@belden.com>
---
 drivers/net/gianfar_ethtool.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 6e35069..25a8c2a 100644
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
+		goto err;
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

