Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab1IONAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:00:04 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42979 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933716Ab1IOM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:59:59 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 4/8] Input: twl6040-vibra: Check the selected path for vibra
Date: Thu, 15 Sep 2011 15:59:17 +0300
Message-Id: <1316091561-30899-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIBSELL/R bit in the VIBCTLL/R register tells the source of the data,
which is going to be used to drive the attached motor(s).
Do not allow effect execution if any of the channels are set to receive
audio data.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index cb74185..fe624f2 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -201,6 +201,13 @@ static int vibra_play(struct input_dev *input, void *data,
 	struct vibra_info *info = input_get_drvdata(input);
 	int ret;
 
+	/* Do not allow effect, while the routing is set to use audio */
+	ret = twl6040_get_vibralr_status(info->twl6040);
+	if (ret & TWL6040_VIBSEL) {
+		dev_info(&input->dev, "Vibra is configured for audio\n");
+		return -EPERM;
+	}
+
 	info->weak_speed = effect->u.rumble.weak_magnitude;
 	info->strong_speed = effect->u.rumble.strong_magnitude;
 	info->direction = effect->direction < EFFECT_DIR_180_DEG ? 1 : -1;
-- 
1.7.6.1

