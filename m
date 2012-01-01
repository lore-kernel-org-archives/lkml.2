Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2AAMmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 07:42:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2AAMmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 07:42:07 -0500
Message-ID: <4F00547A.9090204@redhat.com>
Date: Sun, 01 Jan 2012 14:41:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        apkm@linux-foundation.org
Subject: Re: [PATCH v4 4/5] slub: Only IPI CPUs that have per cpu obj to flush
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com> <1321960128-15191-5-git-send-email-gilad@benyossef.com> <alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 08:23 AM, Pekka Enberg wrote:
> On Tue, 22 Nov 2011, Gilad Ben-Yossef wrote:
>> static void flush_all(struct kmem_cache *s)
>> {
>> -    on_each_cpu(flush_cpu_slab, s, 1);
>> +    cpumask_var_t cpus;
>> +    struct kmem_cache_cpu *c;
>> +    int cpu;
>> +
>> +    if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>
> __GFP_NOWARN too maybe?
>
>> +        for_each_online_cpu(cpu) {
>> +            c = per_cpu_ptr(s->cpu_slab, cpu);
>> +            if (c->page)
>> +                cpumask_set_cpu(cpu, cpus);
>> +        }
>> +        on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
>> +        free_cpumask_var(cpus);
>> +    } else
>> +        on_each_cpu(flush_cpu_slab, s, 1);
>> }
>

Since this seems to be a common pattern, how about:

   zalloc_cpumask_var_or_all_online_cpus(&cpus, GFTP_ATOMIC);
   ...
   free_cpumask_var(cpus);

The long-named function at the top of the block either returns a newly
allocated zeroed cpumask, or a static cpumask with all online cpus set. 
The code in the middle is only allowed to set bits in the cpumask
(should be the common usage).  free_cpumask_var() needs to check whether
the freed object is the static variable.

-- 
error compiling committee.c: too many arguments to function

