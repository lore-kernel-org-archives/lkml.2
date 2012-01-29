Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2A2MSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:18:35 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40235 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2A2MSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:18:33 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120127161236.ff1e7e7e.akpm@linux-foundation.org>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327572121-13673-8-git-send-email-gilad@benyossef.com>
	<20120127161236.ff1e7e7e.akpm@linux-foundation.org>
Date: Sun, 29 Jan 2012 14:18:32 +0200
Message-ID: <CAOtvUMfAd_f=248PTEW6=fqkBxtEB6oahsiqdUC_i2yjfN9m8w@mail.gmail.com>
Subject: Re: [v7 7/8] mm: only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 2:12 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 26 Jan 2012 12:02:00 +0200
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> Calculate a cpumask of CPUs with per-cpu pages in any zone
>> and only send an IPI requesting CPUs to drain these pages
>> to the buddy allocator if they actually have pages when
>> asked to flush.
>>
...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1165,7 +1165,36 @@ void drain_local_pages(void *arg)
>>   */
>>  void drain_all_pages(void)
>>  {
>> -     on_each_cpu(drain_local_pages, NULL, 1);
>> +     int cpu;
>> +     struct per_cpu_pageset *pcp;
>> +     struct zone *zone;
>> +
>> +     /* Allocate in the BSS so we wont require allocation in
>> +      * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
>> +      */
>> +     static cpumask_t cpus_with_pcps;
>> +
>> +     /*
>> +      * We don't care about racing with CPU hotplug event
>> +      * as offline notification will cause the notified
>> +      * cpu to drain that CPU pcps and on_each_cpu_mask
>> +      * disables preemption as part of its processing
>> +      */
>
> hmmm.
>
>> +     for_each_online_cpu(cpu) {
>> +             bool has_pcps = false;
>> +             for_each_populated_zone(zone) {
>> +                     pcp = per_cpu_ptr(zone->pageset, cpu);
>> +                     if (pcp->pcp.count) {
>> +                             has_pcps = true;
>> +                             break;
>> +                     }
>> +             }
>> +             if (has_pcps)
>> +                     cpumask_set_cpu(cpu, &cpus_with_pcps);
>> +             else
>> +                     cpumask_clear_cpu(cpu, &cpus_with_pcps);
>> +     }
>> +     on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
>>  }
>
> Can we end up sending an IPI to a now-unplugged CPU?  That won't work
> very well if that CPU is now sitting on its sysadmin's desk.

Nope. on_each_cpu_mask() disables preemption and calls smp_call_function_many()
which then checks the mask against the cpu_online_mask

> There's also the case of CPU online.  We could end up failing to IPI a
> CPU which now has some percpu pages.  That's not at all serious - 90%
> is good enough in page reclaim.  But this thinking merits a mention in
> the comment.  Or we simply make this code hotplug-safe.

hmm.. I'm probably daft but I don't see how to make the code hotplug safe for
CPU online case. I mean, let's say we disable preemption throughout the
entire ordeal and then the CPU goes online and gets itself some percpu pages
*after* we've calculated the masks, sent the IPIs and waiting for the
whole thing
to finish but before we've returned...

I might be missing something here, but I think that unless you have some other
means to stop newly hotplugged CPUs to grab per cpus pages there is nothing
you can do in this code to stop it. Maybe make the race window
shorter, that's all.

Would adding a comment such as the following OK?

"This code is protected against sending  an IPI to an offline CPU but does not
guarantee sending an IPI to newly hotplugged CPUs"


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
