Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab2GLWf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:35:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59878 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2GLWfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:35:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luis Henriques <luis.henriques@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 005/187] ALSA: hda - Fix power-map regression for HP dv6 & co
Date: Thu, 12 Jul 2012 15:32:41 -0700
Message-Id: <20120712191522.742634173@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712192421.GA28926@kroah.com>
References: <20120712192421.GA28926@kroah.com>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6e1c39c6b00d9141a82c231ba7c5e5b1716974b2 upstream.

The recent fix for power-map controls (commit b0791dda813) caused
regressions on some other HP laptops.  They have fixed pins but these
pins are exposed as jack-detectable.  Thus the driver tries to control
the power-map dynamically per jack detection where it never gets on.

This patch corrects the condition check for fixed pins so that the
power-map is set always for these pins.

NOTE: this is no simple backport from 3.5 kernel.  Since 3.5 kernel
had significant code change in the relevant part, I fixed this
differently.

BugLink: http://bugs.launchpad.net/bugs/1013183
Reported-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4388,7 +4388,7 @@ static int stac92xx_init(struct hda_code
 					 AC_PINCTL_IN_EN);
 	for (i = 0; i < spec->num_pwrs; i++)  {
 		hda_nid_t nid = spec->pwr_nids[i];
-		int pinctl, def_conf;
+		unsigned int pinctl, def_conf;
 
 		/* power on when no jack detection is available */
 		/* or when the VREF is used for controlling LED */
@@ -4415,7 +4415,7 @@ static int stac92xx_init(struct hda_code
 		def_conf = get_defcfg_connect(def_conf);
 		/* skip any ports that don't have jacks since presence
  		 * detection is useless */
-		if (def_conf != AC_JACK_PORT_NONE &&
+		if (def_conf != AC_JACK_PORT_COMPLEX ||
 		    !is_jack_detectable(codec, nid)) {
 			stac_toggle_power_map(codec, nid, 1);
 			continue;


