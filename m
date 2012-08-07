Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031355Ab2HGWuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031252Ab2HGWrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Andreas Koch <andreas@akdesigninc.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 41/49] ALSA: snd-usb: fix clock source validity index
Date: Tue,  7 Aug 2012 15:44:59 -0700
Message-Id: <20120807222030.552691996@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/clock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -111,7 +111,8 @@ static bool uac_clock_source_is_valid(st
 		return 0;
 
 	/* If a clock source can't tell us whether it's valid, we assume it is */
-	if (!uac2_control_is_readable(cs_desc->bmControls, UAC2_CS_CONTROL_CLOCK_VALID))
+	if (!uac2_control_is_readable(cs_desc->bmControls,
+				      UAC2_CS_CONTROL_CLOCK_VALID - 1))
 		return 1;
 
 	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0), UAC2_CS_CUR,


