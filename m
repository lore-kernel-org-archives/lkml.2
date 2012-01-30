Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2A3POj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:14:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44174 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2A3POi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:14:38 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120130145900.GR25268@csn.ul.ie>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327572121-13673-8-git-send-email-gilad@benyossef.com>
	<20120130145900.GR25268@csn.ul.ie>
Date: Mon, 30 Jan 2012 17:14:37 +0200
Message-ID: <CAOtvUMcshnvQs4q4ySbtySWv_qHeEnHiD4USBSiOLGFNHSwzUw@mail.gmail.com>
Subject: Re: [v7 7/8] mm: only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 4:59 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Thu, Jan 26, 2012 at 12:02:00PM +0200, Gilad Ben-Yossef wrote:
>> Calculate a cpumask of CPUs with per-cpu pages in any zone
>> and only send an IPI requesting CPUs to drain these pages
>> to the buddy allocator if they actually have pages when
>> asked to flush.
>>
...
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d2186ec..4135983 100644
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
>
> Lets take two CPUs running this code at the same time. CPU 1 has per-cpu
> pages in all zones. CPU 2 has no per-cpu pages in any zone. If both run
> at the same time, CPU 2 can be clearing the mask for CPU 1 before it has
> had a chance to send the IPI. This means we'll miss sending IPIs to CPUs
> that we intended to.

I'm confused. You seem to be assuming that each CPU is looking at its own pcps
only (per zone). Assuming no change in the state of the pcps when both CPUs
run this code at the same time, both of them should mark the bit for
their respective
CPUs the same, unless one of them raced and managed to send the IPI to clear
pcps from the other, at which point you might see one of them send a
spurious IPI
to drains pcps that have been drained - but that isn't bad.

At least, that is what I meant the code to do and what I believe it
does. What have I
missed?

> As I was willing to send no IPI at all;
>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Thank you for the review and the ACK :-)
>
> But if this gets another revision, add a comment saying that two CPUs
> can interfere with each other running at the same time but we don't
> care.
>
>> +     on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
>>  }
>>

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
