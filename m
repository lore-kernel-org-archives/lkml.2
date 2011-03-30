Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454Ab1C3WFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:05:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:15931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234Ab1C3VGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447238"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [46/275] ALSA: hda - Fix memory leaks in conexant jack arrays
Message-Id: <20110330210442.20D173E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_conexant.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/pci/hda/patch_conexant.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_conexant.c	2011-03-29 22:51:50.977418784 -0700
+++ linux-2.6.35.y/sound/pci/hda/patch_conexant.c	2011-03-29 23:02:59.140322167 -0700
@@ -391,10 +391,16 @@
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
 
