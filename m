Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1DDOwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:52:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23873 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1DDOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:52:40 -0400
X-IronPort-AV: E=Sophos;i="4.63,297,1299474000"; 
   d="scan'208";a="31726611"
Message-ID: <4D99D933.1090004@analog.com>
Date: Mon, 4 Apr 2011 16:44:03 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: michael.hennerich@analog.com
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev
 combining and rewrite of triggers as 'virtual' irq_chips.
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <4D99B34B.9050309@analog.com> <4D99C4D7.1010706@cam.ac.uk>
In-Reply-To: <4D99C4D7.1010706@cam.ac.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:17 PM, Jonathan Cameron wrote:
> On 04/04/11 13:02, Michael Hennerich wrote:
>   
>> On 03/31/2011 04:53 PM, Jonathan Cameron wrote:
>>     
>>> Dear All,
>>>
>>> I'm afraid what in many ways makes sense as three separate
>>> series have gotten rather intertwined.  I can probably unpick
>>> them but it will involve a lot of intermediate code in
>>> lis3l02dq (which is our fiddly example for this set) that I'd
>>> rather avoid.  Hence lets have a guide to what various people
>>> might be interested in:
>>>
>>> 1) Channel registration rework (this has previous been in linux-iio
>>>    but really comes into it's own after we remove various special
>>>    cases later in this code).
>>>
>>>    Patches 1, 2, 3, 21
>>>    (8) - cleanups Arnd Bergmann pointed out in passing.
>>>   
>>>       
>> Good approach. It removes quite a bit on duplicated code across drivers.
>> At the moment I can't think of existing drivers that couldn't moved over
>> to the
>> new channel registration method.
>>     
> There are a few that will require quite a bit more code - principally the
> light sensors with their rather odd channel naming.  I'll do one of those
> shortly and see what we end up with.
>
>   
>> However there are some limitations.
>> read_raw() value is currently type int, depending on the channel type,
>> int type might be too short.
>>     
> True. How far do you think we should go?  s64? I did wonder if it makes sense
> to have two value pointers (perhaps NULL)  So base unit (val1) and
> decimal places of base unit (val2).
>
> So true raw values (e.g. sensor readings) will only set val1, but we have plenty
> of space for things like scale at sufficient accuracy.  That also means we can
> flatten together the attributes in the core for both cases (not a great saving
> but nice to have none the less).
>
> What do you think?
>   
64-bit arithmetic is a bit tricky on Linux. On some platforms you can't
use the native 64-bit divide.
You have to use do_div() instead. So I don't think we should always use
type s64.
As you proposed in your follow up email  - depending on the return value
we can use val1 and val2.
>   
>>  
>>     
>>> 2) Flattening together of (some) of the chardevs (buffer related ones).
>>>    As Arnd pointed out, there is really a use case for having multiple
>>>    watershed type events from ring buffers.  Much better to have a
>>>    single one (be that at a controllable point).  Firstly this removes
>>>    the need for the event escalation code.  Second, this single 'event'
>>>    can then be indicated to user space purely using polling on the
>>>    access chrdev.  This approach does need an additional attribute to
>>>    tell user space what the poll succeeding indicates (tbd).
>>>
>>>    I haven't for now merged the ring handling with the more general
>>>    event handling as Arnd suggested.  This is for two reasons
>>>    1) It's much easier to debug this done in a couple of steps
>>>    2) The approach Arnd suggested may work well, but it is rather
>>>    different to how other bits of the kernel pass event type data
>>>    to user space.  It's an interesting idea, but I'd rather any
>>>    discussion of that approach was separate from the obviously
>>>    big gains seen here.
>>>
>>>    Patches 4, 5, 6, 7, 17
>>>   
>>>       
>> I appreciate the removal of the buffer event chardev. Adding support for
>> poll is also a good thing to do.
>> However support for a blocking read might also fit some use cases.
>>     
> Good point. I guess blocking on any content and poll for the watershead
> gives the best of both worlds.  The blocking read is more down to the
> individual implementations than a core feature though - so one to do
> after this patch set.
>   
>>  
>>     
>>> 3) Reworking the triggering infrastructure to use 'virtual' irq_chips
>>>    This approach was suggested by Thomas Gleixner.
>>>    Before we had explicit trigger consumer lists.  This made for a very
>>>    clunky implementation when we considered moving things over to
>>>    threaded interrupts.  Thomas pointed out we were reinventing the
>>>    wheel and suggested more or less what we have here (I hope ;)
>>>   
>>>       
>> Using threaded interrupts, greatly reduces use of additional workqueues
>> and excessive interrupt enable and disables.
>>     
> There is a nasty side issue here.  What do we do if we are getting triggers
> faster than all of the consumers can work at?  Right now things tend to
> stall.  I think we just want to gracefully stop the relevant trigger
> if this happens.  I'm not quite sure how we can notify userspace that this
> has happened... Perhaps POLLERR? 
>   
I think we had a similar problems before. We definitely need to signal
the error.
For poll, POLLERR seems to be the only suitable return value.
>>   
>>     
>>>    Patches 9 and 10 are minor rearrangements of code in the one
>>>    driver I know of where the physical interrupt line for events
>>>    is the same as that for data ready signals (though not at the
>>>    same time).
>>>   
>>>       
>> I wouldn't consider this being a corner case. I know quite a few devices
>> that trigger data availability,
>> and other events from the same physical interrupt line, and they may do
>> it at the same time.
>>     
> If they do it at the same time things may get a bit nasty. Things are somewhat
> simpler after some of the later patches, as the irq requests are entirely
> handled in the drivers.  Thus the driver could have one interrupt handler.
> The restriction will be that it would only be able to do nested irq calls
> limiting us to not having a top half for anything triggered from such an
> interrupt. This is because identifying whether we have a dataready or
> other event will require querying the device and hence sleeping. Note
> the sysfs trigger driver will also have this restriction (as posted yesterday).
>
> For devices where they share the line but cannot happen at the same time I'd
> prefer to do what we have in the lis3l02dq and completely separate the two
> uses of the interrupt line.
>
>   
>>  
>>     
>>>    In a rare situation we have complete control of these virtual
>>>    interrupts within the subsystem.  As such we want to be able to
>>>    continue to build the subsystem as a module.  This requires a
>>>    couple of additional exports in the generic irq core code and
>>>    also arm (for my test board anyway).
>>>    Patches 13 and 14 make these changes.  I hope they won't prove
>>>    to controversial.
>>>
>>>    Patch 15 adds a board info built in element to the IIO subsystem
>>>    so we have a means of platform data telling us what interrupt
>>>    numbers are available for us to play with.  Does anyone have
>>>    a better way of doing this?  Patch 16 is an example of what
>>>    needs to go in board files.
>>>   
>>>       
>> Since this is purely platform dependent, setting the irq pool from the
>> board setup looks acceptable to me, and depending on the arch or machine
>> it might be necessary two tweak some other defines.
>> However many arches define NR_IRQS always greater than actually used. So
>> why not make IR-Base a Kconfig option?
>>     
> There is currently a nasty hack in the irq codes to deal with the fact that
> for at least some (maybe all) arm chips NR_IRQS is set to those on the SOC
> and doesn't include any others.  The work around for that is that all the
> irq handling adds a chunk of padding.  I would hope that will go away at
> some point in the future.
>   
Back in 2009, when doing the ADP5520 MFD, I came to the same conclusion.
Sad to see that things are still the same.

http://kerneltrap.org/mailarchive/linux-kernel/2009/9/29/4492190/thread

> Otherwise, yes we could indeed make it a KCONFIG option subject to some
> fiddling with individual arches to make it work.  This may be one to tackle
> when moving out of staging rather than now though.
>
> Perhaps we need to try it on a few architectures and see what is needed on each
>   
> Thanks for taking a look!
>
> Jonathan 
>
>
>   


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif

