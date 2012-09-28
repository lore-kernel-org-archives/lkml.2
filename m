Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2I1T6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:58:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2I1S43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 056/262] ALSA: hda - Fix Oops at codec reset/reconfig
Date: Fri, 28 Sep 2012 11:49:45 -0700
Message-Id: <20120928183004.511944123@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2325,6 +2325,7 @@ int snd_hda_codec_reset(struct hda_codec
 	}
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
+	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	snd_hda_jack_tbl_clear(codec);
 	codec->proc_widget_hook = NULL;
 	codec->spec = NULL;
@@ -2340,7 +2341,6 @@ int snd_hda_codec_reset(struct hda_codec
 	codec->num_pcms = 0;
 	codec->pcm_info = NULL;
 	codec->preset = NULL;
-	memset(&codec->patch_ops, 0, sizeof(codec->patch_ops));
 	codec->slave_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	module_put(codec->owner);


