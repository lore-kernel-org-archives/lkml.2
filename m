Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1AJETh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 23:19:37 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:60498 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab1AJETg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 23:19:36 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 9C619A9DF8
From: =?iso-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] DVB Satellite Channel Routing support for DVB-S
Date: Mon, 10 Jan 2011 05:19:27 +0100
Message-Id: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net>
Cc: linux-kernel@vger.kernel.org
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first of all, I hope this is the correct destination and submission format for this type of patch as this is my first contribution here.

I have developed some modifications to the 2.6.37 DVB frontend code to support DVB satellite channel routing (aka "SCR", "Unicable", "EN50494"). Following this standard, all satellite tuners share the same cable and each of them has a fixed intermediate frequency it is supposed to tune to. Zapping is done by sending a special DiSEqC message while SEC voltage is temporarily pulled from 14 to 18 volts. This message includes the tuner's ID from 0 to 7, the frequency, band and polarisation to tune to as well as one out of two satellite positions.

I decided this should be supported by the kernel frontend code as it is impossible to send that special DiSEqC / voltage sequence from userspace. Additionally, it adds fully transparent support for SCR to arbitrary applications that use the DVB API, such as MythTV, VDR, xine etc.

I added an ioctl command and chose command ID 120, so it does not conflict with other patches. As far as I can see, any number above 83 should work, so you might want to change this in "dvb_frontend.c" if you decide to accept the patch. By default, all SCR-code is disabled and the frontend works as usual. You can use the new ioctl command to set up SCR parameters for each tuner. Afterwards, all commands to set up SEC or frequency parameters are intercepted and their values are stored to a new struct inside both the private frontend parameters and DTV cache. This struct is also bidirectionally synced between "private frontend parameters" and dtv_cache along with existing parameters. Before actually tuning the frontend, the tuning frequency will be set to the fixed SCR frequency and the DiSEqC message is generated instead of directly tuning to the requested frequency.

All modifications do compile without warnings and work flawlessly on my Core2 Duo (using AMD64-SMP) with Hauppauge Nova-S and Nova-SE2 (budget, s5h1420, cx88_dvb, cx24123).
My DVB source is an "Inverto IDLB-QUDL41-UNI2L-1PP" Unicable LNB.

Below I paste the kernel patch as well as an example userspace utility to use the code as the linuxtv-wiki says MIME-attachments are undesired. If anything else is required, please contact me.

Regards,
Thomas Schlöter


================= Kernel patch against 2.6.37

diff -uprN a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c	2011-01-05 01:50:19.000000000 +0100
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c	2011-01-10 03:56:58.000000000 +0100
@@ -9,6 +9,8 @@
  *
  * Copyright (C) 2004 Andrew de Quincey (tuning thread cleanup)
  *
+ * Copyright (C) 2011 Thomas Schloeter (satellite channel routing)
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
@@ -50,6 +52,8 @@ static int dvb_override_tune_delay;
 static int dvb_powerdown_on_sleep = 1;
 static int dvb_mfe_wait_time = 5;
 
+int scr_send_tune_cmd(struct dvb_frontend*);
+
 module_param_named(frontend_debug, dvb_frontend_debug, int, 0644);
 MODULE_PARM_DESC(frontend_debug, "Turn on/off frontend core debugging (default:off).");
 module_param(dvb_shutdown_timeout, int, 0644);
@@ -121,6 +125,9 @@ struct dvb_frontend_private {
 	int tone;
 	int voltage;
 
+	/* satellite channel routing */
+	struct dvb_scr_params dvbscr;
+
 	/* swzigzag values */
 	unsigned int state;
 	unsigned int bending;
@@ -1023,10 +1030,19 @@ static void dtv_property_cache_sync(stru
 				    struct dvb_frontend_parameters *p)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
 	c->frequency = p->frequency;
 	c->inversion = p->inversion;
 
+	c->dvbscr.scr_enable = fepriv->dvbscr.scr_enable;
+	c->dvbscr.scr_id = fepriv->dvbscr.scr_id;
+	c->dvbscr.scr_frequency = fepriv->dvbscr.scr_frequency;
+	c->dvbscr.scr_position = fepriv->dvbscr.scr_position;
+	c->dvbscr.scr_frequency_orig = fepriv->dvbscr.scr_frequency_orig;
+	c->dvbscr.scr_polarisation = fepriv->dvbscr.scr_polarisation;
+	c->dvbscr.scr_band = fepriv->dvbscr.scr_band;
+
 	switch (fe->ops.info.type) {
 	case FE_QPSK:
 		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
@@ -1081,6 +1097,14 @@ static void dtv_property_legacy_params_s
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
 
+	fepriv->dvbscr.scr_enable = c->dvbscr.scr_enable;
+	fepriv->dvbscr.scr_id = c->dvbscr.scr_id;
+	fepriv->dvbscr.scr_frequency = c->dvbscr.scr_frequency;
+	fepriv->dvbscr.scr_position = c->dvbscr.scr_position;
+	fepriv->dvbscr.scr_frequency_orig = c->dvbscr.scr_frequency_orig;
+	fepriv->dvbscr.scr_polarisation = c->dvbscr.scr_polarisation;
+	fepriv->dvbscr.scr_band = c->dvbscr.scr_band;
+
 	switch (fe->ops.info.type) {
 	case FE_QPSK:
 		dprintk("%s() Preparing QPSK req\n", __func__);
@@ -1136,6 +1160,14 @@ static void dtv_property_adv_params_sync
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
 
+	fepriv->dvbscr.scr_enable = c->dvbscr.scr_enable;
+	fepriv->dvbscr.scr_id = c->dvbscr.scr_id;
+	fepriv->dvbscr.scr_frequency = c->dvbscr.scr_frequency;
+	fepriv->dvbscr.scr_position = c->dvbscr.scr_position;
+	fepriv->dvbscr.scr_frequency_orig = c->dvbscr.scr_frequency_orig;
+	fepriv->dvbscr.scr_polarisation = c->dvbscr.scr_polarisation;
+	fepriv->dvbscr.scr_band = c->dvbscr.scr_band;
+
 	switch(c->modulation) {
 	case PSK_8:
 	case APSK_16:
@@ -1215,7 +1247,10 @@ static int dtv_property_process_get(stru
 
 	switch(tvp->cmd) {
 	case DTV_FREQUENCY:
-		tvp->u.data = fe->dtv_property_cache.frequency;
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			tvp->u.data = fe->dtv_property_cache.dvbscr.scr_frequency_orig;
+		else
+			tvp->u.data = fe->dtv_property_cache.frequency;
 		break;
 	case DTV_MODULATION:
 		tvp->u.data = fe->dtv_property_cache.modulation;
@@ -1242,10 +1277,18 @@ static int dtv_property_process_get(stru
 		tvp->u.data = fe->dtv_property_cache.delivery_system;
 		break;
 	case DTV_VOLTAGE:
-		tvp->u.data = fe->dtv_property_cache.voltage;
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			tvp->u.data = (fe->dtv_property_cache.dvbscr.scr_polarisation == SCR_POL_H) ?
+					SEC_VOLTAGE_18 : SEC_VOLTAGE_13;
+		else
+			tvp->u.data = fe->dtv_property_cache.voltage;
 		break;
 	case DTV_TONE:
-		tvp->u.data = fe->dtv_property_cache.sectone;
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			tvp->u.data = (fe->dtv_property_cache.dvbscr.scr_band == SCR_BAND_HI) ?
+					SEC_TONE_ON : SEC_TONE_OFF;
+		else
+			tvp->u.data = fe->dtv_property_cache.sectone;
 		break;
 	case DTV_API_VERSION:
 		tvp->u.data = (DVB_API_VERSION << 8) | DVB_API_VERSION_MINOR;
@@ -1342,8 +1385,12 @@ static int dtv_property_process_set(stru
 	dtv_property_dump(tvp);
 
 	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.set_property)
-		r = fe->ops.set_property(fe, tvp);
+	if ((fe->dtv_property_cache.dvbscr.scr_enable != SCR_ON) ||
+	    (tvp->cmd != DTV_FREQUENCY) ||
+	    (tvp->cmd != DTV_VOLTAGE) ||
+	    (tvp->cmd != DTV_TONE))
+		if (fe->ops.set_property)
+			r = fe->ops.set_property(fe, tvp);
 
 	if (r < 0)
 		return r;
@@ -1369,7 +1416,10 @@ static int dtv_property_process_set(stru
 			&fepriv->parameters);
 		break;
 	case DTV_FREQUENCY:
-		fe->dtv_property_cache.frequency = tvp->u.data;
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			fe->dtv_property_cache.dvbscr.scr_frequency_orig = tvp->u.data;
+		else
+			fe->dtv_property_cache.frequency = tvp->u.data;
 		break;
 	case DTV_MODULATION:
 		fe->dtv_property_cache.modulation = tvp->u.data;
@@ -1396,14 +1446,24 @@ static int dtv_property_process_set(stru
 		fe->dtv_property_cache.delivery_system = tvp->u.data;
 		break;
 	case DTV_VOLTAGE:
-		fe->dtv_property_cache.voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
-			(void *)fe->dtv_property_cache.voltage);
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			fe->dtv_property_cache.dvbscr.scr_polarisation =
+				(tvp->u.data == SEC_VOLTAGE_18) ? SCR_POL_H : SCR_POL_V;
+		else {
+			fe->dtv_property_cache.voltage = tvp->u.data;
+			r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+				(void *)fe->dtv_property_cache.voltage);
+		}
 		break;
 	case DTV_TONE:
-		fe->dtv_property_cache.sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
-			(void *)fe->dtv_property_cache.sectone);
+		if (fe->dtv_property_cache.dvbscr.scr_enable == SCR_ON)
+			fe->dtv_property_cache.dvbscr.scr_band =
+				(tvp->u.data == SEC_TONE_ON) ? SCR_BAND_HI : SCR_BAND_LO;
+		else {
+			fe->dtv_property_cache.sectone = tvp->u.data;
+			r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+				(void *)fe->dtv_property_cache.sectone);
+		}
 		break;
 	case DTV_CODE_RATE_HP:
 		fe->dtv_property_cache.code_rate_HP = tvp->u.data;
@@ -1610,6 +1670,7 @@ static int dvb_frontend_ioctl_legacy(str
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int cb_err, err = -EOPNOTSUPP;
+	u32 fe_freq_min, fe_freq_max;
 
 	if (fe->dvb->fe_ioctl_override) {
 		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
@@ -1681,6 +1742,11 @@ static int dvb_frontend_ioctl_legacy(str
 		break;
 
 	case FE_DISEQC_SEND_MASTER_CMD:
+		if (fepriv->dvbscr.scr_enable == SCR_ON) {
+			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
+			err = -EINVAL;
+			break;
+		}
 		if (fe->ops.diseqc_send_master_cmd) {
 			err = fe->ops.diseqc_send_master_cmd(fe, (struct dvb_diseqc_master_cmd*) parg);
 			fepriv->state = FESTATE_DISEQC;
@@ -1689,6 +1755,11 @@ static int dvb_frontend_ioctl_legacy(str
 		break;
 
 	case FE_DISEQC_SEND_BURST:
+		if (fepriv->dvbscr.scr_enable == SCR_ON) {
+			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
+			err = -EINVAL;
+			break;
+		}
 		if (fe->ops.diseqc_send_burst) {
 			err = fe->ops.diseqc_send_burst(fe, (fe_sec_mini_cmd_t) parg);
 			fepriv->state = FESTATE_DISEQC;
@@ -1696,10 +1767,67 @@ static int dvb_frontend_ioctl_legacy(str
 		}
 		break;
 
+	case FE_SET_SCR:
+		if (fe->ops.info.type != FE_QPSK) {
+			dprintk("DVB: %s: SCR is supported on QPSK frontends only!\n", __FUNCTION__);
+			err = -EINVAL;
+			break;
+		}
+		fepriv->dvbscr.scr_enable = ((struct dvb_scr_params *) parg)->scr_enable;
+		fepriv->dvbscr.scr_id = ((struct dvb_scr_params *) parg)->scr_id;
+		fepriv->dvbscr.scr_position = ((struct dvb_scr_params *) parg)->scr_position;
+		fepriv->dvbscr.scr_frequency = ((struct dvb_scr_params *) parg)->scr_frequency;
+		err = 0;
+		if ((fepriv->dvbscr.scr_enable != SCR_ON) && (fepriv->dvbscr.scr_enable != SCR_OFF)) {
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+			err = -EINVAL;
+			dprintk("DVB: %s: Invalid value for SCR_ON in ioctl\n", __FUNCTION__);
+		}
+		dvb_frontend_get_frequency_limits(fe, &fe_freq_min, &fe_freq_max);
+		if ((fepriv->dvbscr.scr_frequency < fe_freq_min / 1000) || (fepriv->dvbscr.scr_frequency > fe_freq_max / 1000)) {
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+			fepriv->dvbscr.scr_frequency = 1400;
+			err = -EINVAL;
+			dprintk("DVB: %s: Invalid value for SCR_FREQ in ioctl\n", __FUNCTION__);
+		}
+		if ((fepriv->dvbscr.scr_position != SCR_POS_A) && (fepriv->dvbscr.scr_position != SCR_POS_B)) {
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+			fepriv->dvbscr.scr_position = SCR_POS_A;
+			err = -EINVAL;
+			dprintk("DVB: %s: Invalid value for SCR_POSITION in ioctl\n", __FUNCTION__);
+		}
+		if (fepriv->dvbscr.scr_id > 7) {
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+			fepriv->dvbscr.scr_id = 0;
+			err = -EINVAL;
+			dprintk("DVB: %s: Invalid value for SCR_ID in ioctl\n", __FUNCTION__);
+		}
+		if (fe->ops.set_voltage)
+			fe->ops.set_voltage(fe, SEC_VOLTAGE_13);
+		else {
+			dprintk("DVB: %s: Set Voltage not supported. SCR not possible.\n", __FUNCTION__);
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+		}
+		if (fe->ops.set_tone)
+			fe->ops.set_tone(fe, SEC_TONE_OFF);
+		else {
+			dprintk("DVB: %s: Set Tone not supported. SCR not possible.\n", __FUNCTION__);
+			fepriv->dvbscr.scr_enable = SCR_OFF;
+		}
+		dtv_property_cache_sync(fe, &fepriv->parameters);
+		break;
+
 	case FE_SET_TONE:
 		if (fe->ops.set_tone) {
-			err = fe->ops.set_tone(fe, (fe_sec_tone_mode_t) parg);
-			fepriv->tone = (fe_sec_tone_mode_t) parg;
+			if (fepriv->dvbscr.scr_enable == SCR_ON) {
+				err = fe->ops.set_tone(fe, SEC_TONE_OFF);
+				fepriv->dvbscr.scr_band =
+					((fe_sec_tone_mode_t) parg == SEC_TONE_ON) ? SCR_BAND_HI : SCR_BAND_LO;
+			}
+			else {
+				err = fe->ops.set_tone(fe, (fe_sec_tone_mode_t) parg);
+				fepriv->tone = (fe_sec_tone_mode_t) parg;
+			}
 			fepriv->state = FESTATE_DISEQC;
 			fepriv->status = 0;
 		}
@@ -1707,14 +1835,26 @@ static int dvb_frontend_ioctl_legacy(str
 
 	case FE_SET_VOLTAGE:
 		if (fe->ops.set_voltage) {
-			err = fe->ops.set_voltage(fe, (fe_sec_voltage_t) parg);
-			fepriv->voltage = (fe_sec_voltage_t) parg;
+			if (fepriv->dvbscr.scr_enable == SCR_ON) {
+				err = fe->ops.set_voltage(fe, SEC_VOLTAGE_13);
+				fepriv->dvbscr.scr_polarisation =
+					((fe_sec_voltage_t) parg == SEC_VOLTAGE_18) ? SCR_POL_H : SCR_POL_V;
+			}
+			else {
+				err = fe->ops.set_voltage(fe, (fe_sec_voltage_t) parg);
+				fepriv->voltage = (fe_sec_voltage_t) parg;
+			}
 			fepriv->state = FESTATE_DISEQC;
 			fepriv->status = 0;
 		}
 		break;
 
 	case FE_DISHNETWORK_SEND_LEGACY_CMD:
+		if (fepriv->dvbscr.scr_enable == SCR_ON) {
+			dprintk("DVB: %s: Operation not available when SCR enabled\n", __FUNCTION__);
+			err = -EINVAL;
+			break;
+		}
 		if (fe->ops.dishnetwork_send_legacy_command) {
 			err = fe->ops.dishnetwork_send_legacy_command(fe, (unsigned long) parg);
 			fepriv->state = FESTATE_DISEQC;
@@ -1805,6 +1945,13 @@ static int dvb_frontend_ioctl_legacy(str
 			dtv_property_cache_sync(fe, &fepriv->parameters);
 		}
 
+		/* intercept tuning info and replace with SCR parameters */
+		if (fepriv->dvbscr.scr_enable == SCR_ON) {
+			fepriv->dvbscr.scr_frequency_orig = fepriv->parameters.frequency;
+			fepriv->parameters.frequency = (uint32_t) fepriv->dvbscr.scr_frequency * 1000;
+			scr_send_tune_cmd(fe);
+		}
+
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.parameters, parg,
 		       sizeof (struct dvb_frontend_parameters));
@@ -1877,6 +2024,10 @@ static int dvb_frontend_ioctl_legacy(str
 		if (fe->ops.get_frontend) {
 			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
+			if (fepriv->dvbscr.scr_enable == SCR_ON) {
+				((struct dvb_frontend_parameters*) parg)->frequency =
+					fepriv->dvbscr.scr_frequency_orig;
+			}
 		}
 		break;
 
@@ -2068,6 +2219,16 @@ int dvb_register_frontend(struct dvb_ada
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
+	/* initialize SCR parameters */
+	fepriv->dvbscr.scr_enable = SCR_OFF;
+	fepriv->dvbscr.scr_id = 0;
+	fepriv->dvbscr.scr_frequency = 1400;
+	fepriv->dvbscr.scr_position = SCR_POS_A;
+	fe->dtv_property_cache.dvbscr.scr_enable = SCR_OFF;
+	fe->dtv_property_cache.dvbscr.scr_id = 0;
+	fe->dtv_property_cache.dvbscr.scr_frequency = 1400;
+	fe->dtv_property_cache.dvbscr.scr_position = SCR_POS_A;
+
 	printk ("DVB: registering adapter %i frontend %i (%s)...\n",
 		fe->dvb->num,
 		fe->id,
@@ -2141,3 +2302,64 @@ void dvb_frontend_detach(struct dvb_fron
 }
 #endif
 EXPORT_SYMBOL(dvb_frontend_detach);
+
+int scr_send_tune_cmd(struct dvb_frontend * fe) {
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int err = 0;
+	struct timeval waketime;
+	struct dvb_diseqc_master_cmd tunecmd;
+	uint8_t channel_byte_1, channel_byte_2;
+	uint16_t frequency_calc;
+    
+	dprintk ("DVB: Tuning to %u, %s, %s using SCR. ID=%u, POS=%s, FREQ=%u\n",
+		fepriv->dvbscr.scr_frequency_orig,
+		((fepriv->dvbscr.scr_polarisation == SCR_POL_H) ? "H" : 
+		((fepriv->dvbscr.scr_polarisation == SCR_POL_V) ? "V" : "?")),
+		((fepriv->dvbscr.scr_band == SCR_BAND_HI) ? "HiBand" : "LoBand"),
+		fepriv->dvbscr.scr_id,
+		((fepriv->dvbscr.scr_position == SCR_POS_A) ? "A" : "B"),
+		fepriv->dvbscr.scr_frequency);             
+    
+	if (fepriv->dvbscr.scr_id > 7) {
+		dprintk ("DVB: %s - wrong SCR ID\n", __FUNCTION__);
+		fepriv->dvbscr.scr_id = 0;
+	}
+    
+	channel_byte_1 = (uint8_t) (fepriv->dvbscr.scr_id << 5);
+
+	if (fepriv->dvbscr.scr_position != SCR_POS_A)
+		channel_byte_1 |= (1 << 4);
+   
+	if (fepriv->dvbscr.scr_polarisation == SCR_POL_H)
+		channel_byte_1 |= (1 << 3);
+    
+	if (fepriv->dvbscr.scr_band == SCR_BAND_HI)
+		channel_byte_1 |= (1 << 2);
+            
+	if (fepriv->dvbscr.scr_frequency_orig == 0) {
+		dprintk ("DVB: %s - invalid SCR tuning\n", __FUNCTION__);
+	}
+    
+	frequency_calc = (uint16_t) ((((fepriv->dvbscr.scr_frequency_orig / 1000) + fepriv->dvbscr.scr_frequency) / 4) - 350);
+	channel_byte_1 |= (((uint8_t) (frequency_calc >> 8)) & 0x03);
+	channel_byte_2 = (uint8_t) (frequency_calc & 0x00FF);
+
+	// Send DiSEqC code E0 10 5A channel_byte_1 channel_byte_2
+	tunecmd.msg_len = 5;
+	tunecmd.msg[0] = 0xE0;
+	tunecmd.msg[1] = 0x10;
+	tunecmd.msg[2] = 0x5A;
+	tunecmd.msg[3] = channel_byte_1;
+	tunecmd.msg[4] = channel_byte_2;
+  
+	do_gettimeofday(&waketime);
+	if ((err = fe->ops.set_voltage(fe, SEC_VOLTAGE_18)) != 0) return err;
+	dvb_frontend_sleep_until(&waketime, 6000);
+	if ((err = fe->ops.diseqc_send_master_cmd(fe, &tunecmd)) != 0) return err;
+	do_gettimeofday(&waketime);
+	dvb_frontend_sleep_until(&waketime, 4000);
+	if ((err = fe->ops.set_voltage(fe, SEC_VOLTAGE_13)) != 0) return err;
+
+	return 0;
+}
+
diff -uprN a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h	2011-01-05 01:50:19.000000000 +0100
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h	2011-01-10 03:12:12.000000000 +0100
@@ -343,6 +343,9 @@ struct dtv_frontend_properties {
 
 	fe_delivery_system_t	delivery_system;
 
+	/* satellite channel routing */
+	struct dvb_scr_params	dvbscr;
+
 	/* ISDB-T specifics */
 	u8			isdbt_partial_reception;
 	u8			isdbt_sb_mode;
diff -uprN a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
--- a/include/linux/dvb/frontend.h	2011-01-05 01:50:19.000000000 +0100
+++ b/include/linux/dvb/frontend.h	2011-01-10 03:35:47.000000000 +0100
@@ -203,6 +203,36 @@ typedef enum fe_hierarchy {
 	HIERARCHY_AUTO
 } fe_hierarchy_t;
 
+/* satellite channel routing */
+typedef enum scr_status {
+	SCR_OFF,
+	SCR_ON
+} scr_status_t;
+
+typedef enum scr_positions {
+	SCR_POS_A,
+	SCR_POS_B
+} scr_position_t;
+
+typedef enum scr_polarisations {
+	SCR_POL_V,
+	SCR_POL_H
+} scr_polarisation_t;
+
+typedef enum scr_bands {
+	SCR_BAND_LO,
+	SCR_BAND_HI
+} scr_band_t;
+
+struct dvb_scr_params {
+	scr_status_t		scr_enable;		/* enable or disable SCR */
+	__u8			scr_id;			/* internal SCR id */
+	scr_position_t		scr_position;		/* SCR satellite position (A or B) */
+	__u32			scr_frequency;		/* SCR frequency we tune to */
+	__u32			scr_frequency_orig;	/* DVB frequency sent to router */
+	scr_polarisation_t	scr_polarisation;	/* DVB polarisation (replaces SEC voltage) */
+	scr_band_t		scr_band;		/* DVB band (replaces SEC tone) */
+};
 
 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
@@ -411,4 +441,7 @@ struct dtv_properties {
 
 #define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
 
+/* satellite channel routing */
+#define FE_SET_SCR                 _IOW('o', 120, struct dvb_scr_params)
+
 #endif /*_DVBFRONTEND_H_*/


================= End of file

================= Userspace utility (requires "frontend.h" from include/linux/dvb directory to compile):


/* dvb-scr-setup.c */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

/* It will take some time until new ioctls are available
 * from default include directories, so use our own copy
 * #include <linux/dvb/frontend.h> */
#include "frontend.h"

void showerr (int, const char *, const char *);

int main (int argc, char ** argv) {
    char frontend_devname [80];
    const int fe_open_mode;
    struct dvb_scr_params scrparms;    
    fe_status_t stat;
    int fd_frontend;
    int adapter = 0;
    int frontend = 0;
    int enable = -1;
    int frequency = 1400;
    int position = 0;
    int scrid = 0;
    int quiet = 0;
    int opt;

    while ((opt = getopt(argc, argv, "a:f:p:i:o:e:q")) != -1) {
        switch (opt) {
            case 'a':
                adapter = strtoul(optarg, NULL, 0);
                break;
            case 'f':
                frontend = strtoul(optarg, NULL, 0);
                break;
            case 'p':
                position = strtoul(optarg, NULL, 0);
                break;
            case 'i':
                scrid = strtoul(optarg, NULL, 0);
                break;
            case 'o':
                frequency = strtoul(optarg, NULL, 0);
                break;
            case 'e':
                enable = strtoul(optarg, NULL, 0);
                break;
            case 'q':
	    	quiet = 1;
		break;
            default:
                showerr (1, "Bad command line", argv[0]);
        };
    }
   
    if ((enable != 0) && (enable != 1)) showerr (1, "Bad value for -e", argv[0]);
    if ((frontend < 0) || (frontend > 8)) showerr (1, "Bad frontend ID", argv[0]);
    if ((adapter < 0) || (adapter > 8)) showerr (1, "Bad adapter ID", argv[0]);
    if ((position < 0) || (position > 1)) showerr (1, "Bad position", argv[0]);
    if ((scrid < 0) || (scrid > 7)) showerr (1, "Bad SCR ID", argv[0]);                                               
    if ((frequency < 950) || (frequency > 2150)) showerr (1, "Bad frequency", argv[0]);
    
    if (! quiet) {
        printf("DVB SCR Setup Tool by Thomas Schloeter\n\n");
	printf("Set DVB adapter %u, frontend %u to following values:\n", adapter, frontend);
	printf("\tSatellite Position:\t%s\n\tSCR-ID:\t\t\t%u\n\tSCR-Frequency:\t\t%u MHz\n\n", position ? "B" : "A", scrid, frequency);
    }

    snprintf (frontend_devname, sizeof(frontend_devname),
              "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
    
    if ((fd_frontend = open (frontend_devname, O_RDWR)) < 0) {
        fprintf (stderr, "ERROR: failed to open '%s': %s\n", frontend_devname, strerror(errno));
    	showerr (0, "No frontend device", argv[0]);
    }

    scrparms.scr_enable = (enable != 0) ? SCR_ON : SCR_OFF;
    scrparms.scr_id = scrid;
    scrparms.scr_position = (position == 0) ? SCR_POS_A : SCR_POS_B;
    scrparms.scr_frequency = frequency;
    
    if (ioctl(fd_frontend, FE_SET_SCR, &scrparms) < 0)
        fprintf (stderr, "ERROR: FE_SET_SCR failed: %s\n", strerror(errno));

    close (fd_frontend);
    
    return 0;
}

void showerr (int showusage, const char * msg, const char * progname) {
    fprintf (stderr, "ERROR: %s.\n\n", msg);
    if (showusage) {
        fprintf (stderr, "Usage: %s [-a <adapter>] [-f <frontend>] [-p <pos>] [-i <ID>] [-o <freq>] -e <0/1> [-q]\n\n", progname);
        fprintf (stderr, "\t-a <adapter>:\tDVB adapter number (optional, default: 0)\n");
        fprintf (stderr, "\t-f <frontend>:\tDVB frontend number (optional, default: 0)\n");
        fprintf (stderr, "\t-p <pos>:\tSCR satellite position [0: A, 1: B] (optional, default: 0)\n");
        fprintf (stderr, "\t-i <ID>:\tSCR participant ID [0-7] (optional, default = 0)\n");
        fprintf (stderr, "\t-o <freq>:\tSCR participant frequency [950-2150] (optional, default: 1400)\n");
        fprintf (stderr, "\t-q:\t\tQuiet operation\n");
        fprintf (stderr, "\t-e:\t\tEnable transparent SCR [0 | 1] (mandatory)\n");
    }
    exit (-1);
}

================= End of file

Signed-off-by: Thomas Schloeter <thomas.schloeter@gmx.net>
