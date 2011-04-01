Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1DAJOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 05:14:39 -0400
Received: from 216-146-103-100.dsl.nemontel.net ([216.146.103.100]:45135 "EHLO
	silka.with-linux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1DAJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 05:14:37 -0400
Message-ID: <4D959683.7040503@silka.with-linux.com>
Date: Fri, 01 Apr 2011 03:10:27 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110309 Thunderbird/3.1.9
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: "Christopher K." <c.krooss@googlemail.com>, Nix <nix@esperi.org.uk>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>	<4D946C73.4090402@ladisch.de> <AANLkTinyRqEa_ML47DOqAJU8aLDEA12geiUUrPGjXHrN@mail.gmail.com> <4D94F728.60609@silka.with-linux.com> <4D952B76.7000201@silka.with-linux.com> <4D95832F.3020200@ladisch.de>
In-Reply-To: <4D95832F.3020200@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/11 01:47, Clemens Ladisch wrote:
>
> Kelly, to apply this patch I need a Signed-off-by tag from you (see
> Documentation/SubmittingPatches).
It works fine Clemens.


--8<---------------------------------------------------------------->8--

ALSA: pcm: fix infinite loop in snd_pcm_update_hw_ptr0()

When period interrupts are disabled, snd_pcm_update_hw_ptr0() compares
the current time against the time estimated for the current hardware
pointer to detect xruns.  The somewhat fuzzy threshold in the while loop
makes it possible that hdelta becomes negative; the comparison being
done with unsigned types then makes the loop go through the entire 263
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
Signed-off-by: Kelly Anderson <kelly@silka.with-linux.com>

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -375,6 +375,7 @@ static int snd_pcm_update_hw_ptr0(struct 
snd_pcm_substream *substream,
      }

      if (runtime->no_period_wakeup) {
+        snd_pcm_sframes_t xrun_threshold;
          /*
           * Without regular period interrupts, we have to check
           * the elapsed time to detect xruns.
@@ -383,7 +384,8 @@ static int snd_pcm_update_hw_ptr0(struct 
snd_pcm_substream *substream,
          if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
              goto no_delta_check;
          hdelta = jdelta - delta * HZ / runtime->rate;
+        xrun_threshold = runtime->hw_ptr_buffer_jiffies / 2 + 1;
-        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
+        while (hdelta > xrun_threshold) {
              delta += runtime->buffer_size;
              hw_base += runtime->buffer_size;
              if (hw_base >= runtime->boundary)
--

