Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1HSWLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:11:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44354 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755496Ab1HSWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:11:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Allow drivers to specify register defaults
Date: Fri, 19 Aug 2011 17:54:17 +0900
Message-Id: <1313744057-14708-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful for the register cache code to be able to specify the
default values for the device registers. The major use is when restoring
the register cache after suspend, knowing the register defaults allows
us to skip registers that are at their default values when we resume which
can be a substantial win on larger modern devices. For some devices
(mostly older ones) the hardware does not support readback so the only way we
can know the values is from code and so initializing the cache with default
values makes it much easier for drivers work with read/modify/write
updates.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is what I was thinking of for specifying the register defaults.
Does this seem reasonable?  If so I'll push it out now, once the
interface is available drivers can start filling in the data even if we
don't use it yet.

Similarly when you're adding the cache support if you could add a
separate patch which makes the driver features available I can put that
on a separate branch which can get merged into other trees if they want
or need it.

 include/linux/regmap.h |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 20a8fbf..e1fe152 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -21,12 +21,24 @@ struct i2c_client;
 struct spi_device;
 
 /**
+ * Default value for a register.  We use an array of structs rather
+ * than a simple array as many modern devices have very sparse
+ * register maps.
+ *
+ * @reg: Register address.
+ * @val: Register value.
+ */
+struct reg_default {
+	unsigned int reg;
+	unsigned int val;
+};
+
+/**
  * Configuration for the register map of a device.
  *
  * @reg_bits: Number of bits in a register address, mandatory.
  * @val_bits: Number of bits in a register value, mandatory.
  *
- * @max_register: Optional, specifies the maximum valid register index.
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
  * @readable_reg: Optional callback returning true if the register
@@ -36,16 +48,24 @@ struct spi_device;
  * @precious_reg: Optional callback returning true if the rgister
  *                should not be read outside of a call from the driver
  *                (eg, a clear on read interrupt status register).
+ *
+ * @max_register: Optional, specifies the maximum valid register index.
+ * @reg_defaults: Power on reset values for registers (for use with
+ *                register cache support).
+ * @num_reg_defaults: Number of elements in reg_defaults.
  */
 struct regmap_config {
 	int reg_bits;
 	int val_bits;
 
-	unsigned int max_register;
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
+
+	unsigned int max_register;
+	struct reg_default *reg_defaults;
+	int num_reg_defaults;
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.5.4

