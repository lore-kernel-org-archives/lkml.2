Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0CZPSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab0CZPSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:18:45 -0400
Message-ID: <4BACD00E.7040401@redhat.com>
Date: Fri, 26 Mar 2010 12:17:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091215115011.GB1385@ucw.cz> <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz> <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com> <20091215201933.GK24406@elf.ucw.cz> <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com> <20091215203300.GL24406@elf.ucw.cz> <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com> <4BAB7659.1040408@redhat.com> <20100326122317.GC5387@hardeman.nu>
In-Reply-To: <20100326122317.GC5387@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Härdeman wrote:
> On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
>>>        2) add current_protocol support on other drivers;
>> Done. Patch were already merged upstream.
>>
>> The current_protocol attribute shows the protocol(s) that the device is accepting
>> and allows changing it to another protocol. 
>>
>> In the case of the em28xx hardware, only one protocol can be active, since the decoder
>> is inside the hardware. 
>>
>> On the raw IR decode implementation I've done at the saa7134, all raw pulse events are
>> sent to all registered decoders, so I'm thinking on using this sysfs node to allow
>> disabling the standard behavior of passing the IR codes to all decoders, routing it
>> to just one decoder.
>>
>> Another alternative would be to show current_protocol only for devices with hardware
>> decoder, and create one sysfs node for each decoder, allowing enabling/disabling each
>> decoder individually.
> 
> You're eventually going to want to add ioctl's to set a lot of TX or RX 
> parameters in one go (stuff like active receiver(s) and transmitter(s), 
> carrier frequency, duty cycle, timeouts, filter levels and resolution - 
> all of which would need to be set in one operation since some hardware 
> will need to be reset after each parameter is changed).

TX is a completely different history. It has nothing to do with input event
subsystem. So, another approach should be taken for it.

I haven't seen yet a hardware decoder with such parameters, but maybe I just
don't have enough specs here to adjust them. Anyway, one simple way to avoid
resetting the hardware for every new parameter change would be to use a timer
for reset. This way, an userspace application or script that is touching on 
several parameters would just send the complete RX init sequence and
after some dozens of milliseconds, the hardware will load the new parameters.

> Then you'll end up with a few things being controlled via sysfs and some 
> being controlled via ioctls. Maybe it's a good idea to have a bitmask of 
> supported and enabled protocols in those ioctls instead?

There's an interesting discussion about bitmasks x a list of enumerated values
as a way to represent a bitmask into a series of values on sysfs,
at http://lwn.net/Articles/378219/  (see "A critical look at sysfs attribute values"
article there).

That's said, I'm starting to think that the better is to have some differentiation
there between hardware and software decoders. IMO, software decoders are better
handled with an "enabled" attribute, per software decoder, inside each irrcv.

In the case of hardware decoders, just one attribute is enough to control it. I think
it should be a bitmask parameter, but presented with their aliases, like for example:
	$cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
	ondemand conservative performance 

This is clearly a bitmask, but it is presented as textual values, instead of a
magic number.

So, we may have
	/sys/class/irrcv/irrcv0/supported_protocols

as, for example:
	RC-5 NEC

and allow setting current_protocol as just "RC-5" or, if the hardware supports
more than one decoder at the same time, as "RC-5 NEC".

-- 

Cheers,
Mauro
