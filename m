Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2AHQJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:09:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55758 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2AHQJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:09:04 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120103143417.7cbea589.akpm@linux-foundation.org>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	<1325499859-2262-5-git-send-email-gilad@benyossef.com>
	<20120103143417.7cbea589.akpm@linux-foundation.org>
Date: Sun, 8 Jan 2012 18:09:03 +0200
Message-ID: <CAOtvUMdY3ZST0Pb+tbec1WSfPgOQtAZQtc6ZMs16U5pBriomXA@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] smp: Add func to IPI cpus based on parameter func
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 12:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon,  2 Jan 2012 12:24:15 +0200
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> Add the on_each_cpu_required() function that wraps on_each_cpu_mask()
>> and calculates the cpumask of cpus to IPI by calling a function supplied
>> as a parameter in order to determine whether to IPI each specific cpu.
>
> The name is actually "on_each_cpu_cond".

Oopss... I started out with on_each_cpu_required as a name and switched but
missed the description. Thanks for pointing it out.

<SNIP>

>> + * Call a function on each processor for which the supplied function
>> + * cond_func returns a positive value. This may include the local
>> + * processor, optionally waiting for all the required CPUs to finish.
>> + * The function may be called on all online CPUs without running the
>> + * cond_func function in extreme circumstance (memory allocation
>> + * failure condition when CONFIG_CPUMASK_OFFSTACK=y)
>> + * All the limitations specified in smp_call_function_many apply.
>> + */
>> +void on_each_cpu_cond(int (*cond_func) (int cpu, void *info),
>> +                     void (*func)(void *), void *info, bool wait)
>> +{
>> +     cpumask_var_t cpus;
>> +     int cpu;
>> +
>> +     if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>> +             for_each_online_cpu(cpu)
>> +                     if (cond_func(cpu, info))
>> +                             cpumask_set_cpu(cpu, cpus);
>> +             on_each_cpu_mask(cpus, func, info, wait);
>> +             free_cpumask_var(cpus);
>> +     } else
>> +             on_each_cpu(func, info, wait);
>> +}
>> +EXPORT_SYMBOL(on_each_cpu_cond);
>
> If zalloc_cpumask_var() fails, can we not fall back to
>
>                for_each_online_cpu(cpu)
>                        if (cond_func(cpu, info))
>                                smp_call_function_single(...);
>

Indeed we can and probably should :-)

I'll send out v6 with this and other fixes momentarily.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
