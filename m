Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1DAH7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:59:07 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:59433 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1DAH7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:59:06 -0400
X-Greylist: delayed 734 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 03:59:05 EDT
Message-ID: <4D95832F.3020200@ladisch.de>
Date: Fri, 01 Apr 2011 09:47:59 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Kelly Anderson <kelly@silka.with-linux.com>
CC: "Christopher K." <c.krooss@googlemail.com>, Nix <nix@esperi.org.uk>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>	<4D946C73.4090402@ladisch.de> <AANLkTinyRqEa_ML47DOqAJU8aLDEA12geiUUrPGjXHrN@mail.gmail.com> <4D94F728.60609@silka.with-linux.com> <4D952B76.7000201@silka.with-linux.com>
In-Reply-To: <4D952B76.7000201@silka.with-linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kelly Anderson wrote:
> OK, I debugged the problem and came up with a solution.  The bottom line
> is that it's a problem with a signed to unsigned compare.

Aaargh, I didn't suspect this.

> First the fix:
> 
> --- ./sound/core/pcm_lib.c.orig    2011-03-27 12:37:20.000000000 -0600
> +++ ./sound/core/pcm_lib.c    2011-03-31 19:01:35.392739127 -0600
> @@ -379,17 +379,17 @@ static int snd_pcm_update_hw_ptr0(struct
>            * Without regular period interrupts, we have to check
>            * the elapsed time to detect xruns.
>            */
> -        jdelta = jiffies - runtime->hw_ptr_jiffies;
> -        if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
> +        jdelta = (snd_pcm_sframes_t)(jiffies - runtime->hw_ptr_jiffies);
> +        if (jdelta < (snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies / 2)
>               goto no_delta_check;
>           hdelta = jdelta - delta * HZ / runtime->rate;
> -        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
> +        while (hdelta > (snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies / 2 + 1) {
>               delta += runtime->buffer_size;
>               hw_base += runtime->buffer_size;
>               if (hw_base >= runtime->boundary)
>                   hw_base = 0;
>               new_hw_ptr = hw_base + pos;
> -            hdelta -= runtime->hw_ptr_buffer_jiffies;
> +            hdelta -= (snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies;
>           }
>           goto no_delta_check;
>       }

Most of these casts have no effect; only the loop condition is
important.  Please test the patch below.

Kelly, to apply this patch I need a Signed-off-by tag from you (see
Documentation/SubmittingPatches).

--8<---------------------------------------------------------------->8--
ALSA: pcm: fix infinite loop in snd_pcm_update_hw_ptr0()

When period interrupts are disabled, snd_pcm_update_hw_ptr0() compares
the current time against the time estimated for the current hardware
pointer to detect xruns.  The somewhat fuzzy threshold in the while loop
makes it possible that hdelta becomes negative; the comparison being
done with unsigned types then makes the loop go through the entire 2^63
negative range, and, depending on the value, never reaching an unsigned
value that is small enough to stop the loop.  Doing this with interrupts
disabled results in the machine locking up.

To prevent this, ensure that the loop condition uses signed types for
both operands so that the comparison is correctly done.

Many thanks to Kelly Anderson for debugging this.

Reported-by: Nix <nix@esperi.org.uk>
Reported-by: "Christopher K." <c.krooss@googlemail.com>
Reported-by: Kelly Anderson <kelly@silka.with-linux.com>
[cl: remove unneeded casts; use a temp variable]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -375,6 +375,7 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 	}
 
 	if (runtime->no_period_wakeup) {
+		snd_pcm_sframes_t xrun_threshold;
 		/*
 		 * Without regular period interrupts, we have to check
 		 * the elapsed time to detect xruns.
@@ -383,7 +384,8 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 		if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
 			goto no_delta_check;
 		hdelta = jdelta - delta * HZ / runtime->rate;
+		xrun_threshold = runtime->hw_ptr_buffer_jiffies / 2 + 1;
-		while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
+		while (hdelta > xrun_threshold) {
 			delta += runtime->buffer_size;
 			hw_base += runtime->buffer_size;
 			if (hw_base >= runtime->boundary)
