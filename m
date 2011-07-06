Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1GFRIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:08:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34226 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1GFRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:08:08 -0400
Message-ID: <4E149670.3040807@canonical.com>
Date: Wed, 06 Jul 2011 10:08:00 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Henrik Rydberg <rydberg@euromail.se>, dmitry.torokhov@gmail.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-10-git-send-email-djkurtz@chromium.org> <20110704214220.GE23915@polaris.bitmath.org> <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com> <20110705192759.GA29549@polaris.bitmath.org> <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
In-Reply-To: <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 09:41 AM, Daniel Kurtz wrote:
> On Wed, Jul 6, 2011 at 3:27 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>> ...
>>> This implementation addresses the following issues:
>>>
>>>   (1) Improves handling of the 2-finger case.  Image sensors due allow
>>> true MT-B for two finger case.  This, for example, allows detecting
>>> whether the click in a click+drag is happening in bottom right or
>>> bottom left quadrant of the pad.
>>
>> In principle, this could be done within the semi-mt realm by adding a
>> binary value to the protocol, distinguishing the diagonals of the
>> bounding box. It would be ugly too, but at least it would be
>> compatible with the current semi-mt effort in userspace.
> 
> (A) I think the "semi-mt" protocol works like this:
>   (1) When two or more fingers are on the pad, report two MT-B slots, where:
>     (a) slot[0] contains (x_min, y_min) of the two fingers
>     (b) slot[1] contains (x_max, y_max) of the two fingers
>     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
>   (2) If one of the two fingers is removed, then the first slot is
> used to report
>       the remaining finger, whichever it is, without changing the
> slot's tracking_id.
>   (3) Advertise this behavior with the SEMI_MT device property
> 
> (B) This is what the proposed T5R2 driver does:
>   (1) When N fingers are on the pad, report N MT-B slots, where:
>     (a) The lowest indexed active slot (tracking_id != -1) contains
> valid finger position data.
>     (b) The highest indexed active slot (tracking_id != -1) contains
> valid finger position data.
>     (c) Any active slots (tracking_id != -1) between these does not
> contain valid finger position data, these 'hidden' slots are just
> active to indicate that there are that many fingers on the pad.
>     (d) Total number of fingers on the pad is always the number of active slots.
>   (2) When fingers are removed from the pad:
>     (a) keep reporting the fingers that are left in the same slots,
> with the same tracking_ids, if possible.
>     (b) If the identities of the fingers that remain is ambiguous,
> invalidate all slots,then re-assign the fingers that remain to new
> slots, with new tracking ids.
>   (3) Advertise this behavior with the T5R2 device property
> 
> (C) A third, compromise implementation might be to do something like this:
>   (1) When >=2 fingers are on the pad, report 2 MT-B slots, where:
>     (a) slot[0] reports finger 1
>     (b) slot[1] reports finger 2
>     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
>   (2) If 1 finger is removed, the tracking_id for its slot is invalidated;
>       but, the finger that remains stays in its same slot with the
> same tracking_id.
>   (3) Whenever the number of fingers changes from/to 3 or more
> fingers, both slots are always invalidated.
>       New tracking_ids are assigned to both slots which contain the
> two fingers now being reported.
>   (4) No special driver property is required for this, not even "semi-mt".
>       It should be as pure MT-B as we can get (plus BTN_TOOL_* hack).

This approach seems better, but there's still an ambiguity. When we go
from two to three or more fingers we get lossy. We can't tell what
touches cross the transition with their data intact.

I'm racking my brain trying to come up with a solution that would make
sense, but I don't think there is one that works seamlessly. I think we
should do what you've written above with two changes:

* Use a new property (T5R2?) to fully denote how screwed up this class
of devices is.
* Don't roll the tracking_id on any number of touch transitions. We're
already telling userspace that the number of touches is changing, so the
tracking_id change is superfluous. The tracking_id of a slot should only
change when we know that the touch is beginning or ending.

No matter what we do, userspace will have to rely on complex heuristics
for this device, which makes me wonder if these devices will really ever
be handled properly...

> IMHO, (C) is an improvement over (A) for two major reasons:
>   (1) tracking the individual touches allows distinguishing a clicking
> finger in bottom right versus bottom left, for example.
>   (2) It makes it possible to track the touch that remains when one of
> the two touches is released.
>       The touch that remains will stay in the same slot, with the same
> tracking id.
>       The tracking id of the touch that is removed will be set to -1.
>         => This eliminates unnecessary gaps in the event stream,
> without introducing position jumps.
>       This behavior occurs often when switching between 1-finger
> motion and 2f-scroll, or when performing 2f-click+drag gestures.
> 
> Note: Tracking which fingers are left on the pad gets much more
> complicated with 3, 4, or 5 fingers.
> This is addressed more fully by the T5R2 solution, but (C), while
> slightly less optimal, should at least not do the wrong thing.
> 
> Sorry, I find it a bit difficult to explain this clearly in writing.
> I guess I'll just have to submit a new patchset that shows what I mean.

You're not the first to be tied up trying to document Synaptics behavior :).

Thanks!

-- Chase
