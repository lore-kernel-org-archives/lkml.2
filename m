Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0JZAig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:38:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46190 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0JZAid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:33 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 4/8] staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
Date: Mon, 25 Oct 2010 19:51:42 -0500
Message-Id: <1288054306-4361-5-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-4-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
 <1288054306-4361-4-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timeout was not being initialized correctly and should
use time_is-before_jiffies, also make it a parameter

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-clock.c       |   13 +++++++------
 drivers/staging/tidspbridge/core/dsp-mmu.c         |    5 ++++-
 .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +++-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 46d17c7..8106d1e 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -202,13 +202,13 @@ static void mcbsp_clk_prepare(bool flag, u8 id)
  * Sets an overflow interrupt for the desired GPT waiting for a timeout
  * of 5 msecs for the interrupt to occur.
  */
-void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
+int dsp_gpt_wait_overflow(short int clk_id, unsigned int load,
+			unsigned long timeout)
 {
 	struct omap_dm_timer *gpt = timer[clk_id - 1];
-	unsigned long timeout;
 
 	if (!gpt)
-		return;
+		return -EINVAL;
 
 	/* Enable overflow interrupt */
 	omap_dm_timer_set_int_enable(gpt, OMAP_TIMER_INT_OVERFLOW);
@@ -222,14 +222,15 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
 	/* Wait 80us for timer to overflow */
 	udelay(80);
 
-	timeout = msecs_to_jiffies(5);
+	timeout = jiffies + msecs_to_jiffies(timeout);
 	/* Check interrupt status and wait for interrupt */
 	while (!(omap_dm_timer_read_status(gpt) & OMAP_TIMER_INT_OVERFLOW)) {
-		if (time_is_after_jiffies(timeout)) {
+		if (time_is_before_jiffies(timeout)) {
 			pr_err("%s: GPTimer interrupt failed\n", __func__);
-			break;
+			return -ETIME;
 		}
 	}
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 6d7501a..2d4e897 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -65,7 +65,10 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 
 	dsp_clk_enable(DSP_CLK_GPT8);
 
-	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
+	if (dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe, 10)) {
+		pr_err("%s: error sending interrupt to DSP\n", __func__);
+		return;
+	}
 
 	/* Clear MMU interrupt */
 	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/clk.h b/drivers/staging/tidspbridge/include/dspbridge/clk.h
index b239503..6fe1ff2 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/clk.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/clk.h
@@ -62,7 +62,9 @@ extern void dsp_clk_exit(void);
  */
 extern void dsp_clk_init(void);
 
-void dsp_gpt_wait_overflow(short int clk_id, unsigned int load);
+int dsp_gpt_wait_overflow(short int clk_id, unsigned int load,
+			unsigned long timeout);
+
 
 /*
  *  ======== dsp_clk_enable ========
-- 
1.6.3.3

