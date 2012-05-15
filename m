Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679Ab2EOC3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:29:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:49862 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895Ab2EOCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 162/179] ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc
Date: Mon, 14 May 2012 22:14:18 -0400
Message-ID: <1337048075-6132-163-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 15439bde3af7ff88459ea2b5520b77312e958df2 upstream.

This fixes faulty outbount packets in case the inbound packets
received from the hardware are fragmented and contain bogus input
iso frames. The bug has been there for ages, but for some strange
reasons, it was only triggered by newer machines in 64bit mode.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: William Light <wrl@illest.net>
Reported-by: Pedro Ribeiro <pedrib@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/usb/caiaq/audio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index a184e91..75c8446 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -469,6 +469,7 @@ static void read_completed(struct urb *urb)
 	struct snd_usb_caiaqdev *dev;
 	struct urb *out;
 	int frame, len, send_it = 0, outframe = 0;
+	size_t offset = 0;
 
 	if (urb->status || !info)
 		return;
@@ -489,7 +490,8 @@ static void read_completed(struct urb *urb)
 		len = urb->iso_frame_desc[outframe].actual_length;
 		out->iso_frame_desc[outframe].length = len;
 		out->iso_frame_desc[outframe].actual_length = 0;
-		out->iso_frame_desc[outframe].offset = BYTES_PER_FRAME * frame;
+		out->iso_frame_desc[outframe].offset = offset;
+		offset += len;
 
 		if (len > 0) {
 			spin_lock(&dev->spinlock);
@@ -505,7 +507,7 @@ static void read_completed(struct urb *urb)
 	}
 
 	if (send_it) {
-		out->number_of_packets = FRAMES_PER_URB;
+		out->number_of_packets = outframe;
 		out->transfer_flags = URB_ISO_ASAP;
 		usb_submit_urb(out, GFP_ATOMIC);
 	}
-- 
1.7.9.6

