Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1KPL0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:26:38 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58580 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756087Ab1KPL0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:26:35 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Cc: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <grant.likely@secretlab.ca>
Subject: [PATCH 1/5] mfd/stmpe: Pass partnum as param to stmpe_probe()
Date: Wed, 16 Nov 2011 16:56:06 +0530
Message-ID: <004126aa92b5c1e0d1b464409510fd5dd9771523.1321442150.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321442150.git.viresh.kumar@st.com>
References: <cover.1321442150.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

partnum is required during probe to get variant's info. Currently partnum was
getting set in i2c interface after it is used and is not at all getting set in
spi interface.

This can be passed as param to stmpe_probe, so that it is available early. With
this, there is no need of i2c interface's init() routine, as it does nothing
else than calling dev_set_drvdata(). So better remove this routine for i2c.

partnum defined in struct stmpe is of no use now, as it is only used once during
probe of stmpe, so we can remove it from struct stmpe too.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/stmpe-i2c.c   |   11 +----------
 drivers/mfd/stmpe-spi.c   |    5 +++--
 drivers/mfd/stmpe.c       |    8 +++++---
 drivers/mfd/stmpe.h       |    2 +-
 include/linux/mfd/stmpe.h |    2 --
 5 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 72fa08b..671fd5c 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -45,20 +45,11 @@ static int i2c_block_write(struct stmpe *stmpe, u8 reg, u8 length,
 	return i2c_smbus_write_i2c_block_data(i2c, reg, length, values);
 }
 
-static void i2c_init(struct stmpe *stmpe)
-{
-	struct i2c_device_id *id = stmpe->ci->data;
-
-	stmpe->partnum = id->driver_data;
-	dev_set_drvdata(stmpe->dev, stmpe);
-}
-
 static struct stmpe_client_info i2c_ci = {
 	.read_byte = i2c_reg_read,
 	.write_byte = i2c_reg_write,
 	.read_block = i2c_block_read,
 	.write_block = i2c_block_write,
-	.init = i2c_init,
 };
 
 static int __devinit
@@ -69,7 +60,7 @@ stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	i2c_ci.client = i2c;
 	i2c_ci.dev = &i2c->dev;
 
-	return stmpe_probe(&i2c_ci);
+	return stmpe_probe(&i2c_ci, id->driver_data);
 }
 
 static int __devexit stmpe_i2c_remove(struct i2c_client *i2c)
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 6f1c0ad3..21861d8 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -64,7 +64,6 @@ static void spi_init(struct stmpe *stmpe)
 {
 	struct spi_device *spi = stmpe->client;
 
-	dev_set_drvdata(stmpe->dev, stmpe);
 	spi->bits_per_word = 8;
 
 	/* This register is only present for stmpe811 */
@@ -86,6 +85,8 @@ static struct stmpe_client_info spi_ci = {
 static int __devinit
 stmpe_spi_probe(struct spi_device *spi)
 {
+	const struct spi_device_id *id = spi_get_device_id(spi);
+
 	/* don't exceed max specified rate - 1MHz - Limitation of STMPE */
 	if (spi->max_speed_hz > 1000000) {
 		dev_dbg(&spi->dev, "f(sample) %d KHz?\n",
@@ -97,7 +98,7 @@ stmpe_spi_probe(struct spi_device *spi)
 	spi_ci.client = spi;
 	spi_ci.dev = &spi->dev;
 
-	return stmpe_probe(&spi_ci);
+	return stmpe_probe(&spi_ci, id->driver_data);
 }
 
 static int __devexit stmpe_spi_remove(struct spi_device *spi)
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3ff2edb..a564f91 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -870,7 +870,7 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 }
 
 /* Called from client specific probe routines */
-int stmpe_probe(struct stmpe_client_info *ci)
+int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 {
 	struct stmpe_platform_data *pdata = dev_get_platdata(ci->dev);
 	struct stmpe *stmpe;
@@ -891,11 +891,13 @@ int stmpe_probe(struct stmpe_client_info *ci)
 	stmpe->pdata = pdata;
 	stmpe->irq_base = pdata->irq_base;
 	stmpe->ci = ci;
-	stmpe->variant = stmpe_variant_info[stmpe->partnum];
+	stmpe->variant = stmpe_variant_info[partnum];
 	stmpe->regs = stmpe->variant->regs;
 	stmpe->num_gpios = stmpe->variant->num_gpios;
+	dev_set_drvdata(stmpe->dev, stmpe);
 
-	ci->init(stmpe);
+	if (ci->init)
+		ci->init(stmpe);
 
 	if (pdata->irq_over_gpio) {
 		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 908f482..a73f4c1 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -97,7 +97,7 @@ struct stmpe_client_info {
 	void (*init)(struct stmpe *stmpe);
 };
 
-int stmpe_probe(struct stmpe_client_info *ci);
+int stmpe_probe(struct stmpe_client_info *ci, int partnum);
 int stmpe_remove(struct stmpe *stmpe);
 
 #define STMPE_ICR_LSB_HIGH	(1 << 2)
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index babc6b2..5afaf89 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -59,7 +59,6 @@ struct stmpe_client_info;
  * @dev: device, mostly for dev_dbg()
  * @client: client - i2c or spi
  * @ci: client specific information
- * @partnum: part number
  * @variant: the detected STMPE model number
  * @regs: list of addresses of registers which are at different addresses on
  *	  different variants.  Indexed by one of STMPE_IDX_*.
@@ -76,7 +75,6 @@ struct stmpe {
 	struct device *dev;
 	void *client;
 	struct stmpe_client_info *ci;
-	enum stmpe_partnum partnum;
 	struct stmpe_variant_info *variant;
 	const u8 *regs;
 
-- 
1.7.2.2

