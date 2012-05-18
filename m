Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2ERQBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:01:09 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:55225 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab2ERQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:01:06 -0400
Message-ID: <4FB6722B.6050103@ladisch.de>
Date: Fri, 18 May 2012 18:00:43 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: kmemleak findings about USB audio recording on 3.3.2
References: <1335112621.20322.8.camel@home>
In-Reply-To: <1335112621.20322.8.camel@home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander E. Patrakov wrote:
> On my home computer with linux-3.3.2, kmemleak found a lot of copies of
> this (not only from pulseaudio, but also from wine):
>
> unreferenced object 0xffff88021afaed40 (size 16):
>   comm "pulseaudio", pid 839, jiffies 4294711382 (age 31392.844s)
>   hex dump (first 16 bytes):
>     80 3e 00 00 c0 5d 00 00 00 7d 00 00 02 00 00 00  .>...]...}......
>   backtrace:
>     [<ffffffff811620d7>] create_object+0x127/0x2b0
>     [<ffffffff81636d81>] kmemleak_alloc+0x21/0x50
>     [<ffffffff81157bc3>] __kmalloc+0x103/0x1e0
>     [<ffffffffa02f650b>] snd_usb_pcm_open+0x3bb/0x4c0 [snd_usb_audio]

Please try this patch.

--8<---------------------------------------------------------------->8--
ALSA: usb-audio: fix rate_list memory leak

The array of sample rates is reallocated every time when opening
the PCM device, but was freed only once when unplugging the device.

Reported-by: "Alexander E. Patrakov" <patrakov@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/usb/pcm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -783,6 +783,9 @@ static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
 	int count = 0, needs_knot = 0;
 	int err;

+	kfree(subs->rate_list.list);
+	subs->rate_list.list = NULL;
+
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
 			return 0;
