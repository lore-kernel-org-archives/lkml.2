Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0G3RoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:44:11 -0400
Received: from kroah.org ([198.145.64.141]:36164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab0G3RgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:36:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.604252476@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Giuliano Pochini <pochini@shiny.it>, Takashi Iwai <tiwai@suse.de>
Subject: [121/140] ALSA: Echoaudio, fix Guru Meditation #00000005.48454C50
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Giuliano Pochini <pochini@shiny.it>

commit b721e68bdc5b39c51bf6a1469f8d3663fbe03243 upstream.

This patch fixes a division by zero error in the irq handler.

There is a small window between the hw_params() callback and when
runtime->frame_bits is set by ALSA middle layer. When another substream is
already running, if an interrupt is delivered during that window the irq
handler calls pcm_pointer() which does a division by zero. The patch below
makes the irq handler skip substreams that are initialized but not started
yet. Cc to Clemens Ladisch because he proposed an alternate fix.

For more information, please read the original thread in the linux-kernel
mailing list: http://lkml.org/lkml/2010/2/2/187

Signed-off-by: Giuliano Pochini <pochini@shiny.it>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/echoaudio/echoaudio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
 	/* The hardware doesn't tell us which substream caused the irq,
 	thus we have to check all running substreams. */
 	for (ss = 0; ss < DSP_MAXPIPES; ss++) {
-		if ((substream = chip->substream[ss])) {
+		substream = chip->substream[ss];
+		if (substream && ((struct audiopipe *)substream->runtime->
+				private_data)->state == PIPE_STATE_STARTED) {
 			period = pcm_pointer(substream) /
 				substream->runtime->period_size;
 			if (period != chip->last_period[ss]) {


