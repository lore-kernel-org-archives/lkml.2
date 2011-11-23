Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1KWG5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:57:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57316 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1KWG5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
	<1321960128-15191-5-git-send-email-gilad@benyossef.com>
	<alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
Date: Wed, 23 Nov 2011 08:57:09 +0200
X-Google-Sender-Auth: FINB8Fx7UEPlU8y_JHXEAc7pUH8
Message-ID: <CAOJsxLFJimmLDev2UjgTYam37zv90gWGnKTPvjKOBre4_Uv81A@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Pekka Enberg <penberg@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
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

On Wed, Nov 23, 2011 at 8:23 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, 22 Nov 2011, Gilad Ben-Yossef wrote:
>>
>> static void flush_all(struct kmem_cache *s)
>> {
>> -       on_each_cpu(flush_cpu_slab, s, 1);
>> +       cpumask_var_t cpus;
>> +       struct kmem_cache_cpu *c;
>> +       int cpu;
>> +
>> +       if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>
> __GFP_NOWARN too maybe?
>
>> +               for_each_online_cpu(cpu) {
>> +                       c = per_cpu_ptr(s->cpu_slab, cpu);
>> +                       if (c->page)
>> +                               cpumask_set_cpu(cpu, cpus);
>> +               }
>> +               on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
>> +               free_cpumask_var(cpus);
>> +       } else
>> +               on_each_cpu(flush_cpu_slab, s, 1);
>> }
>
> Acked-by: Pekka Enberg <penberg@kernel.org>
>
> I can't take the patch because it depends on a new API introduced in the
> first patch.
>
> I'm CC'ing Andrew.

...this time with the right email address.
