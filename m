Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1KVIAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:00:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:12618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab1KVIAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:00:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78681879"
Date: Tue, 22 Nov 2011 16:00:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] hda - delayed ELD repoll
Message-ID: <20111122080038.GA22354@localhost>
References: <20111116082945.414733231@intel.com>
 <20111116083514.568265053@intel.com>
 <20111121064811.GA24027@localhost>
 <s5hr510397z.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr510397z.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 03:30:24PM +0800, Takashi Iwai wrote:
> At Mon, 21 Nov 2011 14:48:11 +0800,
> Wu Fengguang wrote:
> > 
> > On Wed, Nov 16, 2011 at 04:29:47PM +0800, Wu, Fengguang wrote:
> > > The Intel HDMI chips (ironlake at least) are found to have ~250ms delay
> > > between the ELD_Valid=1 hotplug event is send and the ELD buffer becomes
> > > actually readable. During the time the ELD buffer is mysteriously all 0.
> > > 
> > > Fix it by scheduling a delayed work to re-read ELD buffer after 300ms.
> > 
> > Just FYI.
> > 
> > Up to now the 300ms looks sufficient. But if ever there comes longer
> > delays, I've already prepared a patch for retrying it for several times ;)
> 
> Thanks.  I think it's safer to have a repoll mechanism.
> But, looking at the patch, one question remains:
> 
> > @@ -989,10 +990,9 @@ static void hdmi_present_sense(struct hd
> >  	if (eld_valid) {
> >  		if (!snd_hdmi_get_eld(eld, codec, pin_nid))
> >  			snd_hdmi_show_eld(eld);
> > -		else if (retry) {
> > +		else if (repoll) {
> >  			queue_delayed_work(codec->bus->workq,
> > -					   &per_pin->work,
> > -					   msecs_to_jiffies(300));
> > +					   &per_pin->work, repoll * HZ / 3);
> 
> Do you really want to wait longer with a higher repoll number?

I think it would be good to keep constant repoll intervals (it's cheap
after all), but at the same time lift the retry time from 3 to 6.

I did this patch when I got the graphics driver side wrong and
triggered the hotplug event rather early. At the time I find that it
failed until the 3rd repoll (300ms + 600ms + 900ms).

Thanks,
Fengguang
---

Subject: hda - repoll ELD content for multiple times
Date: Fri Nov 18 16:59:32 CST 2011

Improve the one-shot ELD repoll to up to 6 retries.

Up to now the 300ms looks sufficient for the test boxes. However
I'm a bit worried about how well it can fit the wider user base.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 sound/pci/hda/patch_hdmi.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- linux.orig/sound/pci/hda/patch_hdmi.c	2011-11-22 15:50:21.000000000 +0800
+++ linux/sound/pci/hda/patch_hdmi.c	2011-11-22 15:50:41.000000000 +0800
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
@@ -989,7 +990,7 @@ static void hdmi_present_sense(struct hd
 	if (eld_valid) {
 		if (!snd_hdmi_get_eld(eld, codec, pin_nid))
 			snd_hdmi_show_eld(eld);
-		else if (retry) {
+		else if (repoll) {
 			queue_delayed_work(codec->bus->workq,
 					   &per_pin->work,
 					   msecs_to_jiffies(300));
@@ -1004,7 +1005,10 @@ static void hdmi_repoll_eld(struct work_
 	struct hdmi_spec_per_pin *per_pin =
 	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
 
-	hdmi_present_sense(per_pin, false);
+	if (per_pin->repoll_count++ > 6)
+		per_pin->repoll_count = 0;
+
+	hdmi_present_sense(per_pin, per_pin->repoll_count);
 }
 
 static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
@@ -1235,7 +1239,7 @@ static int generic_hdmi_build_jack(struc
 	if (err < 0)
 		return err;
 
-	hdmi_present_sense(per_pin, false);
+	hdmi_present_sense(per_pin, 0);
 	return 0;
 }
 
