Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0KYS5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:57:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0KYS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:57:34 -0500
Date: Thu, 25 Nov 2010 13:57:30 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: patch_realtek: handle unset external amp bits
Message-ID: <20101125185730.GK22651@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit ef5dbbcc removes the default initialization of init_amp to
ALC_INIT_DEFAULT, with the justification that it should be set by
alc_subsystem_id, which contains a switch case:

        tmp = (ass & 0x38) >> 3;        /* external Amp control */
        switch (tmp) {
        case 1:
	...
	case 5:
	}

Which handles values 1,3,7 for GPIOs, or 5 to set _DEFAULT.

But... what if it's 0? :)

I got a bug report this morning from a user whose sound had broken
between 2.6.34 and 2.6.35, and I bisected it down to this commit.

[ 32.366183] ALSA sound/pci/hda/patch_realtek.c:1374: realtek: Enabling
init ASM_ID=0x8a05 CODEC_ID=10ec0888

(0x8a05 & 0x38) >> 3 = 0;

But otherwise the SKU looks fine (since if I revert that commit, it
seems to work correctly.)

I think the best thing to do would be to either restore the 'redundant'
default initialization, or quirk it.

https://bugzilla.redhat.com/show_bug.cgi?id=657388

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
    Revert "ALSA: hda - Remove superfluous external amp setup for ALC888"
    
    This reverts commit ef5dbbccbbfa7d2211fa8efcc095a9f4a7912dda.

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 76c4968..b6ba1d5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10604,6 +10604,9 @@ static int patch_alc882(struct hda_codec *codec)
 	spec->stream_digital_playback = &alc882_pcm_digital_playback;
 	spec->stream_digital_capture = &alc882_pcm_digital_capture;
 
+	if (codec->vendor_id == 0x10ec0888)
+		spec->init_amp = ALC_INIT_DEFAULT; /* always initialize */
+
 	if (!spec->adc_nids && spec->input_mux) {
 		int i, j;
 		spec->num_adc_nids = 0;
