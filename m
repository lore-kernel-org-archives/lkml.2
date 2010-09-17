Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0IQLrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 07:47:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63905 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0IQLrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 07:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AWpPzHH/7/3rdIJiPBGqh/GzcgPOdUW4WTDpXGDmxBkivll88d67dR5IotOyM7HuTZ
         r7aCWQxFcImCthOgkvr+ycOw/e/Hut4Q8lk/192S+LFhfBeT1fCMR6x68lqXF3vNxPQb
         Y2SiY0x5x/hAM3/UH3GLbzudUbS5gBfAs9zPs=
MIME-Version: 1.0
In-Reply-To: <20100916131432.049118bd.akpm@linux-foundation.org>
References: <20100916144618.852b7e9a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100916131432.049118bd.akpm@linux-foundation.org>
Date: Fri, 17 Sep 2010 20:47:36 +0900
Message-ID: <AANLkTinz9=i+wYzBFf0iu_m_C=+t72iiyELoivigxYkH@mail.gmail.com>
Subject: Re: [PATCH][-mm] memcg : memory cgroup cpu hotplug support update.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/17 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 16 Sep 2010 14:46:18 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> This is onto The mm-of-the-moment snapshot 2010-09-15-16-21.
>>
>> ==
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Now, memory cgroup uses for_each_possible_cpu() for percpu stat handling.
>> It's just because cpu hotplug handler doesn't handle them.
>> On the other hand, per-cpu usage counter cache is maintained per cpu and
>> it's cpu hotplug aware.
>>
>> This patch adds a cpu hotplug hanlder and replaces for_each_possible_cpu()
>> with for_each_online_cpu(). And this merges new callbacks with old
>> callbacks.(IOW, memcg has only one cpu-hotplug handler.)
>>
>> For this purpose, mem_cgroup_walk_all() is added.
>>
>> ...
>>
>> @@ -537,7 +540,7 @@ static s64 mem_cgroup_read_stat(struct m
>>       int cpu;
>>       s64 val = 0;
>>
>> -     for_each_possible_cpu(cpu)
>> +     for_each_online_cpu(cpu)
>>               val += per_cpu(mem->stat->count[idx], cpu);
>
> Can someone remind me again why all this code couldn't use
> percpu-counters?
>

The design was based on vmstat[] and some other reasons.
IIUC,  it doesn't has good memory layout when it used as "array".

  spinlock
  counter
  list_head
  percpu pointer

This seems big and not cache friendly to me. I want a memory layout
like vmstat[].
If someone requests, I may able to write a patch of percpu_coutner_array.

And, percpu counter is used with core value + percpu value and does
synchronization
with some thresholds.

memcg's counter is used for 2 purposes as
 - counters #
 - per cpu event counter # don't need any synchronization.

Then, this is as it is now.

>>       return val;
>>  }
>> @@ -700,6 +703,35 @@ static inline bool mem_cgroup_is_root(st
>>       return (mem == root_mem_cgroup);
>>  }
>>
>> +static int mem_cgroup_walk_all(void *data,
>> +             int (*func)(struct mem_cgroup *, void *))
>> +{
>> +     int found, ret, nextid;
>> +     struct cgroup_subsys_state *css;
>> +     struct mem_cgroup *mem;
>> +
>> +     nextid = 1;
>> +     do {
>> +             ret = 0;
>> +             mem = NULL;
>> +
>> +             rcu_read_lock();
>> +             css = css_get_next(&mem_cgroup_subsys, nextid,
>> +                             &root_mem_cgroup->css, &found);
>> +             if (css && css_tryget(css))
>> +                     mem = container_of(css, struct mem_cgroup, css);
>> +             rcu_read_unlock();
>> +
>> +             if (mem) {
>> +                     ret = (*func)(mem, data);
>> +                     css_put(&mem->css);
>> +             }
>> +             nextid = found + 1;
>> +     } while (!ret && css);
>> +
>> +     return ret;
>> +}
>
> It would be better to convert `void *data' to `unsigned cpu' within the
> caller of this function rather than adding the typecast to each
> function which this function calls.  So this becomes
>
> static int mem_cgroup_walk_all(unsigned cpu,
>                int (*func)(struct mem_cgroup *memcg, unsigned cpu))
>

Hmm. As generic function, I may have to add void *data...we already have

 - mem_cgroup_walk_tree() # check hierarchy subtree, not walk all.

This function itself doesn't assume any context of its caller.
(But see below)

>
>> +/*
>> + * CPU Hotplug handling.
>> + */
>> +static int synchronize_move_stat(struct mem_cgroup *mem, void *data)
>> +{
>> +     long cpu = (long)data;
>> +     s64 x = this_cpu_read(mem->stat->count[MEM_CGROUP_ON_MOVE]);
>> +     /* All cpus should have the same value */
>> +     per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) = x;
>> +     return 0;
>> +}
>> +
>> +static int drain_all_percpu(struct mem_cgroup *mem, void *data)
>> +{
>> +     long cpu = (long)(data);
>> +     int i;
>> +     /* Drain data from dying cpu and move to local cpu */
>> +     for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
>> +             s64 data = per_cpu(mem->stat->count[i], cpu);
>> +             per_cpu(mem->stat->count[i], cpu) = 0;
>> +             this_cpu_add(mem->stat->count[i], data);
>> +     }
>> +     /* Reset Move Count */
>> +     per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
>> +     return 0;
>> +}
>
> Some nice comments would be nice.
>
> I don't immediately see anything which guarantees that preemption (and
> cpu migration) are disabled here.  It would be an odd thing to permit
> migration within a cpu-hotplug handler, but where did we guarantee it?

Above code doesn't assume preempt_disable(). Just modify a DEAD cpu's counter.
this_cpu_add() is preempt-safe. I'll add a comment.


> Also, the code appears to assume that the current CPU is the one which
> is being onlined.  What guaranteed that?  This is not the case for
> enable_nonboot_cpus().
>
I thought DEAD cpu is not on scheduler. DEAD notify is done after
cpu_disable().
Hmm, ONLINE handler may have some trouble, I'll write a fix. It's easy.


> It's conventional to put a blank line between end-of-locals and
> start-of-code.  This patch ignored that convention rather a lot.
>
I tend to do that, my mistake.

> The comments in this patch Have Rather Strange Capitalisation Decisions.
>
Ah, sorry.


>> +static int __cpuinit memcg_cpuhotplug_callback(struct notifier_block *nb,
>> +                                     unsigned long action,
>> +                                     void *hcpu)
>> +{
>> +     long cpu = (unsigned long)hcpu;
>> +     struct memcg_stock_pcp *stock;
>> +
>> +     if (action == CPU_ONLINE) {
>> +             mem_cgroup_walk_all((void *)cpu, synchronize_move_stat);
>
> More typecasts which can go away if we make the above change to
> mem_cgroup_walk_all().
>
hmm, I'll rename the function as mem_cgroup_walk_all_cpu().

Thank you for review.
I'll write an update but it may take 3-4days, sorry.

-Kame
