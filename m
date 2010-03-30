Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0C3XsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:48:19 -0400
Received: from kroah.org ([198.145.64.141]:45928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0C3XTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:51 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:47 2010
Message-Id: <20100330224747.366384896@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [042/156] ALSA: hda: Fix 0 dB offset for HP laptops using CX20551 (Waikiki)
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 025f206c9e0f96cc41567b01c07fb852d8900da1 upstream.

BugLink: https://launchpad.net/bugs/420578

The OR has verified that his hardware distorts because of the 0 dB
offset not corresponding to the highest PCM level. Fix this by capping
said PCM level to 0 dB similarly to what we do for CX20549 (Venice).

Reported-by: Mike Pontillo <pontillo@gmail.com>
Tested-by: Mike Pontillo <pontillo@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1570,6 +1570,21 @@ static int patch_cxt5047(struct hda_code
 #endif	
 	}
 	spec->vmaster_nid = 0x13;
+
+	switch (codec->subsystem_id >> 16) {
+	case 0x103c:
+		/* HP laptops have really bad sound over 0 dB on NID 0x10.
+		 * Fix max PCM level to 0 dB (originally it has 0x1e steps
+		 * with 0 dB offset 0x17)
+		 */
+		snd_hda_override_amp_caps(codec, 0x10, HDA_INPUT,
+					  (0x17 << AC_AMPCAP_OFFSET_SHIFT) |
+					  (0x17 << AC_AMPCAP_NUM_STEPS_SHIFT) |
+					  (0x05 << AC_AMPCAP_STEP_SIZE_SHIFT) |
+					  (1 << AC_AMPCAP_MUTE_SHIFT));
+		break;
+	}
+
 	return 0;
 }
 


