Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3AJMte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:49:34 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36104
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab3AJMtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:49:32 -0500
Message-ID: <50EEB8D2.2030702@kernel.dk>
Date: Thu, 10 Jan 2013 13:49:22 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: perex@perex.cz, eldad@fogrefinery.com, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oops in sound/usb/pcm.c:match_endpoint_audioformats() in current
 -git
References: <50EE7A94.60409@kernel.dk> <s5hobgx72zf.wl%tiwai@suse.de>
In-Reply-To: <s5hobgx72zf.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-10 11:21, Takashi Iwai wrote:
> At Thu, 10 Jan 2013 09:23:48 +0100,
> Jens Axboe wrote:
>>
>> Hi,
>>
>> I have a USB DAC that I use for music. Just upgraded my workstation from
>> 3.7-rc7 to 3.8-rc3 this morning, and when the DAC is switched on, I get
>> an immediate oops. I have attached the picture. It's crashing here:
>>
>> (gdb) l *snd_usb_pcm_prepare+0x153
>> 0x161c is in snd_usb_pcm_prepare (sound/usb/pcm.c:470).
>> 465		snd_pcm_format_t pcm_format)
>> 466	{
>> 467		int i;
>> 468		int score = 0;
>> 469	
>> 470		if (fp->channels < 1) {
>> 471			snd_printdd("%s: (fmt @%p) no channels\n", __func__, fp);
>> 472			return 0;
>> 473		}
>> 474	
>>
>> 'fp' is clearly NULL.
> 
> Hmm... it's a function called only from a single place in
> configure_sync_endpoint() and it's in list_for_each_entry():
> 
> 	list_for_each_entry(fp, &sync_subs->fmt_list, list) {
> 		int score = match_endpoint_audioformats(fp, subs->cur_audiofmt,
> 			subs->cur_rate, subs->pcm_format);
> 
> so it must be hardly NULL in normal situations.
> The only scenario I can imagine right now is that the whole structure
> is still uninitialized while it's called.  If so, it's a race problem,
> and shouldn't be new to 3.8.  A patch like below might paper over the
> problem although it's far from perfect.
> 
> 
>> Let me know if you want a bisect.
> 
> Yeah, that'll be really helpful.

Here it is, it's from the one introducing the audioformat lookup.
Confirmed that 3.8-rc3 with this backed out works fine, too. So should
be fairly confident in that result.


commit 0d9741c0e058e2857fe3fed37975515dc8dcd21d
Author: Eldad Zack <eldad@fogrefinery.com>
Date:   Mon Dec 3 20:30:09 2012 +0100

    ALSA: usb-audio: sync ep init fix for audioformat mismatch
    
    Commit 947d299686aa9cc8aecf749d54e8475c6e498956 , "ALSA: snd-usb:
    properly initialize the sync endpoint", while correcting the
    initialization of the sync endpoint when opening just the data
    endpoint, prevents devices that has a sync endpoint, with a channel
    number different than that of the data endpoint, from functioning.
    Due to a different channel and period bytes count, attempting to
    initialize the sync endpoint will fail at the usb host driver.
    For example, when using xhci:
    
     cannot submit urb 0, error -90: internal error
    
    With this patch, if a sync endpoint has multiple audioformats, a
    matching audioformat is preferred. An audioformat must be found
    with at least one channel and support the requested sample rate
    and PCM format, otherwise the stream will not be opened.
    
    If the number of channels differ between the selected audioformat
    and the requested format, adjust the period bytes count accordingly.
    It is safe to perform the calculation on the basis of the channel
    count, since the requested PCM audio format and the rate must be
    supported by the selected audioformat.
    
    Cc: Jeffrey Barish <jeff_barish@earthlink.net>
    Cc: Daniel Mack <zonque@gmail.com>
    Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 769821c..c659310 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -454,6 +454,103 @@ add_sync_ep:
 }
 
 /*
+ * Return the score of matching two audioformats.
+ * Veto the audioformat if:
+ * - It has no channels for some reason.
+ * - Requested PCM format is not supported.
+ * - Requested sample rate is not supported.
+ */
+static int match_endpoint_audioformats(struct audioformat *fp,
+	struct audioformat *match, int rate,
+	snd_pcm_format_t pcm_format)
+{
+	int i;
+	int score = 0;
+
+	if (fp->channels < 1) {
+		snd_printdd("%s: (fmt @%p) no channels\n", __func__, fp);
+		return 0;
+	}
+
+	if (!(fp->formats & (1ULL << pcm_format))) {
+		snd_printdd("%s: (fmt @%p) no match for format %d\n", __func__,
+			fp, pcm_format);
+		return 0;
+	}
+
+	for (i = 0; i < fp->nr_rates; i++) {
+		if (fp->rate_table[i] == rate) {
+			score++;
+			break;
+		}
+	}
+	if (!score) {
+		snd_printdd("%s: (fmt @%p) no match for rate %d\n", __func__,
+			fp, rate);
+		return 0;
+	}
+
+	if (fp->channels == match->channels)
+		score++;
+
+	snd_printdd("%s: (fmt @%p) score %d\n", __func__, fp, score);
+
+	return score;
+}
+
+/*
+ * Configure the sync ep using the rate and pcm format of the data ep.
+ */
+static int configure_sync_endpoint(struct snd_usb_substream *subs)
+{
+	int ret;
+	struct audioformat *fp;
+	struct audioformat *sync_fp = NULL;
+	int cur_score = 0;
+	int sync_period_bytes = subs->period_bytes;
+	struct snd_usb_substream *sync_subs =
+		&subs->stream->substream[subs->direction ^ 1];
+
+	/* Try to find the best matching audioformat. */
+	list_for_each_entry(fp, &sync_subs->fmt_list, list) {
+		int score = match_endpoint_audioformats(fp, subs->cur_audiofmt,
+			subs->cur_rate, subs->pcm_format);
+
+		if (score > cur_score) {
+			sync_fp = fp;
+			cur_score = score;
+		}
+	}
+
+	if (unlikely(sync_fp == NULL)) {
+		snd_printk(KERN_ERR "%s: no valid audioformat for sync ep %x found\n",
+			__func__, sync_subs->ep_num);
+		return -EINVAL;
+	}
+
+	/*
+	 * Recalculate the period bytes if channel number differ between
+	 * data and sync ep audioformat.
+	 */
+	if (sync_fp->channels != subs->channels) {
+		sync_period_bytes = (subs->period_bytes / subs->channels) *
+			sync_fp->channels;
+		snd_printdd("%s: adjusted sync ep period bytes (%d -> %d)\n",
+			__func__, subs->period_bytes, sync_period_bytes);
+	}
+
+	ret = snd_usb_endpoint_set_params(subs->sync_endpoint,
+					  subs->pcm_format,
+					  sync_fp->channels,
+					  sync_period_bytes,
+					  subs->cur_rate,
+					  sync_fp,
+					  NULL);
+
+	return ret;
+}
+
+/*
  * configure endpoint params
  *
  * called  during initial setup and upon resume
@@ -475,13 +572,8 @@ static int configure_endpoint(struct snd_usb_substream *subs)
 		return ret;
 
 	if (subs->sync_endpoint)
-		ret = snd_usb_endpoint_set_params(subs->sync_endpoint,
-						  subs->pcm_format,
-						  subs->channels,
-						  subs->period_bytes,
-						  subs->cur_rate,
-						  subs->cur_audiofmt,
-						  NULL);
+		ret = configure_sync_endpoint(subs);
+
 	return ret;
 }
 

-- 
Jens Axboe

