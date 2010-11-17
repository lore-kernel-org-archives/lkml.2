Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab0KQCf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:35:56 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56709 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598Ab0KQCfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:35:54 -0500
Message-ID: <4CE33F86.7040403@linux.vnet.ibm.com>
Date: Tue, 16 Nov 2010 18:35:50 -0800
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
References: <1289339119.2191.92.camel@laptop> <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com> <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop> <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com> <1289421164.2084.56.camel@laptop> <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com> <1289423135.2084.63.camel@laptop>
In-Reply-To: <1289423135.2084.63.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 01:05 PM, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 21:53 +0100, Stephane Eranian wrote:
>> On Wed, Nov 10, 2010 at 9:32 PM, Peter Zijlstra<peterz@infradead.org>  wrote:
>>> On Wed, 2010-11-10 at 21:08 +0100, Stephane Eranian wrote:
>>>> Would that be by passing the full filename to the tool?
>>>
>>> possible, or something like<pmu-name>:<event-name>, cpu:cycles would
>>> map to /sys/class/pmu/cpu/events/cycles (given the previous patch).
>>>
>>>
>> Ok, but I think you're proposal is missing one bit. You are addressing
>> the class (or type) of PMU, but you are not addressing the naming of
>> an instance.
>>
>> Let's take an example, suppose you have counters on a graphic card.
>> Your system has two such graphic cards. In your scheme you would
>> end up with a sys/class/pmu/gfx/.....
>>
>> But now, suppose I want to count cycles on the first graphic card.
>> Seems to me you need to expose the instances as well. The instance
>> number needs to be passed in the attr struct somehow.
>>
>> You can either create multiple subdir under gfx, or have this info somewhere
>> else in the sysfs tree, if people really care about class vs. instance.
>>
>> I can see users doing:
>> $ perf stat -e gfx@1::cycles ...  ->  sys/class/gfx/1/event/cycles
>>
>> The reason I am using :: here is because libpfm4 is already using
>> this as a separator for PMU type vs. event.
>
>
> right, so the idea is to have these pmu devices hooked into the existing
> sysfs topology, my proposed patch misses that bit because I wanted to
> get something out before having to dig through the topology code trying
> to figure out how all that works.
>
> So the 'cpu' pmu device would be linked from:
>
>    /sys/devices/system/cpu/pmu ->  /sys/class/pmu/cpu
>
> and gfx things would be linked like:
>
>    /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.0/drm/card0/pmu ->  /sys/class/pmu/radeon0

I don't understand the /sys/devices tree much (I will read up on it), 
but this idea looks good to me.

To clarify my understanding a bit and taking the gfx example, in the 
path /sys/class/pmu/radeon0, is the '0' here denoting the 0'th radeon 
chip in the system, or the radeon model number?  I would assume the 0'th 
chip.

So if I assume that now points to a unique radeon chip in the system, 
underneath /sys/class/pmu/radeon0 will be a structure something like:

radeon0/
	event/
		evt0
		..
		evtn

And if there is a second radeon chip, there would be a nearly identical 
tree:

radeon1/
	event/
		evt0
		..
		evtn

Is that correct?

Some of these events may need modifiers / attributes / umasks... 
whatever you want to call them.  And they may need more than one each, 
and they may vary from event to event.  So to add to the hierarchy,
we'd have:

radeon0/
     type (for attr.type)
     event/
         evt0/
             id (a base number for attr.config)
             description (text file - but could be CONFIG_*'d out)
             modifiers/
                 mod0/
                     formula (some ascii syntax for describing how
                              to set .config and/or .config_extra
                              with this modifer's value)
                     description (text - can configure out)
                     constraints (some ascii syntax for describing
                                  the values mod0 can take on)
                 ..
                 modn/
         ..
	evtn/

And this would be replicated for radeon1..n

Maybe all of the "event" directories could be soft links to a common
radeon<model_number> event directory.

When you fully specify an event, you have something like:

/sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.0/drm/card0/pmu/<event>[:<modifier>=nnn:...]

So it wouldn't end up being strictly a sysfs path anymore, and perf 
would have a bit of parsing work to do, to evaluate the modifiers, using 
the info from constraints, and construct the .type, .config, and 
.config_extra fields using formula.

Or maybe you have some other structure in mind?

- Corey
