Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2BAVft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:35:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58504 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932509Ab2BAVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:04 -0500
X-Sasl-enc: UPt0W1aXV3zvl07DHSVwTrbzLEJcT/0MgigUHMMcHDHz 1328130603
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210043.968262390@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [01/89] ALSA: hda - Fix buffer-alignment regression with Nvidia HDMI
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 52409aa6a0e96337da137c069856298f4dd825a0 upstream.

The commit 2ae66c26550cd94b0e2606a9275eb0ab7070ad0e
    ALSA: hda: option to enable arbitrary buffer/period sizes
introduced a regression on machines with Intel controller and Nvidia
HDMI.  The reason is that the driver modifies the global variable
align_buffer_size when an Intel controller is found, and the Nvidia
HDMI controller is probed after Intel although Nvidia chips require
the aligned buffers.

This patch fixes the problem by moving the flag into the local struct
so that it's not affected by other controllers.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42567

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -461,6 +461,7 @@ struct azx {
 	unsigned int irq_pending_warned :1;
 	unsigned int probing :1; /* codec probing phase */
 	unsigned int snoop:1;
+	unsigned int align_buffer_size:1;
 
 	/* for debugging */
 	unsigned int last_cmd[AZX_MAX_CODECS];
@@ -1697,7 +1698,7 @@ static int azx_pcm_open(struct snd_pcm_s
 	runtime->hw.rates = hinfo->rates;
 	snd_pcm_limit_hw_rates(runtime);
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
-	if (align_buffer_size)
+	if (chip->align_buffer_size)
 		/* constrain buffer sizes to be multiple of 128
 		   bytes. This is more efficient in terms of memory
 		   access but isn't required by the HDA spec and
@@ -2753,8 +2754,9 @@ static int __devinit azx_create(struct s
 	}
 
 	/* disable buffer size rounding to 128-byte multiples if supported */
+	chip->align_buffer_size = align_buffer_size;
 	if (chip->driver_caps & AZX_DCAPS_BUFSIZE)
-		align_buffer_size = 0;
+		chip->align_buffer_size = 0;
 
 	/* allow 64bit DMA address if supported by H/W */
 	if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))


