Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1AFIFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:05:23 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57414 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1AFIFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:05:19 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
In-Reply-To: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
Subject: RE: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 16:05:19 +0800
Message-ID: <01ea01cbad78$7603ea80$620bbf80$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQD5q7uzdbzaRxzFKhxkjRMpQze/MJVnmVMA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv1 6/8] unicore32 machine related files: ac97
From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 6 implements ac97 driver.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 drivers/staging/puv3/puv3_ac97.c |  383 ++++++++++++++++++++++++++++++++
 drivers/staging/puv3/puv3_pcm.c  |  449 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/puv3/puv3_pcm.h  |   33 +++
 3 files changed, 865 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/puv3/puv3_ac97.c b/drivers/staging/puv3/puv3_ac97.c
new file mode 100644
index 0000000..f02707e
--- /dev/null
+++ b/drivers/staging/puv3/puv3_ac97.c
@@ -0,0 +1,383 @@
+/*
+ * linux/drivers/staging/puv3/puv3_ac97.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: sound/arm/pxa2xx-ac97.c
+ *
+ * Contributors & Additions/Fixes:
+ *     2009-07-30: enhance the PM support, resume/suspend can operate
+ *                 while ac97 is working by ZHONG Qi
+ *     2009-07-23: cause the ac97's flaw, only support fix sample rate
+ *			by ZHONG Qi
+ *     2009-07-23: add ac97 PM support by ZHONG Qi
+ *     2009-03-11: First version by ZHONG Qi
+ *
+ * TODO:
+ *     1. local_ac97_read, local_ac97_write and puv3_codec_regs
+ *        are involved for fixing bug, about reseting codec automatically
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/ac97_codec.h>
+#include <sound/initval.h>
+
+#include <asm/irq.h>
+#include <linux/mutex.h>
+#include <asm/mach/hardware.h>
+
+#include "puv3_pcm.h"
+
+static DEFINE_MUTEX(car_mutex);
+
+typedef struct {
+	int (*startup)(struct snd_pcm_substream *, void *);
+	void (*shutdown)(struct snd_pcm_substream *, void *);
+	void (*suspend)(void *);
+	void (*resume)(void *);
+	void *priv;
+} puv3_audio_ops_t;
+
+unsigned short puv3_codec_regs[64] = {
+	0x5990, 0x8000, 0x8000, 0x8000, 0x0000, 0x8000, 0x8008, 0x8008,
+	0x8808, 0x8808, 0x8808, 0x8808, 0x8808, 0x0000, 0x8000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x000f, 0x0607, 0x0410, 0xbb80, 0x0000,
+	0x0000, 0xbb80, 0x0000, 0x0000, 0x0000, 0x2000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x2000, 0x2000, 0x000d,
+	0x044c, 0x044c, 0x0800, 0x0800, 0x0003, 0x0000, 0x0000, 0X4740,
+};
+
+/* TODO This is unnecessary, except for fixing bug */
+unsigned short local_ac97_read(unsigned short reg)
+{
+	return puv3_codec_regs[reg/2];
+}
+
+/* TODO This is unnecessary, except for fixing bug */
+void local_ac97_write(unsigned short reg, unsigned short val)
+{
+	int i = 1000;
+
+	puv3_codec_regs[reg/2] = val;
+
+	PKUNITY_AC97_CRAC = AC97_CODEC_REG(reg) | AC97_CODEC_VAL(val);
+
+	while (!(PKUNITY_AC97_CONR & AC97_CODEC_WRITECOMPLETE)) {
+		if (!(i--)) {
+			printk(KERN_WARNING "AC97: %s timeout\n", __func__);
+			break;
+		}
+		udelay(1);
+	}
+}
+
+static unsigned short puv3_ac97_read(struct snd_ac97 *ac97, unsigned short reg)
+{
+	return puv3_codec_regs[reg/2];
+}
+
+static void puv3_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
+		unsigned short val)
+{
+	int i = 1000;
+
+	mutex_lock(&car_mutex);
+
+	if (reg == 0x2 || reg == 0x18)
+		puv3_codec_regs[reg/2] = val & 0x9F1F;
+	else
+		puv3_codec_regs[reg/2] = val;
+
+	PKUNITY_AC97_CRAC = AC97_CODEC_REG(reg) | AC97_CODEC_VAL(val);
+
+	while (!(PKUNITY_AC97_CONR & AC97_CODEC_WRITECOMPLETE)) {
+		if (!(i--)) {
+			printk(KERN_WARNING "AC97: %s timeout\n", __func__);
+			break;
+		}
+		udelay(1);
+	}
+
+	mutex_unlock(&car_mutex);
+}
+
+static void puv3_ac97_reset(struct snd_ac97 *ac97)
+{
+/*	int i = 3;
+
+	PKUNITY_AC97_CONR = AC97_CMD_RESET;
+reset:
+	msleep(1);
+
+	if ((PKUNITY_AC97_CONR & 0x2) == 2) {
+		msleep(1);
+		PKUNITY_AC97_CONR = 0x1;
+		if (i--)
+			goto reset;
+		else {
+			ac97_reset_err = -1;
+			printk("AC97 reset error!\n");
+		}
+	}
+*/
+}
+
+static struct snd_ac97_bus_ops puv3_ac97_ops = {
+	.read	= puv3_ac97_read,
+	.write	= puv3_ac97_write,
+	.reset	= puv3_ac97_reset,
+};
+
+static struct puv3_pcm_dma_params puv3_ac97_pcm_out = {
+	.name			= "AC97 PCM out",
+	.dev_addr		= PKUNITY_AC97_BASE + 0x20, /* OUT FIFO */
+};
+
+static struct puv3_pcm_dma_params puv3_ac97_pcm_in = {
+	.name			= "AC97 PCM in",
+	.dev_addr		= PKUNITY_AC97_BASE + 0x30, /* IN FIFO */
+};
+
+static struct snd_pcm *puv3_ac97_pcm;
+static struct snd_ac97 *puv3_ac97_ac97;
+
+static int puv3_ac97_pcm_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	puv3_audio_ops_t *platform_ops;
+	int r;
+
+	runtime->hw.channels_min = 2;
+	runtime->hw.channels_max = 2;
+
+	r = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
+		AC97_RATES_FRONT_DAC : AC97_RATES_ADC;
+
+	platform_ops = substream->pcm->card->dev->platform_data;
+	if (platform_ops && platform_ops->startup)
+		return platform_ops->startup(substream, platform_ops->priv);
+	else
+		return 0;
+}
+
+static void puv3_ac97_pcm_shutdown(struct snd_pcm_substream *substream)
+{
+	puv3_audio_ops_t *platform_ops;
+
+	platform_ops = substream->pcm->card->dev->platform_data;
+	if (platform_ops && platform_ops->shutdown)
+		platform_ops->shutdown(substream, platform_ops->priv);
+}
+
+static int puv3_ac97_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int reg = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
+		  AC97_PCM_FRONT_DAC_RATE : AC97_PCM_LR_ADC_RATE;
+	return snd_ac97_set_rate(puv3_ac97_ac97, reg, runtime->rate);
+}
+
+static struct puv3_pcm_client puv3_ac97_pcm_client = {
+	.playback_params	= &puv3_ac97_pcm_out,
+	.capture_params		= &puv3_ac97_pcm_in,
+	.startup		= puv3_ac97_pcm_startup,
+	.shutdown		= puv3_ac97_pcm_shutdown,
+	.prepare		= puv3_ac97_pcm_prepare,
+};
+
+#ifdef CONFIG_PM
+
+static unsigned long ac97_regs[2];
+static unsigned long ac97_dma_regs[4];
+int ac97_dma_ch = 0;
+
+static int puv3_ac97_do_suspend(struct snd_card *card, pm_message_t state)
+{
+	puv3_audio_ops_t *platform_ops = card->dev->platform_data;
+
+	snd_power_change_state(card, SNDRV_CTL_POWER_D3cold);
+	snd_pcm_suspend_all(puv3_ac97_pcm);
+	snd_ac97_suspend(puv3_ac97_ac97);
+	if (platform_ops && platform_ops->suspend)
+		platform_ops->suspend(platform_ops->priv);
+
+	/* store DMA & ac97 */
+	ac97_dma_regs[0] = DMAC_SRCADDR(ac97_dma_ch);
+	ac97_dma_regs[1] = DMAC_DESTADDR(ac97_dma_ch);
+	ac97_dma_regs[2] = DMAC_CONTROL(ac97_dma_ch);
+	ac97_dma_regs[3] = DMAC_CONFIG(ac97_dma_ch);
+
+	ac97_regs[0] = PKUNITY_AC97_OUT_FIFO;
+	ac97_regs[1] = PKUNITY_AC97_IN_FIFO;
+
+	return 0;
+}
+
+static int puv3_ac97_do_resume(struct snd_card *card)
+{
+	puv3_audio_ops_t *platform_ops = card->dev->platform_data;
+	int i;
+
+	if (platform_ops && platform_ops->resume)
+		platform_ops->resume(platform_ops->priv);
+	snd_ac97_resume(puv3_ac97_ac97);
+	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+
+	/* restore DMA & codec & AC97 */
+
+	DMAC_SRCADDR(ac97_dma_ch)  = ac97_dma_regs[0];
+	DMAC_DESTADDR(ac97_dma_ch) = ac97_dma_regs[1];
+	DMAC_CONTROL(ac97_dma_ch)  = ac97_dma_regs[2];
+	DMAC_CONFIG(ac97_dma_ch)   = ac97_dma_regs[3];
+
+	for (i = 0; i < 64; i++)
+		local_ac97_write(i*2, puv3_codec_regs[i]);
+
+	PKUNITY_AC97_OCR = AC97_CMD_VPSAMPLE;	/* phone @ var sample rate */
+	PKUNITY_AC97_ICR = AC97_CMD_FCSAMPLE;	/* mic @ fix sample rate   */
+	PKUNITY_AC97_ENABLE = AC97_CMD_ENABLE;
+
+	local_ac97_write(0x2, 0x0000);
+
+	PKUNITY_AC97_OUT_FIFO  = ac97_regs[0];
+	PKUNITY_AC97_IN_FIFO   = ac97_regs[1];
+
+	return 0;
+}
+
+static int puv3_ac97_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct snd_card *card = platform_get_drvdata(dev);
+	int ret = 0;
+
+	if (card)
+		ret = puv3_ac97_do_suspend(card, PMSG_SUSPEND);
+
+	return ret;
+}
+
+static int puv3_ac97_resume(struct platform_device *dev)
+{
+	struct snd_card *card = platform_get_drvdata(dev);
+	int ret = 0;
+
+	if (card)
+		ret = puv3_ac97_do_resume(card);
+
+	return ret;
+}
+
+#else
+#define puv3_ac97_suspend	NULL
+#define puv3_ac97_resume	NULL
+#endif
+
+static int __devinit puv3_ac97_probe(struct platform_device *dev)
+{
+	struct snd_card *card;
+	struct snd_ac97_bus *ac97_bus;
+	struct snd_ac97_template ac97_template;
+	int ret;
+
+	ret = -ENOMEM;
+	if (snd_card_create(SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
+			    THIS_MODULE, 0, &card) < 0)
+		goto err;
+
+	card->dev = &dev->dev;
+	strncpy(card->driver, dev->dev.driver->name, sizeof(card->driver));
+
+	ret = puv3_pcm_new(card, &puv3_ac97_pcm_client, &puv3_ac97_pcm);
+	if (ret)
+		goto err;
+
+	ret = snd_ac97_bus(card, 0, &puv3_ac97_ops, NULL, &ac97_bus);
+	if (ret)
+		goto err;
+	memset(&ac97_template, 0, sizeof(ac97_template));
+	ret = snd_ac97_mixer(ac97_bus, &ac97_template, &puv3_ac97_ac97);
+	if (ret)
+		goto err;
+
+	snprintf(card->shortname, sizeof(card->shortname),
+			"%s", snd_ac97_get_short_name(puv3_ac97_ac97));
+	snprintf(card->longname, sizeof(card->longname),
+			"%s (%s)", dev->dev.driver->name, card->mixername);
+
+	snd_card_set_dev(card, &dev->dev);
+	ret = snd_card_register(card);
+	if (ret == 0) {
+		platform_set_drvdata(dev, card);
+		/* phone @ var sample rate */
+		PKUNITY_AC97_OCR = AC97_CMD_VPSAMPLE;
+		/* mic @ fix sample rate   */
+		PKUNITY_AC97_ICR = AC97_CMD_FCSAMPLE;
+		PKUNITY_AC97_ENABLE = AC97_CMD_ENABLE;
+		return 0;
+	}
+
+err:
+	if (card)
+		snd_card_free(card);
+	return ret;
+}
+
+static int __devexit puv3_ac97_remove(struct platform_device *dev)
+{
+	struct snd_card *card = platform_get_drvdata(dev);
+
+	PKUNITY_AC97_ENABLE = AC97_CMD_DISABLE;
+
+	if (card) {
+		snd_card_free(card);
+		platform_set_drvdata(dev, NULL);
+	}
+
+	return 0;
+}
+
+static struct platform_driver puv3_ac97_driver = {
+	.probe		= puv3_ac97_probe,
+	.remove		= __devexit_p(puv3_ac97_remove),
+	.suspend	= puv3_ac97_suspend,
+	.resume		= puv3_ac97_resume,
+	.driver		= {
+		.name		= "PKUnity-v3-AC97",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init puv3_ac97_init(void)
+{
+	return platform_driver_register(&puv3_ac97_driver);
+}
+
+static void __exit puv3_ac97_exit(void)
+{
+	platform_driver_unregister(&puv3_ac97_driver);
+}
+
+module_init(puv3_ac97_init);
+module_exit(puv3_ac97_exit);
+MODULE_AUTHOR("ZHONG Qi");
+MODULE_DESCRIPTION("AC97 driver for the PKUNITY chip");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/puv3/puv3_pcm.c b/drivers/staging/puv3/puv3_pcm.c
new file mode 100644
index 0000000..53ce7dc
--- /dev/null
+++ b/drivers/staging/puv3/puv3_pcm.c
@@ -0,0 +1,449 @@
+/*
+ * linux/drivers/staging/puv3/puv3_pcm.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: sound/arm/pxa2xx-pcm.c
+ *
+ * Contributors & Additions/Fixes:
+ *     2009-07-30: 1. increase the size of dma_buffer for vphone's performance
+ *                 2. fix the XRUN bug by setting the dma buffer counter to zero
+ *			by ZHONG Qi
+ *     2009-07-23: cause the ac97's flaw, only support fix sample rate
+ *			by ZHONG Qi
+ *     2009-03-11: First version by ZHONG Qi
+ *
+ * TODO:
+ *     1. local_ac97_read, local_ac97_write and puv3_codec_regs
+ *        are involved for fixing bug, about reseting codec automatically
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/irqreturn.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include <asm/irq.h>
+#include <asm/mach/dma.h>
+#include <asm/mach/hardware.h>
+
+#include "puv3_pcm.h"
+
+#define COUNTER_SIZE	16
+#define PERIOD_SIZE	(4 * 1024)
+
+static void kick_dma(int, struct snd_pcm_substream *);
+static unsigned long next_counter(unsigned long);
+
+static const struct snd_pcm_hardware puv3_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_MMAP |
+				  SNDRV_PCM_INFO_MMAP_VALID |
+				  SNDRV_PCM_INFO_INTERLEAVED |
+				  SNDRV_PCM_INFO_PAUSE,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
+	.rates                  = SNDRV_PCM_RATE_48000,
+	.rate_min               = 48000,
+	.rate_max               = 48000,
+	.channels_min           = 1,
+	.channels_max           = 2,
+	.period_bytes_min	= PERIOD_SIZE,
+	.period_bytes_max	= PERIOD_SIZE,
+	.periods_min		= 1,
+	.periods_max		= COUNTER_SIZE, /* 2 */
+	.buffer_bytes_max	= COUNTER_SIZE * PERIOD_SIZE, /* 8 * 1024 */
+	.fifo_size		= 32,
+};
+
+struct puv3_runtime_data {
+	struct puv3_pcm_dma_params *params;
+	unsigned long buffer_counter;
+	size_t period;
+	int dma_lock;
+	int dma_ch;
+	/* TODO add other filed */
+};
+
+static unsigned long next_counter(unsigned long buffer_counter)
+{
+	return ++buffer_counter % COUNTER_SIZE;
+}
+
+static void reload_dma(int dma_ch, struct snd_pcm_substream *substream,
+		       struct snd_pcm_runtime *runtime,
+		       struct puv3_runtime_data *rtd)
+{
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		local_ac97_write(0x2,  puv3_codec_regs[0x2/2]);
+		local_ac97_write(0x18, puv3_codec_regs[0x18/2]);
+		local_ac97_write(0x2a, puv3_codec_regs[0x2a/2]);
+		local_ac97_write(0x2c, puv3_codec_regs[0x2c/2]);
+
+		DMAC_SRCADDR(dma_ch)  = runtime->dma_addr +
+					rtd->buffer_counter * rtd->period;
+		DMAC_DESTADDR(dma_ch) = rtd->params->dev_addr;
+		DMAC_CONTROL(dma_ch)  = DMAC_CONTROL_SIZE_WORD(rtd->period) |
+					DMAC_CONTROL_SI |
+					DMAC_CONTROL_BURST_8BYTE;
+		DMAC_CONFIG(dma_ch)   = DMAC_CONFIG_AC97WR;
+	} else {
+		local_ac97_write(0x1C, puv3_codec_regs[0x1C/2]);
+
+		DMAC_DESTADDR(rtd->dma_ch) = runtime->dma_addr +
+					rtd->buffer_counter * rtd->period;
+		DMAC_SRCADDR(rtd->dma_ch) = rtd->params->dev_addr;
+		DMAC_CONTROL(rtd->dma_ch) = DMAC_CONTROL_SIZE_WORD(rtd->period)
+					| DMAC_CONTROL_DI
+					| DMAC_CONTROL_BURST_8BYTE;
+		DMAC_CONFIG(rtd->dma_ch) = DMAC_CONFIG_AC97RD;
+	}
+}
+
+static void kick_dma(int dma_ch, struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime;
+	struct puv3_runtime_data *rtd;
+
+	runtime = substream->runtime;
+	rtd = runtime->private_data;
+
+	rtd->buffer_counter = next_counter(rtd->buffer_counter);
+
+	reload_dma(dma_ch, substream, runtime, rtd);
+
+	puv3_resume_dma(dma_ch);
+
+	return;
+}
+
+static void reset_dma(int dma_ch, struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime;
+	struct puv3_runtime_data *rtd;
+
+	puv3_stop_dma(dma_ch);
+
+	runtime = substream->runtime;
+	rtd = runtime->private_data;
+
+	rtd->buffer_counter = 0;
+
+	reload_dma(dma_ch, substream, runtime, rtd);
+
+	return;
+}
+
+static int puv3_pcm_hw_params(struct snd_pcm_substream *substream,
+			      struct snd_pcm_hw_params *params)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct puv3_runtime_data *rtd = runtime->private_data;
+	size_t period = params_period_bytes(params);
+	size_t totsize = params_buffer_bytes(params);
+
+	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
+	runtime->dma_bytes = totsize;
+
+	rtd->period = period;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		DMAC_SRCADDR(rtd->dma_ch)  = runtime->dma_addr +
+					rtd->buffer_counter * rtd->period;
+		DMAC_DESTADDR(rtd->dma_ch) = rtd->params->dev_addr;
+		DMAC_CONTROL(rtd->dma_ch) = DMAC_CONTROL_SIZE_WORD(rtd->period)
+					| DMAC_CONTROL_SI
+					| DMAC_CONTROL_BURST_8BYTE;
+		DMAC_CONFIG(rtd->dma_ch)   = DMAC_CONFIG_AC97WR;
+	} else {
+		DMAC_DESTADDR(rtd->dma_ch) = runtime->dma_addr +
+					rtd->buffer_counter * rtd->period;
+		DMAC_SRCADDR(rtd->dma_ch)  = rtd->params->dev_addr;
+		DMAC_CONTROL(rtd->dma_ch) = DMAC_CONTROL_SIZE_WORD(rtd->period)
+					| DMAC_CONTROL_DI
+					| DMAC_CONTROL_BURST_8BYTE;
+		DMAC_CONFIG(rtd->dma_ch)   = DMAC_CONFIG_AC97RD;
+	}
+
+	return 0;
+}
+
+static int puv3_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct puv3_runtime_data *rtd = runtime->private_data;
+
+	puv3_stop_dma(rtd->dma_ch);
+	snd_pcm_set_runtime_buffer(substream, NULL);
+
+	return 0;
+}
+
+static int puv3_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct puv3_pcm_client *client = substream->private_data;
+	return client->prepare(substream);
+}
+
+static int puv3_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct puv3_runtime_data *rtd = runtime->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		rtd->dma_lock = 0;
+		puv3_resume_dma(rtd->dma_ch);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		rtd->dma_lock = 1;
+		ac97_dma_ch = rtd->dma_ch;
+		reset_dma(rtd->dma_ch, substream);
+		break;
+
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		puv3_resume_dma(rtd->dma_ch);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static void puv3_pcm_dma_irq(int dma_ch, void *dev_id)
+{
+	struct snd_pcm_substream *substream = dev_id;
+	struct puv3_runtime_data *rtd = substream->runtime->private_data;
+
+	if (!rtd->dma_lock)
+		kick_dma(dma_ch, substream);
+
+	snd_pcm_period_elapsed(substream);
+}
+
+static snd_pcm_uframes_t puv3_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct puv3_runtime_data *rtd = substream->runtime->private_data;
+	dma_addr_t ptr = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
+			 DMAC_SRCADDR(rtd->dma_ch) : DMAC_DESTADDR(rtd->dma_ch);
+	snd_pcm_uframes_t x = bytes_to_frames(runtime, ptr - runtime->dma_addr);
+	if (x == runtime->buffer_size)
+		x = 0;
+	return x;
+}
+
+static int puv3_pcm_hw_rule_mult32(struct snd_pcm_hw_params *params,
+		struct snd_pcm_hw_rule *rule)
+{
+	struct snd_interval *i = hw_param_interval(params, rule->var);
+	int changed = 0;
+
+	if (i->min & 31) {
+		i->min = (i->min & ~31) + 32;
+		i->openmin = 0;
+		changed = 1;
+	}
+
+	if (i->max & 31) {
+		i->max &= ~31;
+		i->openmax = 0;
+		changed = 1;
+	}
+
+	return changed;
+}
+
+static int puv3_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct puv3_pcm_client *client = substream->private_data;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct puv3_runtime_data *rtd;
+	int ret = 0;
+
+	runtime->hw = puv3_pcm_hardware;
+
+	/*
+	 * For mysterious reasons (and despite what the manual says)
+	 * playback samples are lost if the DMA count is not a multiple
+	 * of the DMA burst size.  Let's add a rule to enforce that.
+	 */
+	ret = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
+				  puv3_pcm_hw_rule_mult32, NULL,
+				  SNDRV_PCM_HW_PARAM_PERIOD_BYTES, -1);
+	if (ret)
+		goto out;
+	ret = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+				  puv3_pcm_hw_rule_mult32, NULL,
+				  SNDRV_PCM_HW_PARAM_BUFFER_BYTES, -1);
+	if (ret)
+		goto out;
+
+	ret = -ENOMEM;
+	rtd = kmalloc(sizeof(*rtd), GFP_KERNEL);
+	if (!rtd)
+		goto out;
+
+	rtd->buffer_counter = 0;
+	rtd->dma_lock = 0;
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		/* TODO unnecessary */
+		local_ac97_write(0x2, 0x0000);
+
+	} else {
+		local_ac97_write(0x1A, 0);
+		local_ac97_write(0x1C, 0x0f0f);
+	}
+
+	rtd->params = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
+		client->playback_params : client->capture_params;
+	ret = puv3_request_dma(rtd->params->name, DMA_PRIO_HIGH,
+			     puv3_pcm_dma_irq, NULL, substream);
+	if (ret < 0)
+		goto err;
+	rtd->dma_ch = ret;
+
+	runtime->private_data = rtd;
+	ret = client->startup(substream);
+	if (!ret)
+		goto out;
+
+	puv3_free_dma(rtd->dma_ch);
+ err:
+	kfree(rtd);
+ out:
+	return ret;
+}
+
+static int puv3_pcm_close(struct snd_pcm_substream *substream)
+{
+	struct puv3_pcm_client *client = substream->private_data;
+	struct puv3_runtime_data *rtd = substream->runtime->private_data;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		local_ac97_write(0x1A, 0);
+		local_ac97_write(0x1C, 0x8000);
+	}
+
+	puv3_free_dma(rtd->dma_ch);
+	client->shutdown(substream);
+	kfree(rtd);
+
+	return 0;
+}
+
+static struct snd_pcm_ops puv3_pcm_ops = {
+	.open		= puv3_pcm_open,
+	.close		= puv3_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= puv3_pcm_hw_params,
+	.hw_free	= puv3_pcm_hw_free,
+	.prepare	= puv3_pcm_prepare,
+	.trigger	= puv3_pcm_trigger,
+	.pointer	= puv3_pcm_pointer,
+};
+
+static int puv3_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	size_t size = puv3_pcm_hardware.buffer_bytes_max;
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->area = dma_alloc_coherent(pcm->card->dev, size,
+					&buf->addr, GFP_KERNEL);
+	dma_cache_sync(pcm->card->dev, &buf->addr, size, DMA_BIDIRECTIONAL);
+	if (!buf->area)
+		return -ENOMEM;
+	buf->bytes = size;
+	return 0;
+}
+
+static void puv3_pcm_free_dma_buffers(struct snd_pcm *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+	int stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		substream = pcm->streams[stream].substream;
+		if (!substream)
+			continue;
+		buf = &substream->dma_buffer;
+		if (!buf->area)
+			continue;
+		dma_free_coherent(pcm->card->dev, buf->bytes,
+				buf->area, buf->addr);
+		buf->area = NULL;
+	}
+}
+
+static u64 puv3_pcm_dmamask = 0xffffffff;
+
+int puv3_pcm_new(struct snd_card *card, struct puv3_pcm_client *client,
+		struct snd_pcm **rpcm)
+{
+	struct snd_pcm *pcm;
+	int play = client->playback_params ? 1 : 0;
+	int capt = client->capture_params ? 1 : 0;
+	int ret;
+
+	ret = snd_pcm_new(card, "PKUNITY-PCM", 0, play, capt, &pcm);
+	if (ret)
+		goto out;
+
+	pcm->private_data = client;
+	pcm->private_free = puv3_pcm_free_dma_buffers;
+
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &puv3_pcm_dmamask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = 0xffffffff;
+
+	if (play) {
+		int stream = SNDRV_PCM_STREAM_PLAYBACK;
+		snd_pcm_set_ops(pcm, stream, &puv3_pcm_ops);
+		ret = puv3_pcm_preallocate_dma_buffer(pcm, stream);
+		if (ret)
+			goto out;
+	}
+	if (capt) {
+		int stream = SNDRV_PCM_STREAM_CAPTURE;
+		snd_pcm_set_ops(pcm, stream, &puv3_pcm_ops);
+		ret = puv3_pcm_preallocate_dma_buffer(pcm, stream);
+		if (ret)
+			goto out;
+	}
+
+	if (rpcm)
+		*rpcm = pcm;
+	ret = 0;
+
+ out:
+	return ret;
+}
+EXPORT_SYMBOL(puv3_pcm_new);
+
+MODULE_AUTHOR("ZHONG Qi");
+MODULE_DESCRIPTION("PKUNITY PCM DMA module");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/puv3/puv3_pcm.h b/drivers/staging/puv3/puv3_pcm.h
new file mode 100644
index 0000000..aa9be9b
--- /dev/null
+++ b/drivers/staging/puv3/puv3_pcm.h
@@ -0,0 +1,33 @@
+/*
+ * linux/drivers/staging/puv3/puv3_pcm.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: sound/arm/pxa2xx-pcm.h
+ *
+ * Contributors & Additions/Fixes:
+ *	2009-03-11: First version by ZHONG Qi
+ */
+
+struct puv3_pcm_dma_params {
+	char *name;			/* stream identifier */
+	u32 dev_addr;			/* device physical address for DMA */
+};
+
+struct puv3_pcm_client {
+	struct puv3_pcm_dma_params *playback_params;
+	struct puv3_pcm_dma_params *capture_params;
+	int (*startup)(struct snd_pcm_substream *);
+	void (*shutdown)(struct snd_pcm_substream *);
+	int (*prepare)(struct snd_pcm_substream *);
+};
+
+extern int puv3_pcm_new(struct snd_card *, struct puv3_pcm_client *,
+		struct snd_pcm **);
+extern void local_ac97_write(unsigned short, unsigned short);
+extern unsigned short local_ac97_read(unsigned short);
+extern unsigned short puv3_codec_regs[];
+extern int ac97_dma_ch;
+

> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Guan Xuetao
> Sent: Thursday, January 06, 2011 3:57 PM
> To: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCHv1 0/8] unicore32 machine related files: summary
> 
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> The whole patch could be fetched from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
>   with branch name: unicore32.
> And it is divided into  three patch sets: core architecture files,
>   additional architecture files, and machine related files.
> 
> This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC.
> 
> Patch 1 adds machine related  core files, also including build infrastructure.
> 
> Patch 2 add all hardware registers definitions, which are not split and inserted into
>  different drivers.
> 
> Patch 3 implements arch-specific pci bus driver.
> 
> Patch 4 implements arch-specific ps2 dirver.
> 
> Patch 5 implements frame buffer driver.
> 
> Patch 6 implements ac97 driver.
> 
> Patch 7 implements arch-specific i2c bus driver.
> 
> Patch 8 implements network driver.
> 
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
>  arch/unicore32/include/asm/mach/bitfield.h    |   24 +
>  arch/unicore32/include/asm/mach/hardware.h    |   45 +
>  arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
>  arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
>  arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
>  arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
>  arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
>  arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
>  arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
>  arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
>  arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
>  arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
>  arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
>  arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
>  arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
>  arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
>  arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
>  arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
>  arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
>  arch/unicore32/include/asm/pci.h              |   46 +
>  arch/unicore32/kernel/pci.c                   |  404 +++++
>  arch/unicore32/kernel/puv3-core.c             |  266 ++++
>  arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
>  arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
>  drivers/input/keyboard/Kconfig                |   11 +
>  drivers/input/keyboard/atkbd.c                |    4 +
>  drivers/input/mouse/psmouse-base.c            |   41 +
>  drivers/input/serio/i8042.h                   |    2 +
>  drivers/pci/Makefile                          |    1 +
>  drivers/staging/puv3/Kconfig                  |  142 ++
>  drivers/staging/puv3/Makefile                 |   27 +
>  drivers/staging/puv3/TODO                     |    7 +
>  drivers/staging/puv3/i8042-ucio.h             |   96 ++
>  drivers/staging/puv3/nb0916-atkbd.h           |   43 +
>  drivers/staging/puv3/puv3_ac97.c              |  383 +++++
>  drivers/staging/puv3/puv3_i2c.c               |  325 ++++
>  drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
>  drivers/staging/puv3/puv3_pcm.h               |   33 +
>  drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
>  drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
>  include/linux/fb.h                            |    2 +
>  42 files changed, 7254 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

