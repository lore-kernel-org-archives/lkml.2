Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030976Ab2ERXFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946578Ab2ERXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:33 -0400
Message-Id: <20120518212649.605056418@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:26:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 04/47] ALSA: hda/idt - Fix power-map for speaker-pins with some HP laptops
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4394,9 +4394,9 @@ static int stac92xx_init(struct hda_code
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


