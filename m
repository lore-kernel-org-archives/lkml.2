Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946436Ab2I1VvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:51:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198Ab2I1UYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 048/218] ALSA: hda - Fix Oops at codec reset/reconfig
Date: Fri, 28 Sep 2012 13:14:25 -0700
Message-Id: <20120928201507.006527182@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2279,6 +2279,7 @@ int snd_hda_codec_reset(struct hda_codec
 	}
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
+	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	snd_hda_jack_tbl_clear(codec);
 	codec->proc_widget_hook = NULL;
 	codec->spec = NULL;
@@ -2292,7 +2293,6 @@ int snd_hda_codec_reset(struct hda_codec
 	codec->num_pcms = 0;
 	codec->pcm_info = NULL;
 	codec->preset = NULL;
-	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->slave_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	module_put(codec->owner);


