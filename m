Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1HXLYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:24:39 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:41545 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXLYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:24:37 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Jason Liu <jason.hui@linaro.org>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <David.Woodhouse@intel.com>, <dedekind1@gmail.com>,
        <patches@linaro.org>
Subject: [[PATCH v2] mtd: check parts pointer before using it
Date: Wed, 24 Aug 2011 19:26:28 +0800
Message-ID: <1314185188-6151-1-git-send-email-jason.hui@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code has the check for parts but it called after kmemdup,
kmemdup(parts, sizeof(*parts) * nr_parts,...)
if (!parts)
	return -ENOMEM

In fact, we need check parts before safely using it.
and we also need check the real_parts to make sure kmemdup
allocation sucessfully.

Signed-off-by: Jason Liu <jason.hui@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
---
V2: Fix one error condition check and add real_parts check too.
---
This patch is based on git://git.infradead.org/users/dedekind/l2-mtd-2.6.git
---
 drivers/mtd/mtdcore.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 09bdbac..b01993e 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -465,12 +465,13 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char **types,
 	struct mtd_partition *real_parts;
 
 	err = parse_mtd_partitions(mtd, types, &real_parts, parser_data);
-	if (err <= 0 && nr_parts) {
+	if (err <= 0 && nr_parts && parts) {
 		real_parts = kmemdup(parts, sizeof(*parts) * nr_parts,
 				     GFP_KERNEL);
-		err = nr_parts;
-		if (!parts)
+		if (!real_parts)
 			err = -ENOMEM;
+		else
+			err = nr_parts;
 	}
 
 	if (err > 0) {
-- 
1.7.4.1


