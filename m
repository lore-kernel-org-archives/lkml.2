Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198Ab2JSCtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:52622 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965079Ab2JSCtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 69/76] ALSA: hda - Stop LPIB delay counting on broken hardware
Date: Thu, 18 Oct 2012 19:47:33 -0700
Message-Id: <20121019024401.214626796@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1f04661fde9deda4a2cd5845258715a22d8af197 upstream.

If LPIB reports a pretty bad value, we can't trust such hardware for
calculating the PCM delay.  Automatically turn off the delay counting
when such a problem is encountered.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48911

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2136,9 +2136,12 @@ static unsigned int azx_get_position(str
 		if (delay < 0)
 			delay += azx_dev->bufsize;
 		if (delay >= azx_dev->period_bytes) {
-			snd_printdd("delay %d > period_bytes %d\n",
-				delay, azx_dev->period_bytes);
-			delay = 0; /* something is wrong */
+			snd_printk(KERN_WARNING SFX
+				   "Unstable LPIB (%d >= %d); "
+				   "disabling LPIB delay counting\n",
+				   delay, azx_dev->period_bytes);
+			delay = 0;
+			chip->driver_caps &= ~AZX_DCAPS_COUNT_LPIB_DELAY;
 		}
 		azx_dev->substream->runtime->delay =
 			bytes_to_frames(azx_dev->substream->runtime, delay);


