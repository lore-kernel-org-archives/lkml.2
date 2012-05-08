Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2EHTox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:44:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab2EHTov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:44:51 -0400
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 09 May 2012 05:44:00 +1000
Subject: [PATCH 2/2] regulator: twl-regulator: make TWL4030_ALLOW_UNSUPPORTED
 more configurable.
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120508194359.31629.80664.stgit@notabene.brown>
In-Reply-To: <20120508193938.31629.64303.stgit@notabene.brown>
References: <20120508193938.31629.64303.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators in the twl4030 can provide some voltage settings
that are not offically supported.
These settings are disabled by default, but can be enabled with
  CONFIG_TWL4030_ALLOW_UNSUPPORTED=y
However
 - that config variable is not mentioned in any Kconfig so cannot
   be used, and
 - a global setting is clumsy - a per regulator setting would be
   better.

So define a new 'feature' flag that a board file can set to enable
these unsupported volatages for boards which need them.

This flag cannot (yet) be set using device-tree.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/regulator/twl-regulator.c |   10 ++++------
 include/linux/i2c/twl.h           |    5 +++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index fffacb4..c739071 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -395,14 +395,12 @@ static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
  * VAUX3 at 3V is incorrectly listed in some TI manuals as unsupported.
  * TI are revising the twl5030/tps659x0 specs to support that 3.0V setting.
  */
-#ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
-#define UNSUP_MASK	0x0000
-#else
 #define UNSUP_MASK	0x8000
-#endif
 
 #define UNSUP(x)	(UNSUP_MASK | (x))
-#define IS_UNSUP(x)	(UNSUP_MASK & (x))
+#define IS_UNSUP(info, x)			\
+	((UNSUP_MASK & (x)) &&			\
+	 !((info)->features & TWL4030_ALLOW_UNSUPPORTED))
 #define LDO_MV(x)	(~UNSUP_MASK & (x))
 
 
@@ -476,7 +474,7 @@ static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			mV = info->table[index];
 
-	return IS_UNSUP(mV) ? 0 : (LDO_MV(mV) * 1000);
+	return IS_UNSUP(info, mV) ? 0 : (LDO_MV(mV) * 1000);
 }
 
 static int
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index d1afedc..3993477 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -750,6 +750,11 @@ struct twl_regulator_driver_data {
 #define TWL5031			BIT(2)  /* twl5031 has different registers */
 #define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
 #define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
+#define TWL4030_ALLOW_UNSUPPORTED BIT(5) /* Some voltages are possible
+					  * but not officially supported.
+					  * This flag is necessary to
+					  * enable them.
+					  */
 
 /*----------------------------------------------------------------------*/
 


