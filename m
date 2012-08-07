Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab2HGDs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:48:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59743 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356Ab2HGDif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:35 -0400
Message-Id: <20120807032804.517490410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Mack <zonque@gmail.com>,
        Andreas Koch <andreas@akdesigninc.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 58/70] ALSA: snd-usb: fix clock source validity index
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit aff252a848ce21b431ba822de3dab9c4c94571cb upstream.

uac_clock_source_is_valid() uses the control selector value to access
the bmControls bitmap of the clock source unit. This is wrong, as
control selector values start from 1, while the bitmap uses all
available bits.

In other words, "Clock Validity Control" is stored in D3..2, not D5..4
of the clock selector unit's bmControls.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Andreas Koch <andreas@akdesigninc.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/clock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 379baad..5e634a2 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -111,7 +111,8 @@ static bool uac_clock_source_is_valid(struct snd_usb_audio *chip, int source_id)
 		return 0;
 
 	/* If a clock source can't tell us whether it's valid, we assume it is */
-	if (!uac2_control_is_readable(cs_desc->bmControls, UAC2_CS_CONTROL_CLOCK_VALID))
+	if (!uac2_control_is_readable(cs_desc->bmControls,
+				      UAC2_CS_CONTROL_CLOCK_VALID - 1))
 		return 1;
 
 	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0), UAC2_CS_CUR,


