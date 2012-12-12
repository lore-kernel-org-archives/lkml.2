Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2LLJwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:52:55 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56911 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LLJwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <50C76208.107@linux.intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
	<50C722AC.3080806@intel.com>
	<20121211154819.GC8873@liondog.tnic>
	<50C75935.1040004@linux.intel.com>
	<20121211161320.GA28827@liondog.tnic>
	<50C76208.107@linux.intel.com>
Date: Wed, 12 Dec 2012 15:22:51 +0530
X-Google-Sender-Auth: Uq-ys9FBPCtt5SWIRRKw7vF0SBs
Message-ID: <CAHLCerPy2+-t0mAwn3nEAd2CRMmyqCLVTO3j2zua1P4uDE1BPA@mail.gmail.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:10 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On 12/11/2012 8:13 AM, Borislav Petkov wrote:
>>
>> On Tue, Dec 11, 2012 at 08:03:01AM -0800, Arjan van de Ven wrote:
>>>
>>> On 12/11/2012 7:48 AM, Borislav Petkov wrote:
>>>>
>>>> On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
>>>>>
>>>>> Another testing of parallel compress with pigz on Linus' git tree.
>>>>> results show we get much better performance/power with powersaving and
>>>>> balance policy:
>>>>>
>>>>> testing command:
>>>>> #pigz -k -c  -p$x -r linux* &> /dev/null
>>>>>
>>>>> On a NHM EP box
>>>>>           powersaving               balance              performance
>>>>> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103
>>>>> 58
>>>>> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
>>>>
>>>>
>>>> This looks funny: so "performance" is eating less watts than
>>>> "powersaving" and "balance" on NHM. Could it be that the average watts
>>>> measurements on NHM are not correct/precise..? On SNB they look as
>>>> expected, according to your scheme.
>>>
>>>
>>> well... it's not always beneficial to group or to spread out
>>> it depends on cache behavior mostly which is best
>>
>>
>> Let me try to understand what this means: so "performance" above with
>> 8 threads means that those threads are spread out across more than one
>> socket, no?
>>
>> If so, this would mean that you have a smaller amount of tasks on each
>> socket, thus the smaller wattage.
>>
>> The "powersaving" method OTOH fills up the one socket up to the brim,
>> thus the slightly higher consumption due to all threads being occupied.
>>
>> Is that it?
>
>
> not sure.
>
> by and large, power efficiency is the same as performance efficiency, with
> some twists.
> or to reword that to be more clear
> if you waste performance due to something that becomes inefficient, you're
> wasting power as well.
> now, you might have some hardware effects that can then save you power...
> but those effects
> then first need to overcome the waste from the performance inefficiency...
> and that almost never happens.
>
> for example, if you have two workloads that each fit barely inside the last
> level cache...
> it's much more efficient to spread these over two sockets... where each has
> its own full LLC
> to use.
> If you'd group these together, both would thrash the cache all the time and
> run inefficient --> bad for power.
>
> now, on the other hand, if you have two threads of a process that share a
> bunch of data structures,
> and you'd spread these over 2 sockets, you end up bouncing data between the
> two sockets a lot,
> running inefficient --> bad for power.
>

Agree with all of the above. However..

> having said all this, if you have to tasks that don't have such cache
> effects, the most efficient way
> of running things will be on 2 hyperthreading halves... it's very hard to
> beat the power efficiency of that.

.. there are alternatives to hyperthreading. On ARM's big.LITTLE
architecture you could simply schedule them on the LITTLE cores. The
big cores just can't beat the power efficiency of the LITTLE ones even
with 'race to halt' that you allude to below. And usecases like mp3
playback simply don't require the kind of performance that the big
cores can offer.

> But this assumes the tasks don't compete with resources much on the HT
> level, and achieve good scaling.
> and this still has to compete with "race to halt", because if you're done
> quicker, you can put the memory
> in self refresh quicker.
>
> none of this stuff is easy for humans or computer programs to determine
> ahead of time... or sometimes even afterwards.
> heck, even for just performance it's really really hard already, never mind
> adding power.
>
> my personal gut feeling is that we should just optimize this scheduler stuff
> for performance, and that
> we're going to be doing quite well on power already if we achieve that.

If Linux is to continue to work efficiently on heterogeneous
multi-processing platforms, it needs to provide scheduling mechanisms
that can be exploited as per the demands of the HW architecture. An
example is the "small task packing (and spreading)" for which Vincent
Guittot has posted a patchset[1] earlier and so has Alex now.

[1] http://lwn.net/Articles/518834/
