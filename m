Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2JNTLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:11:07 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:50031 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440Ab2JNTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:11:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 5/5] snd-ice1712: Fix resume on ice1724
Date: Sun, 14 Oct 2012 21:09:23 +0200
Message-Id: <1350241763-7248-6-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350241763-7248-1-git-send-email-linux@rainbow-software.org>
References: <1350241763-7248-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_pro_rate() is called from hw_params() but not from prepare(), breaking running PCM on suspend/resume.
Call it from prepare() if PCM was suspended to fix the problem.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/ice1712/ice1724.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 0eb7ec6..ade3354 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -783,6 +783,13 @@ static int snd_vt1724_playback_pro_prepare(struct snd_pcm_substream *substream)
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
 	unsigned char val;
 	unsigned int size;
+	int err;
+
+	if (substream->runtime->status->state == SNDRV_PCM_STATE_SUSPENDED) {
+		err = snd_vt1724_set_pro_rate(ice, substream->runtime->rate, 0);
+		if (err < 0)
+			return err;
+	}
 
 	spin_lock_irq(&ice->reg_lock);
 	val = (8 - substream->runtime->channels) >> 1;
@@ -853,6 +860,13 @@ static int snd_vt1724_pcm_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
 	const struct vt1724_pcm_reg *reg = substream->runtime->private_data;
+	int err;
+
+	if (substream->runtime->status->state == SNDRV_PCM_STATE_SUSPENDED) {
+		err = snd_vt1724_set_pro_rate(ice, substream->runtime->rate, 0);
+		if (err < 0)
+			return err;
+	}
 
 	spin_lock_irq(&ice->reg_lock);
 	outl(substream->runtime->dma_addr, ice->profi_port + reg->addr);
-- 
Ondrej Zary

