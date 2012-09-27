Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2I0I02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:26:28 -0400
Received: from svenfoo.org ([82.94.215.22]:56206 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab2I0I0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:26:24 -0400
From: Daniel Mack <zonque@gmail.com>
To: torvalds@linux-foundation.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, stable@kernel.org
Subject: [PATCH] ALSA: snd-usb: fix next_packet_size calls for pause case
Date: Thu, 27 Sep 2012 10:26:01 +0200
Message-Id: <1348734361-13352-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix the calls to next_packet_size() for the pause case. This was
missed in 245baf983 ("ALSA: snd-usb: fix calls to next_packet_size").

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reported-and-tested-by: Christian Tefzer <ctrefzer@gmx.de>
Cc: stable@kernel.org
---
Hi Linus,

Takashi is currently on vacation and asked me to contact you directly
for merging this patch for 3.6. FWIW, it's also available here:

git://github.com/zonque/linux.git alsa-for-3.6

Thanks,
Daniel

 sound/usb/endpoint.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index a83a18d..d9de667 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -203,7 +203,13 @@ static void prepare_outbound_urb(struct snd_usb_endpoint *ep,
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
-- 
1.7.11.4

