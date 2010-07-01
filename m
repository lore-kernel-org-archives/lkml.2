Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab0GAWBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:01:41 -0400
Received: from kroah.org ([198.145.64.141]:33775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab0GAVND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:03 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:48 2010
Message-Id: <20100701174248.538840705@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [025/200] ALSA: pcm: fix the fix of the runtime->boundary calculation
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit ead4046b2fdfd69acc4272e693afd249ad3eb689 upstream.

Commit 7910b4a1db63fefc3d291853d33c34c5b6352e8e in 2.6.34 changed the
runtime->boundary calculation to make this value a multiple of both the
buffer_size and the period_size, because the latter is assumed by the
runtime->hw_ptr_interrupt calculation.

However, due to the lack of a ioctl that could read the software
parameters before they are set, the kernel requires that alsa-lib
calculates the boundary value, too.  The changed algorithm leads to
a different boundary value used by alsa-lib, which makes, e.g., mplayer
fail to play a 44.1 kHz file because the silence_size parameter is now
invalid; bug report:
<https://bugtrack.alsa-project.org/alsa-bug/view.php?id=5015>.

This patch reverts the change to the boundary calculation, and instead
fixes the hw_ptr_interrupt calculation to be period-aligned regardless
of the boundary value.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_lib.c    |    9 +++++++--
 sound/core/pcm_native.c |   39 +++------------------------------------
 2 files changed, 10 insertions(+), 38 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -441,8 +441,13 @@ static int snd_pcm_update_hw_ptr0(struct
 		snd_pcm_playback_silence(substream, new_hw_ptr);
 
 	if (in_interrupt) {
-		runtime->hw_ptr_interrupt = new_hw_ptr -
-				(new_hw_ptr % runtime->period_size);
+		delta = new_hw_ptr - runtime->hw_ptr_interrupt;
+		if (delta < 0)
+			delta += runtime->boundary;
+		delta -= (snd_pcm_uframes_t)delta % runtime->period_size;
+		runtime->hw_ptr_interrupt += delta;
+		if (runtime->hw_ptr_interrupt >= runtime->boundary)
+			runtime->hw_ptr_interrupt -= runtime->boundary;
 	}
 	runtime->hw_ptr_base = hw_base;
 	runtime->status->hw_ptr = new_hw_ptr;
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -27,7 +27,6 @@
 #include <linux/pm_qos_params.h>
 #include <linux/uio.h>
 #include <linux/dma-mapping.h>
-#include <linux/math64.h>
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/info.h>
@@ -370,38 +369,6 @@ static int period_to_usecs(struct snd_pc
 	return usecs;
 }
 
-static int calc_boundary(struct snd_pcm_runtime *runtime)
-{
-	u_int64_t boundary;
-
-	boundary = (u_int64_t)runtime->buffer_size *
-		   (u_int64_t)runtime->period_size;
-#if BITS_PER_LONG < 64
-	/* try to find lowest common multiple for buffer and period */
-	if (boundary > LONG_MAX - runtime->buffer_size) {
-		u_int32_t remainder = -1;
-		u_int32_t divident = runtime->buffer_size;
-		u_int32_t divisor = runtime->period_size;
-		while (remainder) {
-			remainder = divident % divisor;
-			if (remainder) {
-				divident = divisor;
-				divisor = remainder;
-			}
-		}
-		boundary = div_u64(boundary, divisor);
-		if (boundary > LONG_MAX - runtime->buffer_size)
-			return -ERANGE;
-	}
-#endif
-	if (boundary == 0)
-		return -ERANGE;
-	runtime->boundary = boundary;
-	while (runtime->boundary * 2 <= LONG_MAX - runtime->buffer_size)
-		runtime->boundary *= 2;
-	return 0;
-}
-
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
@@ -477,9 +444,9 @@ static int snd_pcm_hw_params(struct snd_
 	runtime->stop_threshold = runtime->buffer_size;
 	runtime->silence_threshold = 0;
 	runtime->silence_size = 0;
-	err = calc_boundary(runtime);
-	if (err < 0)
-		goto _error;
+	runtime->boundary = runtime->buffer_size;
+	while (runtime->boundary * 2 <= LONG_MAX - runtime->buffer_size)
+		runtime->boundary *= 2;
 
 	snd_pcm_timer_resolution_change(substream);
 	runtime->status->state = SNDRV_PCM_STATE_SETUP;


