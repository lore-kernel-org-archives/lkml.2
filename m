Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0IDPKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:10:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53120 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0IDPKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VlgehFbxWX8Q2pjV9ZPtdarWPrpV6OKpXcL6Dx4UjzXhorvzyQGasB6TNSmBBsf1dy
         ffRuMghJGp00GJTKg38lBsuxJJbGUd2n2nXnze/9oRTYnHRX5twLPNCx1HDS7S52eV9B
         NtQxk3ZFbAElb8D5GkH44BPlEmqqzazqoYKuM=
Subject: [PATCH] regulator: 88pm8607 - fix value range checking for
 accessing info->vol_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 23:10:48 +0800
Message-ID: <1283613048.2430.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In choose_voltage(), we use i as array index of info->vol_table.
The valid value range for i should be 0 .. ARRAY_SIZE(info->vol_table) - 1.

Take LDO1 as example, ARRAY_SIZE(LDO1_table) is 4, vol_nbits of LDO1 is 2.
for (i = 0; i < (2 << info->vol_nbits); i++)  is equivalent to
for (i = 0; i < 8; i++)
which is wrong.

The same value range checking also applies for index in pm8607_list_voltage().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 7d149a8..2ce2eb7 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -215,7 +215,7 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	int ret = -EINVAL;
 
-	if (info->vol_table && (index < (2 << info->vol_nbits))) {
+	if (info->vol_table && (index < (1 << info->vol_nbits))) {
 		ret = info->vol_table[index];
 		if (info->slope_double)
 			ret <<= 1;
@@ -233,7 +233,7 @@ static int choose_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 		max_uV = max_uV >> 1;
 	}
 	if (info->vol_table) {
-		for (i = 0; i < (2 << info->vol_nbits); i++) {
+		for (i = 0; i < (1 << info->vol_nbits); i++) {
 			if (!info->vol_table[i])
 				break;
 			if ((min_uV <= info->vol_table[i])
-- 
1.7.0.4



