Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748Ab2ERC5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:57:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030724Ab2ERCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:51 -0400
Message-Id: <20120518023300.045698778@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 42/53] ALSA: hda/idt - Fix power-map for speaker-pins with some HP laptops
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b0791dda813c179e539b0fc1ecd3f5f30f2571e2 upstream.

BIOS on some HP laptops don't set the speaker-pins as fixed but expose
as jacks, and this confuses the driver as if these pins are
jack-detectable.  As a result, the machine doesn't get sounds from
speakers because the driver prepares the power-map update via jack
unsol events which never come up in reality.  The bug was introduced
in some time in 3.2 for enabling the power-mapping feature.

This patch fixes the problem by replacing the check of the persistent
power-map bits with a proper is_jack_detectable() call.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43240

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_sigmatel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 4742cac..2cb1e08 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4415,9 +4415,9 @@ static int stac92xx_init(struct hda_codec *codec)
 		def_conf = get_defcfg_connect(def_conf);
 		/* skip any ports that don't have jacks since presence
  		 * detection is useless */
-		if (def_conf != AC_JACK_PORT_COMPLEX) {
-			if (def_conf != AC_JACK_PORT_NONE)
-				stac_toggle_power_map(codec, nid, 1);
+		if (def_conf != AC_JACK_PORT_NONE &&
+		    !is_jack_detectable(codec, nid)) {
+			stac_toggle_power_map(codec, nid, 1);
 			continue;
 		}
 		if (enable_pin_detect(codec, nid, STAC_PWR_EVENT)) {
-- 
1.7.10



