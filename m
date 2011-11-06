Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1KFOgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 09:36:42 -0500
Received: from apfelkorn.psychaos.be ([195.144.77.38]:42099 "EHLO
	apfelkorn.psychaos.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1KFOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 09:36:41 -0500
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 09:36:41 EST
From: Peter De Schrijver <p2@psychaos.be>
To: p2@psychaos.be
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Verheyen <jeff.verheyen@ampersant.be>
Subject: [PATCH] bt8xx: add support for Tongwei Video Technology TD-3116
Date: Sun,  6 Nov 2011 16:15:47 +0200
Message-Id: <1320588947-9541-1-git-send-email-p2@psychaos.be>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds support for the Tongwei Video Technology TD-3116 board. This
is a Bt878 based capture card with 16 inputs meant for surveilance applications.
It also offers a way to check which inputs have a video signal while capturing another
input. In addition there are a number of alarm inputs and outputs available and there
is microcontroller which is presumably intended for use as a system watchdog. None of
these extra capabilities are supported by the patch.

Signed-off-by: Peter De Schrijver <p2@psychaos.be>
---
 drivers/media/video/bt8xx/bttv-cards.c |   49 ++++++++++++++++++++++++++++++++
 drivers/media/video/bt8xx/bttv.h       |    1 +
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 5939021..9ac71b89 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -80,6 +80,8 @@ static void phytec_muxsel(struct bttv *btv, unsigned int input);
 static void gv800s_muxsel(struct bttv *btv, unsigned int input);
 static void gv800s_init(struct bttv *btv);
 
+static void td3116_muxsel(struct bttv *btv, unsigned int input);
+
 static int terratec_active_radio_upgrade(struct bttv *btv);
 static int tea5757_read(struct bttv *btv);
 static int tea5757_write(struct bttv *btv, int value);
@@ -341,6 +343,7 @@ static struct CARD {
 	{ 0x15401835, BTTV_BOARD_PV183,         "Provideo PV183-6" },
 	{ 0x15401836, BTTV_BOARD_PV183,         "Provideo PV183-7" },
 	{ 0x15401837, BTTV_BOARD_PV183,         "Provideo PV183-8" },
+	{ 0x3116f200, BTTV_BOARD_TVT_TD3116,	"Tongwei Video Technology TD-3116" },
 
 	{ 0, -1, NULL }
 };
@@ -2879,6 +2882,16 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_type     = TUNER_ABSENT,
 		.tuner_addr	= ADDR_UNSET,
 	},
+	[BTTV_BOARD_TVT_TD3116] = {
+		.name           = "Tongwei Video Technology TD-3116",
+		.video_inputs   = 16,
+		.gpiomask       = 0xc00ff,
+		.muxsel         = MUXSEL(2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
+		.muxsel_hook    = td3116_muxsel,
+		.svhs           = NO_SVHS,
+		.pll		= PLL_28,
+		.tuner_type     = TUNER_ABSENT,
+	},
 };
 
 static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3228,6 +3241,42 @@ static void geovision_muxsel(struct bttv *btv, unsigned int input)
 	gpio_bits(0xf, inmux);
 }
 
+/*
+ * The TD3116 has 2 74HC4051 muxes wired to the MUX0 input of a bt878.
+ * The first 74HC4051 has the lower 8 inputs, the second one the higher 8.
+ * The muxes are controlled via a 74HC373 latch which is connected to
+ * GPIOs 0-7. GPIO 18 is connected to the LE signal of the latch.
+ * Q0 of the latch is connected to the Enable (~E) input of the first
+ * 74HC4051. Q1 - Q3 are connected to S0 - S2 of the same 74HC4051.
+ * Q4 - Q7 are connected to the second 74HC4051 in the same way.
+ */
+
+static void td3116_latch_value(struct bttv *btv, u32 value)
+{
+	gpio_bits((1<<18) | 0xff, value);
+	gpio_bits((1<<18) | 0xff, (1<<18) | value);
+	udelay(1);
+	gpio_bits((1<<18) | 0xff, value);
+}
+
+static void td3116_muxsel(struct bttv *btv, unsigned int input)
+{
+	u32 value;
+	u32 highbit;
+
+	highbit = (input & 0x8) >> 3 ;
+
+	/* Disable outputs and set value in the mux */
+	value = 0x11; /* Disable outputs */
+	value |= ((input & 0x7) << 1)  << (4 * highbit);
+	td3116_latch_value(btv, value);
+
+	/* Enable the correct output */
+	value &= ~0x11;
+	value |= ((highbit ^ 0x1) << 4) | highbit;
+	td3116_latch_value(btv, value);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static void bttv_reset_audio(struct bttv *btv)
diff --git a/drivers/media/video/bt8xx/bttv.h b/drivers/media/video/bt8xx/bttv.h
index c633359..32bca32 100644
--- a/drivers/media/video/bt8xx/bttv.h
+++ b/drivers/media/video/bt8xx/bttv.h
@@ -183,6 +183,7 @@
 #define BTTV_BOARD_GEOVISION_GV800S	   0x9d
 #define BTTV_BOARD_GEOVISION_GV800S_SL	   0x9e
 #define BTTV_BOARD_PV183                   0x9f
+#define BTTV_BOARD_TVT_TD3116		   0xa0
 
 
 /* more card-specific defines */
-- 
1.7.4.1

