Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab1KWHwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:52:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65470 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab1KWHws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:52:48 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAOJsxLFJimmLDev2UjgTYam37zv90gWGnKTPvjKOBre4_Uv81A@mail.gmail.com>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-5-git-send-email-gilad@benyossef.com>
	<alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
	<CAOJsxLFJimmLDev2UjgTYam37zv90gWGnKTPvjKOBre4_Uv81A@mail.gmail.com>
Date: Wed, 23 Nov 2011 09:52:47 +0200
Message-ID: <CAOtvUMfYw-QNCq+zXZZrZJaz-i--HSpeH_mdPgN7Bc0Z=u+TjQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 8:57 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Wed, Nov 23, 2011 at 8:23 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> On Tue, 22 Nov 2011, Gilad Ben-Yossef wrote:
>>>
>>> static void flush_all(struct kmem_cache *s)
>>> {
>>> -       on_each_cpu(flush_cpu_slab, s, 1);
>>> +       cpumask_var_t cpus;
>>> +       struct kmem_cache_cpu *c;
>>> +       int cpu;
>>> +
>>> +       if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>>
>> __GFP_NOWARN too maybe?
>>

Right, the allocation failure here is harmless. I should probably do
the same for the page_alloc.c case as well.

>>> +               for_each_online_cpu(cpu) {
>>> +                       c = per_cpu_ptr(s->cpu_slab, cpu);
>>> +                       if (c->page)
>>> +                               cpumask_set_cpu(cpu, cpus);
>>> +               }
>>> +               on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
>>> +               free_cpumask_var(cpus);
>>> +       } else
>>> +               on_each_cpu(flush_cpu_slab, s, 1);
>>> }
>>
>> Acked-by: Pekka Enberg <penberg@kernel.org>
>>
>> I can't take the patch because it depends on a new API introduced in the
>> first patch.
>>
>> I'm CC'ing Andrew.

Thanks!

There's a git tree of these over at: git://github.com/gby/linux.git
branch ipi_noise_v4 in case that helps.

I will send v5 (and create a new git branch for it) with the above
changes and the Arm patch  description update once I get an Ack from
Russel K.

Cheers,
Gilad

>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
