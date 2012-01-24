Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2AXQJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:09:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab2AXQJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:09:15 -0500
Message-ID: <4F1ED77F.4090900@redhat.com>
Date: Tue, 24 Jan 2012 18:08:31 +0200
From: Ronen Hod <rhod@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: leonid.moiseichuk@nokia.com, penberg@kernel.org, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
References: <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com> <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com> <4F175706.8000808@redhat.com> <alpine.LFD.2.02.1201190922390.3033@tux.localdomain> <4F17DCED.4020908@redhat.com> <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com> <4F17E058.8020008@redhat.com> <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com> <20120124153835.GA10990@amt.cnet>
In-Reply-To: <20120124153835.GA10990@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 05:38 PM, Marcelo Tosatti wrote:
> On Thu, Jan 19, 2012 at 10:53:29AM +0000, leonid.moiseichuk@nokia.com wrote:
>>> -----Original Message-----
>>> From: ext Ronen Hod [mailto:rhod@redhat.com]
>>> Sent: 19 January, 2012 11:20
>>> To: Pekka Enberg
>> ...
>>>>>> Isn't
>>>>>>
>>>>>> /proc/sys/vm/min_free_kbytes
>>>>>>
>>>>>> pretty much just that?
>>>>> Would you suggest to use min_free_kbytes as the threshold for sending
>>>>> low_memory_notifications to applications, and separately as a target
>>>>> value for the applications' memory giveaway?
>>>> I'm not saying that the kernel should use it directly but it seems
>>>> like the kind of "ideal number of free pages" threshold you're
>>>> suggesting. So userspace can read that value and use it as the "number
>>>> of free pages" threshold for VM events, no?
>>> Yes, I like it. The rules of the game are simple and consistent all over, be it the
>>> alert threshold, voluntary poling by the apps, and for concurrent work by
>>> several applications.
>>> Well, as long as it provides a good indication for low_mem_pressure.
>> For me it doesn't look that have much sense. min_free_kbytes could be set from user-space (or auto-tuned by kernel) to keep some amount
>> of memory available for GFP_ATOMIC allocations.  In case situation comes under pointed level kernel will reclaim memory from e.g. caches.
>>
>> > From potential user point of view the proposed API has number of lacks which would be nice to have implemented:
>> 1. rename this API from low_mem_pressure to something more related to notification and memory situation in system: memory_pressure, memnotify, memory_level etc. The word "low" is misleading here
>> 2. API must use deferred timers to prevent use-time impact. Deferred timer will be triggered only in case HW event or non-deferrable timer, so if device sleeps timer might be skipped and that is what expected for user-space
> Having userspace specify the "sample period" for low memory notification
> makes no sense. The frequency of notifications is a function of the
> memory pressure.
>
>> 3. API should be tunable for propagate changes when level is Up or Down, maybe both ways.
>
>> 4. to avoid triggering too much events probably has sense to filter according to amount of change but that is optional. If subscriber set timer to 1s the amount of events should not be very big.
>> 5. API must provide interface to request parameters e.g. available swap or free memory just to have some base.
> It would make the interface easier to use if it provided the number of
> pages to free, in the notification (kernel can calculate that as the
> delta between current_free_pages ->  comfortable_free_pages relative to
> process RSS).

If you rely on the notification's argument you lose several features:
  - Handling of notifications by several applications in parallel
  - Voluntary application's decisions, such as cleanup or avoiding allocations, at the application's convenience.
  - Iterative release loops, until there are enough free pages.
I believe that the notification should only serve as a trigger to run the cleanup.

Ronen.

>
>> 6. I do not understand how work with attributes performed ( ) but it has sense to use mask and fill requested attributes using mask and callback table i.e. if free pages requested - they are reported, otherwise not.
>> 7. would have sense to backport couple of attributes from memnotify.c
>>
>> I can submit couple of patches if some of proposals looks sane for everyone.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

