Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1KPIjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:39:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:12240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1KPIjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:39:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="76209629"
Message-Id: <20111116083514.568265053@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 16 Nov 2011 16:29:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
cc: <alsa-devel@alsa-project.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] hda - delayed ELD repoll
References: <20111116082945.414733231@intel.com>
Content-Disposition: inline; filename=eld-delayed-work
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel HDMI chips (ironlake at least) are found to have ~250ms delay
between the ELD_Valid=1 hotplug event is send and the ELD buffer becomes
actually readable. During the time the ELD buffer is mysteriously all 0.

Fix it by scheduling a delayed work to re-read ELD buffer after 300ms.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 sound/pci/hda/patch_hdmi.c |   36 ++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- linux.orig/sound/pci/hda/patch_hdmi.c	2011-11-16 09:53:01.000000000 +0800
+++ linux/sound/pci/hda/patch_hdmi.c	2011-11-16 10:33:06.000000000 +0800
@@ -65,7 +65,10 @@ struct hdmi_spec_per_pin {
 	hda_nid_t pin_nid;
 	int num_mux_nids;
 	hda_nid_t mux_nids[HDA_MAX_CONNECTIONS];
+
+	struct hda_codec *codec;
 	struct hdmi_eld sink_eld;
+	struct delayed_work work;
 };
 
 struct hdmi_spec {
@@ -745,8 +748,7 @@ static void hdmi_setup_audio_infoframe(s
  * Unsolicited events
  */
 
-static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
-			       struct hdmi_eld *eld);
+static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, bool retry);
 
 static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
 {
@@ -766,7 +768,7 @@ static void hdmi_intrinsic_event(struct 
 		return;
 	eld = &spec->pins[pin_idx].sink_eld;
 
-	hdmi_present_sense(codec, pin_nid, eld);
+	hdmi_present_sense(&spec->pins[pin_idx], true);
 
 	/*
 	 * HDMI sink's ELD info cannot always be retrieved for now, e.g.
@@ -968,9 +970,11 @@ static int hdmi_read_pin_conn(struct hda
 	return 0;
 }
 
-static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
-			       struct hdmi_eld *eld)
+static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, bool retry)
 {
+	struct hda_codec *codec = per_pin->codec;
+	struct hdmi_eld *eld = &per_pin->sink_eld;
+	hda_nid_t pin_nid = per_pin->pin_nid;
 	/*
 	 * Always execute a GetPinSense verb here, even when called from
 	 * hdmi_intrinsic_event; for some NVIDIA HW, the unsolicited
@@ -992,13 +996,27 @@ static void hdmi_present_sense(struct hd
 		"HDMI status: Codec=%d Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
 		codec->addr, pin_nid, eld->monitor_present, eld_valid);
 
-	if (eld_valid)
+	if (eld_valid) {
 		if (!snd_hdmi_get_eld(eld, codec, pin_nid))
 			snd_hdmi_show_eld(eld);
+		else if (retry) {
+			queue_delayed_work(codec->bus->workq,
+					   &per_pin->work,
+					   msecs_to_jiffies(300));
+		}
+	}
 
 	snd_hda_input_jack_report(codec, pin_nid);
 }
 
+static void hdmi_repoll_eld(struct work_struct *work)
+{
+	struct hdmi_spec_per_pin *per_pin =
+	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
+
+	hdmi_present_sense(per_pin, false);
+}
+
 static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 {
 	struct hdmi_spec *spec = codec->spec;
@@ -1227,7 +1245,7 @@ static int generic_hdmi_build_jack(struc
 	if (err < 0)
 		return err;
 
-	hdmi_present_sense(codec, per_pin->pin_nid, &per_pin->sink_eld);
+	hdmi_present_sense(per_pin, false);
 	return 0;
 }
 
@@ -1278,6 +1296,8 @@ static int generic_hdmi_init(struct hda_
 				    AC_VERB_SET_UNSOLICITED_ENABLE,
 				    AC_USRSP_EN | pin_nid);
 
+		per_pin->codec = codec;
+		INIT_DELAYED_WORK(&per_pin->work, hdmi_repoll_eld);
 		snd_hda_eld_proc_new(codec, eld, pin_idx);
 	}
 	return 0;
@@ -1292,10 +1312,12 @@ static void generic_hdmi_free(struct hda
 		struct hdmi_spec_per_pin *per_pin = &spec->pins[pin_idx];
 		struct hdmi_eld *eld = &per_pin->sink_eld;
 
+		cancel_delayed_work(&per_pin->work);
 		snd_hda_eld_proc_free(codec, eld);
 	}
 	snd_hda_input_jack_free(codec);
 
+	flush_workqueue(codec->bus->workq);
 	kfree(spec);
 }
 


