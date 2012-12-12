Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab2LLGKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:10:34 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53777 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2LLGKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:10:32 -0500
X-Greylist: delayed 9815 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 01:10:32 EST
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org
Subject: [PATCH] regulator: s5m8767: Fix probe failure due to stack corruption
Date: Wed, 12 Dec 2012 08:57:00 +0530
Message-Id: <1355282820-18364-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function sec_reg_read invokes regmap_read which expects unsigned int *
as the destination address. The existing driver is passing address of local
variable "val" which is u8. This causes the stack corruption and following
dump is observed during probe.

Hence change "val" from u8 to unsigned int.

Unable to handle kernel paging request at virtual address 02410020
pgd = c0004000
[02410020] *pgd=00000000
Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0    Not tainted  (3.6.0-00696-g98a28b18-dirty #27)
PC is at 0x2410020
LR is at _regulator_get_voltage+0x3c/0x70
pc : [<02410020>]    lr : [<c02395d4>]    psr: 20000013
sp : cf839b68  ip : 00000000  fp : cf92d410
r10: 0000cfd0  r9 : c06d9878  r8 : 0000f0a0
r7 : cf839b70  r6 : cf92d400  r5 : 00000011  r4 : cf000000
r3 : 02410020  r2 : 00000000  r1 : 00000048  r0 : cf000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
...........................
.................................

[<c02395d4>] (_regulator_get_voltage+0x3c/0x70) from [<c023ad80>] (print_constraints+0x50/0x36c)
[<c023ad80>] (print_constraints+0x50/0x36c) from [<c023e504>] (set_machine_constraints+0xe8/0x2b0)
[<c023e504>] (set_machine_constraints+0xe8/0x2b0) from [<c023e9c8>] (regulator_register+0x2fc/0x604)
[<c023e9c8>] (regulator_register+0x2fc/0x604) from [<c049d628>] (s5m8767_pmic_probe+0x688/0x718)
[<c049d628>] (s5m8767_pmic_probe+0x688/0x718) from [<c029915c>] (platform_drv_probe+0x18/0x1c)
[<c029915c>] (platform_drv_probe+0x18/0x1c) from [<c0297dd0>] (really_probe+0x68/0x1f4)
[<c0297dd0>] (really_probe+0x68/0x1f4) from [<c0298070>] (driver_probe_device+0x30/0x48)

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/regulator/s5m8767.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 8ef5b33..9e6850f 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -214,7 +214,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
 	int mask = 0xc0, enable_ctrl;
-	u8 val;
+	unsigned int val;
 
 	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret == -EINVAL)
@@ -306,7 +306,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int reg, mask, ret;
 	int reg_id = rdev_get_id(rdev);
-	u8 val;
+	unsigned int val;
 
 	ret = s5m8767_get_voltage_register(rdev, &reg);
 	if (ret)
-- 
1.7.9.5

