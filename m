Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab1F2Qx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:53:58 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:38508 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab1F2Qxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:53:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5/5] ASoC: atmel_ssc_dai: PM: actually stopping clock on suspend/resume
Date: Wed, 29 Jun 2011 20:00:19 +0200
Message-Id: <e069cdab370eb5737ef9ff744fde828e6abb4163.1309368631.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop SSC clock on suspend/resume cycle checking if the controller is actually
initialized. This will save power while sleeping.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 sound/soc/atmel/atmel_ssc_dai.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 9412fc3..43cce80 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -631,12 +631,10 @@ static int atmel_ssc_prepare(struct snd_pcm_substream *substream,
 #ifdef CONFIG_PM
 static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 {
-	struct atmel_ssc_info *ssc_p;
+	struct atmel_ssc_info *ssc_p = &ssc_info[cpu_dai->id];
 
 	if (!cpu_dai->active)
-		return 0;
-
-	ssc_p = &ssc_info[cpu_dai->id];
+		goto out;
 
 	/* Save the status register before disabling transmit and receive */
 	ssc_p->ssc_state.ssc_sr = ssc_readl(ssc_p->ssc->regs, SR);
@@ -652,6 +650,11 @@ static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 	ssc_p->ssc_state.ssc_tcmr = ssc_readl(ssc_p->ssc->regs, TCMR);
 	ssc_p->ssc_state.ssc_tfmr = ssc_readl(ssc_p->ssc->regs, TFMR);
 
+out:
+	if (ssc_p->initialized) {
+		pr_debug("atmel_ssc_dai: suspend - stop clock\n");
+		clk_disable(ssc_p->ssc->clk);
+	}
 	return 0;
 }
 
@@ -659,14 +662,17 @@ static int atmel_ssc_suspend(struct snd_soc_dai *cpu_dai)
 
 static int atmel_ssc_resume(struct snd_soc_dai *cpu_dai)
 {
-	struct atmel_ssc_info *ssc_p;
+	struct atmel_ssc_info *ssc_p = &ssc_info[cpu_dai->id];
 	u32 cr;
 
+	if (ssc_p->initialized) {
+		pr_debug("atmel_ssc_dai: resume - restart clock\n");
+		clk_enable(ssc_p->ssc->clk);
+	}
+
 	if (!cpu_dai->active)
 		return 0;
 
-	ssc_p = &ssc_info[cpu_dai->id];
-
 	/* restore SSC register settings */
 	ssc_writel(ssc_p->ssc->regs, TFMR, ssc_p->ssc_state.ssc_tfmr);
 	ssc_writel(ssc_p->ssc->regs, TCMR, ssc_p->ssc_state.ssc_tcmr);
-- 
1.7.3

