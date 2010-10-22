Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JVLaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:30:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59940 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0JVLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:30:19 -0400
X-Sasl-enc: 3WHSF9REw4y1v7nvMrI341wTsGuxIuhzKCvkstAX0GuH 1287747016
Message-ID: <4CC17629.6050703@ladisch.de>
Date: Fri, 22 Oct 2010 13:31:53 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org
Subject: Re: [alsa-devel] HDA: no sound [was: mmotm 2010-10-20-15-01	uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de> <4CC085F5.9070905@gmail.com>
In-Reply-To: <4CC085F5.9070905@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 10/21/2010 10:05 AM, Takashi Iwai wrote:
> >   commit de8c85f7840e5e29629de95f5af24297fb325e0b
> >     ALSA: HDA: Sigmatel: work around incorrect master muting
> 
> Reverting this one helps.

This one introduced even more wrong volume information on some codecs.
Pleasy try this patch on top:

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -32,6 +32,7 @@
 #include <sound/core.h>
 #include <sound/asoundef.h>
 #include <sound/jack.h>
+#include <sound/tlv.h>
 #include "hda_codec.h"
 #include "hda_local.h"
 #include "hda_beep.h"
@@ -1145,7 +1146,7 @@ static int stac92xx_build_controls(struct hda_codec *codec)
 		/* correct volume offset */
 		vmaster_tlv[2] += vmaster_tlv[3] * spec->volume_offset;
 		/* minimum value is actually mute */
-		vmaster_tlv[3] |= 0x1000;
+		vmaster_tlv[3] |= TLV_DB_SCALE_MUTE;
 		err = snd_hda_add_vmaster(codec, "Master Playback Volume",
 					  vmaster_tlv, slave_vols);
 		if (err < 0)

