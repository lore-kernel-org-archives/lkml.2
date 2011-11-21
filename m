Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1KUEcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:32:48 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:41717 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126Ab1KUEcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:32:46 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>
Subject: [PATCH 5/5 V3] gpio/gpio-stmpe: ADD support for stmpe variant 801
Date: Mon, 21 Nov 2011 10:02:31 +0530
Message-ID: <3acffb8a1da1ff69d70e745b23e8b79a859586c2.1321507421.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1321507421.git.viresh.kumar@st.com>
References: <cover.1321507421.git.viresh.kumar@st.com>
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

Changes since V2:
- stmpe_gpio_set() is updates, so that it doesn't configure other gpio pins by
  mistake.
- STMPE801 also supports Edge interrupts and not level ints. Code updated for
  this too.

 drivers/gpio/gpio-stmpe.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 4c980b5..87a68a8 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -65,7 +65,14 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 	u8 reg = stmpe->regs[which] - (offset / 8);
 	u8 mask = 1 << (offset % 8);
 
-	stmpe_reg_write(stmpe, reg, mask);
+	/*
+	 * Some variants have single register for gpio set/clear functionality.
+	 * For them we need to write 0 to clear and 1 to set.
+	 */
+	if (stmpe->regs[STMPE_IDX_GPSR_LSB] == stmpe->regs[STMPE_IDX_GPCR_LSB])
+		stmpe_set_bits(stmpe, reg, mask, val ? mask : 0);
+	else
+		stmpe_reg_write(stmpe, reg, mask);
 }
 
 static int stmpe_gpio_direction_output(struct gpio_chip *chip,
@@ -132,6 +139,10 @@ static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
 		return -EINVAL;
 
+	/* STMPE801 doesn't have RE and FE registers */
+	if (stmpe_gpio->stmpe->partnum == STMPE801)
+		return 0;
+
 	if (type == IRQ_TYPE_EDGE_RISING)
 		stmpe_gpio->regs[REG_RE][regoffset] |= mask;
 	else
@@ -165,6 +176,11 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 	int i, j;
 
 	for (i = 0; i < CACHE_NR_REGS; i++) {
+		/* STMPE801 doesn't have RE and FE registers */
+		if ((stmpe->partnum == STMPE801) &&
+				(i != REG_IE))
+			continue;
+
 		for (j = 0; j < num_banks; j++) {
 			u8 old = stmpe_gpio->oldregs[i][j];
 			u8 new = stmpe_gpio->regs[i][j];
@@ -241,8 +257,11 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 		}
 
 		stmpe_reg_write(stmpe, statmsbreg + i, status[i]);
-		stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB] + i,
-				status[i]);
+
+		/* Edge detect register is not present on 801 */
+		if (stmpe->partnum != STMPE801)
+			stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_GPEDR_MSB]
+					+ i, status[i]);
 	}
 
 	return IRQ_HANDLED;
-- 
1.7.2.2

