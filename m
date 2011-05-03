Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1ECQ7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:59:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57216 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1ECQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:59:30 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 23/23] intel_sst: fix output noises when it's not in playback
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:43:53 +0100
Message-ID: <20110503164351.24853.11663.stgit@bob.linux.org.uk>
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

When the corresponding output device is not in playback, we can hear a little
noises.

Fix it by powering on the device only when it's in playback.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h           |    1 +
 drivers/staging/intel_sst/intelmid_v2_control.c |   33 +++++++++++++++++------
 2 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index 635cf58..4ad2829 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -84,6 +84,7 @@ struct snd_pmic_ops {
 	int num_channel;
 	int input_dev_id;
 	int mute_status;
+	struct mutex lock;
 	int pb_on, pbhs_on;
 	int cap_on;
 	int output_dev_id;
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 2dc6738..000378a 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -134,6 +134,7 @@ static int nc_init_card(void)
 	snd_pmic_ops_nc.master_mute = UNMUTE;
 	snd_pmic_ops_nc.mute_status = UNMUTE;
 	sst_sc_reg_access(sc_access, PMIC_WRITE, 27);
+	mutex_init(&snd_pmic_ops_nc.lock);
 	pr_debug("init complete!!\n");
 	return 0;
 }
@@ -180,6 +181,7 @@ static int nc_power_up_pb(unsigned int port)
 		return retval;
 	if (port == 0xFF)
 		return 0;
+	mutex_lock(&snd_pmic_ops_nc.lock);
 	nc_enable_audiodac(MUTE);
 	msleep(30);
 
@@ -220,6 +222,8 @@ static int nc_power_up_pb(unsigned int port)
 
 	msleep(30);
 
+	snd_pmic_ops_nc.pb_on = 1;
+
 	/*
 	 * There is a mismatch between Playback Sources and the enumerated
 	 * values of output sources.  This mismatch causes ALSA upper to send
@@ -230,8 +234,9 @@ static int nc_power_up_pb(unsigned int port)
 	if (snd_pmic_ops_nc.output_dev_id == MONO_EARPIECE ||
 	    snd_pmic_ops_nc.output_dev_id == INTERNAL_SPKR)
 		nc_set_amp_power(1);
-	return nc_enable_audiodac(UNMUTE);
-
+	nc_enable_audiodac(UNMUTE);
+	mutex_unlock(&snd_pmic_ops_nc.lock);
+	return 0;
 }
 
 static int nc_power_up_cp(unsigned int port)
@@ -352,7 +357,7 @@ static int nc_power_down_pb(unsigned int device)
 		return retval;
 
 	pr_debug("powering dn pb....\n");
-
+	mutex_lock(&snd_pmic_ops_nc.lock);
 	nc_enable_audiodac(MUTE);
 
 
@@ -379,9 +384,11 @@ static int nc_power_down_pb(unsigned int device)
 
 	msleep(30);
 
-	return nc_enable_audiodac(UNMUTE);
-
+	snd_pmic_ops_nc.pb_on = 0;
 
+	nc_enable_audiodac(UNMUTE);
+	mutex_unlock(&snd_pmic_ops_nc.lock);
+	return 0;
 }
 
 static int nc_power_down_cp(unsigned int device)
@@ -522,11 +529,13 @@ static int nc_set_selected_output_dev(u8 value)
 {
 	struct sc_reg_access sc_access_HP[] = {
 		{LMUTE, 0x02, 0x06},
-		{RMUTE, 0x02, 0x06}
+		{RMUTE, 0x02, 0x06},
+		{DRVPOWERCTRL, 0x06, 0x06},
 	};
 	struct sc_reg_access sc_access_IS[] = {
 		{LMUTE, 0x04, 0x06},
-		{RMUTE, 0x04, 0x06}
+		{RMUTE, 0x04, 0x06},
+		{DRVPOWERCTRL, 0x00, 0x06},
 	};
 	int retval = 0;
 
@@ -536,20 +545,26 @@ static int nc_set_selected_output_dev(u8 value)
 	if (retval)
 		return retval;
 	pr_debug("nc set selected output:%d\n", value);
+	mutex_lock(&snd_pmic_ops_nc.lock);
 	switch (value) {
 	case STEREO_HEADPHONE:
+		if (snd_pmic_ops_nc.pb_on)
+			sst_sc_reg_access(sc_access_HP+2, PMIC_WRITE, 1);
 		retval = sst_sc_reg_access(sc_access_HP, PMIC_WRITE, 2);
 		nc_set_amp_power(0);
 		break;
 	case MONO_EARPIECE:
 	case INTERNAL_SPKR:
-		retval = sst_sc_reg_access(sc_access_IS, PMIC_WRITE, 2);
-		nc_set_amp_power(1);
+		retval = sst_sc_reg_access(sc_access_IS, PMIC_WRITE, 3);
+		if (snd_pmic_ops_nc.pb_on)
+			nc_set_amp_power(1);
 		break;
 	default:
 		pr_err("rcvd illegal request: %d\n", value);
+		mutex_unlock(&snd_pmic_ops_nc.lock);
 		return -EINVAL;
 	}
+	mutex_unlock(&snd_pmic_ops_nc.lock);
 	return retval;
 }
 

