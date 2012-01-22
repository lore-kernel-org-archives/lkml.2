Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab2AVJ7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 04:59:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44873 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2AVJ7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 04:59:45 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <1326265454_1663@mail4.comsite.net>
References: <1326040026-7285-7-git-send-email-gilad@benyossef.com>
	<1326265454_1663@mail4.comsite.net>
Date: Sun, 22 Jan 2012 11:59:44 +0200
Message-ID: <CAOtvUMd4iXTEcmcdW5hpZ+mWbWExvbgzVbz0Zv0TgSiaT9X6QA@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] fs: only send IPI to invalidate LRU BH when needed
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:04 AM, Milton Miller <miltonm@bga.com> wrote:
> On Sun Jan 08 2012 about 11:28:17 EST, Gilad Ben-Yossef wrote:

>
>> +
>> +static int local_bh_lru_avail(int cpu, void *dummy)
>> +{
>
> This is not about the availibilty of the lru, but rather the
> decision if it is empty.  How about has_bh_in_lru() ?

Right. Good point.

>
>> + struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
>> + int i;
>>
>> + for (i = 0; i < BH_LRU_SIZE; i++) {
>> + if (b->bhs[i])
>> + return 1;
>> + }
>
>
> If we change the loop in invalidate_bh to be end to beginning, then we
> could get by only checking b->bhs[0] instead of all BH_LRU_SIZE words.
> (The other loops all start by having entry 0 as a valid entry and pushing
> towards higher slots as they age.)  We might say we don't care, but I
> think we need to know if another cpu is still invalidating in case it
> gets stuck in brelse, we need to wait for all the invalidates to occur
> before we can continue to kill the device.

hmm... less cycles for the check and less cache lines to pull from all
the CPUs is certainly better, but I'm guessing walking backwards on
the bh_lru array is less cache friendly then doing it in the straight up
way because of data cache  prediction logic.  Which one has a bigger
impact? I'm not really sure.

I do think it's a little bit more complicated then the current dead simple
approach.

I don't really mind making the change but those invalidates are rare. The rest
of logic in the bh lru management is "dopey-but-simple" (so says the comment
 so my gut feeling is that its better to have simple code even if possibly less
optimized in this code path.

> The other question is locking, what covers the window from getting
> the bh until it is installed if the lru was empty?  It looks like
> it could be a large hole, but I'm not sure it wasn't there before.
> By when do we need them freed?  The locking seems to be irq-disable
> for smp and preempt-disable for up, can we use an RCU grace period?

Good question. As you realized already the only case where we race
is when going from empty list to having a single item. We'll send an IPI
in all other cases.

The way I see it, with the current code if you were about
to install a new bh lru and you got hit with the invalidating IPI
before you disabled
preemption/interrupts, you have the same race, and you also have the same
race if you got the invalidate IPI, cleaned everything up and then someone calls
to install a bh in the LRU, since there is nothing stopping you from
installing an LRU bh after the invalidate.

So, if the callers to the invalidate path care about this, they must somehow
make sure whatever type of BHs (belong to a specific device or fs) they are
interested in getting  off the LRU are never being added (on any CPU) after the
point they call the invalidate or they are broken already. Again, this
is all true
for the current code to the best of my understanding.

My code doesn't change that. It does make the race window slightly bigger by
a couple of instructions, though so it might expose subtle bugs we had
all along.
I can't really tell if it's a good or bad thing :-)

> There seem to be more on_each_cpu calls in the bdev invalidate
> so we need more patches, although each round trip though ipi
> takes time; we could also consider if they take time.


Sure, I plan to get to all of them in the end (and also all the work
queue variants)
and at least look at them, but I prefer to tackle the low hanging fruits first.

I maintain a rough TODO list of those I intend to visit and status here:
 https://github.com/gby/linux/wiki

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
