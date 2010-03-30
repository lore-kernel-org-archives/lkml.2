Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0C3XUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:50 -0400
Received: from kroah.org ([198.145.64.141]:45934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab0C3XTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:48 2010
Message-Id: <20100330224747.937942593@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [043/156] ALSA: cmipci: work around invalid PCM pointer
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 1c583063a5c769fe2ec604752e383972c69e6d9b upstream.

When the CMI8738 FRAME2 register is read, the chip sometimes (probably
when wrapping around) returns an invalid value that would be outside the
programmed DMA buffer. This leads to an inconsistent PCM pointer that is
likely to result in an underrun.

To work around this, read the register multiple times until we get a
valid value; the error state seems to be very short-lived.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Matija Nalis <mnalis-alsadev@voyager.hr>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/cmipci.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -941,13 +941,21 @@ static snd_pcm_uframes_t snd_cmipci_pcm_
 						struct snd_pcm_substream *substream)
 {
 	size_t ptr;
-	unsigned int reg;
+	unsigned int reg, rem, tries;
+
 	if (!rec->running)
 		return 0;
 #if 1 // this seems better..
 	reg = rec->ch ? CM_REG_CH1_FRAME2 : CM_REG_CH0_FRAME2;
-	ptr = rec->dma_size - (snd_cmipci_read_w(cm, reg) + 1);
-	ptr >>= rec->shift;
+	for (tries = 0; tries < 3; tries++) {
+		rem = snd_cmipci_read_w(cm, reg);
+		if (rem < rec->dma_size)
+			goto ok;
+	}
+	printk(KERN_ERR "cmipci: invalid PCM pointer: %#x\n", rem);
+	return SNDRV_PCM_POS_XRUN;
+ok:
+	ptr = (rec->dma_size - (rem + 1)) >> rec->shift;
 #else
 	reg = rec->ch ? CM_REG_CH1_FRAME1 : CM_REG_CH0_FRAME1;
 	ptr = snd_cmipci_read(cm, reg) - rec->offset;


