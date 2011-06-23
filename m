Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1FWRWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:63145 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759Ab1FWRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 041/247] ALSA: hda - Fix memory leaks in conexant jack arrays
Date: Thu, 23 Jun 2011 13:18:04 -0400
Message-Id: <1308849690-14530-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 70f7db11c45a313b23922cacf248c613c3b2144c upstream.

The Conexant codec driver adds the jack arrays in init callback which
may be called also in each PM resume.  This results in the addition of
new jack element at each time.

The fix is to check whether the requested jack is already present in
the array.

Reference: Novell bug 668929
	https://bugzilla.novell.com/show_bug.cgi?id=668929

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_conexant.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 405492d..fb5752d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -389,10 +389,16 @@ static int conexant_add_jack(struct hda_codec *codec,
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
 
-- 
1.7.4.4

