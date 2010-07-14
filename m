Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0GNNVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:21:19 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45164 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756779Ab0GNNVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:16 -0400
Date: Wed, 14 Jul 2010 15:21:13 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Olivier Grenie <Olivier.Grenie@dibcom.fr>,
        =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/4] drivers/media/dvb: Remove dead Configs
Message-ID: <1ad6738d1051d8b25118c95ea74c4ea67b375e39.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following flags were checked, but never set anywhere, therefore
removing all references from the source code:

CONFIG_BAND_SBAND
CONFIG_BAND_LBAND
CONFIG_STANDARD_DAB
CONFIG_STANDARD_DVBT
CONFIG_TUNER_DIB0090_P1B_SUPPORT
CONFIG_TUNER_DIB0090_CPTURIM_MEMORY
FIREFLY_FIRMWARE

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/media/dvb/frontends/dib0090.c |   84 ---------------------------------
 1 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb/frontends/dib0090.c
index 65240b7..c54ce31 100644
--- a/drivers/media/dvb/frontends/dib0090.c
+++ b/drivers/media/dvb/frontends/dib0090.c
@@ -190,12 +190,6 @@ static u16 dib0090_identify(struct dvb_frontend *fe)
 
 	v = dib0090_read_reg(state, 0x1a);
 
-#ifdef FIRMWARE_FIREFLY
-	/* pll is not locked locked */
-	if (!(v & 0x800))
-		dprintk("FE%d : Identification : pll is not yet locked", fe->id);
-#endif
-
 	/* without PLL lock info */
 	v &= 0x3ff;
 	dprintk("P/V: %04x:", v);
@@ -223,13 +217,8 @@ static u16 dib0090_identify(struct dvb_frontend *fe)
 	else if ((v & 0x1f) == 0x1)
 		dprintk("FE%d : P1C detected", fe->id);
 	else if ((v & 0x1f) == 0x0) {
-#ifdef CONFIG_TUNER_DIB0090_P1B_SUPPORT
-		dprintk("FE%d : P1-A/B detected: using previous driver - support will be removed soon", fe->id);
-		dib0090_p1b_register(fe);
-#else
 		dprintk("FE%d : P1-A/B detected: driver is deactivated - not available", fe->id);
 		return 0xff;
-#endif
 	}
 
 	return v;
@@ -424,12 +413,10 @@ static void dib0090_wbd_target(struct dib0090_state *state, u32 rf)
 
 	if (state->current_band == BAND_VHF)
 		offset = 650;
-#ifndef FIRMWARE_FIREFLY
 	if (state->current_band == BAND_VHF)
 		offset = state->config->wbd_vhf_offset;
 	if (state->current_band == BAND_CBAND)
 		offset = state->config->wbd_cband_offset;
-#endif
 
 	state->wbd_target = dib0090_wbd_to_db(state, state->wbd_offset + offset);
 	dprintk("wbd-target: %d dB", (u32) state->wbd_target);
@@ -589,12 +576,6 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 	/* reset the AGC */
 
 	if (state->config->use_pwm_agc) {
-#ifdef CONFIG_BAND_SBAND
-		if (state->current_band == BAND_SBAND) {
-			dib0090_set_rframp_pwm(state, rf_ramp_pwm_sband);
-			dib0090_set_bbramp_pwm(state, bb_ramp_pwm_boost);
-		} else
-#endif
 #ifdef CONFIG_BAND_CBAND
 		if (state->current_band == BAND_CBAND) {
 			dib0090_set_rframp_pwm(state, rf_ramp_pwm_cband);
@@ -636,12 +617,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 		state->agc_freeze = 0;
 		dib0090_write_reg(state, 0x04, 0x0);
 
-#ifdef CONFIG_BAND_SBAND
-		if (state->current_band == BAND_SBAND) {
-			dib0090_set_rframp(state, rf_ramp_sband);
-			dib0090_set_bbramp(state, bb_ramp_boost);
-		} else
-#endif
 #ifdef CONFIG_BAND_VHF
 		if (state->current_band == BAND_VHF) {
 			dib0090_set_rframp(state, rf_ramp_vhf);
@@ -698,15 +673,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 			adc = (adc * ((s32) 355774) + (((s32) 1) << 20)) >> 21;	/* included in [0:-700] */
 
 			adc_error = (s16) (((s32) ADC_TARGET) - adc);
-#ifdef CONFIG_STANDARD_DAB
-			if (state->fe->dtv_property_cache.delivery_system == STANDARD_DAB)
-				adc_error += 130;
-#endif
-#ifdef CONFIG_STANDARD_DVBT
-			if (state->fe->dtv_property_cache.delivery_system == STANDARD_DVBT &&
-			    (state->fe->dtv_property_cache.modulation == QAM_64 || state->fe->dtv_property_cache.modulation == QAM_16))
-				adc_error += 60;
-#endif
 #ifdef CONFIG_SYS_ISDBT
 			if ((state->fe->dtv_property_cache.delivery_system == SYS_ISDBT) && (((state->fe->dtv_property_cache.layer[0].segment_count >
 											       0)
@@ -738,13 +704,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 
 			if (*tune_state == CT_AGC_STEP_1) {	/* quickly go to the correct range of the ADC power */
 				if (ABS(adc_error) < 50 || state->agc_step++ > 5) {
-
-#ifdef CONFIG_STANDARD_DAB
-					if (state->fe->dtv_property_cache.delivery_system == STANDARD_DAB) {
-						dib0090_write_reg(state, 0x02, (1 << 15) | (15 << 11) | (31 << 6) | (63));	/* cap value = 63 : narrow BB filter : Fc = 1.8MHz */
-						dib0090_write_reg(state, 0x04, 0x0);
-					} else
-#endif
 					{
 						dib0090_write_reg(state, 0x02, (1 << 15) | (3 << 11) | (6 << 6) | (32));
 						dib0090_write_reg(state, 0x04, 0x01);	/*0 = 1KHz ; 1 = 150Hz ; 2 = 50Hz ; 3 = 50KHz ; 4 = servo fast */
@@ -860,11 +819,6 @@ static int dib0090_reset(struct dvb_frontend *fe)
 		dib0090_set_EFUSE(state);
 #endif
 
-#ifdef CONFIG_TUNER_DIB0090_P1B_SUPPORT
-	if (!(state->revision & 0x1))	/* it is P1B - reset is already done */
-		return 0;
-#endif
-
 	/* Upload the default values */
 	n = (u16 *) dib0090_defaults;
 	l = pgm_read_word(n++);
@@ -1117,12 +1071,6 @@ static const struct dib0090_pll dib0090_pll_table[] = {
 	{700000, 0, 2, 4, 4},
 	{860000, 1, 2, 4, 4},
 #endif
-#ifdef CONFIG_BAND_LBAND
-	{1800000, 1, 0, 2, 4},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2900000, 0, 14, 1, 4},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table_fm_vhf_on_cband[] = {
@@ -1140,15 +1088,6 @@ static const struct dib0090_tuning dib0090_tuning_table_fm_vhf_on_cband[] = {
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 #endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table[] = {
@@ -1169,15 +1108,6 @@ static const struct dib0090_tuning dib0090_tuning_table[] = {
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 #endif
-#ifdef CONFIG_BAND_LBAND
-	{1500000, 4, 0, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1600000, 4, 1, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-	{1800000, 4, 3, 20, 0x300, 0x1912, 0x82c9, EN_LBD},
-#endif
-#ifdef CONFIG_BAND_SBAND
-	{2300000, 1, 4, 20, 0x300, 0x2d2A, 0x82c7, EN_SBD},
-	{2900000, 1, 7, 20, 0x280, 0x2deb, 0x8347, EN_SBD},
-#endif
 };
 
 #define WBD     0x781		/* 1 1 1 1 0000 0 0 1 */
@@ -1295,10 +1225,6 @@ static int dib0090_tune(struct dvb_frontend *fe)
 					lo6 |= (1 << 2) | 1;
 				Den = 255;
 			}
-#ifdef CONFIG_BAND_SBAND
-			if (state->current_band == BAND_SBAND)
-				lo6 &= 0xfffb;
-#endif
 
 			dib0090_write_reg(state, 0x15, (u16) FBDiv);
 
@@ -1377,10 +1303,6 @@ static int dib0090_tune(struct dvb_frontend *fe)
 		/*write the final cptrim config */
 		dib0090_write_reg(state, 0x18, lo4 | state->fcaptrim);
 
-#ifdef CONFIG_TUNER_DIB0090_CAPTRIM_MEMORY
-		state->memory[state->memory_index].cap = state->fcaptrim;
-#endif
-
 		*tune_state = CT_TUNER_STEP_4;
 	} else if (*tune_state == CT_TUNER_STEP_4) {
 		dib0090_write_reg(state, 0x1e, 0x07ff);
@@ -1396,12 +1318,6 @@ static int dib0090_tune(struct dvb_frontend *fe)
 
 		c = 4;
 		i = 3;
-#if defined(CONFIG_BAND_LBAND) || defined(CONFIG_BAND_SBAND)
-		if ((state->current_band == BAND_LBAND) || (state->current_band == BAND_SBAND)) {
-			c = 2;
-			i = 2;
-		}
-#endif
 		dib0090_write_reg(state, 0x10, (c << 13) | (i << 11) | (WBD
 #ifdef CONFIG_DIB0090_USE_PWM_AGC
 									| (state->config->use_pwm_agc << 1)
-- 
1.7.0.4

