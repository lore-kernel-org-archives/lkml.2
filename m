Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0CZTVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:21:25 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37064 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CZTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:21:22 -0400
Date: Fri, 26 Mar 2010 20:21:17 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
Message-ID: <20100326192117.GA9290@hardeman.nu>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <20091215195859.GI24406@elf.ucw.cz>
 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
 <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326122317.GC5387@hardeman.nu>
 <4BACD00E.7040401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BACD00E.7040401@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:17:34PM -0300, Mauro Carvalho Chehab wrote:
> David Härdeman wrote:
> > On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
> >>>        2) add current_protocol support on other drivers;
> >> Done. Patch were already merged upstream.
> >>
> >> The current_protocol attribute shows the protocol(s) that the device is accepting
> >> and allows changing it to another protocol. 
> >>
> >> In the case of the em28xx hardware, only one protocol can be active, since the decoder
> >> is inside the hardware. 
> >>
> >> On the raw IR decode implementation I've done at the saa7134, all raw pulse events are
> >> sent to all registered decoders, so I'm thinking on using this sysfs node to allow
> >> disabling the standard behavior of passing the IR codes to all decoders, routing it
> >> to just one decoder.
> >>
> >> Another alternative would be to show current_protocol only for devices with hardware
> >> decoder, and create one sysfs node for each decoder, allowing enabling/disabling each
> >> decoder individually.
> > 
> > You're eventually going to want to add ioctl's to set a lot of TX or RX 
> > parameters in one go (stuff like active receiver(s) and transmitter(s), 
> > carrier frequency, duty cycle, timeouts, filter levels and resolution - 
> > all of which would need to be set in one operation since some hardware 
> > will need to be reset after each parameter is changed).
> 
> TX is a completely different history. It has nothing to do with input event
> subsystem. So, another approach should be taken for it.

I suggest (though I might not have been clear on that point) that irrcv 
devices create a char node...ir specifics are handled via that node 
(with read/write/ioctl...see the other mail I just send).

> I haven't seen yet a hardware decoder with such parameters, but maybe I just
> don't have enough specs here to adjust them.

The entire idea is to have a common API for hardware decoders and 
decoders which provide raw pulse/space timings. That, to me, is one of 
the major points of having in-kernel IR decoders - being able to provide 
a consistent interface for both hardware decoders and pulse/space 
hardware.

> Anyway, one simple way to avoid
> resetting the hardware for every new parameter change would be to use a timer
> for reset. This way, an userspace application or script that is touching on 
> several parameters would just send the complete RX init sequence and
> after some dozens of milliseconds, the hardware will load the new parameters.

And I do not think that sounds like a good interface.

> > Then you'll end up with a few things being controlled via sysfs and some 
> > being controlled via ioctls. Maybe it's a good idea to have a bitmask of 
> > supported and enabled protocols in those ioctls instead?
> 
> There's an interesting discussion about bitmasks x a list of enumerated values
> as a way to represent a bitmask into a series of values on sysfs,
> at http://lwn.net/Articles/378219/  (see "A critical look at sysfs attribute values"
> article there).

Not really relevant...that's just the minor detail of how a sysfs file 
might be represented.

> That's said, I'm starting to think that the better is to have some differentiation
> there between hardware and software decoders. IMO, software decoders are better
> handled with an "enabled" attribute, per software decoder, inside each irrcv.

I think we can create an interface which obscures the differences:

Software decoders will export all in-kernel IR decoders in a bitmask in 
the "supported_protocols" sysfs file or ioctl struct member.

Hardware decoders will export the hardware supported protocol(s) in the 
same file/member.

In addition, a sysfs file or ioctl member for "enabled_protocols" will 
control either the enabled in-kernel IR decoders or hardware decoder(s).



As should be quite obvious by now...I suggest ioctls (on a irrcv 
specific chardev) for controlling this :)

-- 
David Härdeman
