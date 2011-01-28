Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1A1SQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:16:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1A1SQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:16:26 -0500
Message-ID: <4D4307D7.8010301@redhat.com>
Date: Fri, 28 Jan 2011 16:15:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110127021227.GA29709@core.coreip.homeip.net> <4D40E41D.2030003@teksavvy.com> <20110127063815.GA29924@core.coreip.homeip.net> <4D414928.80801@redhat.com> <20110127172128.GA19672@core.coreip.homeip.net> <4D41C071.2090201@redhat.com> <20110128093922.GA3357@core.coreip.homeip.net> <4D42AECE.3020402@redhat.com> <20110128164057.GA6252@core.coreip.homeip.net> <4D42F686.8010104@redhat.com> <20110128173305.GC6252@core.coreip.homeip.net>
In-Reply-To: <20110128173305.GC6252@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-01-2011 15:33, Dmitry Torokhov escreveu:
> On Fri, Jan 28, 2011 at 03:01:58PM -0200, Mauro Carvalho Chehab wrote:
>> Em 28-01-2011 14:40, Dmitry Torokhov escreveu:
>>> On Fri, Jan 28, 2011 at 09:55:58AM -0200, Mauro Carvalho Chehab wrote:
>>
>>>> The rc-core register (and the corresponding input register) is done when
>>>> the device detected a remote controller, so, it should be safe to register
>>>> on that point. If not, IMHO, there's a bug somewhere. 
>>>
>>> It is not a matter of safe or unsafe registration. Registration is fine.
>>> The problem is that with the current set up is that utility is fired
>>> when trunk of [sub]tree is created, but the utility wants to operate on
>>> leaves which may not be there yet.
>>
>> I'm not an udev expert. Is there a udev event that hits only after having
>> the driver completely loaded?
> 
> Define completely loaded? For a PCI SCSI controller does fully loaded
> mean all attached devices are discovered and registered with block layer?
> For a wireless NIC does it mean that it assocuated with an AP? What if
> you have more than one device that driver serves?
> 
> So teh answer is no and there should not be.
> 
>>
>> Starting an udev rule while modprobe is
>> still running is asking for race conditions.
> 
> Not if we write stuff properly.
> 
>>
>> I'm not entirely convinced that this is the bug that Mark is hitting, as
> 
> I do not know yet.
> 
>> rc-core does all needed setups before registering the evdev device. We
>> need the core and the dmesg to be sure about what's happening there.
> 
> I will say it again. Your udev rule triggers when you create rcX device.
> eventX device may apeear 2 hours after that (I could have evdev as a
> module and blacklisted and load it later manually).

Blacklisting it won't (or shouldn't work).

>From rc-main, the registering sequence is:

	dev_set_name(&dev->dev, "rc%ld", dev->devno);
	dev_set_drvdata(&dev->dev, dev);
	rc = device_add(&dev->dev);
	if (rc)
		return rc;

	rc = ir_setkeytable(dev, rc_map);
	if (rc)
		goto out_dev;

	dev->input_dev->dev.parent = &dev->dev;
	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
	dev->input_dev->phys = dev->input_phys;
	dev->input_dev->name = dev->input_name;
	rc = input_register_device(dev->input_dev);
	if (rc)
		goto out_table;

rc-main will wait for input_register_device() to finish, so even if you
blacklist it, rc-core will load it, in order to solve the symbol dependency.

Btw, there's really a race issue there: device_add is happening before
input_register_device(), so the udev rule will cause troubles.

> You need to split it into 2 separate steps:
> 
> 1. Triggers when rcX appears, accesses only rcX and it's parents and
>    does rcX related stuff.
> 
> 2. Triggers when eventX appears and loads keymap and what not. Because
>    it is a child of rcX (in  specific case of remotes) it may examine
>    rcX attributes as well.

The fix is probably simpler: we need to change the udev rules to work at
evdev registration and only if the device is a remote controller. This
should solve the current issue.

>>>> Yet, I agree that udev tries to set devices too fast.
>>>
>>> It tries to set devices exacty when you tell it to do so. It's not like
>>> it goes trolling for random devices is sysfs.
>>>
>>>> It would be better if
>>>> it would wait for a few milisseconds, to reduce the risk of race conditions.
>>>
>>> Gah, I really prefer using properly engineered solutions instead of
>>> adding crutches.
>>
>> I agree.
>>
>>>>> And this could be easily added to the udev's keymap utility that is
>>>>> fired up when we discover evdevX devices.
>>>>
>>>> Yes, it can, if you add the IR protocol selection on that tool. A remote 
>>>> controller keycode table has both the protocol and the keycodes.
>>>> This basically means to merge 99% of the logic inside ir-keytable into the
>>>> evdev generic tool.
>>>
>>> Or just have an utility producing keymap name and feed it as input to
>>> the generic tools. The way most of utilities work...
>>
>> I don't like the idea of running a some logic at udev that would generate
>> such keymap in runtime just before calling the generic tool. The other
> 
> Why? You'd just call something like:
> 
>       keymap $name `rc-keymap-name -d $name`
> 
> where 'keymap' is udev's utility and 'rc-keymap-name' is new utility
> that incorporates map selection logic currently found in rc-keytable.
> 
> It looks like format of the keymaps is compatible between 'keymap' and
> 'ir-keytable' and metadata that is present in your keymaps will not
> confuse 'keymap' utility.

The format is, currently compatible. However, we'll likely need to change it
(or to allow the tool to handle also a different format), due to some reasons:
	1) Protocol and the device name where it is found by default is
	   currently a comment;
	2) We'll need to add a field there specifying the number of the bits
	   to be used by the keymap table, in order to use the proper length
	   with _V2 ioctls;
	3) There are hundreds of keymaps already created for lircd. It
	   would be nice to support lircd format, in order to make life
	   easier for those that use lirc.

If you want to add these to the generic tool, that's fine for me, but, IMO, this
doesn't sound a good idea. There are already specialized tools for other kinds
of input devices (mouse: gpm; joystick: jstest; etc). It seems a bad idea
to merge them into the generic tools.

I think it is better to have a tool that just handle one kind of device, but
does it well, than trying to extend a generic tool to cover all possible
devices, and adding lots of caveats there for it to handle all the specifics.

>> alternative (e. g.) to maintain the RC-protocol dependent keytables separate
>> from the RC protocol used by each table will be a maintenance nightmare.
> 
> I do not propose splitting keytables, I propose splittign utilities.
> ir-keytable is a kitchen sink now. It implements 'keymap', 'evtest' and
> bucnch of other stuff and would be much cleaner if split apart.

It may be broken into a few utilities, by creating a library with the
common code. I'll think about that when I have some spare time for it.

Cheers,
Mauro.
