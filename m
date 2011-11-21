Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1KUGsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:48:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:34077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1KUGsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:48:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78274106"
Date: Mon, 21 Nov 2011 14:48:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] hda - delayed ELD repoll
Message-ID: <20111121064811.GA24027@localhost>
References: <20111116082945.414733231@intel.com>
 <20111116083514.568265053@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116083514.568265053@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 04:29:47PM +0800, Wu, Fengguang wrote:
> The Intel HDMI chips (ironlake at least) are found to have ~250ms delay
> between the ELD_Valid=1 hotplug event is send and the ELD buffer becomes
> actually readable. During the time the ELD buffer is mysteriously all 0.
> 
> Fix it by scheduling a delayed work to re-read ELD buffer after 300ms.

Just FYI.

Up to now the 300ms looks sufficient. But if ever there comes longer
delays, I've already prepared a patch for retrying it for several times ;)

Thanks,
Fengguang

---
 sound/pci/hda/patch_hdmi.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- linux.orig/sound/pci/hda/patch_hdmi.c	2011-11-18 17:05:44.000000000 +0800
+++ linux/sound/pci/hda/patch_hdmi.c	2011-11-21 10:45:22.000000000 +0800
@@ -69,6 +69,7 @@ struct hdmi_spec_per_pin {
 	struct hda_codec *codec;
 	struct hdmi_eld sink_eld;
 	struct delayed_work work;
+	int repoll_count;
 };
 
 struct hdmi_spec {
@@ -748,7 +749,7 @@ static void hdmi_setup_audio_infoframe(s
  * Unsolicited events
  */
 
-static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, bool retry);
+static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, int repoll);
 
 static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
 {
@@ -766,7 +767,7 @@ static void hdmi_intrinsic_event(struct 
 	if (pin_idx < 0)
 		return;
 
-	hdmi_present_sense(&spec->pins[pin_idx], true);
+	hdmi_present_sense(&spec->pins[pin_idx], 1);
 }
 
 static void hdmi_non_intrinsic_event(struct hda_codec *codec, unsigned int res)
@@ -960,7 +961,7 @@ static int hdmi_read_pin_conn(struct hda
 	return 0;
 }
 
-static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, bool retry)
+static void hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, int repoll)
 {
 	struct hda_codec *codec = per_pin->codec;
 	struct hdmi_eld *eld = &per_pin->sink_eld;
@@ -989,10 +990,9 @@ static void hdmi_present_sense(struct hd
 	if (eld_valid) {
 		if (!snd_hdmi_get_eld(eld, codec, pin_nid))
 			snd_hdmi_show_eld(eld);
-		else if (retry) {
+		else if (repoll) {
 			queue_delayed_work(codec->bus->workq,
-					   &per_pin->work,
-					   msecs_to_jiffies(300));
+					   &per_pin->work, repoll * HZ / 3);
 		}
 	}
 
@@ -1004,7 +1004,10 @@ static void hdmi_repoll_eld(struct work_
 	struct hdmi_spec_per_pin *per_pin =
 	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
 
-	hdmi_present_sense(per_pin, false);
+	if (per_pin->repoll_count++ > 3)
+		per_pin->repoll_count = 0;
+
+	hdmi_present_sense(per_pin, per_pin->repoll_count);
 }
 
 static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
@@ -1235,7 +1238,7 @@ static int generic_hdmi_build_jack(struc
 	if (err < 0)
 		return err;
 
-	hdmi_present_sense(per_pin, false);
+	hdmi_present_sense(per_pin, 0);
 	return 0;
 }
 
