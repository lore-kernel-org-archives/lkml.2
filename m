Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1ECQ7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:59:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57214 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab1ECQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:59:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 22/23] sst: internal speaker needs setting a GPIO line
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:43:40 +0100
Message-ID: <20110503163829.24853.78711.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

On Moorestown platform, internal speaker's power line is connected to a GPIO
line, so we need to enable or disable it properly.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jeff Cheng <jeff_cheng@wistron.com>
Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h           |    2 ++
 drivers/staging/intel_sst/intelmid.c            |   13 ++++++++++--
 drivers/staging/intel_sst/intelmid_v2_control.c |   25 ++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index 986a3df..635cf58 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -120,6 +120,8 @@ struct snd_pmic_ops {
 	unsigned int hw_dmic_map[MFLD_MAX_HW_CH];
 	unsigned int available_dmics;
 	int (*set_hw_dmic_route) (u8 index);
+
+	int gpio_amp;
 };
 
 extern void sst_mad_send_jack_report(struct snd_jack *jack,
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index cbe09f2..25656ad 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -40,6 +40,7 @@
 #include <sound/jack.h>
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
+#include <linux/gpio.h>
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
 #include "intel_sst_fw_ipc.h"
@@ -920,14 +921,20 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	ret_val = snd_intelmad_create(intelmaddata, card);
 	if (ret_val) {
 		pr_err("snd_intelmad_create failed\n");
-		goto set_pvt_data;;
+		goto set_pvt_data;
 	}
 	card->private_data = &intelmaddata;
 	snd_card_set_dev(card, &pdev->dev);
 	ret_val = snd_card_register(card);
 	if (ret_val) {
 		pr_err("snd_card_register failed\n");
-		goto set_pvt_data;;
+		goto set_pvt_data;
+	}
+	if (pdev->dev.platform_data) {
+		int gpio_amp = *(int *)pdev->dev.platform_data;
+		if (gpio_request_one(gpio_amp, GPIOF_OUT_INIT_LOW, "amp power"))
+			gpio_amp = 0;
+		intelmaddata->sstdrv_ops->scard_ops->gpio_amp = gpio_amp;
 	}
 
 	pr_debug("snd_intelmad_probe complete\n");
@@ -957,6 +964,8 @@ static int snd_intelmad_remove(struct platform_device *pdev)
 	struct snd_intelmad *intelmaddata = platform_get_drvdata(pdev);
 
 	if (intelmaddata) {
+		if (intelmaddata->sstdrv_ops->scard_ops->gpio_amp)
+			gpio_free(intelmaddata->sstdrv_ops->scard_ops->gpio_amp);
 		free_irq(intelmaddata->irq, intelmaddata);
 		snd_card_free(intelmaddata->card);
 	}
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index b19f51e..2dc6738 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -28,6 +28,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/gpio.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/file.h>
@@ -87,6 +88,12 @@ enum reg_v3 {
 	AUXDBNC = 0x12f,
 };
 
+static void nc_set_amp_power(int power)
+{
+	if (snd_pmic_ops_nc.gpio_amp)
+		gpio_set_value(snd_pmic_ops_nc.gpio_amp, power);
+}
+
 /****
  * nc_init_card - initialize the sound card
  *
@@ -213,6 +220,16 @@ static int nc_power_up_pb(unsigned int port)
 
 	msleep(30);
 
+	/*
+	 * There is a mismatch between Playback Sources and the enumerated
+	 * values of output sources.  This mismatch causes ALSA upper to send
+	 * Item 1 for Internal Speaker, but the expected enumeration is 2!  For
+	 * now, treat MONO_EARPIECE and INTERNAL_SPKR identically and power up
+	 * the needed resources
+	 */
+	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
+	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR)
+		nc_set_amp_power(1);
 	return nc_enable_audiodac(UNMUTE);
 
 }
@@ -274,7 +291,6 @@ static int nc_power_down(void)
 	int retval = 0;
 	struct sc_reg_access sc_access[5];
 
-
 	if (snd_pmic_ops_nc.card_status == SND_CARD_UN_INIT)
 		retval = nc_init_card();
 	if (retval)
@@ -284,6 +300,10 @@ static int nc_power_down(void)
 
 	pr_debug("powering dn nc_power_down ....\n");
 
+	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
+	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR)
+		nc_set_amp_power(0);
+
 	msleep(30);
 
 	sc_access[0].reg_addr = DRVPOWERCTRL;
@@ -519,9 +539,12 @@ static int nc_set_selected_output_dev(u8 value)
 	switch (value) {
 	case STEREO_HEADPHONE:
 		retval = sst_sc_reg_access(sc_access_HP, PMIC_WRITE, 2);
+		nc_set_amp_power(0);
 		break;
+	case MONO_EARPIECE:
 	case INTERNAL_SPKR:
 		retval = sst_sc_reg_access(sc_access_IS, PMIC_WRITE, 2);
+		nc_set_amp_power(1);
 		break;
 	default:
 		pr_err("rcvd illegal request: %d\n", value);

