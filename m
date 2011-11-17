Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1KQFdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:33:14 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:58618 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755480Ab1KQFct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:32:49 -0500
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
Subject: [PATCH V2 4/5] mfd/stmpe: ADD support for stmpe variant 801
Date: Thu, 17 Nov 2011 11:02:23 +0530
Message-ID: <96ac3346cb9d3f25927c8f16ccde6a0537a727f4.1321507421.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321507421.git.viresh.kumar@st.com>
References: <cover.1321507421.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STMPE801 is a GPIO expander. Registers for 801 are much different from other
variants. This patch adds support for STMPE801 in stmpe mfd driver.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/stmpe-i2c.c   |    1 +
 drivers/mfd/stmpe-spi.c   |    1 +
 drivers/mfd/stmpe.c       |   97 +++++++++++++++++++++++++++++++++++++++------
 drivers/mfd/stmpe.h       |   19 +++++++++
 include/linux/mfd/stmpe.h |    1 +
 5 files changed, 106 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index b11d33b..373f423 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -72,6 +72,7 @@ static int __devexit stmpe_i2c_remove(struct i2c_client *i2c)
 
 static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe610", STMPE610 },
+	{ "stmpe801", STMPE801 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
 	{ "stmpe2401", STMPE2401 },
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index 46963a5..b58c43c 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -110,6 +110,7 @@ static int __devexit stmpe_spi_remove(struct spi_device *spi)
 
 static const struct spi_device_id stmpe_spi_id[] = {
 	{ "stmpe610", STMPE610 },
+	{ "stmpe801", STMPE801 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
 	{ "stmpe2401", STMPE2401 },
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 67ff3dc..fc2c6af 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -241,12 +241,14 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, enum stmpe_block block)
 	u8 regaddr = stmpe->regs[STMPE_IDX_GPAFR_U_MSB];
 	int af_bits = variant->af_bits;
 	int numregs = DIV_ROUND_UP(stmpe->num_gpios * af_bits, 8);
-	int afperreg = 8 / af_bits;
 	int mask = (1 << af_bits) - 1;
 	u8 regs[numregs];
-	int af;
-	int ret;
+	int af, afperreg, ret;
+
+	if (!variant->get_altfunc)
+		return 0;
 
+	afperreg = 8 / af_bits;
 	mutex_lock(&stmpe->lock);
 
 	ret = __stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
@@ -321,6 +323,50 @@ static struct mfd_cell stmpe_keypad_cell = {
 };
 
 /*
+ * STMPE801
+ */
+static const u8 stmpe801_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE801_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE801_REG_SYS_CTRL,
+	[STMPE_IDX_GPMR_LSB]	= STMPE801_REG_GPIO_MP_STA,
+	[STMPE_IDX_GPSR_LSB]	= STMPE801_REG_GPIO_SET_PIN,
+	[STMPE_IDX_GPCR_LSB]	= STMPE801_REG_GPIO_SET_PIN,
+	[STMPE_IDX_GPDR_LSB]	= STMPE801_REG_GPIO_DIR,
+	[STMPE_IDX_IEGPIOR_LSB] = STMPE801_REG_GPIO_INT_EN,
+	[STMPE_IDX_ISGPIOR_MSB] = STMPE801_REG_GPIO_INT_STA,
+
+};
+
+static struct stmpe_variant_block stmpe801_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= 0,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+};
+
+static int stmpe801_enable(struct stmpe *stmpe, unsigned int blocks,
+			   bool enable)
+{
+	if (blocks & STMPE_BLOCK_GPIO)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static struct stmpe_variant_info stmpe801 = {
+	.name		= "stmpe801",
+	.id_val		= STMPE801_ID,
+	.id_mask	= 0xffff,
+	.num_gpios	= 8,
+	.regs		= stmpe801_regs,
+	.blocks		= stmpe801_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe801_blocks),
+	.num_irqs	= STMPE801_NR_INTERNAL_IRQS,
+	.enable		= stmpe801_enable,
+};
+
+/*
  * Touchscreen (STMPE811 or STMPE610)
  */
 
@@ -667,6 +713,7 @@ static struct stmpe_variant_info stmpe2403 = {
 
 static struct stmpe_variant_info *stmpe_variant_info[] = {
 	[STMPE610]	= &stmpe610,
+	[STMPE801]	= &stmpe801,
 	[STMPE811]	= &stmpe811,
 	[STMPE1601]	= &stmpe1601,
 	[STMPE2401]	= &stmpe2401,
@@ -683,6 +730,11 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	int ret;
 	int i;
 
+	if (variant->id_val == STMPE801_ID) {
+		handle_nested_irq(stmpe->irq_base);
+		return IRQ_HANDLED;
+	}
+
 	ret = stmpe_block_read(stmpe, israddr, num, isr);
 	if (ret < 0)
 		return IRQ_NONE;
@@ -769,14 +821,17 @@ static struct irq_chip stmpe_irq_chip = {
 
 static int __devinit stmpe_irq_init(struct stmpe *stmpe)
 {
+	struct irq_chip *chip = NULL;
 	int num_irqs = stmpe->variant->num_irqs;
 	int base = stmpe->irq_base;
 	int irq;
 
+	if (stmpe->variant->id_val != STMPE801_ID)
+		chip = &stmpe_irq_chip;
+
 	for (irq = base; irq < base + num_irqs; irq++) {
 		irq_set_chip_data(irq, stmpe);
-		irq_set_chip_and_handler(irq, &stmpe_irq_chip,
-					 handle_edge_irq);
+		irq_set_chip_and_handler(irq, chip, handle_edge_irq);
 		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
@@ -808,7 +863,7 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
 	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
 	struct stmpe_variant_info *variant = stmpe->variant;
-	u8 icr = STMPE_ICR_LSB_GIM;
+	u8 icr;
 	unsigned int id;
 	u8 data[2];
 	int ret;
@@ -831,16 +886,32 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	if (ret)
 		return ret;
 
-	if (irq_trigger == IRQF_TRIGGER_FALLING ||
-	    irq_trigger == IRQF_TRIGGER_RISING)
-		icr |= STMPE_ICR_LSB_EDGE;
+	if (id == STMPE801_ID)
+		icr = STMPE801_REG_SYS_CTRL_INT_EN;
+	else
+		icr = STMPE_ICR_LSB_GIM;
+
+	/* STMPE801 doesn't support Edge interrupts */
+	if (id != STMPE801_ID) {
+		if (irq_trigger == IRQF_TRIGGER_FALLING ||
+				irq_trigger == IRQF_TRIGGER_RISING)
+			icr |= STMPE_ICR_LSB_EDGE;
+	}
 
 	if (irq_trigger == IRQF_TRIGGER_RISING ||
-	    irq_trigger == IRQF_TRIGGER_HIGH)
-		icr |= STMPE_ICR_LSB_HIGH;
+			irq_trigger == IRQF_TRIGGER_HIGH) {
+		if (id == STMPE801_ID)
+			icr |= STMPE801_REG_SYS_CTRL_INT_HI;
+		else
+			icr |= STMPE_ICR_LSB_HIGH;
+	}
 
-	if (stmpe->pdata->irq_invert_polarity)
-		icr ^= STMPE_ICR_LSB_HIGH;
+	if (stmpe->pdata->irq_invert_polarity) {
+		if (id == STMPE801_ID)
+			icr ^= STMPE801_REG_SYS_CTRL_INT_HI;
+		else
+			icr ^= STMPE_ICR_LSB_HIGH;
+	}
 
 	if (stmpe->pdata->autosleep) {
 		ret = stmpe_autosleep(stmpe, autosleep_timeout);
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index a73f4c1..7b8e13f 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -105,6 +105,25 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STMPE_ICR_LSB_GIM	(1 << 0)
 
 /*
+ * STMPE801
+ */
+#define STMPE801_ID			0x0108
+#define STMPE801_NR_INTERNAL_IRQS	1
+
+#define STMPE801_REG_CHIP_ID		0x00
+#define STMPE801_REG_VERSION_ID		0x02
+#define STMPE801_REG_SYS_CTRL		0x04
+#define STMPE801_REG_GPIO_INT_EN	0x08
+#define STMPE801_REG_GPIO_INT_STA	0x09
+#define STMPE801_REG_GPIO_MP_STA	0x10
+#define STMPE801_REG_GPIO_SET_PIN	0x11
+#define STMPE801_REG_GPIO_DIR		0x12
+
+#define STMPE801_REG_SYS_CTRL_RESET	(1 << 7)
+#define STMPE801_REG_SYS_CTRL_INT_EN	(1 << 2)
+#define STMPE801_REG_SYS_CTRL_INT_HI	(1 << 0)
+
+/*
  * STMPE811
  */
 
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 342005a..ca1d7a3 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -21,6 +21,7 @@ enum stmpe_block {
 
 enum stmpe_partnum {
 	STMPE610,
+	STMPE801,
 	STMPE811,
 	STMPE1601,
 	STMPE2401,
-- 
1.7.2.2

