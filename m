Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2CUM5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:57:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47935 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab2CUM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:57:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jozef Vesely <vesely@gjh.sk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible bug (or not clear coding) in uvc_v4l2.c
Date: Wed, 21 Mar 2012 13:58:05 +0100
Message-ID: <1706556.vixMv5JEgY@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120320160251.GA79846@mail.kolej.mff.cuni.cz>
References: <20120320160251.GA79846@mail.kolej.mff.cuni.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jozef,

On Tuesday 20 March 2012 17:02:51 Jozef Vesely wrote:
> Good day,
> 
> I am sorry to disturb you, I have been reading through uvc driver source
> and this caught my eye:
> http://lxr.linux.no/#linux+v3.3/drivers/media/video/uvc/uvc_v4l2.c#L671
> 
> 678: int pin = 0;
> ...
> 689: } else if (pin < selector->bNrInPins) {
> ...
> 690: pin = selector->baSourceID[index];
> 
> pin is always 0 in the comparison, was this intended?
> (wasn't the line 690 supposed to be before the comparison?
> or the index to be compared  to bNrInPins?)
> 
> Please excuse me wasting your tine if it is a total nonsense.

It's not a waste of time at all. Thank you for the report.

The following patch should fix the problem.

commit 578ac85ae011ed5d1f3aeebcb511509c84792f23
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Wed Mar 21 13:50:36 2012 +0100

    uvcvideo: Fix ENUMINPUT handling
    
    Properly validate the user-supplied index against the number of inputs.
    The code used the pin local variable instead of the index by mistake.
    
    Reported-by: Jozef Vesely <vesely@gjh.sk>
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Cc: stable@vger.kernel.org

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 111bfff..a6b9491 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -687,7 +687,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					break;
 			}
 			pin = iterm->id;
-		} else if (pin < selector->bNrInPins) {
+		} else if (index < selector->bNrInPins) {
 			pin = selector->baSourceID[index];
 			list_for_each_entry(iterm, &chain->entities, chain) {
 				if (!UVC_ENTITY_IS_ITERM(iterm))

I will push it to mainline.

> PS: I am looking for a reason why MJPEG stopped working on my cameras (long
>> time ago), any hints?

Not as such. Could you please provide me with more information ? You can drop
the linux-kernel CC and add linux-uvc-devel@lists.sourceforge.net
(subscriber-only at the moment) or linux-media@vger.kernel.org instead.

-- 
Regards,

Laurent Pinchart

