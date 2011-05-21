Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1EUAl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:41:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46808 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1EUAlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fKr23Qvyga1ljjv4TdFJuI5EoRMgaQB2ehGe7auH689qaeh0R0FlO3CG4ITDnSOTFT
         t5ZmyzP51xQvtTXh5HnR32HQEAwLLoFxRXwhfuLT/qE8XkjNZ2NpZdVbvxj2cA8pSlGu
         vYdS7FXO+RfeO7NwZ1cCDRPAs2Vo62YGzW4Nk=
MIME-Version: 1.0
In-Reply-To: <20110520145115.d52f3693.akpm@linux-foundation.org>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124837.72978344.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520145115.d52f3693.akpm@linux-foundation.org>
Date: Sat, 21 May 2011 09:41:50 +0900
Message-ID: <BANLkTinwmtgh+p=aeZux3NuC2ftbR5OMgQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] memcg asyncrhouns reclaim workqueue
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/21 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 20 May 2011 12:48:37 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> workqueue for memory cgroup asynchronous memory shrinker.
>>
>> This patch implements the workqueue of async shrinker routine. each
>> memcg has a work and only one work can be scheduled at the same time.
>>
>> If shrinking memory doesn't goes well, delay will be added to the work.
>>
>
> When this code explodes (as it surely will), users will see large
> amounts of CPU consumption in the work queue thread.  We want to make
> this as easy to debug as possible, so we should try to make the
> workqueue's names mappable back onto their memcg's.  And anything else
> we can think of to help?
>

I had a patch for showing per-memcg reclaim latency stats. It will be help.
I'll add it again to this set. I just dropped it because there are many patches
onto memory.stat in flight..


>>
>> ...
>>
>> +static void mem_cgroup_async_shrink(struct work_struct *work)
>> +{
>> +     struct delayed_work *dw = to_delayed_work(work);
>> +     struct mem_cgroup *mem = container_of(dw,
>> +                     struct mem_cgroup, async_work);
>> +     bool congested = false;
>> +     int delay = 0;
>> +     unsigned long long required, usage, limit, shrink_to;
>
> There's a convention which is favored by some (and ignored by the
> clueless ;)) which says "one definition per line".
>
> The reason I like one-definition-per-line is that it leaves a little
> room on the right where the programmer can explain the role of the
> local.
>
> Another advantage is that one can initialise it.  eg:
>
>        unsigned long limit = res_counter_read_u64(&mem->res, RES_LIMIT);
>
> That conveys useful information: the reader can see what it's
> initialised with and can infer its use.
>
> A third advantage is that it can now be made const, which conveys very
> useful informtation and can prevent bugs.
>
> A fourth advantage is that it makes later patches to this function more
> readable and easier to apply when there are conflicts.
>
ok, I will fix.

>
>> +     limit = res_counter_read_u64(&mem->res, RES_LIMIT);
>> +     shrink_to = limit - MEMCG_ASYNC_MARGIN - PAGE_SIZE;
>> +     usage = res_counter_read_u64(&mem->res, RES_USAGE);
>> +     if (shrink_to <= usage) {
>> +             required = usage - shrink_to;
>> +             required = (required >> PAGE_SHIFT) + 1;
>> +             /*
>> +              * This scans some number of pages and returns that memory
>> +              * reclaim was slow or now. If slow, we add a delay as
>> +              * congestion_wait() in vmscan.c
>> +              */
>> +             congested = mem_cgroup_shrink_static_scan(mem, (long)required);
>> +     }
>> +     if (test_bit(ASYNC_NORESCHED, &mem->async_flags)
>> +         || mem_cgroup_async_should_stop(mem))
>> +             goto finish_scan;
>> +     /* If memory reclaim couldn't go well, add delay */
>> +     if (congested)
>> +             delay = HZ/10;
>
> Another magic number.
>
> If Moore's law holds, we need to reduce this number by 1.4 each year.
> Is this good?
>

not good.  I just used the same magic number now used with wait_iff_congested.
Other than timer, I can use pagein/pageout event counter. If we have
dirty_ratio,
I may able to link this to dirty_ratio and wait until dirty_ratio is enough low.
Or, wake up again hit limit.

Do you have suggestion ?



>> +     queue_delayed_work(memcg_async_shrinker, &mem->async_work, delay);
>> +     return;
>> +finish_scan:
>> +     cgroup_release_and_wakeup_rmdir(&mem->css);
>> +     clear_bit(ASYNC_RUNNING, &mem->async_flags);
>> +     return;
>> +}
>> +
>> +static void run_mem_cgroup_async_shrinker(struct mem_cgroup *mem)
>> +{
>> +     if (test_bit(ASYNC_NORESCHED, &mem->async_flags))
>> +             return;
>
> I can't work out what ASYNC_NORESCHED does.  Is its name well-chosen?
>
how about BLOCK/STOP_ASYNC_RECLAIM ?

>> +     if (test_and_set_bit(ASYNC_RUNNING, &mem->async_flags))
>> +             return;
>> +     cgroup_exclude_rmdir(&mem->css);
>> +     /*
>> +      * start reclaim with small delay. This delay will allow us to do job
>> +      * in batch.
>
> Explain more?
>
yes, or I'll change this logic. I wanted to do low/high watermark
without "low" watermark...

>> +      */
>> +     if (!queue_delayed_work(memcg_async_shrinker, &mem->async_work, 1)) {
>> +             cgroup_release_and_wakeup_rmdir(&mem->css);
>> +             clear_bit(ASYNC_RUNNING, &mem->async_flags);
>> +     }
>> +     return;
>> +}
>> +
>>
>> ...
>>
>

Thank you for review. I realized I need some amount of works. I'll add texts to
explain behavior and make codes simpler.


Thanks,
-Kame
