Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2LLOVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:21:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:56194 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab2LLOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAGjg+kHTvQe4NBTf41oSanZ9WBvFHsRPFqT4MdW9Sft=pOd5HA@mail.gmail.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
	<50C722AC.3080806@intel.com>
	<20121211154819.GC8873@liondog.tnic>
	<50C75935.1040004@linux.intel.com>
	<20121211161320.GA28827@liondog.tnic>
	<50C76208.107@linux.intel.com>
	<CAHLCerPy2+-t0mAwn3nEAd2CRMmyqCLVTO3j2zua1P4uDE1BPA@mail.gmail.com>
	<CAGjg+kHTvQe4NBTf41oSanZ9WBvFHsRPFqT4MdW9Sft=pOd5HA@mail.gmail.com>
Date: Wed, 12 Dec 2012 15:21:20 +0100
Message-ID: <CAKfTPtC+=-zvQ=NyVyDto76SfJY=90e4mrkJ0DGH-_PVpBg3EQ@mail.gmail.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <lkml.alex@gmail.com>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2012 14:55, Alex Shi <lkml.alex@gmail.com> wrote:
>>>>>
>>>>>
>>>>> well... it's not always beneficial to group or to spread out
>>>>> it depends on cache behavior mostly which is best
>>>>
>>>>
>>>> Let me try to understand what this means: so "performance" above with
>>>> 8 threads means that those threads are spread out across more than one
>>>> socket, no?
>>>>
>>>> If so, this would mean that you have a smaller amount of tasks on each
>>>> socket, thus the smaller wattage.
>>>>
>>>> The "powersaving" method OTOH fills up the one socket up to the brim,
>>>> thus the slightly higher consumption due to all threads being occupied.
>>>>
>>>> Is that it?
>>>
>>>
>>> not sure.
>>>
>>> by and large, power efficiency is the same as performance efficiency, with
>>> some twists.
>>> or to reword that to be more clear
>>> if you waste performance due to something that becomes inefficient, you're
>>> wasting power as well.
>>> now, you might have some hardware effects that can then save you power...
>>> but those effects
>>> then first need to overcome the waste from the performance inefficiency...
>>> and that almost never happens.
>>>
>>> for example, if you have two workloads that each fit barely inside the last
>>> level cache...
>>> it's much more efficient to spread these over two sockets... where each has
>>> its own full LLC
>>> to use.
>>> If you'd group these together, both would thrash the cache all the time and
>>> run inefficient --> bad for power.
>>>
>>> now, on the other hand, if you have two threads of a process that share a
>>> bunch of data structures,
>>> and you'd spread these over 2 sockets, you end up bouncing data between the
>>> two sockets a lot,
>>> running inefficient --> bad for power.
>>>
>>
>> Agree with all of the above. However..
>>
>>> having said all this, if you have to tasks that don't have such cache
>>> effects, the most efficient way
>>> of running things will be on 2 hyperthreading halves... it's very hard to
>>> beat the power efficiency of that.
>>
>> .. there are alternatives to hyperthreading. On ARM's big.LITTLE
>> architecture you could simply schedule them on the LITTLE cores. The
>> big cores just can't beat the power efficiency of the LITTLE ones even
>> with 'race to halt' that you allude to below. And usecases like mp3
>> playback simply don't require the kind of performance that the big
>> cores can offer.
>>
>>> But this assumes the tasks don't compete with resources much on the HT
>>> level, and achieve good scaling.
>>> and this still has to compete with "race to halt", because if you're done
>>> quicker, you can put the memory
>>> in self refresh quicker.
>>>
>>> none of this stuff is easy for humans or computer programs to determine
>>> ahead of time... or sometimes even afterwards.
>>> heck, even for just performance it's really really hard already, never mind
>>> adding power.
>>>
>>> my personal gut feeling is that we should just optimize this scheduler stuff
>>> for performance, and that
>>> we're going to be doing quite well on power already if we achieve that.
>>
>> If Linux is to continue to work efficiently on heterogeneous
>> multi-processing platforms, it needs to provide scheduling mechanisms
>> that can be exploited as per the demands of the HW architecture.
>
> Linus definitely disagree such ideas. :) So, need to summaries the
> logical beyond all hardware.
>
>> example is the "small task packing (and spreading)" for which Vincent
>> Guittot has posted a patchset[1] earlier and so has Alex now.
>
> Sure. I just thought my patchset should handled the 'small task
> packing' scenario. Could you guy like to have a try?

Hi Alex,

Yes, I will do a try with your patchset when i will have some spare time

Vincent

>>
>> [1] http://lwn.net/Articles/518834/
