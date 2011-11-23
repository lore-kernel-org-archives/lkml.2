Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1KWA52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:57:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1KWAfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:35:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:55 2011
Message-Id: <20111123002555.453658442@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Pierre-louis Bossart <pierre-louis.bossart@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [27/53] ALSA: hda - fix ELD memory leak
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


Backported from commit b95d68b8179764e29558b75cec35ef4a6a98925b.

memset(eld) clears eld->proc_entry which will leak the struct
snd_info_entry when unloading module.

Fix it by
- memset only the fields before eld->eld_buffer
- set eld->eld_valid to true _after_ all eld fields have been filled

Cc: Pierre-louis Bossart <pierre-louis.bossart@intel.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_eld.c    |    5 +----
 sound/pci/hda/patch_hdmi.c |   15 +++++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -297,10 +297,10 @@ static int hdmi_update_eld(struct hdmi_e
 					buf + ELD_FIXED_BYTES + mnl + 3 * i);
 	}
 
+	e->eld_valid = true;
 	return 0;
 
 out_fail:
-	e->eld_ver = 0;
 	return -EINVAL;
 }
 
@@ -318,9 +318,6 @@ int snd_hdmi_get_eld(struct hdmi_eld *el
 	int size;
 	unsigned char *buf;
 
-	if (!eld->eld_valid)
-		return -ENOENT;
-
 	size = snd_hdmi_get_eld_size(codec, nid);
 	if (size == 0) {
 		/* wfg: workaround for ASUS P5E-VM HDMI board */
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -920,20 +920,23 @@ static void hdmi_present_sense(struct hd
 	 * the unsolicited response to avoid custom WARs.
 	 */
 	int present = snd_hda_pin_sense(codec, pin_nid);
+	bool eld_valid = false;
 
-	memset(eld, 0, sizeof(*eld));
+#ifdef CONFIG_PROC_FS
+	memset(eld, 0, offsetof(struct hdmi_eld, proc_entry));
+#else
+	memset(eld, 0, sizeof(struct hdmi_eld));
+#endif
 
 	eld->monitor_present	= !!(present & AC_PINSENSE_PRESENCE);
 	if (eld->monitor_present)
-		eld->eld_valid	= !!(present & AC_PINSENSE_ELDV);
-	else
-		eld->eld_valid	= 0;
+		eld_valid	= !!(present & AC_PINSENSE_ELDV);
 
 	printk(KERN_INFO
 		"HDMI status: Codec=%d Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
-		codec->addr, pin_nid, eld->monitor_present, eld->eld_valid);
+		codec->addr, pin_nid, eld->monitor_present, eld_valid);
 
-	if (eld->eld_valid)
+	if (eld_valid)
 		if (!snd_hdmi_get_eld(eld, codec, pin_nid))
 			snd_hdmi_show_eld(eld);
 


