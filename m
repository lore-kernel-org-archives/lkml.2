Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1J1IuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:50:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52790 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1J1IuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:50:17 -0400
MIME-Version: 1.0
X-Originating-IP: [89.138.253.16]
In-Reply-To: <alpine.DEB.2.00.1110272257040.14619@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	<1319385413-29665-6-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1110272257040.14619@router.home>
Date: Fri, 28 Oct 2011 10:50:16 +0200
Message-ID: <CAOtvUMd3vWPfPFoLiZ7O1M1Ka1=py0p0Lx_G1PoH4bG2tfAJEQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] slub: Only IPI CPUs that have per cpu obj to flush
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:06 AM, Christoph Lameter <cl@gentwo.org> wrote:
> On Sun, 23 Oct 2011, Gilad Ben-Yossef wrote:
>
>> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
>> index f58d641..b130f61 100644
>> --- a/include/linux/slub_def.h
>> +++ b/include/linux/slub_def.h
>> @@ -102,6 +102,9 @@ struct kmem_cache {
>>        */
>>       int remote_node_defrag_ratio;
>>  #endif
>> +
>> +     /* Which CPUs hold local slabs for this cache. */
>> +     cpumask_var_t cpus_with_slabs;
>>       struct kmem_cache_node *node[MAX_NUMNODES];
>>  };
>
> Please do not add fields to structures for passing parameters to
> functions. This just increases the complexity of the patch and extends a
> structures needlessly.

The field was added to provide storage to cpus_with_slabs during
flush_all, since otherwise cpus_with_slabs, being a cpumask, would
require a kmem_cache allocation in the middle of flush_all  for
CONFIG_CPUMASK_OFF_STACK=y case, which Pekka E. objected to.

The next patch in the series makes the field (and overhead) only added
for  CONFIG_CPUMASK_OFF_STACK=y case but I wanted to break out the
addition to the patch core feature and the optimization of only adding
the field for CONFIG_CPUMASK_OFF_STACK=y, so this patch as is without
the next one is only good for bisect value.

I should have probably have commented about it in the description of
this patch and not only in the next one. Sorry about that. I will fix
it for the next round.

>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 7c54fe8..f8cbf2d 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -1948,7 +1948,18 @@ static void flush_cpu_slab(void *d)
>>
>>  static void flush_all(struct kmem_cache *s)
>>  {
>> -     on_each_cpu(flush_cpu_slab, s, 1);
>> +     struct kmem_cache_cpu *c;
>> +     int cpu;
>> +
>> +     for_each_online_cpu(cpu) {
>> +             c = per_cpu_ptr(s->cpu_slab, cpu);
>> +             if (c && c->page)
>> +                     cpumask_set_cpu(cpu, s->cpus_with_slabs);
>> +             else
>> +                     cpumask_clear_cpu(cpu, s->cpus_with_slabs);
>> +     }
>> +
>> +     on_each_cpu_mask(s->cpus_with_slabs, flush_cpu_slab, s, 1);
>>  }
>
>
> You do not need s->cpus_with_slabs to be in kmem_cache. Make it a local
> variable instead.

That is what the next patch does - for CONFIG_CPUMASK_OFFSTACK=n, alt least.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
