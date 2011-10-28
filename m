Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1J1JJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:09:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48435 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1J1JJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:09:53 -0400
MIME-Version: 1.0
X-Originating-IP: [89.138.253.16]
In-Reply-To: <alpine.DEB.2.00.1110272304020.14619@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	<1319385413-29665-7-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1110272304020.14619@router.home>
Date: Fri, 28 Oct 2011 11:09:52 +0200
Message-ID: <CAOtvUMcHOysen7betBOwEJAjL-UVzvBfCf0fzmmBERFrivkOBA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if offstack
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:06 AM, Christoph Lameter <cl@gentwo.org> wrote:
> On Sun, 23 Oct 2011, Gilad Ben-Yossef wrote:
>
>> We need a cpumask to track cpus with per cpu cache pages
>> to know which cpu to whack during flush_all. For
>> CONFIG_CPUMASK_OFFSTACK=n we allocate the mask on stack.
>> For CONFIG_CPUMASK_OFFSTACK=y we don't want to call kmalloc
>> on the flush_all path, so we preallocate per kmem_cache
>> on cache creation and use it in flush_all.
>
> I think the on stack alloc should be the default because we can then avoid
> the field in kmem_cache and the associated logic with managing the field.
> Can we do a GFP_ATOMIC allocation in flush_all()? If the alloc
> fails then you can still fallback to send an IPI to all cpus.


Yes, that was exactly what I did in the first version of this patch
did. See: https://lkml.org/lkml/2011/9/25/32

Pekka E. did not like it because of the allocation out of kmem_cache
in CONFIG_CPUMASK_OFFSTACK=y case in a code path that is supposed to
shrink kmem_caches. I have to say I certainly see his point so I tried
to work around that. On the other hand the overhead code complexity
wise of avoiding that allocation is non trivial.

I tried to give it some more thought -

Since flush_all is called on a kmem_cache basis, to allocate off of
the cpumask kmem_cache while shrinking *another cache* is fine. A
little weird maybe, but fine.

Trouble might lurk if some code path will try to shrink the cpumask
kmem_cache. This can happens if a code path ever tries to either close
the cpumask kmem_cache, which I find very unlikely, or if someone will
try to shrink the cpumask kmem_cache. Right now the only in tree user
I found of kmem_shrink_cache is the acpi code, and even that happens
only for a few specific caches and only during boot. I don't see that
changing.

I think if it is up to me, I recommend going the simpler  route that
does the allocation in flush_all using GFP_ATOMIC for
CPUMASK_OFFSTACK=y and sends an IPI to all CPUs if it fails, because
it is simpler code and in the end I believe it is also correct.

What do you guys think?

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
