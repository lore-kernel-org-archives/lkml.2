Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1DLOxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:53:17 -0400
Received: from kroah.org ([198.145.64.141]:57545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab1DLOiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.009741137@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kelly Anderson <kelly@silka.with-linux.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [038/105] ALSA: pcm: fix infinite loop in snd_pcm_update_hw_ptr0()
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kelly Anderson <kelly@silka.with-linux.com>

commit 12ff414e2e4512f59fe191dc18e856e2939a1c79 upstream.

When period interrupts are disabled, snd_pcm_update_hw_ptr0() compares
the current time against the time estimated for the current hardware
pointer to detect xruns.  The somewhat fuzzy threshold in the while loop
makes it possible that hdelta becomes negative; the comparison being
done with unsigned types then makes the loop go through the entire 263
negative range, and, depending on the value, never reach an unsigned
value that is small enough to stop the loop.  Doing this with interrupts
disabled results in the machine locking up.

To prevent this, ensure that the loop condition uses signed types for
both operands so that the comparison is correctly done.

Many thanks to Kelly Anderson for debugging this.

Reported-by: Nix <nix@esperi.org.uk>
Reported-by: "Christopher K." <c.krooss@googlemail.com>
Reported-and-tested-by: Kelly Anderson <kelly@silka.with-linux.com>
Signed-off-by: Kelly Anderson <kelly@silka.with-linux.com>
[cl: remove unneeded casts; use a temp variable]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -375,6 +375,7 @@ static int snd_pcm_update_hw_ptr0(struct
 	}
 
 	if (runtime->no_period_wakeup) {
+		snd_pcm_sframes_t xrun_threshold;
 		/*
 		 * Without regular period interrupts, we have to check
 		 * the elapsed time to detect xruns.
@@ -383,7 +384,8 @@ static int snd_pcm_update_hw_ptr0(struct
 		if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
 			goto no_delta_check;
 		hdelta = jdelta - delta * HZ / runtime->rate;
-		while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
+		xrun_threshold = runtime->hw_ptr_buffer_jiffies / 2 + 1;
+		while (hdelta > xrun_threshold) {
 			delta += runtime->buffer_size;
 			hw_base += runtime->buffer_size;
 			if (hw_base >= runtime->boundary)


