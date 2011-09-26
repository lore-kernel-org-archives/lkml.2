Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1IZIfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:35:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37173 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1IZIfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:35:23 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1317022420.9084.57.camel@twins>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<1316940890-24138-6-git-send-email-gilad@benyossef.com>
	<1317022420.9084.57.camel@twins>
Date: Mon, 26 Sep 2011 11:35:21 +0300
Message-ID: <CAOtvUMeMsd0Jk1k4wP9Y+7NW3FYZZAqV1-cRj5Zt4+eaugWoPg@mail.gmail.com>
Subject: Re: [PATCH 5/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:33 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
>> +       if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>> +               for_each_online_cpu(cpu) {
>> +                       c = per_cpu_ptr(s->cpu_slab, cpu);
>> +                       if (c && c->page)
>> +                               cpumask_set_cpu(cpu, cpus);
>> +               }
>> +               on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
>> +               free_cpumask_var(cpus);
>
> Right, having to do that for_each_oneline_cpu() loop only to then IPI
> them can cause a massive cacheline bounce fest.. Ideally you'd want to
> keep a cpumask per kmem_cache, although I bet the memory overhead of
> that isn't attractive.
>
> Also, what Pekka says, having that alloc here isn't good either.

Yes, the alloc in the flush_all path definitively needs to go. I
wonder if just to resolve that allocating the mask per cpu and not in
kmem_cache itself is not better - after all, all we need is a single
mask per cpu when we wish to do a flush_all and no per cache. The
memory overhead of that is slightly better. This doesn't cover the
cahce bounce issue.

My thoughts regarding that were that since the flush_all() was a
rather rare operation it is preferable to do some more
work/interference here, if it allows us to avoid having to do more
work in the hotter alloc/dealloc paths, especially since it allows us
to have less IPIs that I figured are more intrusive then cacheline
steals (are they?)

After all, for each CPU that actually needs to do a flush, we are
making the flush a bit more expensive because of the cache bounce just
before we send the IPI, but that IPI and further operations are an
expensive operations anyway. For CPUs that don't need to do a flush, I
replaced an IPI for a cacheline(s) steal. I figured it was still a
good bargain

I will spin a new patch that moves this to kmem_cache if you believe
this is the right way to go.

Thanks!
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
