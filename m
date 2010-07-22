Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0GVDOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:14:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0GVDOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:14:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 21 Jul 2010 20:14:31 -0700
From: Wei Ni <wni@nvidia.com>
To: "'Takashi Iwai'" <tiwai@suse.de>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        "'Pavel Hofman'" <pavel.hofman@insite.cz>,
        "'alsa-devel'" <alsa-devel@alsa-project.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'akpm'" <akpm@linux-foundation.org>
Date: Thu, 22 Jul 2010 11:14:26 +0800
Subject: RE: Support MCP89 hdmi audio
Thread-Topic: Support MCP89 hdmi audio
Thread-Index: Acso07nMflWDO5UDTmCfLvbdwLjmOgAeCMgw
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C29D065C72@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C29D065C70@HKMAIL01.nvidia.com>
 <s5hr5ix2dzb.wl%tiwai@suse.de>
In-Reply-To: <s5hr5ix2dzb.wl%tiwai@suse.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's great, I will try it.

Thanks
Wei.

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Wednesday, July 21, 2010 8:53 PM
To: Wei Ni
Cc: Wu Fengguang; 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
Subject: Re: Support MCP89 hdmi audio

At Wed, 21 Jul 2010 19:45:09 +0800,
Wei Ni wrote:
> 
> Hi, all
> I'm an Nvidia engineer, I maintain the nvidia linux hdmi audio driver.
> 
> An end-user report a problem with his TV attached to an MCP89.
> ALSA won't send audio to it, because
> PD=0:
> HDMI hot plug event: Pin=5 Presence_Detect=1 ELD_Valid=0
> HDMI hot plug event: Pin=5 Presence_Detect=0 ELD_Valid=1
> 
> As you know, in linux driver patch_hdmi.c, it use (pind && eldv)
> in unsolicited events. So the driver can't detect the monitor.
> 
> >From the HAD specification
> (http://download.intel.com/standards/hdaudio/pdf/HDA036.pdf):
> 
> Original text for Unsolicited Response PD bit:
> 
> Presence Detect: When this bit is set, sense measurement has
> changed on the pin widget and software can use the pin sense
> control verb to determine the current pin sense data state.
> For analog pin widgets, this UR means that Presence Detect or
> Impedance has changed on the pin widget.
> For digital pin widgets, including HDMI pin widgets, this means
> that presence detect (and optionally ELD valid bit) has
> **changed**. [my emphasis]
> 
> Updated text for Unsolicted Response PD bit:
> 
> Presence Detect: This bit reflects the **present** [my
> emphasis] state of the Pin Sense Presence Detect bit when the
> unsolicited response is triggered. Software can optionally use
> the pin sense control verb to determine the latest pin sense
> data state. This bit implementation is only required for
> digital display pin widget. Non digital display pin widget is
> optional to implement this bit.
> 
> For our MCP89, the values indicates the change of status of PD, not the actual value of PD,
> which follows older description of UR for PD bit.
> 
> So could we add a workaround for MCP89? We could use Pin Sense to determine again in
> unsolicited events. If it return 0xc0000000, it means PD=1 and ELVD=1.
> Or do you have any suggestions?

Yes.  The patch below does similar thing.
Could you give it a try?


thanks,

Takashi

---
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 86067ee..2fc5396 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -52,6 +52,10 @@ struct hdmi_spec {
 	 */
 	struct hda_multi_out multiout;
 	unsigned int codec_type;
+
+	/* misc flags */
+	/* PD bit indicates only the update, not the current state */
+	unsigned int old_pin_detect:1;
 };
 
 
@@ -616,6 +620,9 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec, hda_nid_t nid,
  * Unsolicited events
  */
 
+static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
+			       struct hdmi_eld *eld);
+
 static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
 {
 	struct hdmi_spec *spec = codec->spec;
@@ -632,6 +639,12 @@ static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
 	if (index < 0)
 		return;
 
+	if (spec->old_pin_detect) {
+		if (pind)
+			hdmi_present_sense(codec, tag, &spec->sink_eld[index]);
+		pind = spec->sink_eld[index].monitor_present;
+	}
+
 	spec->sink_eld[index].monitor_present = pind;
 	spec->sink_eld[index].eld_valid = eldv;
 
diff --git a/sound/pci/hda/patch_nvhdmi.c b/sound/pci/hda/patch_nvhdmi.c
index 3c10c0b..b0652ac 100644
--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -478,6 +478,7 @@ static int patch_nvhdmi_8ch_89(struct hda_codec *codec)
 
 	codec->spec = spec;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP89;
+	spec->old_pin_detect = 1;
 
 	if (hdmi_parse_codec(codec) < 0) {
 		codec->spec = NULL;
@@ -508,6 +509,7 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 	spec->multiout.max_channels = 8;
 	spec->multiout.dig_out_nid = nvhdmi_master_con_nid_7x;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP7X;
+	spec->old_pin_detect = 1;
 
 	codec->patch_ops = nvhdmi_patch_ops_8ch_7x;
 
@@ -528,6 +530,7 @@ static int patch_nvhdmi_2ch(struct hda_codec *codec)
 	spec->multiout.max_channels = 2;
 	spec->multiout.dig_out_nid = nvhdmi_master_con_nid_7x;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP7X;
+	spec->old_pin_detect = 1;
 
 	codec->patch_ops = nvhdmi_patch_ops_2ch;
 
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
