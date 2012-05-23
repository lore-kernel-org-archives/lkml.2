Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2EWLc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:32:58 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49226 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2EWLc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:32:56 -0400
Message-ID: <4FBCCAE2.7080706@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 13:32:50 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com> <1337677268.9698.6.camel@twins>
In-Reply-To: <1337677268.9698.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12052311-2966-0000-0000-0000042B44AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/22/2012 11:01 AM, Peter Zijlstra wrote:
> On Mon, 2012-05-21 at 17:45 +0200, Martin Schwidefsky wrote:
>> our performance team found a performance degradation with a recent
>> distribution update in regard to fair sleepers (or the lack of fair
>> sleepers). On s390 we used to run with fair sleepers disabled.
>
> This change was made a very long time ago.. tell your people to mind
> what upstream does if they want us to mind them.

Your're completely right, but we do mind - and we have reasons for that. 
I'll try to explain why.
Upstream often has so many changes that some effects end up hidden 
behind each others. A lot of issues are detected and fixed there, but 
due to restricted resources not all of them. Also every new developed 
features goes through test. Distribution releases are the 3rd stage of 
testing before something is available for a customer.

The analysis of the features in general and fair sleepers among them 
started by a teammate long ago. More precisely, a bit before the time we 
both agreed about the related 
http://comments.gmane.org/gmane.linux.kernel/920457, so I'd say in time. 
It re-occurred every distribution release since then, but so far without 
a real fix.

Then in early 2010 the removal of the fair sleepers tunable took place, 
but - and here I admit our fault - this didn't increase pressure for a 
long time as both major distributions where at 2.6.32 back then and 
stayed there for a long time.

Eventually we also had a revert of that patch in both major 
distributions for the last few service updates that backported this 
patch. All that hoping that we finally identify and avoid needing that 
revert upstream.
All that causes a lot of discussions every distribution release.

I hope all that relativizes your feeling of "a long time"

But currently a fix seems out of reach solving things so that we can 
live with fair sleepers (without being able to turn it off in case it is 
needed).


> Also, reports like this make me want to make /debug/sched_features a
> patch in tip/out-of-tree so that its never available outside
> development.

Sorry if we offended you in any way, that was not our intention at all. 
But I guess keeping the tunables available is the only way to properly 
test them for all the myriad of hardware/workload combinations out there 
- and by far not all things can be reliably tested out-of-tree.

>> We see the performance degradation with our network benchmark and fair
>> sleepers enabled, the largest hit is on virtual connections:
>>
>> VM guest Hipersockets
>>     Throughput degrades up to 18%
>>     CPU load/cost increase up to 17%
>> VM stream
>>     Throughput degrades up to 15%
>>     CPU load/cost increase up to 22%
>> LPAR Hipersockets
>>     Throughput degrades up to 27%
>>     CPU load/cost increase up to 20%
>
> Why is this, is this some weird interaction with your hypervisor?

It is not completely analyzed, as soon as debugging goes out of Linux it 
can be kind of complex even internally.

On top of these network degradations we also have issues with database 
latencies even when not using virtual network connections. But for these 
I didn't have such summarized numbers at hand when I searched for 
workload data. As rule of thumb the worst case latency can grow up to x3 
if fair sleepers is on. It felt a bit like the old throughput vs 
worst-case latency trade-off - eventually people might want to decide on 
their own between the two.


>> In short, we want the fair sleepers tunable back. I understand that on
>> x86 we want to avoid the cost of a branch on the hot path in place_entity,
>> therefore add a compile time config option for the fair sleeper control.
>
> I'm very much not liking this... this makes s390 schedule completely
> different from all the other architectures.

I don't even "like" it myself - If I could make wishes I would like the 
50% of gentle sleepers working fine, but unfortunately they aren't. 
Liking it or not - for the moment this is the only way we can avoid 
several severe degradations. And I'm not even sure if some others just 
didn't realize yet or refused to ask loud enough for it.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

