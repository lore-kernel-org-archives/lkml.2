Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0CZQCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:02:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:20016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0CZQCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FyzQpgg6YFQNForRHCCJz++qhtzYbSWBNrvQYMDQouHhAZFJrXWs3IKKvq4TKZ0H/z
         7RhqCVn+Qnz1kyt7SoRnMWFuNXOPpI7bH/wXmY3uLUasqhA6XByYASw90SdNMtq3zEW5
         2FaoXK0f98Vr6HaecLY1g6YKAd9HTOgHVWX7s=
Date: Fri, 26 Mar 2010 09:01:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
 system?
Message-ID: <20100326160150.GA28804@core.coreip.homeip.net>
References: <20091215195859.GI24406@elf.ucw.cz>
 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
 <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326112755.GB5387@hardeman.nu>
 <4BACC769.6020906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BACC769.6020906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:40:41AM -0300, Mauro Carvalho Chehab wrote:
> David Härdeman wrote:
> > On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
> >>>        10) extend keycode table replacement to support big/variable 
> >>>        sized scancodes;
> >> Pending.
> >>
> >> The current limit here is the scancode ioctl's are defined as:
> >>
> >> #define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
> >> #define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */
> >>
> >> As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
> >> with a keycode, there's not enough bits there for IR.
> >>
> >> The better approach seems to create an struct with an arbitrary long size, like:
> >>
> >> struct keycode_table_entry {
> >> 	unsigned keycode;
> >> 	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
> >> 	int len;
> >> }
> >>
> >> and re-define the ioctls. For example we might be doing:
> >>
> >> #define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
> >> #define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
> >> #define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)
> >>
> >> Provided that the size for struct keycode_table_entry is different, _IO will generate
> >> a different magic number for those.
> >>
> >> Or, instead of using 0x04, just use another sequential number at the 'E' namespace.
> >>
> >> An specific function to clear the table is needed with big scancode space,
> >> as already discussed.
> >>
> > 
> > I'd suggest:
> > 
> > struct keycode_table_entry {
> > 	unsigned keycode;
> > 	unsigned index;
> > 	unsigned len;
> > 	char scancode[];
> > };
> > 
> > Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are 
> > ignored), that way no special function to clear the table is necessary, 
> > instead you do a loop with:
> > 
> > EVIOCGKEYCODEBIG (with index 0)
> > EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
> > 		  keycode = KEY_RESERVED)
> > 
> > until EVIOCGKEYCODEBIG returns an error.
> 
> Makes sense.

Yes, I think so too. Just need a nice way to handle transition, I'd
like in the end to have drivers implement only the improved methods and
map legacy methods in evdev.

> 
> > This also allows you to get all the current mappings from the kernel 
> > without having to blindly search through an arbitrarily large keyspace.
> > 
> > Also, EVIOCLEARKEYCODEBIG should be:
> > 
> > #define EVIOCLEARKEYCODEBIG _IOR('E', 0x04, struct keycode_table_entry)
> > 
> > That way a user space application can simply call EVIOCLEARKEYCODEBIG, 
> > ask the user for an appropriate keycode, fill in the keycode member of 
> > the struct returned from EVIOCLEARKEYCODEBIG and call EVIOCSKEYCODEBIG.
> 
> By using the index concept, I don't think we need another ioctl. Also,
> there's no way for kernel to handle it, as it will be using the same
> magic number of EVIOCGKEYCODEBIG.
> 
> > On a related note, I really think the interface would benefit from 
> > allowing more than one keytable per irrcv device with an input device 
> > created per keytable. That way you can have one input device per remote 
> > control. This implies that EVIOCLEARKEYCODEBIG is a bit misplaced as an 
> > evdev IOCTL since there's an N-1 mapping between input devices and irrcv 
> > devices.
> 
> I don't think that an ioctl over one /dev/input/event should be the proper way
> to ask kernel to create another filtered /dev/input/event. As it were commented
> that the multimedia keys on some keyboards could benefit on having a filter
> capability, maybe we may have a sysfs node at class input that would allow
> the creation/removal of the filtered event interface.

No, if you want separate event devices just create a new instance of
input device for every keymap and have driver/irrcv class route events
to proper input device.

Thanks.

-- 
Dmitry
