Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1KMIjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 03:39:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60274 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1KMIjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 03:39:40 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1320606618.1428.76.camel@jaguar>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	<1319385413-29665-7-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1110272304020.14619@router.home>
	<CAOtvUMcHOysen7betBOwEJAjL-UVzvBfCf0fzmmBERFrivkOBA@mail.gmail.com>
	<alpine.DEB.2.00.1111020351350.23788@router.home>
	<1320606618.1428.76.camel@jaguar>
Date: Sun, 13 Nov 2011 10:39:39 +0200
Message-ID: <CAOtvUMfcus0Gx3z9XA9EEU-QQuAi4aMp7+_cNEVZzsDmzxLavQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] slub: only preallocate cpus_with_slabs if offstack
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 9:10 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, 28 Oct 2011, Gilad Ben-Yossef wrote:
>> > I think if it is up to me, I recommend going the simpler  route that
>> > does the allocation in flush_all using GFP_ATOMIC for
>> > CPUMASK_OFFSTACK=y and sends an IPI to all CPUs if it fails, because
>> > it is simpler code and in the end I believe it is also correct.
>
> On Wed, 2011-11-02 at 03:52 -0500, Christoph Lameter wrote:
>> I support that. Pekka?
>
> Sure. I'm OK with that. Someone needs to run some tests to make sure
> it's working with low memory conditions when GFP_ATOMIC allocations
> fail, though.

I've just used the fault injection framework (which is really cool by
the way) to inject an
allocation failure for every cpumask alloc in slub.c flush_all in
CONFIG_CPUMASK_OFFSTACK=y kernel and then forced each kmem cache
to flush by reading sys/kernel/slab/*/alloc_calls and everything seems to be
in order. dmesg log shows the fault injection failing the allocation,
I get an extra debug
trace from the cpumask allocation code and the system keeps chugging along.

While at it I did a similar thing for the drain_all_pages of
mm/page_alloc.c (running
a new version of the code from the previous patch) and forced the
drain to be called
by running ./hackbench 1000. Here again I saw log reports of the code
path being
called (from the fault injection framework), allocation failed and
save for the debug
trace the system continued to work fine (the OOm killer has killed by
shell, but that
is to be expected).

Both of the above with the latest spin of the patch I'll send out soon
after some more tests,
so it looks good.

Thanks!
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
