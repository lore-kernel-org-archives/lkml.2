Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1KPIjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:39:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:37299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab1KPIjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,520,1315206000"; 
   d="scan'208";a="75559096"
Message-Id: <20111116083514.440785922@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 16 Nov 2011 16:29:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
cc: <alsa-devel@alsa-project.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Pierre-louis Bossart <pierre-louis.bossart@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] hda - fix ELD memory leak
References: <20111116082945.414733231@intel.com>
Content-Disposition: inline; filename=fix-eld-memset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset(eld) clears eld->proc_entry which will leak the struct
snd_info_entry when unloading module.

Fix it by
- memset only the fields before eld->eld_buffer
- set eld->eld_valid to true _after_ all eld fields have been filled

cc: <stable@kernel.org>
cc: Pierre-louis Bossart <pierre-louis.bossart@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 sound/pci/hda/hda_eld.c    |    5 +----
 sound/pci/hda/hda_local.h  |    3 +++
 sound/pci/hda/patch_hdmi.c |   11 +++++------
 3 files changed, 9 insertions(+), 10 deletions(-)

--- linux.orig/sound/pci/hda/hda_eld.c	2011-11-15 21:02:25.000000000 +0800
+++ linux/sound/pci/hda/hda_eld.c	2011-11-15 21:27:36.000000000 +0800
@@ -297,10 +297,10 @@ static int hdmi_update_eld(struct hdmi_e
 					buf + ELD_FIXED_BYTES + mnl + 3 * i);
 	}
 
+	e->eld_valid = true;
 	return 0;
 
 out_fail:
-	e->eld_ver = 0;
 	return -EINVAL;
 }
 
@@ -323,9 +323,6 @@ int snd_hdmi_get_eld(struct hdmi_eld *el
 	 * ELD is valid, actual eld_size is assigned in hdmi_update_eld()
 	 */
 
-	if (!eld->eld_valid)
-		return -ENOENT;
-
 	size = snd_hdmi_get_eld_size(codec, nid);
 	if (size == 0) {
 		/* wfg: workaround for ASUS P5E-VM HDMI board */
--- linux.orig/sound/pci/hda/patch_hdmi.c	2011-11-15 21:02:25.000000000 +0800
+++ linux/sound/pci/hda/patch_hdmi.c	2011-11-16 09:34:27.000000000 +0800
@@ -980,20 +980,19 @@ static void hdmi_present_sense(struct hd
 	 * the unsolicited response to avoid custom WARs.
 	 */
 	int present = snd_hda_pin_sense(codec, pin_nid);
+	bool eld_valid = false;
 
-	memset(eld, 0, sizeof(*eld));
+	memset(eld, 0, offsetof(struct hdmi_eld, eld_buffer));
 
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
 
--- linux.orig/sound/pci/hda/hda_local.h	2011-11-16 09:31:30.000000000 +0800
+++ linux/sound/pci/hda/hda_local.h	2011-11-16 09:33:45.000000000 +0800
@@ -651,6 +651,9 @@ struct hdmi_eld {
 	int	spk_alloc;
 	int	sad_count;
 	struct cea_sad sad[ELD_MAX_SAD];
+	/*
+	 * all fields above eld_buffer will be cleared before updating ELD
+	 */
 	char    eld_buffer[ELD_MAX_SIZE];
 #ifdef CONFIG_PROC_FS
 	struct snd_info_entry *proc_entry;


