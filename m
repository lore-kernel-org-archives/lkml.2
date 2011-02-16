Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab1BPBhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:37:16 -0500
Received: from kroah.org ([198.145.64.141]:39106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab1BPAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:34 2011
Message-Id: <20110216001434.315840294@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [092/272] ALSA: hda - Add static_hdmi_pcm option to HDMI codec parser
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0ebaa24c6b1f62839bcd12d63fa76e3cf23b9bd0 upstream.

The dynamic PCM restriction based on ELD information may lead to the
problem in some cases, e.g. when the receiver is turned off.  Then it
may send a TV HDMI default such as channels = 2.  Since it's still
plugged, the driver doesn't know whether it's the right configuration
for future use.  Now, when an app opens the device at this moment,
then turn on the receiver, the app still sends channels=2.

The right solution is to implement some kind of notification and
automatic re-open mechanism.  But, this is a goal far ahead.

This patch provides a workaround for such a case by providing a new
module option static_hdmi_pcm for snd-hda-codec-hdmi module.  When
this is set to true, the driver doesn't change PCM parameters per
ELD information.  For users who need the static configuration like
the scenario above, set this to true.

The parameter can be changed dynamically via sysfs, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -31,10 +31,15 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/moduleparam.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
 
+static bool static_hdmi_pcm;
+module_param(static_hdmi_pcm, bool, 0644);
+MODULE_PARM_DESC(static_hdmi_pcm, "Don't restrict PCM parameters per ELD info");
+
 /*
  * The HDMI/DisplayPort configuration can be highly dynamic. A graphics device
  * could support two independent pipes, each of them can be connected to one or
@@ -827,7 +832,7 @@ static int hdmi_pcm_open(struct hda_pcm_
 		*codec_pars = *hinfo;
 
 	eld = &spec->sink_eld[idx];
-	if (eld->eld_valid && eld->sad_count > 0) {
+	if (!static_hdmi_pcm && eld->eld_valid && eld->sad_count > 0) {
 		hdmi_eld_update_pcm_info(eld, hinfo, codec_pars);
 		if (hinfo->channels_min > hinfo->channels_max ||
 		    !hinfo->rates || !hinfo->formats)


