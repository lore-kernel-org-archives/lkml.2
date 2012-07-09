Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2GIOks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:40:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab2GIOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:25 -0400
Message-Id: <20120709143119.898673309@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 22/48] ALSA: hda - Fix power-map regression for HP dv6 & co
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6e1c39c6b00d9141a82c231ba7c5e5b1716974b2 upstream.

The recent fix for power-map controls (commit b0791dda813) caused
regressions on some other HP laptops.  They have fixed pins but these
pins are exposed as jack-detectable.  Thus the driver tries to control
the power-map dynamically per jack detection where it never gets on.

This patch adds the check of connection and it assumes the no jack
detection is available for fixed pins no matter what pin capability
says.

BugLink: http://bugs.launchpad.net/bugs/1013183
Reported-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_sigmatel.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4457,7 +4457,7 @@ static int stac92xx_init(struct hda_code
 					 AC_PINCTL_IN_EN);
 	for (i = 0; i < spec->num_pwrs; i++)  {
 		hda_nid_t nid = spec->pwr_nids[i];
-		int pinctl, def_conf;
+		unsigned int pinctl, def_conf;
 
 		/* power on when no jack detection is available */
 		/* or when the VREF is used for controlling LED */
@@ -4484,7 +4484,7 @@ static int stac92xx_init(struct hda_code
 		def_conf = get_defcfg_connect(def_conf);
 		/* skip any ports that don't have jacks since presence
  		 * detection is useless */
-		if (def_conf != AC_JACK_PORT_NONE &&
+		if (def_conf != AC_JACK_PORT_COMPLEX ||
 		    !is_jack_detectable(codec, nid)) {
 			stac_toggle_power_map(codec, nid, 1);
 			continue;


