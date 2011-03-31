Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1CaHKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:10:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44240 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab1CaHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:10:00 -0400
X-Sasl-enc: SUsJYVtbV/9stb5JuzyimRs4+sMlccNfWE5RHIFbnuDz 1301555399
Message-ID: <4D942914.3020404@ladisch.de>
Date: Thu, 31 Mar 2011 09:11:16 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Kelly Anderson <kelly@silka.with-linux.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.38+ hard lockup in pcm_lib.c
References: <4D9314A1.7030106@silka.with-linux.com>
In-Reply-To: <4D9314A1.7030106@silka.with-linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kelly Anderson wrote:
> I had a consistent hard-lockup on one of my machines, an Amd X6, just
> after Kdm loaded the desktop (most certainly when it decides to start
> talking to the sound card).  Everything was dead, even ssh access to the
> computer.  I git bisected it until I found the commit that was causing
> it.  After reverting the patch everything is fine.
> 
> commit 59ff878ffb26bc0be812ca8295799164f413ae88
> Author: Clemens Ladisch
> Date:   Thu Nov 18 09:43:52 2010 +0100
> 
>      ALSA: pcm: detect xruns in no-period-wakeup mode

This looks as if you get an infinite loop, probably because
hw_ptr_buffer_jiffies is zero.

Please try this patch:

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -425,6 +425,8 @@ static int snd_pcm_hw_params(struct snd_
 	runtime->no_period_wakeup =
 			(params->info & SNDRV_PCM_INFO_NO_PERIOD_WAKEUP) &&
 			(params->flags & SNDRV_PCM_HW_PARAMS_NO_PERIOD_WAKEUP);
+	runtime->hw_ptr_buffer_jiffies =
+			max(1uL, (runtime->buffer_size * HZ) / runtime->rate);
 
 	bits = snd_pcm_format_physical_width(runtime->format);
 	runtime->sample_bits = bits;
@@ -866,8 +868,6 @@ static void snd_pcm_post_start(struct sn
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_trigger_tstamp(substream);
 	runtime->hw_ptr_jiffies = jiffies;
-	runtime->hw_ptr_buffer_jiffies = (runtime->buffer_size * HZ) / 
-							    runtime->rate;
 	runtime->status->state = state;
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
 	    runtime->silence_size > 0)
