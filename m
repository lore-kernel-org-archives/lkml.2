Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1BPCHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:07:13 -0500
Received: from kroah.org ([198.145.64.141]:48887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241Ab1BPBt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.536162559@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [042/115] ALSA: hda - Fix memory leaks in conexant jack arrays
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 70f7db11c45a313b23922cacf248c613c3b2144c upstream.

The Conexant codec driver adds the jack arrays in init callback which
may be called also in each PM resume.  This results in the addition of
new jack element at each time.

The fix is to check whether the requested jack is already present in
the array.

Reference: Novell bug 668929
	https://bugzilla.novell.com/show_bug.cgi?id=668929

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_conexant.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -366,10 +366,16 @@ static int conexant_add_jack(struct hda_
 	struct conexant_spec *spec;
 	struct conexant_jack *jack;
 	const char *name;
-	int err;
+	int i, err;
 
 	spec = codec->spec;
 	snd_array_init(&spec->jacks, sizeof(*jack), 32);
+
+	jack = spec->jacks.list;
+	for (i = 0; i < spec->jacks.used; i++, jack++)
+		if (jack->nid == nid)
+			return 0 ; /* already present */
+
 	jack = snd_array_new(&spec->jacks);
 	name = (type == SND_JACK_HEADPHONE) ? "Headphone" : "Mic" ;
 


