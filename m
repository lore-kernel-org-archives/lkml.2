Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1KJSiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:38:52 -0500
Received: from www17.your-server.de ([213.133.104.17]:50484 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1KJSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:38:50 -0500
Message-ID: <1320950323.20155.106.camel@localhost.localdomain>
Subject: [PATCH] ALSA: usb-audio: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 19:38:43 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/sound/usb/quirks.c b/sound/usb/quirks.c
--- a/sound/usb/quirks.c 2011-11-07 19:38:37.987378553 +0100
+++ b/sound/usb/quirks.c 2011-11-08 11:06:23.015258350 +0100
@@ -137,12 +137,12 @@ static int create_fixed_stream_quirk(str
 		return -ENOMEM;
 	}
 	if (fp->nr_rates > 0) {
-		rate_table = kmalloc(sizeof(int) * fp->nr_rates, GFP_KERNEL);
+		rate_table = kmemdup(fp->rate_table,
+				     sizeof(int) * fp->nr_rates, GFP_KERNEL);
 		if (!rate_table) {
 			kfree(fp);
 			return -ENOMEM;
 		}
-		memcpy(rate_table, fp->rate_table, sizeof(int) * fp->nr_rates);
 		fp->rate_table = rate_table;
 	}
 
@@ -224,10 +224,9 @@ static int create_uaxx_quirk(struct snd_
 	if (altsd->bNumEndpoints != 1)
 		return -ENXIO;
 
-	fp = kmalloc(sizeof(*fp), GFP_KERNEL);
+	fp = kmemdup(&ua_format, sizeof(*fp), GFP_KERNEL);
 	if (!fp)
 		return -ENOMEM;
-	memcpy(fp, &ua_format, sizeof(*fp));
 
 	fp->iface = altsd->bInterfaceNumber;
 	fp->endpoint = get_endpoint(alts, 0)->bEndpointAddress;
.

