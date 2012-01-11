Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab2AKHEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:04:30 -0500
Received: from mail4.comsite.net ([205.238.176.238]:27328 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2AKHEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:04:24 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.21.127.101;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v6 5/8] slub: only IPI CPUs that have per cpu obj to flush
In-Reply-To: <1326040026-7285-6-git-send-email-gilad@benyossef.com>
References: <1326040026-7285-6-git-send-email-gilad@benyossef.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux.com>, "Michal Nazarewicz" <mina86@mina86.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Date: Wed, 11 Jan 2012 01:04:13 -0600
X-Originating-IP: 71.21.127.101
Message-ID: <1326265453_1662@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun Jan 08 2012 about 11:28:11 EST, Gilad Ben-Yossef wrote:
> flush_all() is called for each kmem_cahce_destroy(). So every cache
> being destroyed dynamically ended up sending an IPI to each CPU in the

ends up

> system, regardless if the cache has ever been used there.
> 
> For example, if you close the Infinband ipath driver char device file,
> the close file ops calls kmem_cache_destroy(). So running some
> infiniband config tool on one a single CPU dedicated to system tasks
> might interrupt the rest of the 127 CPUs I dedicated to some CPU

127 CPUs dedicated

> intensive task.

CPU intensive or latency sensitive task.


> 
> I suspect there is a good chance that every line in the output of "git
> grep kmem_cache_destroy linux/ | grep '\->'" has a similar scenario.
> 
> This patch attempts to rectify this issue by sending an IPI to flush
> the per cpu objects back to the free lists only to CPUs that seems to
> have such objects.

that seem to have

> 
> The check which CPU to IPI is racy but we don't care since asking a
> CPU without per cpu objects to flush does no damage and as far as I
> can tell the flush_all by itself is racy against allocs on remote
> CPUs anyway, so if you meant the flush_all to be determinstic, you

required (vs meant)

> had to arrange for locking regardless.
> 
> Without this patch the following artificial test case:
> 
> $ cd /sys/kernel/slab
> $ for DIR in *; do cat $DIR/alloc_calls > /dev/null; done
> 
> produces 166 IPIs on an cpuset isolated CPU. With it it produces none.
> 
> The code path of memory allocation failure for CPUMASK_OFFSTACK=y
> config was tested using fault injection framework.
> 
..
> mm/slub.c | 10 +++++++++-
> 1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 09ccee8..31833d6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2013,9 +2013,17 @@ static void flush_cpu_slab(void *d)
> __flush_cpu_slab(s, smp_processor_id());
> }
> 
> +static int has_cpu_slab(int cpu, void *info)
> +{
> + struct kmem_cache *s = info;
> + struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> +
> + return !!(c->page);

__flush_cpu_slab is careful to test that the the per_cpu_ptr is not
NULL before referencing the page field.  free_percpu likewise ignores
NULL pointers.  We need to check !!(c && c->page) here.


[change int to bool assuming you make the change in the other patch].

> +}
> +
> static void flush_all(struct kmem_cache *s)
> {
> - on_each_cpu(flush_cpu_slab, s, 1);
> + on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1);
> }

milton
