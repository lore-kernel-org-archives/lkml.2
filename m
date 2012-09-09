Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2IIXQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51369 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab2IIXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:46 -0400
Message-Id: <20120909224158.028477526@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 53/95] ALSA: hda - dont create dysfunctional mixer controls for ca0132
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit c41999a23929f30808bae6009d8065052d4d73fd upstream.

It's possible that these amps are settable somehow, e g through
secret codec verbs, but for now, don't create the controls (as
they won't be working anyway, and cause errors in amixer).

BugLink: https://bugs.launchpad.net/bugs/1038651
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_ca0132.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 9c0ec0a..49750a9 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -275,6 +275,10 @@ static int _add_switch(struct hda_codec *codec, hda_nid_t nid, const char *pfx,
 	int type = dir ? HDA_INPUT : HDA_OUTPUT;
 	struct snd_kcontrol_new knew =
 		HDA_CODEC_MUTE_MONO(namestr, nid, chan, 0, type);
+	if ((query_amp_caps(codec, nid, type) & AC_AMPCAP_MUTE) == 0) {
+		snd_printdd("Skipping '%s %s Switch' (no mute on node 0x%x)\n", pfx, dirstr[dir], nid);
+		return 0;
+	}
 	sprintf(namestr, "%s %s Switch", pfx, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
@@ -286,6 +290,10 @@ static int _add_volume(struct hda_codec *codec, hda_nid_t nid, const char *pfx,
 	int type = dir ? HDA_INPUT : HDA_OUTPUT;
 	struct snd_kcontrol_new knew =
 		HDA_CODEC_VOLUME_MONO(namestr, nid, chan, 0, type);
+	if ((query_amp_caps(codec, nid, type) & AC_AMPCAP_NUM_STEPS) == 0) {
+		snd_printdd("Skipping '%s %s Volume' (no amp on node 0x%x)\n", pfx, dirstr[dir], nid);
+		return 0;
+	}
 	sprintf(namestr, "%s %s Volume", pfx, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }


