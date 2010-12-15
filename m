Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0LOTO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:14:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52695 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0LOTOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <4D08FF4F.1020307@canonical.com>
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
	<4D06A7B1.6060609@canonical.com>
	<4D06A90C.90009@euromail.se>
	<4D07E38C.4020201@canonical.com>
	<4D08CEE8.9080804@euromail.se>
	<4D08FF4F.1020307@canonical.com>
Date: Wed, 15 Dec 2010 13:14:52 -0600
Message-ID: <AANLkTikM5dXSv2onvF5aqzqkEuwrvbS5DTeE0CiW91j3@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:47 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/15/2010 09:21 AM, Henrik Rydberg wrote:
>>> After some testing this is mostly fine,
>>
>>  but I have one of those terrible
>>> "integrated buttons" (or whatever we call it) trackpads. When switching
>>> to multitouch mode, the cursor will sometimes jump when I go to push the
>>> button.
>>>
>>> Take the following sequence:
>>>
>>> 1. Touch in top right corner of pad to position cursor
>>> 2. Touch in bottom left corner over button
>>> 3. Press button, but finger moves a little
>>>
>>> Step 3 causes the primary coordinates in the synaptics MT protocol to
>>> flip to the button-pressing touch. This causes a cursor jump. *Many*
>>> times I have gone to press an "Ok" dialog button and found that I
>>> accidentally launched an application from my dock :).
>>
>>
>> I see - the behavior of the primary coordinates seems to vary between models,
>> then. On the other hand, if you point and click with the same finger, one could
>> possibly go around this problem, even though it means less precision. On my MT
>> laptop, I can click at the very edge of the pad without the cursor moving.
>
> Because of the mechanical properties of my particular touchpad, it's
> nearly impossible to click without dragging. My touchpad isn't one of
> the new clickpads where the entire pad hinges. On a clickpad, I would
> hope depress without movement is easy. On my trackpad, the buttons are
> somewhat stiff and flex non-uniformly, causing the unwanted movement.
>
> So, in Ubuntu we mask out the area of the touchpad where the buttons
> are. Any movement in that area is discarded. Thus, the only way to be
> sure of a click is to position with one touch, then lift the touch, then
> click one of the buttons. Annoying :).

Is this custom code or in upstream (are you talking about
inside_active_area logic?)?  I'm not sure why your seeing a jump if
its being discarded.  There is a chance that something related to this
discard logic is defeating the other logic that handles jumps caused
during finger transitions.

>
>>> I think we should perform some rudimentary touch tracking to ensure the
>>> same touch is always used for reporting ABS_X/ABS_Y. A simple distance
>>> comparison between the two touches, as I implemented in one of my other
>>> patches, would suffice.
>>
>>
>> One can certainly decide on the "best" coordinates when putting down the second
>> finger, as we tried for elantech. However, after some movement, when the second
>> finger is lifted, chances are you get a jump then instead.
>
> Chris, isn't this filtered out in xf86-input-synaptics based on the
> change in the number of touches?

Yes, in version 1.30 or newer xf86-input-synaptics anyways.  And of
course the *TAP transition needs to come in same sync window as jump
for it to be helpful.  It may be able to handle if *TAP comes 1 sync
window before jump but that would be about the limit.

Mind sending me a evtest log snippet during
touch-then-click-with-2nd-finger (with MT mode enabled)?  Seeing those
tends to be better for understanding then words for me.  I'm
interested for more then just this specific issue, btw.

I'm really interested in where the *TAP come (before or after)
relative to cursor jump and how close it was to being filtered out by
xf86-input-synaptics.

>
>>> What do you think?
>>
>>
>> The general approach we have taken for the kernel is to provide a left button
>> for both the macbooks and these clickpads, and in addition provide enough
>> information (read mt data) to solve this problem in userspace. In other words,
>> one should probably see what additions are needed in the common X drivers to
>> make the experience a pleasant one.
>
> I think we're confusing clickpads and my "integrated buttons" trackpad
> (I know we settled on a different name, but I can't remember it now :).
> I believe my issue is purely due to the primary coordinates switching
> back and forth between two touches as I position and click with two fingers.

I would think they both have same issue... Just yours may have some
extra movement and pressure changes compared to the other.

Chris

>
> Also, I have been told by an OEM partner that my trackpad will *never*
> be used again :). We could consider quirking it if what makes this
> trackpad work is detrimental to other trackpads.
>
> Thanks,
>
> -- Chase
>
