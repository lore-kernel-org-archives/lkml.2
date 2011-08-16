Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1HPCvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab1HPCvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:08 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024454.971146052@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [19/26] ASoC: Tegra: wm8903 machine driver: Allow re-insertion of
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 module

From: Stephen Warren <swarren@nvidia.com>

commit 29591ed4ac6fe00e3ff23b5be0cdc7016ef9c47e upstream.

Two issues were preventing module snd-soc-tegra-wm8903.ko from being
removed and re-inserted:

a) The speaker-enable GPIO is hosted by the WM8903 chip. This GPIO must
   be freed before snd_soc_unregister_card() is called, because that
   triggers wm8903.c:wm8903_remove(), which calls gpiochip_remove(), which
   then fails if any of the GPIOs are in use. To solve this, free all GPIOs
   first, so the code doesn't care where they come from.

b) We need to call snd_soc_jack_free_gpios() to match the call to
   snd_soc_jack_add_gpios() during initialization. Without this, the
   call to snd_soc_jack_add_gpios() fails during any subsequent modprobe
   and initialization, since the GPIO and IRQ are already registered. In
   turn, this causes the headphone state not to be monitored, so the
   headphone is assumed not to be plugged in, and the audio path to it is
   never enabled.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/tegra/tegra_wm8903.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -56,6 +56,7 @@
 #define GPIO_HP_MUTE    BIT(1)
 #define GPIO_INT_MIC_EN BIT(2)
 #define GPIO_EXT_MIC_EN BIT(3)
+#define GPIO_HP_DET     BIT(4)
 
 struct tegra_wm8903 {
 	struct tegra_asoc_utils_data util_data;
@@ -304,6 +305,7 @@ static int tegra_wm8903_init(struct snd_
 		snd_soc_jack_add_gpios(&tegra_wm8903_hp_jack,
 					1,
 					&tegra_wm8903_hp_jack_gpio);
+		machine->gpio_requested |= GPIO_HP_DET;
 	}
 
 	snd_soc_jack_new(codec, "Mic Jack", SND_JACK_MICROPHONE,
@@ -429,10 +431,10 @@ static int __devexit tegra_wm8903_driver
 	struct tegra_wm8903 *machine = snd_soc_card_get_drvdata(card);
 	struct tegra_wm8903_platform_data *pdata = machine->pdata;
 
-	snd_soc_unregister_card(card);
-
-	tegra_asoc_utils_fini(&machine->util_data);
-
+	if (machine->gpio_requested & GPIO_HP_DET)
+		snd_soc_jack_free_gpios(&tegra_wm8903_hp_jack,
+					1,
+					&tegra_wm8903_hp_jack_gpio);
 	if (machine->gpio_requested & GPIO_EXT_MIC_EN)
 		gpio_free(pdata->gpio_ext_mic_en);
 	if (machine->gpio_requested & GPIO_INT_MIC_EN)
@@ -441,6 +443,11 @@ static int __devexit tegra_wm8903_driver
 		gpio_free(pdata->gpio_hp_mute);
 	if (machine->gpio_requested & GPIO_SPKR_EN)
 		gpio_free(pdata->gpio_spkr_en);
+	machine->gpio_requested = 0;
+
+	snd_soc_unregister_card(card);
+
+	tegra_asoc_utils_fini(&machine->util_data);
 
 	kfree(machine);
 


