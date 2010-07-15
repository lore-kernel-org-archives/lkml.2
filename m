Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab0GOSss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:48:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55964 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934268Ab0GOSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pfl3FxdlZmJ1QDlmb9p/r+kFyOyE4XK9gTW6YHS4pYhc6Cyp3suXJpAcxcHpjbk8ax
         u6MSGHFP0c53gEm2j+ARcmey56v56xIgssPis/8VliVXa4v7QBzXTXJX6W92FKp/K3NL
         vtAgNjOvmy47qnR9JQc47yqRIBt3voJa8Wlmo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eliot Blennerhassett <eblennerhassett@audioscience.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 8/8] sound: asihpi: fix sign bug
Date: Thu, 15 Jul 2010 22:48:19 +0400
Message-Id: <1279219700-12892-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bytes_per_sec is unsigned, so if snd_pcm_format_width() return error we
would not see it.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/pci/asihpi/asihpi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 91218f7..c80b0b8 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -460,6 +460,7 @@ static int snd_card_asihpi_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_card_asihpi *card = snd_pcm_substream_chip(substream);
 	int err;
 	u16 format;
+	int width;
 	unsigned int bytes_per_sec;
 
 	print_hwparams(params);
@@ -512,9 +513,10 @@ static int snd_card_asihpi_pcm_hw_params(struct snd_pcm_substream *substream,
 				dpcm->hpi_buffer_attached);
 	}
 	bytes_per_sec = params_rate(params) * params_channels(params);
-	bytes_per_sec *= snd_pcm_format_width(params_format(params));
+	width = snd_pcm_format_width(params_format(params));
+	bytes_per_sec *= width;
 	bytes_per_sec /= 8;
-	if (bytes_per_sec <= 0)
+	if (width < 0 || bytes_per_sec == 0)
 		return -EINVAL;
 
 	dpcm->bytes_per_sec = bytes_per_sec;
-- 
1.7.0.4

