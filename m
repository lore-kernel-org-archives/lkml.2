Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2KUS2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:28:34 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53514 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2KUS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:28:32 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-i2c@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-core: dt: Pick i2c bus number from i2c alias if present
Date: Wed, 21 Nov 2012 10:26:01 -0800
Message-Id: <1353522362-25519-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1353522362-25519-1-git-send-email-dianders@chromium.org>
References: <1353450428-2615-2-git-send-email-dianders@chromium.org>
 <1353522362-25519-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows you to get the equivalent functionality of
i2c_add_numbered_adapter() with all data in the device tree and no
special case code in your driver.  This is a common device tree
technique.

For quick reference, the FDT syntax for using an alias to provide an
ID looks like:
  aliases {
    i2c0 = &i2c_0;
    i2c1 = &i2c_1;
  };

Signed-off-by: Doug Anderson <dianders@chromium.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>

---
 drivers/i2c/i2c-core.c |  105 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 77 insertions(+), 28 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a7edf98..71deb2a2 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -915,13 +915,81 @@ out_list:
 }
 
 /**
+ * i2c_get_number_from_dt - get the adapter number based on dt alias
+ * @adap: the adapter to look at
+ *
+ * Check whether there's an alias in the FDT that gives an ID for this i2c
+ * device.  Use an alias like "i2c<nr>", like:
+ *   aliases {
+ *     i2c0 = &i2c_0;
+ *     i2c1 = &i2c_1;
+ *   };
+ *
+ * Returns the ID if found.  If no alias is found returns -1.
+ */
+static int i2c_get_number_from_dt(struct i2c_adapter *adap)
+{
+	struct device *dev = &adap->dev;
+	int id;
+
+	if (!dev->of_node)
+		return -1;
+
+	id = of_alias_get_id(dev->of_node, "i2c");
+	if (id < 0)
+		return -1;
+	return id;
+}
+
+/**
+ * _i2c_add_numbered_adapter - i2c_add_numbered_adapter where nr is never -1
+ * @adap: the adapter to register (with adap->nr initialized)
+ * Context: can sleep
+ *
+ * See i2c_add_numbered_adapter() for details.
+ */
+static int _i2c_add_numbered_adapter(struct i2c_adapter *adap)
+{
+	int	id;
+	int	status;
+
+	/* Handled by wrappers */
+	BUG_ON(adap->nr == -1);
+
+	if (adap->nr & ~MAX_IDR_MASK)
+		return -EINVAL;
+
+retry:
+	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
+		return -ENOMEM;
+
+	mutex_lock(&core_lock);
+	/* "above" here means "above or equal to", sigh;
+	 * we need the "equal to" result to force the result
+	 */
+	status = idr_get_new_above(&i2c_adapter_idr, adap, adap->nr, &id);
+	if (status == 0 && id != adap->nr) {
+		status = -EBUSY;
+		idr_remove(&i2c_adapter_idr, id);
+	}
+	mutex_unlock(&core_lock);
+	if (status == -EAGAIN)
+		goto retry;
+
+	if (status == 0)
+		status = i2c_register_adapter(adap);
+	return status;
+}
+
+/**
  * i2c_add_adapter - declare i2c adapter, use dynamic bus number
  * @adapter: the adapter to add
  * Context: can sleep
  *
  * This routine is used to declare an I2C adapter when its bus number
- * doesn't matter.  Examples: for I2C adapters dynamically added by
- * USB links or PCI plugin cards.
+ * doesn't matter or when its bus number is specified by an dt alias.
+ * Examples of bases when the bus number doesn't matter: I2C adapters
+ * dynamically added by USB links or PCI plugin cards.
  *
  * When this returns zero, a new bus number was allocated and stored
  * in adap->nr, and the specified adapter became available for clients.
@@ -931,6 +999,12 @@ int i2c_add_adapter(struct i2c_adapter *adapter)
 {
 	int	id, res = 0;
 
+	id = i2c_get_number_from_dt(adapter);
+	if (id >= 0) {
+		adapter->nr = id;
+		return _i2c_add_numbered_adapter(adapter);
+	}
+
 retry:
 	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
 		return -ENOMEM;
@@ -977,34 +1051,9 @@ EXPORT_SYMBOL(i2c_add_adapter);
  */
 int i2c_add_numbered_adapter(struct i2c_adapter *adap)
 {
-	int	id;
-	int	status;
-
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
-
-retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
-
-	mutex_lock(&core_lock);
-	/* "above" here means "above or equal to", sigh;
-	 * we need the "equal to" result to force the result
-	 */
-	status = idr_get_new_above(&i2c_adapter_idr, adap, adap->nr, &id);
-	if (status == 0 && id != adap->nr) {
-		status = -EBUSY;
-		idr_remove(&i2c_adapter_idr, id);
-	}
-	mutex_unlock(&core_lock);
-	if (status == -EAGAIN)
-		goto retry;
-
-	if (status == 0)
-		status = i2c_register_adapter(adap);
-	return status;
+	return _i2c_add_numbered_adapter(adap);
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
-- 
1.7.7.3

