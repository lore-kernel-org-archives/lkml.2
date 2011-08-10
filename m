Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1HJPdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:33:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1HJPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:33:14 -0400
Message-ID: <4E42A4AE.4020008@gmail.com>
Date: Wed, 10 Aug 2011 17:33:02 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Florian Mickler <florian@mickler.org>, Oliver Neukum <oliver@neukum.org>,
        linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        pedrib@gmail.com, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------000700020004070602000804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000700020004070602000804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/10/2011 04:32 PM, Alan Stern wrote:
> Looking at the driver's current code, it appears that your patch
> does not fix the bug properly.  Using discontiguous regions in the
> transfer buffer is perfectly okay.  The real problem is later on,
> where you do:
>
> if (send_it) { out->number_of_packets = FRAMES_PER_URB;
>
> This should be
>
> out->number_of_packets = outframe;
>
> The way it is now, the USB stack will try to use data from all the
> frame descriptors, and the last few will be stale because the loop
> doesn't set them.

That's actually true, even though it doesn't seem to cause any trouble.
I tested everything here of course, and the output URBs return back from
the USB stack with their length fields zeroed out, which then
causes the stack to send packets with zero-length fields at the end.

However, doing it right doesn't harm either. Thanks for spotting.

Takashi, can you apply this version?


Thanks,
Daniel


--------------000700020004070602000804
Content-Type: text/plain;
 name="0001-ALSA-snd-usb-caiaq-Correct-offset-fields-of-outbound.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ALSA-snd-usb-caiaq-Correct-offset-fields-of-outbound.pa";
 filename*1="tch"

>From 57e3283c950e2b783a8f6afc001cc0e16aaaaea2 Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Fri, 5 Aug 2011 13:49:52 +0200
Subject: [PATCH] ALSA: snd-usb-caiaq: Correct offset fields of outbound
 iso_frame_desc

This fixes faulty outbount packets in case the inbound packets
received from the hardware are fragmented and contain bogus input
iso frames. The bug has been there for ages, but for some strange
reasons, it was only triggered by newer machines in 64bit mode.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: William Light <wrl@illest.net>
Reported-by: Pedro Ribeiro <pedrib@gmail.com>
Cc: stable@kernel.org
---
 sound/usb/caiaq/audio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index d0d493c..aa52b3e 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -614,6 +614,7 @@ static void read_completed(struct urb *urb)
 	struct snd_usb_caiaqdev *dev;
 	struct urb *out;
 	int frame, len, send_it = 0, outframe = 0;
+	size_t offset = 0;
 
 	if (urb->status || !info)
 		return;
@@ -634,7 +635,8 @@ static void read_completed(struct urb *urb)
 		len = urb->iso_frame_desc[outframe].actual_length;
 		out->iso_frame_desc[outframe].length = len;
 		out->iso_frame_desc[outframe].actual_length = 0;
-		out->iso_frame_desc[outframe].offset = BYTES_PER_FRAME * frame;
+		out->iso_frame_desc[outframe].offset = offset;
+		offset += len;
 
 		if (len > 0) {
 			spin_lock(&dev->spinlock);
@@ -650,7 +652,7 @@ static void read_completed(struct urb *urb)
 	}
 
 	if (send_it) {
-		out->number_of_packets = FRAMES_PER_URB;
+		out->number_of_packets = outframe;
 		out->transfer_flags = URB_ISO_ASAP;
 		usb_submit_urb(out, GFP_ATOMIC);
 	}
-- 
1.7.6


--------------000700020004070602000804--
