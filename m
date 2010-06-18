Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0FRC4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:56:21 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:60495 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188Ab0FRC4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:56:19 -0400
From: Stuart Longland <redhatter@gentoo.org>
To: ALSA Development List <alsa-devel@alsa-project.org>
Cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: Fix overflow bug in SOC_DOUBLE_R_SX_TLV
Date: Fri, 18 Jun 2010 12:56:10 +1000
Message-Id: <1276829770-31557-1-git-send-email-redhatter@gentoo.org>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <20100618023810.GS7759@www.longlandclan.yi.org>
References: <20100618023810.GS7759@www.longlandclan.yi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SX_TLV widgets are read, if the gain is set to a value below 0dB,
the mixer control is erroniously read as being at maximum volume.

The value read out of the CODEC register is never sign-extended, and
when the minimum value is subtracted (read; added, since the minimum is
negative) the result is a number greater than the maximum allowed value
for the control, and hence it saturates.

Solution: Mask the result so that it "wraps around", emulating
sign-extension.

Signed-off-by: Stuart Longland <redhatter@gentoo.org>
---
 sound/soc/soc-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a82a797..0470288 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2400,8 +2400,8 @@ int snd_soc_get_volsw_2r_sx(struct snd_kcontrol *kcontrol,
 	int val = snd_soc_read(codec, mc->reg) & mask;
 	int valr = snd_soc_read(codec, mc->rreg) & mask;
 
-	ucontrol->value.integer.value[0] = ((val & 0xff)-min);
-	ucontrol->value.integer.value[1] = ((valr & 0xff)-min);
+	ucontrol->value.integer.value[0] = ((val & 0xff)-min) & mask;
+	ucontrol->value.integer.value[1] = ((valr & 0xff)-min) & mask;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_get_volsw_2r_sx);
-- 
1.6.4.4

