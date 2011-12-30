Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab1L3PZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:25:52 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:45588 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1L3PZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:25:50 -0500
Message-ID: <4EFDD7FA.9000903@tilera.com>
Date: Fri, 30 Dec 2011 10:25:46 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 5/5] mm: Only IPI CPUs to drain local pages if they
 exist
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com> <1321960128-15191-6-git-send-email-gilad@benyossef.com> <20111223102810.GT3487@suse.de> <CAOtvUMd6+ZZVLp-FbbEwbq3UZLRvSRo+_MMYj1aCGT3gBhxMwg@mail.gmail.com> <20111230150421.GE15729@suse.de>
In-Reply-To: <20111230150421.GE15729@suse.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2011 10:04 AM, Mel Gorman wrote:
> On Sun, Dec 25, 2011 at 11:39:59AM +0200, Gilad Ben-Yossef wrote:
>> I think of it more of as a CPU isolation feature then pure performance.
>> If you have a system with a couple of dozens of CPUs (Tilera, SGI, Cavium
>> or the various virtual NUMA folks) you tend to want to break up the system
>> into sets of CPUs that work of separate tasks.
> Even with the CPUs isolated, how often is it the case that many of
> the CPUs have 0 pages on their per-cpu lists? I checked a bunch of
> random machines just there and in every case all CPUs had at least
> one page on their per-cpu list. In other words I believe that in
> many cases the exact same number of IPIs will be used but with the
> additional cost of allocating a cpumask.

Just to chime in here from the Tilera point of view, it is indeed important
to handle the case when all the CPUs have 0 pages in their per-cpu lists,
because it may be that the isolated CPUs are not running kernel code at
all, but instead running very jitter-sensitive user-space code doing direct
MMIO.  So it's worth the effort, in that scenario, to avoid perturbing the
cpus with no per-cpu pages.

And in general, as multi-core continues to scale up, it will be
increasingly worth the effort to avoid doing operations that hit every
single cpu "just in case".

> As a way of mitigating that, I would suggest this is done in two passes.
> The first would check if at least 50% of the CPUs have no pages on their
> per-cpu list. Then and only then allocate the per-cpu mask to limit the
> IPIs. Use a separate patch that counts in /proc/vmstat how many times the
> per-cpu mask was allocated as an approximate measure of how often this
> logic really reduces the number of IPI calls in practice and report that
> number with the patch - i.e. this patch reduces the number of times IPIs
> are globally transmitted by X% for some workload. 

It's really a question of how important it is to avoid the IPIs, even to a
relatively small number of cpus.  If only a few cpus are running
jitter-sensitive code, you may still want to take steps to avoid
interrupting them.  I do think the right strategy is to optimistically try
to allocate the cpumask, and only if it fails, send IPIs to every cpu.

Alternately, since we really don't want more than one cpu running the drain
code anyway, you could imagine using a static cpumask, along with a lock to
serialize attempts to drain all the pages.  (Locking here would be tricky,
since we need to run on_each_cpu with interrupts enabled, but there's
probably some reasonable way to make it work.)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

