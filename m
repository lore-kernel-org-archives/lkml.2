Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030873Ab2I1TJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:09:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030676Ab2I1TG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 256/262] ALSA: snd-usb: fix next_packet_size calls for pause case
Date: Fri, 28 Sep 2012 11:53:05 -0700
Message-Id: <20120928183028.767976040@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 8dce30c89113e314d29d3b8f362aadff8087fccb upstream.

Also fix the calls to next_packet_size() for the pause case. This was
missed in 245baf983 ("ALSA: snd-usb: fix calls to next_packet_size").

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reported-and-tested-by: Christian Tefzer <ctrefzer@gmx.de>
[ Taking directly because Takashi is on vacation  - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -197,7 +197,13 @@ static void prepare_outbound_urb(struct
 			/* no data provider, so send silence */
 			unsigned int offs = 0;
 			for (i = 0; i < ctx->packets; ++i) {
-				int counts = ctx->packet_size[i];
+				int counts;
+
+				if (ctx->packet_size[i])
+					counts = ctx->packet_size[i];
+				else
+					counts = snd_usb_endpoint_next_packet_size(ep);
+
 				urb->iso_frame_desc[i].offset = offs * ep->stride;
 				urb->iso_frame_desc[i].length = counts * ep->stride;
 				offs += counts;


