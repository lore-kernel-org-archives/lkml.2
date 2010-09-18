Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0IRTbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:31:22 -0400
Received: from kroah.org ([198.145.64.141]:43405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab0IRTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:15 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.787152957@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Daniel Mack <daniel@caiaq.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [052/129] ALSA: usb-audio: fix detection of vendor-specific device protocol settings
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit a2acad8298a42b7be684a32fafaf83332bba9c2b upstream.

The Audio Class v2 support code in 2.6.35 added checks for the
bInterfaceProtocol field.  However, there are devices (usually those
detected by vendor-specific quirks) that do not have one of the
predefined values in this field, which made the driver reject them.

To fix this regression, restore the old behaviour, i.e., assume that
a device with an unknown bInterfaceProtocol field (other than
UAC_VERSION_2) has more or less UAC-v1-compatible descriptors.

[compile warning fixes by tiwai]

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c     |    9 +++++----
 sound/usb/clock.c    |    3 +--
 sound/usb/endpoint.c |   11 ++++++-----
 sound/usb/format.c   |   14 ++++++++++----
 sound/usb/mixer.c    |   10 +++++++++-
 sound/usb/pcm.c      |    3 +--
 6 files changed, 32 insertions(+), 18 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -216,6 +216,11 @@ static int snd_usb_create_streams(struct
 	}
 
 	switch (protocol) {
+	default:
+		snd_printdd(KERN_WARNING "unknown interface protocol %#02x, assuming v1\n",
+			    protocol);
+		/* fall through */
+
 	case UAC_VERSION_1: {
 		struct uac_ac_header_descriptor_v1 *h1 = control_header;
 
@@ -253,10 +258,6 @@ static int snd_usb_create_streams(struct
 
 		break;
 	}
-
-	default:
-		snd_printk(KERN_ERR "unknown protocol version 0x%02x\n", protocol);
-		return -EINVAL;
 	}
 
 	return 0;
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -304,12 +304,11 @@ int snd_usb_init_sample_rate(struct snd_
 
 	switch (altsd->bInterfaceProtocol) {
 	case UAC_VERSION_1:
+	default:
 		return set_sample_rate_v1(chip, iface, alts, fmt, rate);
 
 	case UAC_VERSION_2:
 		return set_sample_rate_v2(chip, iface, alts, fmt, rate);
 	}
-
-	return -EINVAL;
 }
 
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -274,6 +274,12 @@ int snd_usb_parse_audio_endpoints(struct
 
 		/* get audio formats */
 		switch (protocol) {
+		default:
+			snd_printdd(KERN_WARNING "%d:%u:%d: unknown interface protocol %#02x, assuming v1\n",
+				    dev->devnum, iface_no, altno, protocol);
+			protocol = UAC_VERSION_1;
+			/* fall through */
+
 		case UAC_VERSION_1: {
 			struct uac_as_header_descriptor_v1 *as =
 				snd_usb_find_csint_desc(alts->extra, alts->extralen, NULL, UAC_AS_GENERAL);
@@ -335,11 +341,6 @@ int snd_usb_parse_audio_endpoints(struct
 				   dev->devnum, iface_no, altno, as->bTerminalLink);
 			continue;
 		}
-
-		default:
-			snd_printk(KERN_ERR "%d:%u:%d : unknown interface protocol %04x\n",
-				   dev->devnum, iface_no, altno, protocol);
-			continue;
 		}
 
 		/* get format type */
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -49,7 +49,8 @@ static u64 parse_audio_format_i_type(str
 	u64 pcm_formats;
 
 	switch (protocol) {
-	case UAC_VERSION_1: {
+	case UAC_VERSION_1:
+	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
@@ -64,9 +65,6 @@ static u64 parse_audio_format_i_type(str
 		format <<= 1;
 		break;
 	}
-
-	default:
-		return -EINVAL;
 	}
 
 	pcm_formats = 0;
@@ -385,6 +383,10 @@ static int parse_audio_format_i(struct s
 	 * audio class v2 uses class specific EP0 range requests for that.
 	 */
 	switch (protocol) {
+	default:
+		snd_printdd(KERN_WARNING "%d:%u:%d : invalid protocol version %d, assuming v1\n",
+			   chip->dev->devnum, fp->iface, fp->altsetting, protocol);
+		/* fall through */
 	case UAC_VERSION_1:
 		fp->channels = fmt->bNrChannels;
 		ret = parse_audio_format_rates_v1(chip, fp, (unsigned char *) fmt, 7);
@@ -435,6 +437,10 @@ static int parse_audio_format_ii(struct
 	fp->channels = 1;
 
 	switch (protocol) {
+	default:
+		snd_printdd(KERN_WARNING "%d:%u:%d : invalid protocol version %d, assuming v1\n",
+			   chip->dev->devnum, fp->iface, fp->altsetting, protocol);
+		/* fall through */
 	case UAC_VERSION_1: {
 		struct uac_format_type_ii_discrete_descriptor *fmt = _fmt;
 		brate = le16_to_cpu(fmt->wMaxBitRate);
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2168,7 +2168,15 @@ int snd_usb_create_mixer(struct snd_usb_
 	}
 
 	host_iface = &usb_ifnum_to_if(chip->dev, ctrlif)->altsetting[0];
-	mixer->protocol = get_iface_desc(host_iface)->bInterfaceProtocol;
+	switch (get_iface_desc(host_iface)->bInterfaceProtocol) {
+	case UAC_VERSION_1:
+	default:
+		mixer->protocol = UAC_VERSION_1;
+		break;
+	case UAC_VERSION_2:
+		mixer->protocol = UAC_VERSION_2;
+		break;
+	}
 
 	if ((err = snd_usb_mixer_controls(mixer)) < 0 ||
 	    (err = snd_usb_mixer_status_create(mixer)) < 0)
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -173,13 +173,12 @@ int snd_usb_init_pitch(struct snd_usb_au
 
 	switch (altsd->bInterfaceProtocol) {
 	case UAC_VERSION_1:
+	default:
 		return init_pitch_v1(chip, iface, alts, fmt);
 
 	case UAC_VERSION_2:
 		return init_pitch_v2(chip, iface, alts, fmt);
 	}
-
-	return -EINVAL;
 }
 
 /*


