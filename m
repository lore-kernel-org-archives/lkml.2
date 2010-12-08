Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab0LHBAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:05 -0500
Received: from kroah.org ([198.145.64.141]:48674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0LHBAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:01 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:28 2010
Message-Id: <20101208005728.147271155@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [068/289] ALSA: hda - Add workarounds for CT-IBG controllers
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 62b7e5e09bcb854ff05e6ee1aa161f8283dc36ee upstream.

Creative IBG controllers require the playback stream-tags to be started
from 1, instead of capture+1.  Otherwise the stream stalls.

Reported-by: Wai Yew CHAY <wychay@ctl.creative.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_codec.c |    5 ++++-
 sound/pci/hda/hda_intel.c |    9 +++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1216,6 +1216,7 @@ void snd_hda_codec_setup_stream(struct h
 	struct hda_codec *c;
 	struct hda_cvt_setup *p;
 	unsigned int oldval, newval;
+	int type;
 	int i;
 
 	if (!nid)
@@ -1254,10 +1255,12 @@ void snd_hda_codec_setup_stream(struct h
 	p->dirty = 0;
 
 	/* make other inactive cvts with the same stream-tag dirty */
+	type = get_wcaps_type(get_wcaps(codec, nid));
 	list_for_each_entry(c, &codec->bus->codec_list, list) {
 		for (i = 0; i < c->cvt_setups.used; i++) {
 			p = snd_array_elem(&c->cvt_setups, i);
-			if (!p->active && p->stream_tag == stream_tag)
+			if (!p->active && p->stream_tag == stream_tag &&
+			    get_wcaps_type(get_wcaps(codec, p->nid)) == type)
 				p->dirty = 1;
 		}
 	}
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1647,7 +1647,7 @@ static int azx_pcm_prepare(struct snd_pc
 	struct azx_dev *azx_dev = get_azx_dev(substream);
 	struct hda_pcm_stream *hinfo = apcm->hinfo[substream->stream];
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	unsigned int bufsize, period_bytes, format_val;
+	unsigned int bufsize, period_bytes, format_val, stream_tag;
 	int err;
 
 	azx_stream_reset(chip, azx_dev);
@@ -1689,7 +1689,12 @@ static int azx_pcm_prepare(struct snd_pc
 	else
 		azx_dev->fifo_size = 0;
 
-	return snd_hda_codec_prepare(apcm->codec, hinfo, azx_dev->stream_tag,
+	stream_tag = azx_dev->stream_tag;
+	/* CA-IBG chips need the playback stream starting from 1 */
+	if (chip->driver_type == AZX_DRIVER_CTX &&
+	    stream_tag > chip->capture_streams)
+		stream_tag -= chip->capture_streams;
+	return snd_hda_codec_prepare(apcm->codec, hinfo, stream_tag,
 				     azx_dev->format_val, substream);
 }
 


