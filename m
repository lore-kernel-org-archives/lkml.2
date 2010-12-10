Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0LJD5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:57:05 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51945 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0LJD5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:57:04 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <felipe.contreras@gmail.com>, <nm@ti.com>,
        <ohad@wizery.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 2/4] staging: tidspbridge - fix timeout in dsp_gpt_wait_overflow
Date: Thu,  9 Dec 2010 21:55:40 -0600
Message-Id: <1291953342-4905-3-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timeout was not being initialized correctly and should
use time_is-before_jiffies, also make it a parameter.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-clock.c       |   17 ++++++++++-------
 drivers/staging/tidspbridge/core/ue_deh.c          |    5 +++++
 .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +++-
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 46d17c7..db02e12 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -198,17 +198,19 @@ static void mcbsp_clk_prepare(bool flag, u8 id)
  * dsp_gpt_wait_overflow - set gpt overflow and wait for fixed timeout
  * @clk_id:      GP Timer clock id.
  * @load:        Overflow value.
+ * @timeout:     Timeout.
  *
  * Sets an overflow interrupt for the desired GPT waiting for a timeout
- * of 5 msecs for the interrupt to occur.
+ * of @timeout msecs for the interrupt to occur.
  */
-void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
+int dsp_gpt_wait_overflow(short int clk_id, unsigned int load,
+			unsigned long timeout)
+
 {
 	struct omap_dm_timer *gpt = timer[clk_id - 1];
-	unsigned long timeout;
 
 	if (!gpt)
-		return;
+		return -EINVAL;
 
 	/* Enable overflow interrupt */
 	omap_dm_timer_set_int_enable(gpt, OMAP_TIMER_INT_OVERFLOW);
@@ -222,14 +224,15 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
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
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 1e30ce8..0537edf 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -195,6 +195,11 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 
 	dsp_clk_enable(DSP_CLK_GPT7);
 
+	if (dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe, 10)) {
+		pr_err("%s: error sending interrupt to DSP\n", __func__);
+		return;
+	}
+
 	dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe);
 
 	/* Clear MMU interrupt */
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
1.7.3.2

