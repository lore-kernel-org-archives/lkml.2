Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432Ab0KQTrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:47:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:44749 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0KQTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:47:36 -0500
Message-ID: <4CE43153.2070206@linux.vnet.ibm.com>
Date: Wed, 17 Nov 2010 11:47:31 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
References: <1289339119.2191.92.camel@laptop> <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com> <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop> <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com> <1289421164.2084.56.camel@laptop> <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com> <1289423135.2084.63.camel@laptop>  <4CE33F86.7040403@linux.vnet.ibm.com> <1289993128.2109.714.camel@laptop>
In-Reply-To: <1289993128.2109.714.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 03:25 AM, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 18:35 -0800, Corey Ashford wrote:
>
>> I don't understand the /sys/devices tree much (I will read up on it),
>> but this idea looks good to me.
>
> Yeah, me too.. I talked to Kay a bit earlier on and /sys/devices/system
> is 'special'..
>
>> To clarify my understanding a bit and taking the gfx example, in the
>> path /sys/class/pmu/radeon0, is the '0' here denoting the 0'th radeon
>> chip in the system, or the radeon model number?  I would assume the 0'th
>> chip.
>
> Chip indeed.
>
>> So if I assume that now points to a unique radeon chip in the system,
>> underneath /sys/class/pmu/radeon0 will be a structure something like:
>>
>> radeon0/
>> 	event/
>> 		evt0
>> 		..
>> 		evtn
>>
>> And if there is a second radeon chip, there would be a nearly identical
>> tree:
>>
>> radeon1/
>> 	event/
>> 		evt0
>> 		..
>> 		evtn
>>
>> Is that correct?
>
> Yes.
>
>> Some of these events may need modifiers / attributes / umasks...
>> whatever you want to call them.  And they may need more than one each,
>> and they may vary from event to event.  So to add to the hierarchy,
>> we'd have:
>>
>> radeon0/
>>       type (for attr.type)
>>       event/
>>           evt0/
>>               id (a base number for attr.config)
>>               description (text file - but could be CONFIG_*'d out)
>>               modifiers/
>>                   mod0/
>>                       formula (some ascii syntax for describing how
>>                                to set .config and/or .config_extra
>>                                with this modifer's value)
>>                       description (text - can configure out)
>>                       constraints (some ascii syntax for describing
>>                                    the values mod0 can take on)
>>                   ..
>>                   modn/
>>           ..
>> 	evtn/
>>
>> And this would be replicated for radeon1..n
>
> The idea of the events dir is to provide a few frequently used/common
> events, not to be an exhaustive list.
>
> What we can do is provide a break-down of the config in the top-level
> directory and refer people to the hardware documentation (they need to
> read that anyway if they want to make use special events anyway).

If the config breakdown is at the top level, it will be nearly 
unreadable for WSP, because of the many different encoding formats we 
use, even for one PMU.  See below.

>
>> Maybe all of the "event" directories could be soft links to a common
>> radeon<model_number>  event directory.
>
> Possibly, but I don't expect this to be a common thing, and we can
> always do it later.
>
>> When you fully specify an event, you have something like:
>>
>> /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.0/drm/card0/pmu/<event>[:<modifier>=nnn:...]
>>
>> So it wouldn't end up being strictly a sysfs path anymore, and perf
>> would have a bit of parsing work to do, to evaluate the modifiers, using
>> the info from constraints, and construct the .type, .config, and
>> .config_extra fields using formula.
>>
>> Or maybe you have some other structure in mind?
>
> I wouldn't bother with modifiers and all that:
>    perf record -e radeon0:r0123456789ABCDEF
>
> is there for people who know what they're doing, possibly we can parse
> the config format and use some of that to enable things like:
>
> [ using the x86-intel format because I actually know that, as opposed to
>    the radeon case which I know absolutely nothing about. ]
>
> # cat cpu/config_format
> event_selector:8
> unit_mask:8
> NULL:7
> invert:1
> counter_mask:8
>

This is an interesting approach, though for the IBM WSP (aka PowerEN) 
chip, the config_format would have to be at a deeper level than the PMU, 
because the modifiers that affect the event, vary from event to event. 
Either that or you'd have to provide a complex union structure.

However, above you say that you want to have "a few frequently 
used/common events".  I thought that was the job of the perf "generic 
events".  My understanding was that the sysfs tree was the solution for 
all events, including arch-specific, and seldom-used events.  Ingo 
pushed back on a user-space library solution (like libpfm4) because he 
wanted event info in sysfs (or some other mechanism by which the kernel 
could expose event info to user space).

If there is going to be no place in sysfs for arch-specific events, I'll 
want to start pushing for perf to be able to use a user space library again.

How about a compromise position: all of the arch-specific events are 
exposed to user space via sysfs iff some CONFIG_* variable to set to 
true.  Something like CONFIG_EXPOSE_ALL_HW_PERF_EVENTS_IN_SYSFS.
This way you would only use all that memory when it's explicitly 
configured in.

> perf record -e radeon0:event_selector=0xf;unit_mask=0x5;invert;counter_mask=1
>
> To make it slightly easier, we could maybe event do something like:
>
> perf record -e radeon0:instructions;invert;counter_mask=1
>
> To take the base of the 'instructions' event and modify that with the
> invert and counter_mask details.

I like this.

- Corey
