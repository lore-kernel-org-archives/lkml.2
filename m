Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1F2LFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:05:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1F2LFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:05:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HWiICl4JvKF/zQLLk70YR1MQY/P/JNhNG6FRq4dIPBgl9+JU5HAnBGdGWfs205D6O
	s+rbkY0x44jhNZ2Qu0a7A==
MIME-Version: 1.0
In-Reply-To: <4E0AF84D.6050702@canonical.com>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-11-git-send-email-djkurtz@chromium.org> <4E0AF84D.6050702@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 29 Jun 2011 19:04:45 +0800
X-Google-Sender-Auth: mb8mk9qPxNuJ4ctD1NWWXYVMgsQ
Message-ID: <CAGS+omCfw3CQ8z6iS3QQx7hZs1e8kOpC1-L1SFsGQv0RdmAMqg@mail.gmail.com>
Subject: Re: [PATCH 10/12] Input: synaptics - decode AGM packet types
To: Chase Douglas <chase.douglas@canonical.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

Thanks for looking at the patches!

On Wed, Jun 29, 2011 at 6:02 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
>
> On 06/29/2011 06:07 AM, djkurtz@chromium.org wrote:
> > From: Daniel Kurtz <djkurtz@chromium.org>
> >
> > A Synaptics image sensor tracks 5 fingers, but can only report 2.
> > This behavior is called "T5R2" = Track 5 Report 2
> >
> > Algorithm for choosing which 2 fingers to report in which packet:
> >   Touchpad maintains 5 slots, numbered 0 to 4.
> >   Initially all slots are empty.
> >   As new fingers are detected, they are assigned the lowest available
> >   slot.
> >   Touchpad always reports:
> >     SGM: lowest numbered non-empty slot
> >     AGM: highest numbered non-empty slot, if there is one.
>
> Hi Daniel,
>
> Thanks for the new patches! I will review them soon in detail, but I
> would like to first confirm some details about the above.
>
> In the older "profile" devices, we got essentially the bounding box of
> all touches. This allows us to detect pinch gestures between the two
> most extreme touches when there are three touches on the touchpad.
>
> The above description makes it sound like we will no longer have a
> bounding box of touches. According to the description, if I put four
> fingers down in a square formation and then touch a fifth finger in the
> middle of the square, I will only see the locations of one corner and
> the middle of the square. This would make meaningful gesture detection
> beyond two touches nearly impossible. Is this really how the touchpad
> works, or is the above description not quite right?

This is how the image sensor works, from my observations.

As for profile sensors the kernel driver creates a "best guess
bounding box" by picking:
   top_left = (min(x1,x2), min(y1,y2))
   bottom_right = (max(x1,x2), max(y1,y2))

However, at least from my experiments with one profile sensor, there
is no guarantee that this rectangle actually contains all touches on
the pad.
In fact, I think it is trying really hard to return the position of
the first two touches that it is tracking.
When there are two fingers, it returns the finger with the larger
y-value (and what the trackpad believes to be its x-), and the SGM
packet, and the other finger in the AGM.
When there are three or more fingers, it still reports the first two,
irregardless of where the new fingers are added.

It would be very curious if different profile sensors behaved differently.

In any case, this patch should not change the behavior of profile
sensors, since it only applies to image sensors.

Thanks,
-Daniel
