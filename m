Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab0LHB3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:29:54 -0500
Received: from kroah.org ([198.145.64.141]:49154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab0LHBCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:11 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:38 2010
Message-Id: <20101208005738.061815246@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [166/289] ALSA: Fix SNDCTL_DSP_RESET ioctl for OSS emulation
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60686aa0086a14f8b15c83a09f3df1eebe3aab3c upstream.

In OSS emulation, SNDCTL_DSP_RESET ioctl needs the reset of the internal
buffer state in addition to drop of the running streams.  Otherwise the
succeeding access becomes inconsistent.

Tested-by: Amit Nagal <helloin.amit@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/oss/pcm_oss.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1510,16 +1510,19 @@ static ssize_t snd_pcm_oss_read1(struct
 static int snd_pcm_oss_reset(struct snd_pcm_oss_file *pcm_oss_file)
 {
 	struct snd_pcm_substream *substream;
+	struct snd_pcm_runtime *runtime;
+	int i;
 
-	substream = pcm_oss_file->streams[SNDRV_PCM_STREAM_PLAYBACK];
-	if (substream != NULL) {
+	for (i = 0; i < 2; i++) {
+		substream = pcm_oss_file->streams[i];
+		if (!substream)
+			continue;
+		runtime = substream->runtime;
 		snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
-		substream->runtime->oss.prepare = 1;
-	}
-	substream = pcm_oss_file->streams[SNDRV_PCM_STREAM_CAPTURE];
-	if (substream != NULL) {
-		snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
-		substream->runtime->oss.prepare = 1;
+		runtime->oss.prepare = 1;
+		runtime->oss.buffer_used = 0;
+		runtime->oss.prev_hw_ptr_period = 0;
+		runtime->oss.period_ptr = 0;
 	}
 	return 0;
 }


