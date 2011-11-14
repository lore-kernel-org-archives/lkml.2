Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1KNNTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 08:19:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58641 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1KNNTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 08:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtvUMe+Um-t3k=VC2Kz4hnOdKYszn9_OG8fa2tp8qK=FLpz0Q@mail.gmail.com>
References: <1321179449-6675-1-git-send-email-gilad@benyossef.com>
	<1321179449-6675-5-git-send-email-gilad@benyossef.com>
	<CAJd=RBC0eTkjF8CSKXv-SK5Zef1G+9x-FUYRBXKmVg6Gbno5gw@mail.gmail.com>
	<CAOtvUMe+Um-t3k=VC2Kz4hnOdKYszn9_OG8fa2tp8qK=FLpz0Q@mail.gmail.com>
Date: Mon, 14 Nov 2011 21:19:11 +0800
Message-ID: <CAJd=RBCkHe14gXBh3GyYyTM8dvvUam_Har5BpUU1WuG9Spd-3g@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] slub: Only IPI CPUs that have per cpu obj to flush
From: Hillf Danton <dhillf@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 10:57 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Sun, Nov 13, 2011 at 2:20 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>
>> On Sun, Nov 13, 2011 at 6:17 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>
> ...
>>
>> > diff --git a/mm/slub.c b/mm/slub.c
>> > index 7d2a996..caf4b3a 100644
>> > --- a/mm/slub.c
>> > +++ b/mm/slub.c
>> > @@ -2006,7 +2006,20 @@ static void flush_cpu_slab(void *d)
>> >
>> >  static void flush_all(struct kmem_cache *s)
>> >  {
>> > -       on_each_cpu(flush_cpu_slab, s, 1);
>> > +       cpumask_var_t cpus;
>> > +       struct kmem_cache_cpu *c;
>> > +       int cpu;
>> > +
>> > +       if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
>>
>> Perhaps, the technique of local_cpu_mask defined in kernel/sched_rt.c
>> could be used to replace the above atomic allocation.
>>
>
> Thank you for taking the time to review my patch :-)
>
> That is indeed the direction I went with inthe previous iteration of
> this patch, with the small change that because of observing that the
> allocation will only actually occurs for CPUMASK_OFFSTACK=y which by
> definition are systems with lots and lots of CPUs and, it is actually
> better to allocate the cpumask per kmem_cache rather then per CPU,
> since on system where it matters we are bound to have more CPUs (e.g.
> 4096) then kmem_caches (~160). See
> https://lkml.org/lkml/2011/10/23/151.
>
> I then went a head and further optimized the code to only incur the
> memory overhead of allocating those cpumasks for CPUMASK_OFFSTACK=y
> systems. See https://lkml.org/lkml/2011/10/23/152.
>
> As you can see from the discussion that evolved, there seems to be an
> agreement that the code complexity overhead involved is simply not
> worth it for what is, unlike sched_rt, a rather esoteric case and one
> where allocation failure is easily dealt with.
>
Even with the introduced overhead of allocation, IPIs could not go down
as much as we wish, right?
