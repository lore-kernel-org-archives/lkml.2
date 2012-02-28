Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2B1BI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:08:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48212 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965032Ab2B1BIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.193 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.562023494@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 13/72] ALSA: hda - Fix redundant jack creations for cx5051
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[Note that since the patch isn't applicable (and unnecessary) to
3.3-rc, there is no corresponding upstream fix.]

The cx5051 parser calls snd_hda_input_jack_add() in the init callback
to create and initialize the jack detection instances.  Since the init
callback is called at each time when the device gets woken up after
suspend or power-saving mode, the duplicated instances are accumulated
at each call.  This ends up with the kernel warnings with the too
large array size.

The fix is simply to move the calls of snd_hda_input_jack_add() into
the parser section instead of the init callback.

The fix is needed only up to 3.2 kernel, since the HD-audio jack layer
was redesigned in the 3.3 kernel.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1899,6 +1899,10 @@ static void cxt5051_init_mic_port(struct
 	snd_hda_codec_write(codec, nid, 0,
 			    AC_VERB_SET_UNSOLICITED_ENABLE,
 			    AC_USRSP_EN | event);
+}
+
+static void cxt5051_init_mic_jack(struct hda_codec *codec, hda_nid_t nid)
+{
 	snd_hda_input_jack_add(codec, nid, SND_JACK_MICROPHONE, NULL);
 	snd_hda_input_jack_report(codec, nid);
 }
@@ -1916,7 +1920,6 @@ static int cxt5051_init(struct hda_codec
 	struct conexant_spec *spec = codec->spec;
 
 	conexant_init(codec);
-	conexant_init_jacks(codec);
 
 	if (spec->auto_mic & AUTO_MIC_PORTB)
 		cxt5051_init_mic_port(codec, 0x17, CXT5051_PORTB_EVENT);
@@ -2037,6 +2040,12 @@ static int patch_cxt5051(struct hda_code
 	if (spec->beep_amp)
 		snd_hda_attach_beep_device(codec, spec->beep_amp);
 
+	conexant_init_jacks(codec);
+	if (spec->auto_mic & AUTO_MIC_PORTB)
+		cxt5051_init_mic_jack(codec, 0x17);
+	if (spec->auto_mic & AUTO_MIC_PORTC)
+		cxt5051_init_mic_jack(codec, 0x18);
+
 	return 0;
 }
 


