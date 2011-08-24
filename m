Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1HXKr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:47:59 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:36332
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab1HXKr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:47:56 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Jason Liu <jason.hui@linaro.org>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <David.Woodhouse@intel.com>, <dedekind1@gmail.com>,
        <patches@linaro.org>
Subject: [PATCH] mtd: check parts pointer before using it
Date: Wed, 24 Aug 2011 18:53:01 +0800
Message-ID: <1314183181-4197-1-git-send-email-jason.hui@linaro.org>
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

Signed-off-by: Jason Liu <jason.hui@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>

---
This patch is based on git://git.infradead.org/users/dedekind/l2-mtd-2.6.git
---
 drivers/mtd/mtdcore.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 09bdbac..ce59ff5 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -465,12 +465,10 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char **types,
 	struct mtd_partition *real_parts;
 
 	err = parse_mtd_partitions(mtd, types, &real_parts, parser_data);
-	if (err <= 0 && nr_parts) {
+	if (err <= 0 && nr_parts && !parts) {
 		real_parts = kmemdup(parts, sizeof(*parts) * nr_parts,
 				     GFP_KERNEL);
 		err = nr_parts;
-		if (!parts)
-			err = -ENOMEM;
 	}
 
 	if (err > 0) {
-- 
1.7.4.1


