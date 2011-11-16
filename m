Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1KPL0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:26:48 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:44208 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291Ab1KPL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:26:45 -0500
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
Subject: [PATCH 5/5] gpio/gpio-stmpe: ADD support for stmpe variant 801
Date: Wed, 16 Nov 2011 16:56:10 +0530
Message-ID: <26f9662d244e0141b6fdda76bc4c2e345d7c14cb.1321442150.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321442150.git.viresh.kumar@st.com>
References: <cover.1321442150.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STMPE801 is a GPIO expander. GPIO registers for 801 are slightly different from other
variants. This patch adds support for STMPE801 in stmpe gpio driver.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/gpio/gpio-stmpe.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 4c980b5..cba57f6 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -65,7 +65,15 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 	u8 reg = stmpe->regs[which] - (offset / 8);
 	u8 mask = 1 << (offset % 8);
 
-	stmpe_reg_write(stmpe, reg, mask);
+	/*
+	 * Some variants have single register for gpio set/clear functionality.
+	 * For them we need to write 0 to clear and 1 to set.
+	 */
+	if (!val && (stmpe->regs[STMPE_IDX_GPSR_LSB] ==
+				stmpe->regs[STMPE_IDX_GPCR_LSB]))
+		stmpe_set_bits(stmpe, reg, mask, ~mask);
+	else
+		stmpe_set_bits(stmpe, reg, mask, mask);
 }
 
 static int stmpe_gpio_direction_output(struct gpio_chip *chip,
@@ -125,10 +133,19 @@ static struct gpio_chip template_chip = {
 static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
+	/* STMPE801 doesn't have RE and FE registers */
+	if (stmpe->variant->id_val == STMPE801) {
+		if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
+			return 0;
+		else
+			return -EINVAL;
+	}
+
 	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
 		return -EINVAL;
 
@@ -165,6 +182,11 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 	int i, j;
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
+		/* STMPE801 doesn't have RE and FE registers */
+		if ((stmpe->variant->id_val == STMPE801) &&
+				(i != REG_IE))
+			continue;
+
 		for (j = 0; j < num_banks; j++) {
 			u8 old = stmpe_gpio->oldregs[i][j];
 			u8 new = stmpe_gpio->regs[i][j];
@@ -241,8 +263,11 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 		}
 
 		stmpe_reg_write(stmpe, statmsbreg + i, status[i]);
-		stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB] + i,
-				status[i]);
+
+		/* Edge detect register is not present on 801 */
+		if (stmpe->variant->id_val != STMPE801)
+			stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB]
+					+ i, status[i]);
 	}
 
 	return IRQ_HANDLED;
-- 
1.7.2.2

