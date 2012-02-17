Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2BQBBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:01:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58701 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042Ab2BQBAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:34 -0500
X-Sasl-enc: 4k9aZduNNXVMIlUVGT/DAV8ki3/DjPQjgYbiRNqvIshi 1329440433
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:37 2012
Message-Id: <20120217005537.243545942@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anisse Astier <anisse@astier.eu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [24/28] ALSA: hda - Fix initialization of secondary capture source on VT1705
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fc1156c0b0f7ad45ec03d919866349eeca2bf18c upstream.

VT1705 codec has two ADCs where the secondary ADC has no MUX but only
a fixed connection to the mic pin.  This confused the driver and it
tries always overriding the input-source selection by assumption of
the existing MUX for the secondary ADC, resulted in resetting the
input-source at each time PM (including power-saving) occurs.

The fix is simply to check the existence of MUX for secondary ADCs in
the initialization code.

Tested-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -665,6 +665,9 @@ static void via_auto_init_analog_input(s
 	/* init input-src */
 	for (i = 0; i < spec->num_adc_nids; i++) {
 		int adc_idx = spec->inputs[spec->cur_mux[i]].adc_idx;
+		/* secondary ADCs must have the unique MUX */
+		if (i > 0 && !spec->mux_nids[i])
+			break;
 		if (spec->mux_nids[adc_idx]) {
 			int mux_idx = spec->inputs[spec->cur_mux[i]].mux_idx;
 			snd_hda_codec_write(codec, spec->mux_nids[adc_idx], 0,


