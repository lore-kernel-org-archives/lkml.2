Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab2LTI6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:58:04 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:33608 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab2LTI57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:57:59 -0500
From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Subject: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
Date: Thu, 20 Dec 2012 09:57:19 +0100
Message-ID: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides support for 1801 variant of stmpe gpio port expanders.
This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
special key or dedicated key function.

Note that special/dedicated key function is not supported yet.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
---
 drivers/gpio/gpio-stmpe.c             |   52 +++++--
 drivers/input/keyboard/stmpe-keypad.c |  251 +++++++++++++++++++++++++++------
 drivers/mfd/Kconfig                   |    1 +
 drivers/mfd/stmpe-i2c.c               |    1 +
 drivers/mfd/stmpe.c                   |   97 ++++++++++++-
 drivers/mfd/stmpe.h                   |   49 +++++++
 include/linux/mfd/stmpe.h             |    3 +
 7 files changed, 392 insertions(+), 62 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index dce3472..662c415 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -42,14 +42,25 @@ static inline struct stmpe_gpio *to_stmpe_gpio(struct gpio_chip *chip)
 	return container_of(chip, struct stmpe_gpio, chip);
 }
 
+static inline u8 stmpe_gpio_reg(struct stmpe *stmpe, u8 index, int offset)
+{
+	u8 reg;
+	if (stmpe->partnum == STMPE1801)
+		reg = stmpe->regs[index] + offset;
+	else
+		reg = stmpe->regs[index] - offset;
+	return reg;
+}
+
 static int stmpe_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPMR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
 	int ret;
+	u8 reg, mask;
 
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPMR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 	ret = stmpe_reg_read(stmpe, reg);
 	if (ret < 0)
 		return ret;
@@ -62,8 +73,10 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int which = val ? STMPE_IDX_GPSR_LSB : STMPE_IDX_GPCR_LSB;
-	u8 reg = stmpe->regs[which] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, which, offset / 8);
+	mask = 1 << (offset % 8);
 
 	/*
 	 * Some variants have single register for gpio set/clear functionality.
@@ -80,8 +93,10 @@ static int stmpe_gpio_direction_output(struct gpio_chip *chip,
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPDR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 
 	stmpe_gpio_set(chip, offset, val);
 
@@ -93,8 +108,10 @@ static int stmpe_gpio_direction_input(struct gpio_chip *chip,
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
-	u8 mask = 1 << (offset % 8);
+	u8 reg, mask;
+
+	reg = stmpe_gpio_reg(stmpe, STMPE_IDX_GPDR_LSB, offset / 8);
+	mask = 1 << (offset % 8);
 
 	return stmpe_set_bits(stmpe, reg, mask, 0);
 }
@@ -174,6 +191,7 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 		[REG_IE]	= STMPE_IDX_IEGPIOR_LSB,
 	};
 	int i, j;
+	u8 reg;
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
 		/* STMPE801 doesn't have RE and FE registers */
@@ -189,7 +207,8 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 				continue;
 
 			stmpe_gpio->oldregs[i][j] = new;
-			stmpe_reg_write(stmpe, stmpe->regs[regmap[i]] - j, new);
+			reg = stmpe_gpio_reg(stmpe, regmap[i], j);
+			stmpe_reg_write(stmpe, reg, new);
 		}
 	}
 
@@ -229,18 +248,20 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 {
 	struct stmpe_gpio *stmpe_gpio = dev;
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
-	u8 statmsbreg = stmpe->regs[STMPE_IDX_ISGPIOR_MSB];
 	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
 	u8 status[num_banks];
 	int ret;
 	int i;
+	bool lsb = stmpe->partnum == STMPE1801;
+	u8 statmsbreg = lsb ? stmpe->regs[STMPE_IDX_ISGPIOR_LSB] :
+			stmpe->regs[STMPE_IDX_ISGPIOR_MSB];
 
 	ret = stmpe_block_read(stmpe, statmsbreg, num_banks, status);
 	if (ret < 0)
 		return IRQ_NONE;
 
 	for (i = 0; i < num_banks; i++) {
-		int bank = num_banks - i - 1;
+		int bank = lsb ? i : num_banks - i - 1;
 		unsigned int enabled = stmpe_gpio->regs[REG_IE][bank];
 		unsigned int stat = status[i];
 
@@ -258,10 +279,11 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 
 		stmpe_reg_write(stmpe, statmsbreg + i, status[i]);
 
-		/* Edge detect register is not present on 801 */
-		if (stmpe->partnum != STMPE801)
-			stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB]
-					+ i, status[i]);
+		/* Edge detect register is not present on 801 and 1801 */
+		if (stmpe->partnum != STMPE801 && stmpe->partnum != STMPE1801)
+			stmpe_reg_write(stmpe,
+				stmpe->regs[STMPE_IDX_GPEDR_MSB] + i,
+				status[i]);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index 8923352..2b081b7 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -14,41 +14,114 @@
 #include <linux/input/matrix_keypad.h>
 #include <linux/mfd/stmpe.h>
 
-/* These are at the same addresses in all STMPE variants */
-#define STMPE_KPC_COL			0x60
-#define STMPE_KPC_ROW_MSB		0x61
-#define STMPE_KPC_ROW_LSB		0x62
-#define STMPE_KPC_CTRL_MSB		0x63
-#define STMPE_KPC_CTRL_LSB		0x64
-#define STMPE_KPC_COMBI_KEY_0		0x65
-#define STMPE_KPC_COMBI_KEY_1		0x66
-#define STMPE_KPC_COMBI_KEY_2		0x67
-#define STMPE_KPC_DATA_BYTE0		0x68
-#define STMPE_KPC_DATA_BYTE1		0x69
-#define STMPE_KPC_DATA_BYTE2		0x6a
-#define STMPE_KPC_DATA_BYTE3		0x6b
-#define STMPE_KPC_DATA_BYTE4		0x6c
+/* These are at the same addresses in most of STMPE variants */
+#define STMPE_REG_KPC_COL		0x60
+#define STMPE_REG_KPC_ROW_MSB		0x61
+#define STMPE_REG_KPC_ROW_LSB		0x62
+#define STMPE_REG_KPC_CTRL_MSB		0x63
+#define STMPE_REG_KPC_CTRL_LSB		0x64
+#define STMPE_REG_KPC_COMBI_KEY_0	0x65
+#define STMPE_REG_KPC_COMBI_KEY_1	0x66
+#define STMPE_REG_KPC_COMBI_KEY_2	0x67
+#define STMPE_REG_KPC_DATA_BYTE0	0x68
+#define STMPE_REG_KPC_DATA_BYTE1	0x69
+#define STMPE_REG_KPC_DATA_BYTE2	0x6a
+#define STMPE_REG_KPC_DATA_BYTE3	0x6b
+#define STMPE_REG_KPC_DATA_BYTE4	0x6c
 
 #define STMPE_KPC_CTRL_LSB_SCAN		(0x1 << 0)
 #define STMPE_KPC_CTRL_LSB_DEBOUNCE	(0x7f << 1)
 #define STMPE_KPC_CTRL_MSB_SCAN_COUNT	(0xf << 4)
 
+/* STMPE1801 */
+#define STMPE1801_REG_KPC_ROW		0x30
+#define STMPE1801_REG_KPC_COL_LOW	0x31
+#define STMPE1801_REG_KPC_COL_HIGH	0x32
+#define STMPE1801_REG_KPC_CTRL_LOW	0x33
+#define STMPE1801_REG_KPC_CTRL_MID	0x34
+#define STMPE1801_REG_KPC_CTRL_HIGH	0x35
+#define STMPE1801_REG_KPC_CMD		0x36
+#define STMPE1801_REG_KPC_COMBI_KEY_0	0x37
+#define STMPE1801_REG_KPC_COMBI_KEY_1	0x38
+#define STMPE1801_REG_KPC_COMBI_KEY_2	0x39
+#define STMPE1801_REG_KPC_DATA_BYTE0	0x3a
+#define STMPE1801_REG_KPC_DATA_BYTE1	0x3b
+#define STMPE1801_REG_KPC_DATA_BYTE2	0x3c
+#define STMPE1801_REG_KPC_DATA_BYTE3	0x3d
+#define STMPE1801_REG_KPC_DATA_BYTE4	0x3e
+
+#define STMPE1801_MSK_KPC_SCAN_COUNT	(0xf << 4)
+#define STMPE1801_MSK_KPC_DEBOUNCE	(0x3f << 2)
+#define STMPE1801_MSK_KPC_CMD_SCAN	(0x1 << 0)
+
 #define STMPE_KPC_ROW_MSB_ROWS		0xff
 
 #define STMPE_KPC_DATA_UP		(0x1 << 7)
-#define STMPE_KPC_DATA_ROW		(0xf << 3)
-#define STMPE_KPC_DATA_COL		(0x7 << 0)
+
 #define STMPE_KPC_DATA_NOKEY_MASK	0x78
 
 #define STMPE_KEYPAD_MAX_DEBOUNCE	127
 #define STMPE_KEYPAD_MAX_SCAN_COUNT	15
 
 #define STMPE_KEYPAD_MAX_ROWS		8
-#define STMPE_KEYPAD_MAX_COLS		8
-#define STMPE_KEYPAD_ROW_SHIFT		3
+#define STMPE_KEYPAD_MAX_COLS		10
+
 #define STMPE_KEYPAD_KEYMAP_SIZE	\
 	(STMPE_KEYPAD_MAX_ROWS * STMPE_KEYPAD_MAX_COLS)
 
+enum {
+	STMPE_IDX_KPC_COL_LSB,
+	STMPE_IDX_KPC_COL_MSB,
+	STMPE_IDX_KPC_ROW_LSB,
+	STMPE_IDX_KPC_ROW_MSB,
+	STMPE_IDX_KPC_CTRL_LSB,
+	STMPE_IDX_KPC_CTRL_MID,
+	STMPE_IDX_KPC_CTRL_MSB,
+	STMPE_IDX_KPC_CMD,
+	STMPE_IDX_KPC_COMBI_KEY_0,
+	STMPE_IDX_KPC_COMBI_KEY_1,
+	STMPE_IDX_KPC_COMBI_KEY_2,
+	STMPE_IDX_KPC_DATA_BYTE0,
+	STMPE_IDX_KPC_DATA_BYTE1,
+	STMPE_IDX_KPC_DATA_BYTE2,
+	STMPE_IDX_KPC_DATA_BYTE3,
+	STMPE_IDX_KPC_DATA_BYTE4,
+};
+
+static const u8 stmpe_default_regs[] = {
+	[STMPE_IDX_KPC_COL_LSB]		= STMPE_REG_KPC_COL,
+	[STMPE_IDX_KPC_ROW_LSB]		= STMPE_REG_KPC_ROW_LSB,
+	[STMPE_IDX_KPC_ROW_MSB]		= STMPE_REG_KPC_ROW_MSB,
+	[STMPE_IDX_KPC_CTRL_LSB]	= STMPE_REG_KPC_CTRL_LSB,
+	[STMPE_IDX_KPC_CTRL_MSB]	= STMPE_REG_KPC_CTRL_MSB,
+	[STMPE_IDX_KPC_COMBI_KEY_0]	= STMPE_REG_KPC_COMBI_KEY_0,
+	[STMPE_IDX_KPC_COMBI_KEY_1]	= STMPE_REG_KPC_COMBI_KEY_1,
+	[STMPE_IDX_KPC_COMBI_KEY_2]	= STMPE_REG_KPC_COMBI_KEY_2,
+	[STMPE_IDX_KPC_DATA_BYTE0]	= STMPE_REG_KPC_DATA_BYTE0,
+	[STMPE_IDX_KPC_DATA_BYTE1]	= STMPE_REG_KPC_DATA_BYTE1,
+	[STMPE_IDX_KPC_DATA_BYTE2]	= STMPE_REG_KPC_DATA_BYTE2,
+	[STMPE_IDX_KPC_DATA_BYTE3]	= STMPE_REG_KPC_DATA_BYTE3,
+	[STMPE_IDX_KPC_DATA_BYTE4]	= STMPE_REG_KPC_DATA_BYTE4,
+};
+
+static const u8 stmpe_1801_regs[] = {
+	[STMPE_IDX_KPC_COL_LSB]		= STMPE1801_REG_KPC_COL_LOW,
+	[STMPE_IDX_KPC_COL_MSB]		= STMPE1801_REG_KPC_COL_HIGH,
+	[STMPE_IDX_KPC_ROW_LSB]		= STMPE1801_REG_KPC_ROW,
+	[STMPE_IDX_KPC_CTRL_LSB]	= STMPE1801_REG_KPC_CTRL_LOW,
+	[STMPE_IDX_KPC_CTRL_MID]	= STMPE1801_REG_KPC_CTRL_MID,
+	[STMPE_IDX_KPC_CTRL_MSB]	= STMPE1801_REG_KPC_CTRL_HIGH,
+	[STMPE_IDX_KPC_CMD]		= STMPE1801_REG_KPC_CMD,
+	[STMPE_IDX_KPC_COMBI_KEY_0]	= STMPE1801_REG_KPC_COMBI_KEY_0,
+	[STMPE_IDX_KPC_COMBI_KEY_1]	= STMPE1801_REG_KPC_COMBI_KEY_1,
+	[STMPE_IDX_KPC_COMBI_KEY_2]	= STMPE1801_REG_KPC_COMBI_KEY_2,
+	[STMPE_IDX_KPC_DATA_BYTE0]	= STMPE1801_REG_KPC_DATA_BYTE0,
+	[STMPE_IDX_KPC_DATA_BYTE1]	= STMPE1801_REG_KPC_DATA_BYTE1,
+	[STMPE_IDX_KPC_DATA_BYTE2]	= STMPE1801_REG_KPC_DATA_BYTE2,
+	[STMPE_IDX_KPC_DATA_BYTE3]	= STMPE1801_REG_KPC_DATA_BYTE3,
+	[STMPE_IDX_KPC_DATA_BYTE4]	= STMPE1801_REG_KPC_DATA_BYTE4,
+};
+
 /**
  * struct stmpe_keypad_variant - model-specific attributes
  * @auto_increment: whether the KPC_DATA_BYTE register address
@@ -57,6 +130,10 @@
  * @num_normal_data: number of normal keys' data bytes
  * @max_cols: maximum number of columns supported
  * @max_rows: maximum number of rows supported
+ * @row_mask: mask used to get row number in KPC_DATA_BYTEx registers
+ * @col_mask: mask used to get column number in KPC_DATA_BYTEx registers
+ * @row_shift: shift used to get row number in KPC_DATA_BYTEx registers
+ * @col_shift: shift used to get column number in KPC_DATA_BYTEx registers
  * @col_gpios: bitmask of gpios which can be used for columns
  * @row_gpios: bitmask of gpios which can be used for rows
  */
@@ -66,8 +143,13 @@ struct stmpe_keypad_variant {
 	int		num_normal_data;
 	int		max_cols;
 	int		max_rows;
+	unsigned int	row_mask;
+	unsigned int	col_mask;
+	unsigned char	row_shift;
+	unsigned char	col_shift;
 	unsigned int	col_gpios;
 	unsigned int	row_gpios;
+	const u8	*regs;
 };
 
 static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
@@ -77,8 +159,27 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 3,
 		.max_cols		= 8,
 		.max_rows		= 8,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x000ff,	/* GPIO 0 - 7 */
 		.row_gpios		= 0x0ff00,	/* GPIO 8 - 15 */
+		.regs			= stmpe_default_regs,
+	},
+	[STMPE1801] = {
+		.auto_increment		= true,
+		.num_data		= 5,
+		.num_normal_data	= 3,
+		.max_cols		= 10,
+		.max_rows		= 8,
+		.row_mask		= (0x7 << 0),
+		.row_shift		= 0,
+		.col_mask		= (0xf << 3),
+		.col_shift		= 3,
+		.col_gpios		= 0x3ff00,	/* GPIO 8 - 17 */
+		.row_gpios		= 0x000ff,	/* GPIO 0 - 7 */
+		.regs			= stmpe_1801_regs,
 	},
 	[STMPE2401] = {
 		.auto_increment		= false,
@@ -86,8 +187,13 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 2,
 		.max_cols		= 8,
 		.max_rows		= 12,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
 		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
+		.regs			= stmpe_default_regs,
 	},
 	[STMPE2403] = {
 		.auto_increment		= true,
@@ -95,8 +201,13 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
 		.num_normal_data	= 3,
 		.max_cols		= 8,
 		.max_rows		= 12,
+		.row_mask		= (0xf << 3),
+		.row_shift		= 3,
+		.col_mask		= (0x7 << 0),
+		.col_shift		= 0,
 		.col_gpios		= 0x0000ff,	/* GPIO 0 - 7*/
 		.row_gpios		= 0x1fef00,	/* GPIO 8-14, 16-20 */
+		.regs			= stmpe_default_regs,
 	},
 };
 
@@ -108,6 +219,7 @@ struct stmpe_keypad {
 
 	unsigned int rows;
 	unsigned int cols;
+	unsigned char scan_code_row_shift;
 	bool enable;
 
 	unsigned short keymap[STMPE_KEYPAD_KEYMAP_SIZE];
@@ -162,11 +274,13 @@ static int stmpe_keypad_read_data(struct stmpe_keypad *keypad, u8 *data)
 	int i;
 
 	if (variant->auto_increment)
-		return stmpe_block_read(stmpe, STMPE_KPC_DATA_BYTE0,
-					variant->num_data, data);
+		return stmpe_block_read(stmpe,
+				variant->regs[STMPE_IDX_KPC_DATA_BYTE0],
+				variant->num_data, data);
 
 	for (i = 0; i < variant->num_data; i++) {
-		ret = stmpe_reg_read(stmpe, STMPE_KPC_DATA_BYTE0 + i);
+		ret = stmpe_reg_read(stmpe,
+				variant->regs[STMPE_IDX_KPC_DATA_BYTE0] + i);
 		if (ret < 0)
 			return ret;
 
@@ -191,9 +305,10 @@ static irqreturn_t stmpe_keypad_irq(int irq, void *dev)
 
 	for (i = 0; i < variant->num_normal_data; i++) {
 		u8 data = fifo[i];
-		int row = (data & STMPE_KPC_DATA_ROW) >> 3;
-		int col = data & STMPE_KPC_DATA_COL;
-		int code = MATRIX_SCAN_CODE(row, col, STMPE_KEYPAD_ROW_SHIFT);
+		int row = (data & variant->row_mask) >> variant->row_shift;
+		int col = (data & variant->col_mask) >> variant->col_shift;
+		int code = MATRIX_SCAN_CODE(row, col,
+				keypad->scan_code_row_shift);
 		bool up = data & STMPE_KPC_DATA_UP;
 
 		if ((data & STMPE_KPC_DATA_NOKEY_MASK)
@@ -270,33 +385,69 @@ static int __devinit stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
 	if (ret < 0)
 		return ret;
 
-	ret = stmpe_reg_write(stmpe, STMPE_KPC_COL, keypad->cols);
+	ret = stmpe_reg_write(stmpe, variant->regs[STMPE_IDX_KPC_COL_LSB],
+			keypad->cols);
 	if (ret < 0)
 		return ret;
 
-	ret = stmpe_reg_write(stmpe, STMPE_KPC_ROW_LSB, keypad->rows);
+	if (stmpe->partnum == STMPE1801 && variant->max_cols > 8) {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_COL_MSB],
+				0x3,
+				keypad->cols >> 8);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = stmpe_reg_write(stmpe, variant->regs[STMPE_IDX_KPC_ROW_LSB],
+			keypad->rows);
 	if (ret < 0)
 		return ret;
 
 	if (variant->max_rows > 8) {
-		ret = stmpe_set_bits(stmpe, STMPE_KPC_ROW_MSB,
-				     STMPE_KPC_ROW_MSB_ROWS,
-				     keypad->rows >> 8);
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_ROW_MSB],
+				STMPE_KPC_ROW_MSB_ROWS,
+				keypad->rows >> 8);
 		if (ret < 0)
 			return ret;
 	}
 
-	ret = stmpe_set_bits(stmpe, STMPE_KPC_CTRL_MSB,
-			     STMPE_KPC_CTRL_MSB_SCAN_COUNT,
-			     plat->scan_count << 4);
-	if (ret < 0)
-		return ret;
+	if (stmpe->partnum == STMPE1801) {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_LSB],
+				STMPE1801_MSK_KPC_SCAN_COUNT,
+				plat->scan_count << 4);
+		if (ret < 0)
+			return ret;
+
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_MID],
+				STMPE1801_MSK_KPC_DEBOUNCE,
+				(plat->debounce_ms << 1));
+		if (ret < 0)
+			return ret;
+
+		return  stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CMD],
+				STMPE1801_MSK_KPC_CMD_SCAN,
+				STMPE1801_MSK_KPC_CMD_SCAN);
+	} else {
+		ret = stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_MSB],
+				STMPE_KPC_CTRL_MSB_SCAN_COUNT,
+				plat->scan_count << 4);
+		if (ret < 0)
+			return ret;
+
+		return stmpe_set_bits(stmpe,
+				variant->regs[STMPE_IDX_KPC_CTRL_LSB],
+				STMPE_KPC_CTRL_LSB_SCAN |
+				STMPE_KPC_CTRL_LSB_DEBOUNCE,
+				STMPE_KPC_CTRL_LSB_SCAN |
+				(plat->debounce_ms << 1));
+	}
 
-	return stmpe_set_bits(stmpe, STMPE_KPC_CTRL_LSB,
-			      STMPE_KPC_CTRL_LSB_SCAN |
-			      STMPE_KPC_CTRL_LSB_DEBOUNCE,
-			      STMPE_KPC_CTRL_LSB_SCAN |
-			      (plat->debounce_ms << 1));
 }
 
 static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
@@ -341,8 +492,21 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
 	input->keycodesize = sizeof(keypad->keymap[0]);
 	input->keycodemax = ARRAY_SIZE(keypad->keymap);
 
-	matrix_keypad_build_keymap(plat->keymap_data, STMPE_KEYPAD_ROW_SHIFT,
-				   input->keycode, input->keybit);
+	keypad->stmpe = stmpe;
+	keypad->plat = plat;
+	keypad->input = input;
+	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
+
+	/*
+	 * compute keypad->scan_code_row_shift by figuring out
+	 * how many bits are needed to encode keypad->variant->max_cols
+	 */
+	keypad->scan_code_row_shift =
+			get_count_order(keypad->variant->max_cols);
+
+	matrix_keypad_build_keymap(plat->keymap_data,
+			keypad->scan_code_row_shift,
+			input->keycode, input->keybit);
 
 	for (i = 0; i < plat->keymap_data->keymap_size; i++) {
 		unsigned int key = plat->keymap_data->keymap[i];
@@ -351,11 +515,6 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
 		keypad->rows |= 1 << KEY_ROW(key);
 	}
 
-	keypad->stmpe = stmpe;
-	keypad->plat = plat;
-	keypad->input = input;
-	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
-
 	ret = stmpe_keypad_chip_init(keypad);
 	if (ret < 0)
 		goto out_freeinput;
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acf35bf..e3713c8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -293,6 +293,7 @@ config MFD_STMPE
 
 		STMPE811: GPIO, Touchscreen
 		STMPE1601: GPIO, Keypad
+		STMPE1801: GPIO, Keypad
 		STMPE2401: GPIO, Keypad
 		STMPE2403: GPIO, Keypad
 
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 373f423..a2135f8 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -75,6 +75,7 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe801", STMPE801 },
 	{ "stmpe811", STMPE811 },
 	{ "stmpe1601", STMPE1601 },
+	{ "stmpe1801", STMPE1801 },
 	{ "stmpe2401", STMPE2401 },
 	{ "stmpe2403", STMPE2403 },
 	{ }
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 6b8f941..902038d 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -15,6 +15,7 @@
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
+#include <linux/delay.h>
 #include "stmpe.h"
 
 static int __stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
@@ -643,6 +644,88 @@ static struct stmpe_variant_info stmpe1601 = {
 };
 
 /*
+ * STMPE1801
+ */
+static const u8 stmpe1801_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE1801_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE1801_REG_INT_CTRL_LOW,
+	[STMPE_IDX_IER_LSB]	= STMPE1801_REG_INT_EN_MASK_LOW,
+	[STMPE_IDX_ISR_LSB]	= STMPE1801_REG_INT_STA_LOW,
+	[STMPE_IDX_GPMR_LSB]	= STMPE1801_REG_GPIO_MP_LOW,
+	[STMPE_IDX_GPSR_LSB]	= STMPE1801_REG_GPIO_SET_LOW,
+	[STMPE_IDX_GPCR_LSB]	= STMPE1801_REG_GPIO_CLR_LOW,
+	[STMPE_IDX_GPDR_LSB]	= STMPE1801_REG_GPIO_SET_DIR_LOW,
+	[STMPE_IDX_GPRER_LSB]	= STMPE1801_REG_GPIO_RE_LOW,
+	[STMPE_IDX_GPFER_LSB]	= STMPE1801_REG_GPIO_FE_LOW,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1801_REG_INT_EN_GPIO_MASK_LOW,
+	[STMPE_IDX_ISGPIOR_LSB]	= STMPE1801_REG_INT_STA_GPIO_LOW,
+};
+
+static struct stmpe_variant_block stmpe1801_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE1801_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE1801_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe1801_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE1801_MSK_INT_EN_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE1801_MSK_INT_EN_KPC;
+
+	return __stmpe_set_bits(stmpe, STMPE1801_REG_INT_EN_MASK_LOW, mask,
+				enable ? mask : 0);
+}
+
+static int stmpe1801_reset(struct stmpe *stmpe)
+{
+	unsigned long timeout;
+	int ret = 0;
+
+	ret = __stmpe_set_bits(stmpe, STMPE1801_REG_SYS_CTRL,
+		STMPE1801_MSK_SYS_CTRL_RESET, STMPE1801_MSK_SYS_CTRL_RESET);
+	if (ret < 0)
+		return ret;
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	while (time_before(jiffies, timeout)) {
+		ret = __stmpe_reg_read(stmpe, STMPE1801_REG_SYS_CTRL);
+		if (ret < 0)
+			return ret;
+		if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
+			return 0;
+		usleep_range(100, 200);
+	};
+	return -EIO;
+}
+
+static struct stmpe_variant_info stmpe1801 = {
+	.name		= "stmpe1801",
+	.id_val		= STMPE1801_ID,
+	.id_mask	= 0xfff0,
+	.num_gpios	= 18,
+	.af_bits	= 0,
+	.regs		= stmpe1801_regs,
+	.blocks		= stmpe1801_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe1801_blocks),
+	.num_irqs	= STMPE1801_NR_INTERNAL_IRQS,
+	.enable		= stmpe1801_enable,
+	/* stmpe1801 do not have any gpio alternate function */
+	.get_altfunc	= NULL,
+};
+
+/*
  * STMPE24XX
  */
 
@@ -740,6 +823,7 @@ static struct stmpe_variant_info *stmpe_variant_info[STMPE_NBR_PARTS] = {
 	[STMPE801]	= &stmpe801,
 	[STMPE811]	= &stmpe811,
 	[STMPE1601]	= &stmpe1601,
+	[STMPE1801]	= &stmpe1801,
 	[STMPE2401]	= &stmpe2401,
 	[STMPE2403]	= &stmpe2403,
 };
@@ -759,7 +843,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	struct stmpe *stmpe = data;
 	struct stmpe_variant_info *variant = stmpe->variant;
 	int num = DIV_ROUND_UP(variant->num_irqs, 8);
-	u8 israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
+	u8 israddr;
 	u8 isr[num];
 	int ret;
 	int i;
@@ -769,6 +853,11 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	if (variant->id_val == STMPE1801_ID)
+		israddr = stmpe->regs[STMPE_IDX_ISR_LSB];
+	else
+		israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
+
 	ret = stmpe_block_read(stmpe, israddr, num, isr);
 	if (ret < 0)
 		return IRQ_NONE;
@@ -936,6 +1025,12 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	if (ret)
 		return ret;
 
+	if (id == STMPE1801_ID)	{
+		ret =  stmpe1801_reset(stmpe);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (stmpe->irq >= 0) {
 		if (id == STMPE801_ID)
 			icr = STMPE801_REG_SYS_CTRL_INT_EN;
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 7b8e13f..ff2b09b 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -199,6 +199,55 @@ int stmpe_remove(struct stmpe *stmpe);
 #define STPME1601_AUTOSLEEP_ENABLE		(1 << 3)
 
 /*
+ * STMPE1801
+ */
+#define STMPE1801_ID			0xc110
+#define STMPE1801_NR_INTERNAL_IRQS	5
+#define STMPE1801_IRQ_KEYPAD_COMBI	4
+#define STMPE1801_IRQ_GPIOC		3
+#define STMPE1801_IRQ_KEYPAD_OVER	2
+#define STMPE1801_IRQ_KEYPAD		1
+#define STMPE1801_IRQ_WAKEUP		0
+
+#define STMPE1801_REG_CHIP_ID			0x00
+#define STMPE1801_REG_SYS_CTRL			0x02
+#define STMPE1801_REG_INT_CTRL_LOW		0x04
+#define STMPE1801_REG_INT_EN_MASK_LOW		0x06
+#define STMPE1801_REG_INT_STA_LOW		0x08
+#define STMPE1801_REG_INT_EN_GPIO_MASK_LOW	0x0A
+#define STMPE1801_REG_INT_EN_GPIO_MASK_MID	0x0B
+#define STMPE1801_REG_INT_EN_GPIO_MASK_HIGH	0x0C
+#define STMPE1801_REG_INT_STA_GPIO_LOW		0x0D
+#define STMPE1801_REG_INT_STA_GPIO_MID		0x0E
+#define STMPE1801_REG_INT_STA_GPIO_HIGH		0x0F
+#define STMPE1801_REG_GPIO_SET_LOW		0x10
+#define STMPE1801_REG_GPIO_SET_MID		0x11
+#define STMPE1801_REG_GPIO_SET_HIGH		0x12
+#define STMPE1801_REG_GPIO_CLR_LOW		0x13
+#define STMPE1801_REG_GPIO_CLR_MID		0x14
+#define STMPE1801_REG_GPIO_CLR_HIGH		0x15
+#define STMPE1801_REG_GPIO_MP_LOW		0x16
+#define STMPE1801_REG_GPIO_MP_MID		0x17
+#define STMPE1801_REG_GPIO_MP_HIGH		0x18
+#define STMPE1801_REG_GPIO_SET_DIR_LOW		0x19
+#define STMPE1801_REG_GPIO_SET_DIR_MID		0x1A
+#define STMPE1801_REG_GPIO_SET_DIR_HIGH		0x1B
+#define STMPE1801_REG_GPIO_RE_LOW		0x1C
+#define STMPE1801_REG_GPIO_RE_MID		0x1D
+#define STMPE1801_REG_GPIO_RE_HIGH		0x1E
+#define STMPE1801_REG_GPIO_FE_LOW		0x1F
+#define STMPE1801_REG_GPIO_FE_MID		0x20
+#define STMPE1801_REG_GPIO_FE_HIGH		0x21
+#define STMPE1801_REG_GPIO_PULL_UP_LOW		0x22
+#define STMPE1801_REG_GPIO_PULL_UP_MID		0x23
+#define STMPE1801_REG_GPIO_PULL_UP_HIGH		0x24
+
+#define STMPE1801_MSK_SYS_CTRL_RESET		(1 << 7)
+
+#define STMPE1801_MSK_INT_EN_KPC		(1 << 1)
+#define STMPE1801_MSK_INT_EN_GPIO		(1 << 3)
+
+/*
  * STMPE24xx
  */
 
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index f8d5b4d..5b87ec4 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -26,6 +26,7 @@ enum stmpe_partnum {
 	STMPE801,
 	STMPE811,
 	STMPE1601,
+	STMPE1801,
 	STMPE2401,
 	STMPE2403,
 	STMPE_NBR_PARTS
@@ -39,6 +40,7 @@ enum {
 	STMPE_IDX_CHIP_ID,
 	STMPE_IDX_ICR_LSB,
 	STMPE_IDX_IER_LSB,
+	STMPE_IDX_ISR_LSB,
 	STMPE_IDX_ISR_MSB,
 	STMPE_IDX_GPMR_LSB,
 	STMPE_IDX_GPSR_LSB,
@@ -49,6 +51,7 @@ enum {
 	STMPE_IDX_GPFER_LSB,
 	STMPE_IDX_GPAFR_U_MSB,
 	STMPE_IDX_IEGPIOR_LSB,
+	STMPE_IDX_ISGPIOR_LSB,
 	STMPE_IDX_ISGPIOR_MSB,
 	STMPE_IDX_MAX,
 };
-- 
1.7.10

