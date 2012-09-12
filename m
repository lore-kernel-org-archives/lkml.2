Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2ILXjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:39:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab2ILXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:39:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 23/85] ALSA: hda - dont create dysfunctional mixer controls for ca0132
Date: Wed, 12 Sep 2012 16:36:06 -0700
Message-Id: <20120912233544.167806742@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit c41999a23929f30808bae6009d8065052d4d73fd upstream.

It's possible that these amps are settable somehow, e g through
secret codec verbs, but for now, don't create the controls (as
they won't be working anyway, and cause errors in amixer).

BugLink: https://bugs.launchpad.net/bugs/1038651
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -276,6 +276,10 @@ static int _add_switch(struct hda_codec
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
@@ -287,6 +291,10 @@ static int _add_volume(struct hda_codec
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


