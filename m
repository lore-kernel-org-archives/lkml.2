Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0JLSl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:41:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50787 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab0JLSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <1286900585.22715.367.camel@mini>
References: <1286900585.22715.367.camel@mini>
Date: Tue, 12 Oct 2010 13:41:53 -0500
Message-ID: <AANLkTi=zdVjoD_hgtgjSOkOYGS+WsKvfh4=kdCc-f6--@mail.gmail.com>
Subject: Re: Proposal for synaptics driver
From: Chris Bagwell <chris@cnpbagwell.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:23 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> Hi all,
>
> There's been many patches and discussions on the synaptics MT work, so I
> wanted to gather thoughts into one thread to push things forward.
>
> First, I want to note something that I think has been overlooked. We've
> been talking about "ClickPad" devices quite a bit. One can find the
> product page for these devices at:
>
> http://www.synaptics.com/solutions/products/clickpad
>
> As a brief overview, ClickPads are an MT surface where the entire
> surface clicks. The click may be uniform over the touchpad, or it may be
> hinged on one of the edges. It appears that Takashi has figured out the
> appropriate bits in the extended capabilities flags to recognized a
> ClickPad. I can't confirm this, but it sounds like the device emits a
> middle mouse button click when the touchpad is depressed.
>
> Here's the confusing part: Synaptics has a different series of touchpads
> where only certain regions of the touchpad click. This is the case on my
> Dell Mini 1012. Unfortunately, I can't find any documentation for these
> touchpads on Synaptics' website. As another brief overview, my touchpad
> has two buttons integrated into the bottom ~20% of the touchpad. The
> left half of the button area clicks separately from the right half, and
> the device emits left and right buttons as appropriate. The rest of the
> touchpad is stationary and does not click. If no one has a better name
> for these touchpads, I'll refer to them as "integrated buttons"
> touchpads. Also unfortunately, I don't know which cap bits inform us of
> an integrated buttons touchpad, though I have suspicions it's bit
> 0x200000 of the 0c extended caps mask.

Ahh, that clears some things up to me.  Based on Takashi's
xf86-input-synaptic patches, it seems the click area is still in this
~20% range even for clickpads.  It sounds like the main difference
between clickpad's and "integrated button" touchpads is clickpads have
a way of reporting X/Y events in that click area *without* declaring
button press.  If one really wanted to, this same clickpad behavior
could be emulated based on pressure but thats probably best for
userspace.  BTW, is there any pressure thresholds for your touchpad?

>
> Now onto implementation decisions. I feel that a kernel driver should
> provide a usable mouse without needing an X input module. There are
> projects like Wayland that don't use X, and I think people use gpm for
> consoles still. My definition of a usable mouse is single touch and left
> click support (including click and drag using a physical button).
>
> To answer another recurring question throughout the thread, other MT
> drivers send both ABS_MT_* and regular ABS_* events. One of the MT
> touches is assigned for single touch emulation at any given time. This
> supports legacy user space software that expects ST events while
> allowing for MT events to be used by more advanced software. I think we
> should do the same for Synaptics, and we should track the ST emulation
> touch as Henrik suggested.

I haven't had time to review the code Henrik pointed to and don't
think exact behavior was spelled out in thread.  Since it applies to
my touchpad's, I'd like to state it briefly so we know how this rule
will be bent in later part of email.

I believe basic intent is to support ST emulation by continuing to
report the same touch for life of touch and if its released first the
emulation will revert to remaining tracked touch and advertise this
transition using BTN_TOOL_DOUBLETAP going from 1->0.

>
> For ClickPad devices, my feeling is that we should translate middle
> button clicks to left button clicks in the kernel, and MT+ST emulation
> should be performed. Middle and right click functionality may be
> provided for in userspace, like in xf86-input-synaptics or through a
> gesture stack. I think this level of support meets my personal criteria
> for kernel level functionality specified above.

Agree.  I would consider click and drag as optional with ST emulation
but hopefully we can get it working with some thought.

>
> Integrated buttons devices pose more of a challenge due to the need to
> properly support click and drag. Lets first assume that we can detect
> such a touchpad and determine the button area (I'll revisit this later).
> I think we should disable single touch support over the buttons due to
> the following scenario:
>
> User positions cursor over button on screen, attempts to click physical
> touchpad button, cursor moves because of motion on touchpad when user
> depresses button.

I think for this exact scenario its probably not needed but your in
best position to say.  I can do a button press-like touch on my
touchpad today with no cursor movement though.

Here is a close version of filtering ST when in click area that may or
may not be better option.  We could instead modify rule to track 1st
touch to track 1st touch unless its in click area and then prefer
second touch instead.

Let me try to convince myself that we won't see cursor jumps in X.
1st touch in click area:
BTN_LEFT=1/BTN_TOUCH=1/ABS_X=1st_finger/ABS_Y=1st_finger.  2nd touch
in drag area:  BTN_TOOL_DOUBLETAP=1/ABS_X=2nd_finger/ABS_Y=2nd_finger.
 Release 2nd finger:
BTN_TOOL_DOUBLETAP=0/ABS_X=1st_finger/ABS_Y=1st_finger.

xf86-input-synaptics can handle those transitions without jumping.
Maybe not gpm or similar but should be small fixes to applications.

This approach should allow click and drag to work and also allow ST
only applications to convert BTN_LEFT into left/middle/right as long
as it knows its an "integrated button" or "clickpad" touchpad.

BTW, I think both mouse movement issue and click and drag issue
applies to clickpad as well and so can use same decisions for it.

>
> However, we should support MT over the entire touchpad surface. Perhaps
> proper filtering and such could make the above scenario work better, and
> an advanced user space software, like xf86-input-synaptics, could listen
> to the MT events to get the data if it wants.
>
> Integrated buttons have ST emulation support, but only over the
> non-button area of the touchpad. If a touch moves over the button area,
> it disappears as far as ST-only aware software is concerned. ST
> emulation does not switch to another touch because that would look like
> a dragged touch. Since a touch beginning over the button area is never
> sent through ST emulation, click and drag will always work no matter
> which touch goes down first.

Do you know if hardware is doing any filtering?  For example, if you
move 1 finger from middle to click area does it do simple thing and
start reporting button press?  If it is filtering then that may change
the story a little.

I think both filtering approach and "prefer non-click touch" approach
allow click-and-drag.  If you do something like 2 finger touch in
center and move tracked finger into click area then it would need to
start reporting other touch and turn into a click-and-drag operation.
This ST tracking switch shouldn't seem different to user space then
case of user releasing tracked finger and moving to click area I
think.  Since BTN_TOOL_DOUBLETAP will go from 1 to 0 in both these
cases, user space has something to understand tracking switch.

Chris
>
> Now the bit about integrated button touchpad detection. First, I would
> be interested in learning if anyone can disprove bit 0x200000 of the 0c
> extended caps flags means integrated buttons. I wonder if we shouldn't
> solicit for caps bits of various devices too? I'd be happy to look into
> setting up a web survey form if people think this would be useful.
> Otherwise, should we try using that bit to see if it works for people or
> causes regressions? If that bit isn't correct, should we make it a
> module parameter to enable integrated button functionality? What about
> button area size? Should we assume it's the same across all such
> touchpads?
>
> I would argue that if we can't detect integrated buttons touchpads we
> should have a module parameter. I believe we can use udev to specify
> module parameter quirks for machine types that are known to have
> integrated buttons. Until we hear of regressions, I would assume the
> same button area across all such devices.
>
> I'd like to reach some sort of consensus before we proceed with more
> patches, otherwise things will just end up confusing :). I think what
> I've outlined above should be reasonably easy to implement, the hard
> part is just agreeing on what is best.
>
> Thanks,
>
> -- Chase
>
>
