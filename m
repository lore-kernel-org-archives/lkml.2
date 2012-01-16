Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2APSr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:47:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2APSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:47:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:17 2012
Message-Id: <20120116184516.947847548@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [14/48] ALSA: hda - Fix the lost power-setup of seconary pins after PM resume
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f2cbba7602383cd9cdd21f0a5d0b8bd1aad47b33 upstream.

When multiple headphone or other detectable output pins are present,
the power-map has to be updated after resume appropriately, but the
current driver doesn't check all pins but only the first pin (since
it's enough to check it for the mute-behavior).  This resulted in the
silent output from the secondary outputs after PM resume.

This patch fixes the problem by checking all pins at (re-)init time.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=740347

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4306,6 +4306,27 @@ static void stac_store_hints(struct hda_
 	}
 }
 
+static void stac_issue_unsol_events(struct hda_codec *codec, int num_pins,
+				    const hda_nid_t *pins)
+{
+	while (num_pins--)
+		stac_issue_unsol_event(codec, *pins++);
+}
+
+/* fake event to set up pins */
+static void stac_fake_hp_events(struct hda_codec *codec)
+{
+	struct sigmatel_spec *spec = codec->spec;
+
+	if (spec->autocfg.hp_outs)
+		stac_issue_unsol_events(codec, spec->autocfg.hp_outs,
+					spec->autocfg.hp_pins);
+	if (spec->autocfg.line_outs &&
+	    spec->autocfg.line_out_pins[0] != spec->autocfg.hp_pins[0])
+		stac_issue_unsol_events(codec, spec->autocfg.line_outs,
+					spec->autocfg.line_out_pins);
+}
+
 static int stac92xx_init(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
@@ -4356,10 +4377,7 @@ static int stac92xx_init(struct hda_code
 		stac92xx_auto_set_pinctl(codec, spec->autocfg.line_out_pins[0],
 				AC_PINCTL_OUT_EN);
 		/* fake event to set up pins */
-		if (cfg->hp_pins[0])
-			stac_issue_unsol_event(codec, cfg->hp_pins[0]);
-		else if (cfg->line_out_pins[0])
-			stac_issue_unsol_event(codec, cfg->line_out_pins[0]);
+		stac_fake_hp_events(codec);
 	} else {
 		stac92xx_auto_init_multi_out(codec);
 		stac92xx_auto_init_hp_out(codec);
@@ -5000,19 +5018,11 @@ static void stac927x_proc_hook(struct sn
 #ifdef CONFIG_PM
 static int stac92xx_resume(struct hda_codec *codec)
 {
-	struct sigmatel_spec *spec = codec->spec;
-
 	stac92xx_init(codec);
 	snd_hda_codec_resume_amp(codec);
 	snd_hda_codec_resume_cache(codec);
 	/* fake event to set up pins again to override cached values */
-	if (spec->hp_detect) {
-		if (spec->autocfg.hp_pins[0])
-			stac_issue_unsol_event(codec, spec->autocfg.hp_pins[0]);
-		else if (spec->autocfg.line_out_pins[0])
-			stac_issue_unsol_event(codec,
-					       spec->autocfg.line_out_pins[0]);
-	}
+	stac_fake_hp_events(codec);
 	return 0;
 }
 


