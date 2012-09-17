Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2IQAvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168Ab2IQAtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:53 -0400
Message-Id: <20120917003642.945121034@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Daniel J Blueman <daniel@quora.org>
Subject: [ 121/135] ALSA: hda - Fix Oops at codec reset/reconfig
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 07dc59f0988cb54fd87bd373b3b27eb2401dd811 upstream.

snd_hda_codec_reset() calls restore_pincfgs() where the codec is
powered up again, which eventually tries to resume and initialize via
the callbacks of the codec.  However, it's the place just after codec
free callback, thus no codec callbacks should be called after that.
On a codec like CS4206, it results in Oops due to the access in init
callback.

This patch fixes the issue by clearing the codec callbacks properly
after freeing codec.

Reported-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2312,6 +2312,7 @@ int snd_hda_codec_reset(struct hda_codec
 	}
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
+	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->proc_widget_hook = NULL;
 	codec->spec = NULL;
 	free_hda_cache(&codec->amp_cache);
@@ -2324,7 +2325,6 @@ int snd_hda_codec_reset(struct hda_codec
 	codec->num_pcms = 0;
 	codec->pcm_info = NULL;
 	codec->preset = NULL;
-	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->slave_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	module_put(codec->owner);


