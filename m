Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab0DVUja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:39:30 -0400
Received: from kroah.org ([198.145.64.141]:37414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0DVT2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:11 2010
Message-Id: <20100422190911.648574866@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [048/197] ALSA: hda: Fix 0 dB offset for Lenovo Thinkpad models using AD1981
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit b8e80cf386419453678b01bef830f53445ebb15d upstream.

BugLink: https://launchpad.net/bugs/551606

The OR's hardware distorts at PCM 100% because it does not correspond to
0 dB. Fix this in patch_ad1981() for all models using the Thinkpad
quirk.

Reported-by: Jane Silber
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1789,6 +1789,14 @@ static int patch_ad1981(struct hda_codec
 	case AD1981_THINKPAD:
 		spec->mixers[0] = ad1981_thinkpad_mixers;
 		spec->input_mux = &ad1981_thinkpad_capture_source;
+		/* set the upper-limit for mixer amp to 0dB for avoiding the
+		 * possible damage by overloading
+		 */
+		snd_hda_override_amp_caps(codec, 0x11, HDA_INPUT,
+					  (0x17 << AC_AMPCAP_OFFSET_SHIFT) |
+					  (0x17 << AC_AMPCAP_NUM_STEPS_SHIFT) |
+					  (0x05 << AC_AMPCAP_STEP_SIZE_SHIFT) |
+					  (1 << AC_AMPCAP_MUTE_SHIFT));
 		break;
 	case AD1981_TOSHIBA:
 		spec->mixers[0] = ad1981_hp_mixers;


