Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000Ab2BJXSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:18:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2BJWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:28 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.488144229@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dylan Reid <dgreid@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 05/86] ALSA: hda - Fix calling cs_automic twice for Cirrus codecs.
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit f70eecde3bca92630d3886496e73316ff353f185 upstream.

If cs_automic is called twice (like it is during init) while the mic
is present, it will over-write the last_input with the new one,
causing it to switch back to the automic input when the mic is
unplugged. This leaves the driver in a state (cur_input, last_input,
and automix_idx the same) where the internal mic can not be selected
until it is rebooted without the mic attached.

Check that the mic hasn't already been switched to before setting
last_input.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -976,8 +976,10 @@ static void cs_automic(struct hda_codec
 	/* specific to CS421x, single ADC */
 	if (spec->vendor_nid == CS421X_VENDOR_NID) {
 		if (present) {
-			spec->last_input = spec->cur_input;
-			spec->cur_input = spec->automic_idx;
+			if (spec->cur_input != spec->automic_idx) {
+				spec->last_input = spec->cur_input;
+				spec->cur_input = spec->automic_idx;
+			}
 		} else  {
 			spec->cur_input = spec->last_input;
 		}


