Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1AMWFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:05:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26744 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1AMWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:05:48 -0500
Date: Thu, 13 Jan 2011 23:05:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Lee Jones <lee.jones@canonical.com>
Subject: [PATCH][rfc] media, video, stv06xx, pb0100: Don't potentially deref
 NULL in pb0100_start().
Message-ID: <alpine.LNX.2.00.1101132300490.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_altnum_to_altsetting() may return NULL. If it does we'll dereference a 
NULL pointer in 
drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c::pb0100_start().
As far as I can tell there's not really anything more sensible than 
-ENODEV that we can return in that situation, but I'm not at all intimate 
with this code so I'd like a bit of review/comments on this before it's 
applied.
Anyway, here's a proposed patch.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 stv06xx_pb0100.c |    2 ++
 1 file changed, 2 insertions(+)

  compile tested only.

diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
index ac47b4c..75a5b9c 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
@@ -217,6 +217,8 @@ static int pb0100_start(struct sd *sd)
 
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
 	alt = usb_altnum_to_altsetting(intf, sd->gspca_dev.alt);
+	if (!alt)
+		return -ENODEV;
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 
 	/* If we don't have enough bandwidth use a lower framerate */



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

