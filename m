Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1KAQ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:26:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1KAQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:26:49 -0400
From: Taylor Hutt <thutt@chromium.org>
To: thutt@chromium.org
Cc: swarren@nvidia.com, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] asoc: tegra: wm8903: Simplify pin disconnect
Date: Tue,  1 Nov 2011 09:26:11 -0700
Message-Id: <1320164771-457-1-git-send-email-thutt@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note that this patch fails the kernel patch checker because
 the 'M' macro produces an error that it's value should be enclosed
 in parenthesis; this is not actually possible for this use & expansion.)

Detail

  This change is a simplification, both in implementation and for
  reasoning about whcih pins are connected and disconnected.

  The impetus for the change was the addition of new boards, and the
  difficulty in reasoning about the previous code to disconnect pins.

  Now, unless a connection is specified for the current board, the pin
  will be disconnected.

  A follow-on change will add the 'asymptote' board.

Testing

  Visual inspection from original code.
  Built kernel.

Signed-off-by: Taylor Hutt <thutt@chromium.org>
---
 sound/soc/tegra/tegra_wm8903.c |  146 ++++++++++++++++++++++++++++++++++------
 1 files changed, 125 insertions(+), 21 deletions(-)

diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 7766478..95a9a39 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -240,6 +240,130 @@ static const struct snd_kcontrol_new tegra_wm8903_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Int Spk"),
 };
 
+/* tegra_wm8903_disconnect_pins
+ *
+ *   Disconnect pins which are not actually connected.
+ *
+ *   This implementation is easy to reason about, easy to maintain,
+ *   and very easy to extend.
+ *
+ *   Unless specifically connected on a board, each pin will be marked
+ *   as disconnected.
+ *
+ *   Add a New Machine
+ *
+ *      Add new machine by adding elements to the MACHINES macro.
+ *
+ *   Add a new Pin:
+ *
+ *      Insert the pin name into the 'wm8903_connected_pins' array.
+ *      See 'Connect a Pin' to connect the pin.
+ *
+ *   Connect a Pin:
+ *
+ *      To connect a pin on a particular machine, use the CONNECT()
+ *      macro.
+ *
+ *  Note: There is one distasteful artifact in this system, which I
+ *        believe is acceptable due to the other advantages (listed
+ *        above) of this implementation.  Notably, the expansion of
+ *        'MACHINES' in the assignment to 'disconnect' below looks
+ *        like syntactically incorrect code.
+ */
+static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
+					 struct snd_soc_dapm_context *dapm)
+{
+#define MACHINES                               \
+	M(aebl)                                 \
+	M(harmony)                              \
+	M(kaen)                                 \
+	M(seaboard)                             \
+	M(ventana)
+
+#define M(_x) mn_##_x,
+	enum machine_names {
+		MACHINES
+		N_MACHINES
+	};
+#undef M
+	static const struct wm8903_connected_pins {
+		const char *name;
+		bool connected[N_MACHINES];
+	} pins[] = {
+#define CONNECT(_machine) .connected[mn_##_machine] = true
+		{
+			.name = "IN1L",
+			CONNECT(harmony),
+			CONNECT(ventana),
+		},
+		{
+			.name = "IN1R",
+			CONNECT(seaboard),
+			CONNECT(aebl),
+		},
+		{
+			.name = "IN2L",
+		},
+		{
+			.name = "IN2R",
+			CONNECT(kaen),
+		},
+		{
+			.name = "IN3L",
+		},
+		{
+			.name = "IN3R",
+		},
+		{
+			.name = "LON",
+			CONNECT(harmony),
+			CONNECT(ventana),
+			CONNECT(seaboard),
+			CONNECT(kaen),
+		},
+		{
+			.name = "RON",
+			CONNECT(harmony),
+			CONNECT(ventana),
+			CONNECT(seaboard),
+			CONNECT(kaen),
+		},
+		{
+			.name = "ROP",
+			CONNECT(harmony),
+			CONNECT(ventana),
+			CONNECT(seaboard),
+			CONNECT(kaen),
+		},
+		{
+			.name = "LOP",
+			CONNECT(harmony),
+			CONNECT(ventana),
+			CONNECT(seaboard),
+			CONNECT(kaen),
+		},
+		{
+			.name = "LINEOUTR",
+			CONNECT(aebl),
+		},
+		{
+			.name = "LINEOUTL",
+			CONNECT(aebl),
+		},
+#undef CONNECT
+	};
+	unsigned i;
+
+	/* FIXME: Calculate automatically based on DAPM routes? */
+	for (i = 0; i < ARRAY_SIZE(pins); ++i) {
+#define M(_x) || (machine_is_##_x() && !pins[i].connected[mn_##_x])
+		const bool disconnect = false MACHINES;
+		if (disconnect)
+			snd_soc_dapm_nc_pin(dapm, pins[i].name);
+#undef M
+	}
+}
+
 static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
@@ -318,27 +442,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 
 	snd_soc_dapm_force_enable_pin(dapm, "Mic Bias");
 
-	/* FIXME: Calculate automatically based on DAPM routes? */
-	if (!machine_is_harmony() && !machine_is_ventana())
-		snd_soc_dapm_nc_pin(dapm, "IN1L");
-	if (!machine_is_seaboard() && !machine_is_aebl())
-		snd_soc_dapm_nc_pin(dapm, "IN1R");
-	snd_soc_dapm_nc_pin(dapm, "IN2L");
-	if (!machine_is_kaen())
-		snd_soc_dapm_nc_pin(dapm, "IN2R");
-	snd_soc_dapm_nc_pin(dapm, "IN3L");
-	snd_soc_dapm_nc_pin(dapm, "IN3R");
-
-	if (machine_is_aebl()) {
-		snd_soc_dapm_nc_pin(dapm, "LON");
-		snd_soc_dapm_nc_pin(dapm, "RON");
-		snd_soc_dapm_nc_pin(dapm, "ROP");
-		snd_soc_dapm_nc_pin(dapm, "LOP");
-	} else {
-		snd_soc_dapm_nc_pin(dapm, "LINEOUTR");
-		snd_soc_dapm_nc_pin(dapm, "LINEOUTL");
-	}
-
+	tegra_wm8903_disconnect_pins(card, dapm);
 	snd_soc_dapm_sync(dapm);
 
 	return 0;
-- 
1.7.3.1

