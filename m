Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0JLVpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:45:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38032 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0JLVpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <1286914296.31864.83.camel@mini>
References: <1286900585.22715.367.camel@mini>
	<AANLkTi=zdVjoD_hgtgjSOkOYGS+WsKvfh4=kdCc-f6--@mail.gmail.com>
	<1286914296.31864.83.camel@mini>
Date: Tue, 12 Oct 2010 16:11:58 -0500
Message-ID: <AANLkTi=e_X5UDktzMCY4hP1rbg2htWJYno_6bcrcYmX+@mail.gmail.com>
Subject: Re: Proposal for synaptics driver
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 3:11 PM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On Tue, 2010-10-12 at 13:41 -0500, Chris Bagwell wrote:
>> On Tue, Oct 12, 2010 at 11:23 AM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>> > Hi all,
>> >
>> > There's been many patches and discussions on the synaptics MT work, so I
>> > wanted to gather thoughts into one thread to push things forward.
>> >
>> > First, I want to note something that I think has been overlooked. We've
>> > been talking about "ClickPad" devices quite a bit. One can find the
>> > product page for these devices at:
>> >
>> > http://www.synaptics.com/solutions/products/clickpad
>> >
>> > As a brief overview, ClickPads are an MT surface where the entire
>> > surface clicks. The click may be uniform over the touchpad, or it may be
>> > hinged on one of the edges. It appears that Takashi has figured out the
>> > appropriate bits in the extended capabilities flags to recognized a
>> > ClickPad. I can't confirm this, but it sounds like the device emits a
>> > middle mouse button click when the touchpad is depressed.
>> >
>> > Here's the confusing part: Synaptics has a different series of touchpads
>> > where only certain regions of the touchpad click. This is the case on my
>> > Dell Mini 1012. Unfortunately, I can't find any documentation for these
>> > touchpads on Synaptics' website. As another brief overview, my touchpad
>> > has two buttons integrated into the bottom ~20% of the touchpad. The
>> > left half of the button area clicks separately from the right half, and
>> > the device emits left and right buttons as appropriate. The rest of the
>> > touchpad is stationary and does not click. If no one has a better name
>> > for these touchpads, I'll refer to them as "integrated buttons"
>> > touchpads. Also unfortunately, I don't know which cap bits inform us of
>> > an integrated buttons touchpad, though I have suspicions it's bit
>> > 0x200000 of the 0c extended caps mask.
>>
>> Ahh, that clears some things up to me.  Based on Takashi's
>> xf86-input-synaptic patches, it seems the click area is still in this
>> ~20% range even for clickpads.
>
> Hmm, based on the synaptics product page I figured the click area of a
> ClickPad would be the entire surface. Takashi, do you have any input
> here? Maybe the ClickPad devices people have been using is of the hinged
> type, where it's easier to click on the bottom of the pad instead of the
> top?
>
>> It sounds like the main difference
>> between clickpad's and "integrated button" touchpads is clickpads have
>> a way of reporting X/Y events in that click area *without* declaring
>> button press.
>
> On my touchpad, the "embedded buttons" (what I'm calling "integrated
> buttons" now due to the name clash with the bcm5974 semantics) are touch
> sensitive, so the device still reports X/Y events no matter whether the
> button is depressed or not..
>
>> If one really wanted to, this same clickpad behavior
>> could be emulated based on pressure but thats probably best for
>> userspace.  BTW, is there any pressure thresholds for your touchpad?
>
> What do you mean by pressure thresholds? My device does report pressure.

OK, that was my confusion.  I didn't realize these also had real
buttons and so can also report X/Y in click area without button press.
 I was assuming the firmware was detecting button press based on
pressure or finger width and that it needed to go above some very low
threshold before activated.  So the parts of my email you weren't
quite sure about are explained to me now by this answer.

[ .. ]

>
>> I think both filtering approach and "prefer non-click touch" approach
>> allow click-and-drag.  If you do something like 2 finger touch in
>> center and move tracked finger into click area then it would need to
>> start reporting other touch and turn into a click-and-drag operation.
>> This ST tracking switch shouldn't seem different to user space then
>> case of user releasing tracked finger and moving to click area I
>> think.  Since BTN_TOOL_DOUBLETAP will go from 1 to 0 in both these
>> cases, user space has something to understand tracking switch.
>
> I think we're in agreement on everything except for the possibility of
> using BTN_TOOL_* to distinguish between ST emulation touch switches. The
> BTN_TOOL_* switch could allow full ST emulation over the button area of
> an "embedded buttons" trackpad until a button is pressed, but might
> slightly break legacy clients like gpm. Again, I'm open to both options,
> so if anyone feels particularly strong about this please speak up :).

I'm going to go off and also study the hid-magicmouse now and a few
other things to make sure I understand how tracking could be
implemented based on past work.

I do want to point out more that when synaptics hw is not in this new
MT-mode that it is BTN_TOOL_DOUBLETAP that is saving the day for
preventing cursor jumps from 2 finger touches anywhere on touchpad...
not just click areas.  The current ABS_X/ABS_Y values do change
fingers they are tracking but it happens to correspond to changes in
finger counts as well.

The story is harder for my touchpad (with external buttons) since it
doesn't support finger count but instead only finger width.  I think
this behavior is same for these "embedded button" touchpads, right?
Its harder to inform all applications to treat finger width changes
same as BTN_TOOL_DOUBLETAP transitions to prevent cursor jumps.

I'm hoping my touchpad supports this MT-mode so that we can start
reporting BTN_TOOL_DOUBLETAP which should fix a wider list of apps
from having cursor jumps during tracking changes.

Anyways, since the logic is really needed in user land to work with
certain hardware/kernel releases anyways, it seems fair to elevate it
to a requirement also for MT devices and take advantage of it.

Chris

>
> Thanks for the feedback Chris!
>
> -- Chase
>
>
