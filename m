Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1I1XMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:12:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab1I1Woe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220139.880444560@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [138/244] ALSA: hda/realtek - Fix auto-mute with HP+LO configuration
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8974bd51a77824d91010176f9a5da28513c2e1f5 upstream.

When the system has only the headphone and the line-out jacks without
speakers, the current auto-mute code doesn't work.  It's because the
spec->automute_lines flag is wrongly referred in update_speakers().
This flag must be meaningless when spec->automute_hp_lo isn't set, thus
they should be always coupled.

The patch fixes the problem and add a comment to indicate the
relationship briefly.

BugLink: http://bugs.launchpad.net/bugs/851697

Reported-by: David Henningsson <david.henningsson@canonical.com>
Tested-By: Jayne Han <jayne.han@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -397,7 +397,7 @@ struct alc_spec {
 	unsigned int auto_mic:1;
 	unsigned int automute:1;	/* HP automute enabled */
 	unsigned int detect_line:1;	/* Line-out detection enabled */
-	unsigned int automute_lines:1;	/* automute line-out as well */
+	unsigned int automute_lines:1;	/* automute line-out as well; NOP when automute_hp_lo isn't set */
 	unsigned int automute_hp_lo:1;	/* both HP and LO available */
 
 	/* other flags */
@@ -1161,7 +1161,7 @@ static void update_speakers(struct hda_c
 	if (spec->autocfg.line_out_pins[0] == spec->autocfg.hp_pins[0] ||
 	    spec->autocfg.line_out_pins[0] == spec->autocfg.speaker_pins[0])
 		return;
-	if (!spec->automute_lines || !spec->automute)
+	if (!spec->automute || (spec->automute_hp_lo && !spec->automute_lines))
 		on = 0;
 	else
 		on = spec->jack_present;
@@ -1494,7 +1494,7 @@ static int alc_automute_mode_get(struct
 	unsigned int val;
 	if (!spec->automute)
 		val = 0;
-	else if (!spec->automute_lines)
+	else if (!spec->automute_hp_lo || !spec->automute_lines)
 		val = 1;
 	else
 		val = 2;
@@ -1515,7 +1515,8 @@ static int alc_automute_mode_put(struct
 		spec->automute = 0;
 		break;
 	case 1:
-		if (spec->automute && !spec->automute_lines)
+		if (spec->automute &&
+		    (!spec->automute_hp_lo || !spec->automute_lines))
 			return 0;
 		spec->automute = 1;
 		spec->automute_lines = 0;


