Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0CZTHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:07:49 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49028 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0CZTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:07:46 -0400
Date: Fri, 26 Mar 2010 20:07:41 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Message-ID: <20100326190741.GA8743@hardeman.nu>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326112755.GB5387@hardeman.nu>
 <4BACC769.6020906@redhat.com>
 <20100326160150.GA28804@core.coreip.homeip.net>
 <4BACED6B.9030409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BACED6B.9030409@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:22:51PM -0300, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Fri, Mar 26, 2010 at 11:40:41AM -0300, Mauro Carvalho Chehab wrote:
> >> David Härdeman wrote:
> >>> I'd suggest:
> >>>
> >>> struct keycode_table_entry {
> >>> 	unsigned keycode;
> >>> 	unsigned index;
> >>> 	unsigned len;
> >>> 	char scancode[];
> >>> };
> >>>
> >>> Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are 
> >>> ignored), that way no special function to clear the table is necessary, 
> >>> instead you do a loop with:
> >>>
> >>> EVIOCGKEYCODEBIG (with index 0)
> >>> EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
> >>> 		  keycode = KEY_RESERVED)
> >>>
> >>> until EVIOCGKEYCODEBIG returns an error.
> >> Makes sense.
> > 
> > Yes, I think so too. Just need a nice way to handle transition, I'd
> > like in the end to have drivers implement only the improved methods and
> > map legacy methods in evdev.
> 
> Ok. I'll prepare the patches for adding the new ioctl, in a way that it will
> also handle the legacy methods, and post for review.

If EVIOCGKEYCODEBIG is going to be used as a superset of the old ioctl, 
might it be a good idea change the proposed struct to:

struct keycode_table_entry {
	unsigned keycode;
	unsigned index;
	unsigned type;
	unsigned len;
	char scancode[];
};

Where "type" is used to give a hint of how the scancode[] member should 
be interpreted?

>>>> On a related note, I really think the interface would benefit from 
>>>> allowing more than one keytable per irrcv device with an input 
>>>> device created per keytable. That way you can have one input device 
>>>> per remote control. This implies that EVIOCLEARKEYCODEBIG is a bit 
>>>> misplaced as an evdev IOCTL since there's an N-1 mapping between 
>>>> input devices and irrcv devices.
>>> I don't think that an ioctl over one /dev/input/event should be the 
>>> proper way
>>> to ask kernel to create another filtered /dev/input/event. As it 
>>> were commented
>>> that the multimedia keys on some keyboards could benefit on having a 
>>> filter
>>> capability, maybe we may have a sysfs node at class input that would 
>>> allow
>>> the creation/removal of the filtered event interface.
>> 
>> No, if you want separate event devices just create a new instance 
>> of
>> input device for every keymap and have driver/irrcv class route 
>> events
>> to proper input device.

I fully agree!

> This don't solve the issue about how to signalize to kernel that more than one
> input device is needed. 
> 
> As the userspace will request the creation of those keymaps, we need some way
> to receive such requests from userspace. 
> 
> I can see a few ways for doing it:
> 
> 1) create a control device for the irrcv device as a hole,
> that would handle such requests via ioctl (/dev/irctl[0-9]* ?)
>
> 2) create a read/write sysfs node that would indicate the number of event/keymaps
> associated with a given IR. By writing a bigger number, it would create new devices.
> By writing a smaller number, it will delete some maps. There's an issue though: 
> what criteria would be used to delete? The newly created ones?

This won't work for the reason you've already set out...which keymap 
should be deleted?
 
> 3) create a fixed number of event devices, and add a sysfs attribute to enable
> or disable it;

You really seem to prefer sysfs over ioctls :)

> 4) create a fixed number of sysfs attributes to represent the keymaps. For example:
> /sys/class/irrcv/irrcv0/keymap0/enabled
> 	...
> /sys/class/irrcv/irrcv0/keymap7/enabled
> 
> The input/event node will be created only when the enabled=1.

This sounds like 3)

> I don't like (2) or (3), because removing a table with (2) may end by removing the wrong
> table, and (3) will create more event interfaces than probably needed by the majority
> of IR users.
> 
> maybe (4) is the better one.

Personally I think 1) is the best approach. Having a device for the 
irrcv device allows for three kinds of operations:

read
----
which corresponds to RX...you're eventually going to want to let 
userspace devices read IR commands which have no entries in a keytable 
yet in order to create keytables for new remotes, the same interface can 
also be used for lirc-type user-space apps which want to access the raw 
pulse/space timings for userspace decoding.

write
-----
which would correspond to TX...I'd suggest a stream of s32 integers to 
imply pulse/space timings.

ioctl
-----
for controlling the RX/TX parameters, creating/destroying additional 
keytables, etc...

Basically, we'll end up with a lirc_dev 2.0. And the "irrcv" class name 
will be misleading since it will be irrcv + irsnd :)

-- 
David Härdeman
