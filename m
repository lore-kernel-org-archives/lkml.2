Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1CaL5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:57:32 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:40208 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1CaL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:57:31 -0400
Message-ID: <4D946C73.4090402@ladisch.de>
Date: Thu, 31 Mar 2011 13:58:43 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Christopher K." <c.krooss@googlemail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>
In-Reply-To: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher K. wrote:
> Kernel 2.6.38 has been freezing ever since rc1 on my asus p7p55d.
> After booting up, the kernel seems to use a lot of cpu-time and after
> 20-30 seconds
> the system comes to a complete halt.
> 
> I just finished bisecting 2.6.37 - 2.6.38-rc1 and found this commit to
> be responsible:
> 
> 59ff878ffb26bc0be812ca8295799164f413ae88

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
