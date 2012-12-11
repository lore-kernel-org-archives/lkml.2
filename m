Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2LKQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:40:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:31023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2LKQkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:40:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="255853318"
Message-ID: <50C76208.107@linux.intel.com>
Date: Tue, 11 Dec 2012 08:40:40 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic> <50C75935.1040004@linux.intel.com> <20121211161320.GA28827@liondog.tnic>
In-Reply-To: <20121211161320.GA28827@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 8:13 AM, Borislav Petkov wrote:
> On Tue, Dec 11, 2012 at 08:03:01AM -0800, Arjan van de Ven wrote:
>> On 12/11/2012 7:48 AM, Borislav Petkov wrote:
>>> On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
>>>> Another testing of parallel compress with pigz on Linus' git tree.
>>>> results show we get much better performance/power with powersaving and
>>>> balance policy:
>>>>
>>>> testing command:
>>>> #pigz -k -c  -p$x -r linux* &> /dev/null
>>>>
>>>> On a NHM EP box
>>>>           powersaving               balance   	         performance
>>>> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
>>>> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
>>>
>>> This looks funny: so "performance" is eating less watts than
>>> "powersaving" and "balance" on NHM. Could it be that the average watts
>>> measurements on NHM are not correct/precise..? On SNB they look as
>>> expected, according to your scheme.
>>
>> well... it's not always beneficial to group or to spread out
>> it depends on cache behavior mostly which is best
>
> Let me try to understand what this means: so "performance" above with
> 8 threads means that those threads are spread out across more than one
> socket, no?
>
> If so, this would mean that you have a smaller amount of tasks on each
> socket, thus the smaller wattage.
>
> The "powersaving" method OTOH fills up the one socket up to the brim,
> thus the slightly higher consumption due to all threads being occupied.
>
> Is that it?

not sure.

by and large, power efficiency is the same as performance efficiency, with some twists.
or to reword that to be more clear
if you waste performance due to something that becomes inefficient, you're wasting power as well.
now, you might have some hardware effects that can then save you power... but those effects
then first need to overcome the waste from the performance inefficiency... and that almost never happens.

for example, if you have two workloads that each fit barely inside the last level cache...
it's much more efficient to spread these over two sockets... where each has its own full LLC
to use.
If you'd group these together, both would thrash the cache all the time and run inefficient --> bad for power.

now, on the other hand, if you have two threads of a process that share a bunch of data structures,
and you'd spread these over 2 sockets, you end up bouncing data between the two sockets a lot,
running inefficient --> bad for power.


having said all this, if you have to tasks that don't have such cache effects, the most efficient way
of running things will be on 2 hyperthreading halves... it's very hard to beat the power efficiency of that.
But this assumes the tasks don't compete with resources much on the HT level, and achieve good scaling.
and this still has to compete with "race to halt", because if you're done quicker, you can put the memory
in self refresh quicker.

none of this stuff is easy for humans or computer programs to determine ahead of time... or sometimes even afterwards.
heck, even for just performance it's really really hard already, never mind adding power.

my personal gut feeling is that we should just optimize this scheduler stuff for performance, and that
we're going to be doing quite well on power already if we achieve that.


