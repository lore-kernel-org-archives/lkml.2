Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2EUMzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:55:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2EUMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:55:49 -0400
Message-ID: <1337604940.11739.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Fix wrong kfree calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 21 May 2012 20:55:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_kzalloc function eliminates the need for manual resource releasing
and simplify error handling. Resources allocated by devm_* are freed
automatically on driver detach.

Thus adding kfree calls here will introduce double free bug.

The memory of desc array and the pointers to the rdev[] are allocated by
devm_kzalloc call for struct palmas_pmic.

struct palmas_pmic {
        struct palmas *palmas;
        struct device *dev;
        struct regulator_desc desc[PALMAS_NUM_REGS];
        struct regulator_dev *rdev[PALMAS_NUM_REGS];
        struct mutex mutex;

        int smps123;
        int smps457;

        int range[PALMAS_REG_SMPS10];
};

Which means we should not call kfree for pmic->rdev and pmic->desc.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index c4435f6..9b7ca90 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -775,9 +775,6 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 err_unregister_regulator:
 	while (--id >= 0)
 		regulator_unregister(pmic->rdev[id]);
-	kfree(pmic->rdev);
-	kfree(pmic->desc);
-	kfree(pmic);
 	return ret;
 }
 
@@ -788,10 +785,6 @@ static int __devexit palmas_remove(struct platform_device *pdev)
 
 	for (id = 0; id < PALMAS_NUM_REGS; id++)
 		regulator_unregister(pmic->rdev[id]);
-
-	kfree(pmic->rdev);
-	kfree(pmic->desc);
-	kfree(pmic);
 	return 0;
 }
 
-- 
1.7.5.4



