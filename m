Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1KSAQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:16:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366Ab1KSAJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.025893516@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [01/26] ALSA: hda - Dont add elements of other codecs to vmaster slave
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit aeb4b88ec0a948efce8e3a23a8f964d3560a7308 upstream.

When a virtual mater control is created, the driver looks for slave
elements from the assigned card instance.  But this may include the
elements of other codecs when multiple codecs are on the same HD-audio
bus.  This works at the first time, but it'll give Oops when it's once
freed and re-created via reconfig sysfs.

This patch changes the element-look-up strategy to limit only to the
mixer elements of the same codec.

Reported-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_codec.c |   60 +++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2187,6 +2187,39 @@ int snd_hda_codec_reset(struct hda_codec
 	return 0;
 }
 
+typedef int (*map_slave_func_t)(void *, struct snd_kcontrol *);
+
+/* apply the function to all matching slave ctls in the mixer list */
+static int map_slaves(struct hda_codec *codec, const char * const *slaves,
+		      map_slave_func_t func, void *data)
+{
+	struct hda_nid_item *items;
+	const char * const *s;
+	int i, err;
+
+	items = codec->mixers.list;
+	for (i = 0; i < codec->mixers.used; i++) {
+		struct snd_kcontrol *sctl = items[i].kctl;
+		if (!sctl || !sctl->id.name ||
+		    sctl->id.iface != SNDRV_CTL_ELEM_IFACE_MIXER)
+			continue;
+		for (s = slaves; *s; s++) {
+			if (!strcmp(sctl->id.name, *s)) {
+				err = func(data, sctl);
+				if (err)
+					return err;
+				break;
+			}
+		}
+	}
+	return 0;
+}
+
+static int check_slave_present(void *data, struct snd_kcontrol *sctl)
+{
+	return 1;
+}
+
 /**
  * snd_hda_add_vmaster - create a virtual master control and add slaves
  * @codec: HD-audio codec
@@ -2207,12 +2240,10 @@ int snd_hda_add_vmaster(struct hda_codec
 			unsigned int *tlv, const char * const *slaves)
 {
 	struct snd_kcontrol *kctl;
-	const char * const *s;
 	int err;
 
-	for (s = slaves; *s && !snd_hda_find_mixer_ctl(codec, *s); s++)
-		;
-	if (!*s) {
+	err = map_slaves(codec, slaves, check_slave_present, NULL);
+	if (err != 1) {
 		snd_printdd("No slave found for %s\n", name);
 		return 0;
 	}
@@ -2223,23 +2254,10 @@ int snd_hda_add_vmaster(struct hda_codec
 	if (err < 0)
 		return err;
 
-	for (s = slaves; *s; s++) {
-		struct snd_kcontrol *sctl;
-		int i = 0;
-		for (;;) {
-			sctl = _snd_hda_find_mixer_ctl(codec, *s, i);
-			if (!sctl) {
-				if (!i)
-					snd_printdd("Cannot find slave %s, "
-						    "skipped\n", *s);
-				break;
-			}
-			err = snd_ctl_add_slave(kctl, sctl);
-			if (err < 0)
-				return err;
-			i++;
-		}
-	}
+	err = map_slaves(codec, slaves, (map_slave_func_t)snd_ctl_add_slave,
+			 kctl);
+	if (err < 0)
+		return err;
 	return 0;
 }
 EXPORT_SYMBOL_HDA(snd_hda_add_vmaster);


