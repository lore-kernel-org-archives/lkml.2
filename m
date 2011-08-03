Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1HCXl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:41:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab1HCX1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:49 2011
Message-Id: <20110803221249.006674120@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [050/102] ALSA: virtuoso: fix silent analog output on Xonar Essence ST Deluxe
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit c81c6b356b52d3fcb4d531d149573fc100aad643 upstream.

Commit dd203fa97bd5 (ALSA: virtuoso: remove non-working controls on
Essence ST Deluxe) made it impossible to adjust the volume after the
driver initialized it to muted.

Ensure that those DACs that can be accessed with I2C are initialized
to the same volume that is the reset default of the DAC without I2C.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/xonar_pcm179x.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -327,8 +327,10 @@ static void pcm1796_init(struct oxygen *
 {
 	struct xonar_pcm179x *data = chip->model_data;
 
-	data->pcm1796_regs[0][18 - PCM1796_REG_BASE] = PCM1796_MUTE |
+	data->pcm1796_regs[0][18 - PCM1796_REG_BASE] =
 		PCM1796_DMF_DISABLED | PCM1796_FMT_24_I2S | PCM1796_ATLD;
+	if (!data->broken_i2c)
+		data->pcm1796_regs[0][18 - PCM1796_REG_BASE] |= PCM1796_MUTE;
 	data->pcm1796_regs[0][19 - PCM1796_REG_BASE] =
 		PCM1796_FLT_SHARP | PCM1796_ATS_1;
 	data->pcm1796_regs[0][20 - PCM1796_REG_BASE] =
@@ -1123,6 +1125,7 @@ int __devinit get_xonar_pcm179x_model(st
 			chip->model.control_filter = xonar_st_h6_control_filter;
 			chip->model.dac_channels_pcm = 8;
 			chip->model.dac_channels_mixer = 8;
+			chip->model.dac_volume_min = 255;
 			chip->model.dac_mclks = OXYGEN_MCLKS(256, 128, 128);
 			break;
 		}


