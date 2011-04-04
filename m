Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1DDSHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:07:34 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33635 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1DDSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:07:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9A0944.8040907@cam.ac.uk>
Date: Mon, 04 Apr 2011 19:09:08 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: michael.hennerich@analog.com
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev
 combining and rewrite of triggers as 'virtual' irq_chips.
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <4D99B34B.9050309@analog.com> <4D99C4D7.1010706@cam.ac.uk> <4D99D933.1090004@analog.com>
In-Reply-To: <4D99D933.1090004@analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

....
>>   
>>> However there are some limitations.
>>> read_raw() value is currently type int, depending on the channel type,
>>> int type might be too short.
>>>     
>> True. How far do you think we should go?  s64? I did wonder if it makes sense
>> to have two value pointers (perhaps NULL)  So base unit (val1) and
>> decimal places of base unit (val2).
>>
>> So true raw values (e.g. sensor readings) will only set val1, but we have plenty
>> of space for things like scale at sufficient accuracy.  That also means we can
>> flatten together the attributes in the core for both cases (not a great saving
>> but nice to have none the less).
>>
>> What do you think?
>>   
> 64-bit arithmetic is a bit tricky on Linux. On some platforms you can't
> use the native 64-bit divide.
> You have to use do_div() instead. So I don't think we should always use
> type s64.
> As you proposed in your follow up email  - depending on the return value
> we can use val1 and val2.
Cool, I'll give that a go.  I'll also blindly port a few more drivers
over to the new framework and see where problems occur.
>>>   
>>>     
>>>>    Patches 9 and 10 are minor rearrangements of code in the one
>>>>    driver I know of where the physical interrupt line for events
>>>>    is the same as that for data ready signals (though not at the
>>>>    same time).
>>>>   
>>>>       
>>> I wouldn't consider this being a corner case. I know quite a few devices
>>> that trigger data availability,
>>> and other events from the same physical interrupt line, and they may do
>>> it at the same time.
>>>     
>> If they do it at the same time things may get a bit nasty. Things are somewhat
>> simpler after some of the later patches, as the irq requests are entirely
>> handled in the drivers.  Thus the driver could have one interrupt handler.
>> The restriction will be that it would only be able to do nested irq calls
>> limiting us to not having a top half for anything triggered from such an
>> interrupt. This is because identifying whether we have a dataready or
>> other event will require querying the device and hence sleeping. Note
>> the sysfs trigger driver will also have this restriction (as posted yesterday).
>>
>> For devices where they share the line but cannot happen at the same time I'd
>> prefer to do what we have in the lis3l02dq and completely separate the two
>> uses of the interrupt line.
I've been persuaded otherwise ;) See other branch of thread.
>>
>>   
>>>  
>>>     
>>>>    In a rare situation we have complete control of these virtual
>>>>    interrupts within the subsystem.  As such we want to be able to
>>>>    continue to build the subsystem as a module.  This requires a
>>>>    couple of additional exports in the generic irq core code and
>>>>    also arm (for my test board anyway).
>>>>    Patches 13 and 14 make these changes.  I hope they won't prove
>>>>    to controversial.
>>>>
>>>>    Patch 15 adds a board info built in element to the IIO subsystem
>>>>    so we have a means of platform data telling us what interrupt
>>>>    numbers are available for us to play with.  Does anyone have
>>>>    a better way of doing this?  Patch 16 is an example of what
>>>>    needs to go in board files.
>>>>   
>>>>       
>>> Since this is purely platform dependent, setting the irq pool from the
>>> board setup looks acceptable to me, and depending on the arch or machine
>>> it might be necessary two tweak some other defines.
>>> However many arches define NR_IRQS always greater than actually used. So
>>> why not make IR-Base a Kconfig option?
>>>     
>> There is currently a nasty hack in the irq codes to deal with the fact that
>> for at least some (maybe all) arm chips NR_IRQS is set to those on the SOC
>> and doesn't include any others.  The work around for that is that all the
>> irq handling adds a chunk of padding.  I would hope that will go away at
>> some point in the future.
>>   
> Back in 2009, when doing the ADP5520 MFD, I came to the same conclusion.
> Sad to see that things are still the same.
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2009/9/29/4492190/thread
Yes. I guess that fuzz has to happen somewhere even if it is just a case
of platforms defining it to be big enough for all known boards (which is
hideous).
...
