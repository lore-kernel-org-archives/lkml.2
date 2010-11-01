Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0KAVWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:22:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0KAVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:22:46 -0400
Date: Mon, 1 Nov 2010 17:22:44 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: William Sherman <shermanw@indiana.edu>, linux-kernel@vger.kernel.org,
        Linux Input <linux-input@vger.kernel.org>
Subject: Re: usbhid: HP LD4200tm touchscreen ALMOST works
In-Reply-To: <20101101211456.GA30692@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1011011717460.15851@pobox.suse.cz>
References: <4CC61731.1080100@indiana.edu> <20101101211456.GA30692@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Dmitry Torokhov wrote:

> > I'm looking to dig into the usbhid driver code to get me the last
> > mile and get my HP LD4200tm touchscreen working on my Linux system.
> > [NOTE: I posted about this elsewhere, but as I think about it more,
> > this is more of a linux-kernel issue than anything else, so I'm
> > reprising that note here.]
> 
> I think you'll have better luck on linux-input...

Thanks for CC, Dmitry.

> > So, in first connecting the HP touchscreen (with touchscreen hardware
> > from Nexio) to the Linux system (running Ubuntu 10.10 -- 2.6.35-22 generic)
> > things were looking up, as the unit almost worked right out of the box
> > as a plug-and-play device.  Unfortunately, that last mile needs to be
> > addressed in order for the unit to work in a useful way.  I think I've
> > narrowed down the problem to the usbhid driver, as I'll explain in a
> > moment, and while I expect I have the ability to debug and fix the issue,
> > this would be my first dive into Linux driver coding, so I could probably
> > use a pointer as to what steps are necessary to get the proper kernel
> > sources, compile the needed parts and restart the system (hopefully
> > just restart X-windows) to test my edits (especially since Ubuntu tends
> > to not include a not of the necessary components).
> > 
> > I've collected gobs of data on what udev, hidraw, evtest and X-windows
> > report, but before I get to any of that, here's the executive summary:
> > 
> > Plugging the HP LD4200tm into a Ubuntu 10.10 system will cause the
> > device to be recognized, create a usbhid device, create an event device,
> > activate the evdev driver for Xorg, and put it on the list of X's inputs.
> > So far, so good.
> > 
> > Touching the device causes the mouse pointer to jump to that location,
> > even better.
> > 
> > But when I'm touching the screen, what happens is that the system
> > generates a continuous stream of button presses/releases -- as if
> > I moved the mouse to a particular location and then went crazy
> > tapping on the mouse button.  This is the part that makes the system
> > unusable.
> > 
> > One more data point is that if I touch the screen with a second
> > finger, the button barrage stops, and it will now gracefully report
> > the movement of the first finger.
> > 
> > So all I need to do is modify the driver for this device's protocol
> > to not send all the unnecessary release/press events.
> > 
> > 
> > Here is the data that leads me to believe the issue is at the usbhid
> > layer:
> > 
> > 
> > 1) Running "evtest /dev/input/event4" reveals that the button barrage
> > is already occurring at the HID event layer.
> > 
> > 2) Watching the raw data on /dev/usb/hiddev2 does report a stream of
> > data as the touchscreen is touched (and no data when it's not touched),
> > looking at the output suggests that the device is only reporting touch/
> > release events when the screen is actually touched or released.  And of
> > course, even if the device were reporting things poorly, I figure the
> > usbhid driver could be written to overcome this.
> > 
> > Fortunately, the data seems to be a constant 14-byte stride, so I
> > wrote a simple awk script ("nexio") to reformat the data as I was
> > figuring out the raw protocol.  Here's a sample of the reformatted
> > data, followed by my estimation of the protocol:
> >         % sudo xxd -c 14 -g 1 /dev/hidraw2 | nexio
> >         0000000: 01 03 01 12d8 3357  02 02 15e1 1f71  01
> >         000000e: 01 03 01 12cc 332a  02 02 15e1 1f71  01
> >         000001c: 01 03 01 12de 3335  00 02 15e1 1f71  01
> >         000002a: 01 03 01 12f4 3346  00 02 15e1 1f71  01
> >         0000038: 01 03 01 1304 3352  00 02 15e1 1f71  01
> >         0000046: 01 03 01 130c 3358  00 02 15e1 1f71  01
> >         [... (next I stop touching the screen, and then touch it again)]
> >         00009a0: 01 03 01 12d8 3357  00 02 15e1 1f71  01
> >         00009ae: 01 03 01 12d8 3357  00 02 15e1 1f71  01
> >         00009bc: 01 02 01 12d8 3357  00 02 15e1 1f71  01
> >         00009ca: 01 03 01 10af 3681  02 02 15e1 1f71  01
> >         00009d8: 01 03 01 10a5 3651  02 02 15e1 1f71  01
> >         00009e6: 01 03 01 10b7 3654  00 02 15e1 1f71  01
> >         [... (next is a multi-touch event)]
> >         0000c78: 01 03 01 1019 3627  00 02 15e1 1f71  01
> >         0000c86: 01 03 01 1019 3627  00 02 15e1 1f71  01
> >         0000c94: 01 00 01 100b 35f8  00 02 1585 3110  00
> >         0000ca2: 01 00 01 100e 3604  00 02 158a 311b  00
> >         0000cb0: 01 00 01 1013 3615  00 02 1591 312b  00
> >         0000cbe: 01 00 01 1017 3622  00 02 1596 3136  00
> >         0000ccc: 01 00 01 1019 3628  00 02 1598 313c  00
> >         0000cda: 01 00 01 1019 3629  00 02 1599 313d  00
> >         0000ce8: 01 03 01 1019 3629  03 02 1598 313d  02
> >         0000cf6: 01 03 01 1019 3628  03 02 1598 313c  02
> >         0000d04: 01 03 01 1019 3627  03 02 1598 313b  02
> >         0000d12: 01 03 01 1018 3627  03 02 1597 313a  02
> >         [... (next I release both fingers -- not quite simultaneously)]
> >         0000df2: 01 03 01 1019 3627  03 02 1598 3132  02
> >         0000e00: 01 03 01 1019 3627  03 02 1598 3132  02
> >         0000e0e: 01 03 01 1019 3627  02 02 1598 3132  01
> >         0000e1c: 01 03 01 1019 3626  02 02 1598 3132  01
> >         0000e2a: 01 03 01 1019 3626  00 02 1598 3132  01
> >         0000e38: 01 03 01 1019 3626  00 02 1598 3132  01
> >         0000e46: 01 03 01 1019 3626  00 02 1598 3132  01
> >         0000e54: 01 03 01 1019 3626  00 02 1598 3132  01
> >         0000e62: 01 03 01 1019 3625  00 02 1598 3132  01
> >         0000e70: 01 02 01 1019 3625  00 02 1598 3132  01

Thanks a lot for the detailed analysis. What would actually be interesting 
to see would be the HID debugfs output. Namely

1) mount debugfs
2) cat /sys/kernel/debug/<device>/rdesc
3) obtain output of /sys/kernel/debug/<device>/events and annotate it as 
you did for your previous output (i.e. "this happens when I do one-finger 
move", "this happens when I do two-finger trick to make it work").

This way, it'd be much easier to see what is actually hapenning on HID 
level.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
