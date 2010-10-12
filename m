Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0JLQXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:23:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38148 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0JLQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:23:13 -0400
Subject: Proposal for synaptics driver
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Henrik Rydberg <rydberg@bitmath.org>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 12:23:05 -0400
Message-ID: <1286900585.22715.367.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There's been many patches and discussions on the synaptics MT work, so I
wanted to gather thoughts into one thread to push things forward.

First, I want to note something that I think has been overlooked. We've
been talking about "ClickPad" devices quite a bit. One can find the
product page for these devices at:

http://www.synaptics.com/solutions/products/clickpad

As a brief overview, ClickPads are an MT surface where the entire
surface clicks. The click may be uniform over the touchpad, or it may be
hinged on one of the edges. It appears that Takashi has figured out the
appropriate bits in the extended capabilities flags to recognized a
ClickPad. I can't confirm this, but it sounds like the device emits a
middle mouse button click when the touchpad is depressed.

Here's the confusing part: Synaptics has a different series of touchpads
where only certain regions of the touchpad click. This is the case on my
Dell Mini 1012. Unfortunately, I can't find any documentation for these
touchpads on Synaptics' website. As another brief overview, my touchpad
has two buttons integrated into the bottom ~20% of the touchpad. The
left half of the button area clicks separately from the right half, and
the device emits left and right buttons as appropriate. The rest of the
touchpad is stationary and does not click. If no one has a better name
for these touchpads, I'll refer to them as "integrated buttons"
touchpads. Also unfortunately, I don't know which cap bits inform us of
an integrated buttons touchpad, though I have suspicions it's bit
0x200000 of the 0c extended caps mask.

Now onto implementation decisions. I feel that a kernel driver should
provide a usable mouse without needing an X input module. There are
projects like Wayland that don't use X, and I think people use gpm for
consoles still. My definition of a usable mouse is single touch and left
click support (including click and drag using a physical button).

To answer another recurring question throughout the thread, other MT
drivers send both ABS_MT_* and regular ABS_* events. One of the MT
touches is assigned for single touch emulation at any given time. This
supports legacy user space software that expects ST events while
allowing for MT events to be used by more advanced software. I think we
should do the same for Synaptics, and we should track the ST emulation
touch as Henrik suggested.

For ClickPad devices, my feeling is that we should translate middle
button clicks to left button clicks in the kernel, and MT+ST emulation
should be performed. Middle and right click functionality may be
provided for in userspace, like in xf86-input-synaptics or through a
gesture stack. I think this level of support meets my personal criteria
for kernel level functionality specified above.

Integrated buttons devices pose more of a challenge due to the need to
properly support click and drag. Lets first assume that we can detect
such a touchpad and determine the button area (I'll revisit this later).
I think we should disable single touch support over the buttons due to
the following scenario:

User positions cursor over button on screen, attempts to click physical
touchpad button, cursor moves because of motion on touchpad when user
depresses button.

However, we should support MT over the entire touchpad surface. Perhaps
proper filtering and such could make the above scenario work better, and
an advanced user space software, like xf86-input-synaptics, could listen
to the MT events to get the data if it wants.

Integrated buttons have ST emulation support, but only over the
non-button area of the touchpad. If a touch moves over the button area,
it disappears as far as ST-only aware software is concerned. ST
emulation does not switch to another touch because that would look like
a dragged touch. Since a touch beginning over the button area is never
sent through ST emulation, click and drag will always work no matter
which touch goes down first.

Now the bit about integrated button touchpad detection. First, I would
be interested in learning if anyone can disprove bit 0x200000 of the 0c
extended caps flags means integrated buttons. I wonder if we shouldn't
solicit for caps bits of various devices too? I'd be happy to look into
setting up a web survey form if people think this would be useful.
Otherwise, should we try using that bit to see if it works for people or
causes regressions? If that bit isn't correct, should we make it a
module parameter to enable integrated button functionality? What about
button area size? Should we assume it's the same across all such
touchpads?

I would argue that if we can't detect integrated buttons touchpads we
should have a module parameter. I believe we can use udev to specify
module parameter quirks for machine types that are known to have
integrated buttons. Until we hear of regressions, I would assume the
same button area across all such devices.

I'd like to reach some sort of consensus before we proceed with more
patches, otherwise things will just end up confusing :). I think what
I've outlined above should be reasonably easy to implement, the hard
part is just agreeing on what is best.

Thanks,

-- Chase

