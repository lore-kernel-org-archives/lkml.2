Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1C1C3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:29:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:50938 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1C1C3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="725810263"
From: Lu Guanqun <guanqun.lu@intel.com>
To: meego-kernel@lists.meego.com
Cc: alan@linux.intel.com, arjan@linux.intel.com, fengguang.wu@intel.com,
        feng.tang@intel.com, michael.fu@intel.com, xingchao.wang@intel.com,
        vinod.koul@intel.com, jeeja.kp@intel.com,
        Lu Guanqun <guanqun.lu@intel.com>, Jeff Cheng <jeff_cheng@wistron.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ramesh Babu K V <ramesh.babu@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 2/2] sst: internal speaker needs setting a GPIO line
Date: Mon, 28 Mar 2011 10:29:20 +0800
Message-Id: <1301279360-9839-3-git-send-email-guanqun.lu@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
References: <1301279360-9839-1-git-send-email-guanqun.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch originates from Jeff Cheng's patch to enable the internal speaker.

On Moorestown platform, internal speaker's power line is connected to a GPIO
line, this information is got from SFI GPIO table, so we need set it to 1 to
enable the internal speaker, or set it to 0 to disable it.

When we set the output device, we power on or off the internal speaker on demand.

CC: "Koul, Vinod" <vinod.koul@intel.com>
CC: "Kp, Jeeja" <jeeja.kp@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jeff Cheng <jeff_cheng@wistron.com>
Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
---
 drivers/staging/intel_sst/Kconfig               |    2 +-
 drivers/staging/intel_sst/intel_sst.h           |    2 +
 drivers/staging/intel_sst/intelmid.c            |    4 ++
 drivers/staging/intel_sst/intelmid_v2_control.c |   35 ++++++++++++++++++++++-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/intel_sst/Kconfig b/drivers/staging/intel_sst/Kconfig
index b46bd9d..76d4b39 100644
--- a/drivers/staging/intel_sst/Kconfig
+++ b/drivers/staging/intel_sst/Kconfig
@@ -11,7 +11,7 @@ config SND_INTELMID
 	select SND_PCM
 	select SND_SEQUENCER
 	select SND_JACK
-	depends on SND_INTEL_SST
+	depends on SND_INTEL_SST && X86_MRST
 	default n
 	help
 	  Say Y here to include support for the Intel(R) MID sound card driver
diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index 986a3df..a68080c 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -120,6 +120,8 @@ struct snd_pmic_ops {
 	unsigned int hw_dmic_map[MFLD_MAX_HW_CH];
 	unsigned int available_dmics;
 	int (*set_hw_dmic_route) (u8 index);
+
+	unsigned gpio_speaker_power;
 };
 
 extern void sst_mad_send_jack_report(struct snd_jack *jack,
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 3071904..7927523 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -26,6 +26,7 @@
  */
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -945,6 +946,9 @@ static int snd_intelmad_remove(struct platform_device *pdev)
 	struct snd_intelmad *intelmaddata = platform_get_drvdata(pdev);
 
 	if (intelmaddata) {
+		if (intelmaddata->sstdrv_ops->scard_ops->gpio_speaker_power)
+			gpio_free(intelmaddata->sstdrv_ops->scard_ops->
+					gpio_speaker_power);
 		free_irq(intelmaddata->irq, intelmaddata);
 		snd_card_free(intelmaddata->card);
 	}
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 9cfcb52..243dcad 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -26,8 +26,10 @@
  *  This file contains the control operations of vendor 3
  */
 
+#include <linux/gpio.h>
 #include <linux/pci.h>
 #include <linux/file.h>
+#include <asm/mrst.h>
 #include <sound/control.h>
 #include "intel_sst.h"
 #include "intelmid_snd_control.h"
@@ -84,6 +86,12 @@ enum reg_v3 {
 	AUXDBNC = 0x12f,
 };
 
+static void nc_set_amp_power(int power)
+{
+	if (snd_pmic_ops_nc.gpio_speaker_power)
+		gpio_set_value(snd_pmic_ops_nc.gpio_speaker_power, power);
+}
+
 /****
  * nc_init_card - initilize the sound card
  *
@@ -91,6 +99,7 @@ enum reg_v3 {
  */
 static int nc_init_card(void)
 {
+	int pin;
 	struct sc_reg_access sc_access[] = {
 		{VAUDIOCNT, 0x25, 0},
 		{VOICEPORT1, 0x00, 0},
@@ -124,6 +133,13 @@ static int nc_init_card(void)
 	snd_pmic_ops_nc.master_mute = UNMUTE;
 	snd_pmic_ops_nc.mute_status = UNMUTE;
 	sst_sc_reg_access(sc_access, PMIC_WRITE, 27);
+
+	pin = mid_lookup_gpio("amp_shutdown");
+	if (pin < 0 ||
+	    gpio_request_one(pin, GPIOF_OUT_INIT_LOW, "speaker power"))
+		pin = 0;
+	snd_pmic_ops_nc.gpio_speaker_power = pin;
+
 	pr_debug("sst: init complete!!\n");
 	return 0;
 }
@@ -210,6 +226,16 @@ static int nc_power_up_pb(unsigned int port)
 
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
@@ -271,7 +297,6 @@ static int nc_power_down(void)
 	int retval = 0;
 	struct sc_reg_access sc_access[5];
 
-
 	if (snd_pmic_ops_nc.card_status == SND_CARD_UN_INIT)
 		retval = nc_init_card();
 	if (retval)
@@ -281,6 +306,11 @@ static int nc_power_down(void)
 
 	pr_debug("sst: powering dn nc_power_down ....\n");
 
+	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
+	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR) {
+		msleep(30);
+		nc_set_amp_power(0);
+	}
 	msleep(30);
 
 	sc_access[0].reg_addr = DRVPOWERCTRL;
@@ -516,9 +546,12 @@ static int nc_set_selected_output_dev(u8 value)
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
 		pr_err("sst: rcvd illegal request: %d\n", value);
-- 
1.7.2.3

