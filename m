Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab0FRIEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab0FRIEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:04:31 -0400
Message-ID: <4C1B2864.6010305@kernel.org>
Date: Fri, 18 Jun 2010 10:03:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<4C18DC69.10704@kernel.org>	<1276698880.9309.44.camel@m0nster>	<4C18E4B7.5040702@kernel.org>	<1276701074.9309.60.camel@m0nster>	<4C18F2B8.9060805@kernel.org>	<1276705838.9309.94.camel@m0nster>	<4C1901E9.2080907@kernel.org> <20100617161539.d4ea62c0.akpm@linux-foundation.org>
In-Reply-To: <20100617161539.d4ea62c0.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 08:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helo,

On 06/18/2010 01:15 AM, Andrew Morton wrote:
> On Wed, 16 Jun 2010 18:55:05 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
>> It was about using wq for cpu intensive / RT stuff.  Linus said,
>>
>>   So stop arguing about irrelevancies. Nobody uses workqueues for RT
>>   or for CPU-intensive crap. It's not what they were designed for, or
>>   used for.
> 
> kernel/padata.c uses workqueues for cpu-intensive work, as I understand
> it.

Replied in the other mail but supporting padata isn't hard and I think
padata is actually the right way to support cpu intensive workload.
wq works as (coneceptually) simple concurrency provider and another
core layer can manage its priority and re-export it as necessary.

> I share Daniel's concerns here.  Being able to set a worker thread's
> priority or policy isn't a crazy thing.

Well, priority itself isn't but doing that from userland is and most
of the conversation was about cmwq taking away the ability to do that
from userland.

> Also one might want to specify that a work item be executed on one
> of a node's CPUs, or within a cpuset's CPUs, maybe other stuff.  I
> have vague feelings that there's already code in the kernel
> somewhere which does some of these things.

There was virtual driver which wanted to use put workers into cpusets.
I'll talk about it below w/ ivtv.

> (Please remind me what your patches did about create_rt_workqueue and
> stop_machine?)

stop_machine was using wq as frontend to threads and repeatedly
creating and destroying them on demand which caused scalability issues
on machines with a lot of cpus.  Scheduler had per-cpu persistent RT
threads which were multiplexed in ad-hoc way to serve other purposes
too.  cpu_stop implements per-cpu persistent RT workers with proper
interface and now both scheduler and stop_machine use them.

> (Please note that drivers/media/video/ivtv/ivtv-irq.c is currently
> running sched_setscheduler() against a workqueue thread of its own
> creation, so we have precedent).

Oooh... missed that.

> If someone wants realtime service for a work item then at present, the
> way to do that is to create your own kernel threads, set their policy
> and start feeding them work items.  That sounds like a sensible
> requirement and implementation to me.  But how does it translate into
> the new implementation?
> 
> The priority/policy logically attaches to the work itself, not to the
> thread which serves it.  So one would want to be able to provide that
> info at queue_work()-time.  Could the workqueue core then find a thread,
> set its policy/priority, schedule it and then let the CPU scheduler do
> its usual thing with it?
> 
> That doesn't sound too bad?  Add policy/priority/etc fields to the
> work_struct?

Yeah, sure, we can do that but I think it would be an over engineering
effort.  Vast majority of use cases use workqueues as simple execution
context provider and work much better with the worker sharing
implemented by cmwq (generally lower latency, much less restrictions).

Cases where special per-thread attribute adjustments are necessary can
be better served in more flexible way by making kthread easier to use.
Priority is one thing but someone wants cpuset affinity, there's no
way to do that with shared workers and it's silly to not share workers
at all for those few exceptions.

ST wq essentially worked as simple thread wrapper and it grew a few of
those usages but they can be counted with one hand in the whole
kernel.  Converting to kthread is usually okay to do but getting the
kthread_stop() and memory barriers right can be pain in the ass, so
having a easier wrapper there would be pretty helpful.

Thanks.

-- 
tejun
