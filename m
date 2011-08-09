Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1HIQmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:42:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39882 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1HIQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:41:58 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
Date: Wed, 10 Aug 2011 00:39:05 +0800
Message-Id: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/net/gianfar_ethtool.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 6e35069..134fe1b 100644
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
@@ -765,7 +776,10 @@ static int gfar_ethflow_to_filer_table(struct gfar_private *priv, u64 ethflow, u
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
1.7.0.4

