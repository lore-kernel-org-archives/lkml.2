Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2EAUqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:46:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2EAUqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:46:10 -0400
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 02 May 2012 06:44:50 +1000
Subject: [PATCH 2/2] twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120501204450.27026.40239.stgit@notabene.brown>
In-Reply-To: <20120501204259.27026.40156.stgit@notabene.brown>
References: <20120501204259.27026.40156.stgit@notabene.brown>
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

 drivers/regulator/twl-regulator.c |   12 +++++-------
 include/linux/i2c/twl.h           |    5 +++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 9cdfc38..03a316d 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -388,14 +388,12 @@ static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
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
 
 
@@ -469,7 +467,7 @@ static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			mV = info->table[index];
 
-	return IS_UNSUP(mV) ? 0 : (LDO_MV(mV) * 1000);
+	return IS_UNSUP(info, mV) ? 0 : (LDO_MV(mV) * 1000);
 }
 
 static int
@@ -483,7 +481,7 @@ twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		int mV = info->table[vsel];
 		int uV;
 
-		if (IS_UNSUP(mV))
+		if (IS_UNSUP(info, mV))
 			continue;
 		uV = LDO_MV(mV) * 1000;
 
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 88e8cd8..8eec440 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -752,6 +752,11 @@ struct twl_regulator_driver_data {
 #define TWL5031			BIT(2)  /* twl5031 has different registers */
 #define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
 #define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
+#define TWL4030_ALLOW_UNSUPPORTED BIT(5) /* Some voltages are possible
+					  * but not officially supported.
+					  * This flag is necessary to
+					  * enable them.
+					  */
 
 /*----------------------------------------------------------------------*/
 


