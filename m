Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0HaWGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:06:07 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44538 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab0HaWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:06:06 -0400
Message-ID: <4C7D7CB7.90709@euromail.se>
Date: Wed, 01 Sep 2010 00:05:43 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] HID: magicmouse: remove axis data filtering
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>	 <1283280068-12285-4-git-send-email-chase.douglas@canonical.com>	 <4C7D6739.5000601@euromail.se> <1283288319.2255.103.camel@mini>	 <4C7D6ECB.2000308@euromail.se> <1283289360.2255.113.camel@mini>	 <4C7D71B8.4020408@euromail.se> <1283290078.2255.119.camel@mini>	 <4C7D767C.8040607@euromail.se>  <1283291469.2255.129.camel@mini> <1283291819.2255.134.camel@mini>
In-Reply-To: <1283291819.2255.134.camel@mini>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OqYxe-0007qf-9F.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OqYxe-0007qf-9F 51b9ab611bb7b0b87c7dd7c63afaf638
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 11:56 PM, Chase Douglas wrote:

> On Tue, 2010-08-31 at 17:51 -0400, Chase Douglas wrote:
>> On Tue, 2010-08-31 at 23:39 +0200, Henrik Rydberg wrote:
>>> On 08/31/2010 11:27 PM, Chase Douglas wrote:
>>>
>>>> On Tue, 2010-08-31 at 23:18 +0200, Henrik Rydberg wrote:
>>>>> On 08/31/2010 11:16 PM, Chase Douglas wrote:
>>>>>
>>>>>> On Tue, 2010-08-31 at 23:06 +0200, Henrik Rydberg wrote:
>>>>>>> On 08/31/2010 10:58 PM, Chase Douglas wrote:
>>>>>>>
>>>>>>>> On Tue, 2010-08-31 at 22:34 +0200, Henrik Rydberg wrote:
>>>>>>>>> On 08/31/2010 08:41 PM, Chase Douglas wrote:
>>>>>>>>>
>>>>>>>>>> The Magic Mouse device is very precise. No driver filtering of input
>>>>>>>>>> data needs to be performed.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>>>>>>>>>> Acked-by: Michael Poole <mdpoole@troilus.org>
>>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I am still not sure this is a good idea. Bandwidth from MT devices is a big
>>>>>>>>> deal. A statement roughly how much data comes out of mtdev (which does the
>>>>>>>>> filtering for type A devices) before and after this change would be reassuring.
>>>>>>>>
>>>>>>>> As it is right now, hid-magicmouse doesn't support MT slots. I think all
>>>>>>>> the fuzz code ends up comparing in the MT case is between one touch and
>>>>>>>> another touch, not between one touch's current location and its previous
>>>>>>>> location. If I'm correct, then it means a fuzz > 0 is incorrect for
>>>>>>>> non-slotted MT devices.
>>>>>>>>
>>>>>>>> In fact, the code in drivers/input/input.c around line 194 looks like it
>>>>>>>> discards defuzzing in this case, so one could say this patch is making
>>>>>>>> things more correct :).
>>>>>>>
>>>>>>>
>>>>>>> For type A devices, the filtering is performed in userspace, in mtdev, in the
>>>>>>> same manner as it would have been performed in the kernel in the MT slot case.
>>>>>>> Therefore, knowing the amount of messages coming out of mtdev is a direct
>>>>>>> measurement of the effect of filtering.
>>>>>>
>>>>>> Yes, but we're only interested in the kernel driver when reviewing this
>>>>>> patch. Leaving the fuzz in as it is has no effect right now on ABS_MT_*
>>>>>> axes. On the other axes, such as the touch orientation, it's probably
>>>>>> more harmful than good.
>>>>>
>>>>>
>>>>> "We" are interested in knowing if this patch makes any sense, given that
>>>>> filtering is in actuality performed in userspace, and thus modifying this code
>>>>> changes the stream rate into userspace applications, thank you.
>>>>
>>>> Because in-kernel defuzzing is turned off for ABS_MT_* axes on
>>>> non-slotted MT devices, there will be no change in the number of events
>>>> sent to the userspace due to this patch.
>>>>
>>>> Maybe I'm missing something more fundamental. In which case, I'll need
>>>> more details to get it through my dense skull :).
>>>
>>>
>>> All events passes through to mtdev, yes, but mtdev filters a considerable amount
>>> of events from passing through to X drivers like evdev. Thus, the fuzz values
>>> reported in the kernel driver impacts the performance in userspace, even if
>>> filtering is not done in the kernel.
>>
>> My disconnect was that I didn't understand that the fuzz value in the
>> kernel is exported to userspace. I thought the defuzzing in mtdev was
>> independent of the defuzzing in the kernel.
>>
>> Basically, I don't feel I have the time to do the analysis you want
>> right now. If you really want, I can just remove this change.
> 
> On second thought, if there's no jitter from the device, the only reason
> to filter is to save bandwidth. The magicmouse devices are very verbose
> strictly because they have a higher resolution than most devices. If
> that's an issue for userspace, then the filtering should be based on the
> resolution. In fact, I see that's what you do in mtdev when the
> in-kernel fuzz is 0.
> 
> This separates the kernel fuzz into a removal of jitter, and the mtdev
> fuzz into a dampening of the number of events passed to clients. Since
> magicmouse devices have no discernable jitter, shouldn't we set the
> in-kernel fuzz to 0 and let mtdev do its thing as appropriate?


Per-driver data is more precise than a generic value for all devices. This
thread has documented the details of why there is an interest in the fuzz
values. Skipping the patch until MT slots are implemented or measurements can be
done might be the most sensible thing to do.

Thanks,
Henrik
