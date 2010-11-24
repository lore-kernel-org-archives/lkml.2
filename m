Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab0KXOCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:02:35 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60633 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0KXOCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:02:34 -0500
MIME-Version: 1.0
In-Reply-To: <1290529171.2390.7994.camel@nimitz>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
Date: Wed, 24 Nov 2010 15:02:32 +0100
Message-ID: <AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: =?UTF-8?Q?Peter_Sch=C3=BCller?= <scode@spotify.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first of all, thank you very much for taking the time to analyze the situation!

> Yeah, drop_caches doesn't seem very likely.
>
> Your postgres data looks the cleanest and is probably the easiest to
> analyze.  Might as well start there:
>
>        http://files.spotify.com/memcut/postgresql_weekly.png

Since you wanted to look at that primarily I re-visited that
particular case to confirm what was really happening. Unfortunately I
have to retract my claim here, because it turns out that we have
backups running locally on the machine before shipping them away, and
it seems that indeed the cache evictions on that machine are
correlated with the removal of said backup after it was shipped away
(and testing confirms the behavior).

Of course that is entirely expected (that removal of a recently
written file will cause a sudden spike in free memory) so the
PostgreSQL graph is a red herring.

This was unfortunate, and a result of me picking this guy fairly
ad-hoc for the purpose of summarizing the situation in my post to the
list. We have spent considerable time trying to make sure that the
evictions are indeed anomalous and not e.g. due to a file removal in
the case of the actual service where we are negatively affected, but I
was not sufficiently careful before proclaiming that we seem to see a
similar effects on other hosts.

It may still be the case, but I am not finding a case which is
sufficiently clear at this time (being sure requires really looking at
what is going on with each class of machine and eliminating various
forms of backups, log rotation and other behavior exhibited). This
also means that in general it's not certain that we are in fact seeing
this behavior on others at all.

However it does leave all other observations, including the very
direct correlation in time with load spikes and a lack of correlation
with backups jobs, and the fact that the eviction seems to be of
actively used data given the resulting I/O storm. So I feel confident
in saying that we definitely do have an actual issue (although as
previously indicated we have not proven conclusively that there is
absolutely no userspace application allocating and touching lots of
pages suddenly, but it seems very unlikely).

> Just eyeballing it, _most_ of the evictions seem to happen after some
> movement in the active/inactive lists.  We see an "inactive" uptick as
> we start to launder pages, and the page activation doesn't keep up with
> it.  This is a _bit_ weird since we don't see any slab cache or other
> users coming to fill the new space.  Something _wanted_ the memory, so
> why isn't it being used?

In this case we have the writing of a backup file (with corresponding
page touching for reading data). This is followed by a period of
reading the recently written file, followed by it being removed.

> Do you have any large page (hugetlbfs) or other multi-order (> 1 page)
> allocations happening in the kernel?

No; we're not using huge pages at all (not consciously). Looking at
/proc/meminfo I can confirm that we just see this:

HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB

So hopefully that should not be a factor.

> If you could start recording /proc/{vmstat,buddystat,meminfo,slabinfo},
> it would be immensely useful.  The munin graphs are really great, but
> they don't have the detail which you can get from stuff like vmstat.

Absolutely. I'll get some recording of those going and run for
sufficient duration to correlate with page evictions.

> For a page-cache-heavy workload where you care a lot more about things
> being _in_ cache rather than having good NUMA locality, you probably
> want "zone_reclaim_mode" set to 0:
>
>        http://www.kernel.org/doc/Documentation/sysctl/vm.txt
>
> That'll be a bit more comprehensive than messing with numactl.  It
> really is the best thing if you just don't care about NUMA latencies all
> that much.

Thanks! That looks to be exactly what we would like in this case and,
if Interpret you and the documentation correctly, obviates the need to
ask for interleaved allocation.

>  What kind of hardware is this, btw?

It varies somewhat in age, but all of them are Intel. The oldest ones
have 16 GB of memory and are of this CPU type:

cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           L5420  @ 2.50GHz
stepping	: 6
cpu MHz		: 2494.168
cache size	: 6144 KB

While newer ones have ~36 GB memory and are of this CPU type:

cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           E5504  @ 2.00GHz
stepping	: 5
cpu MHz		: 2000.049
cache size	: 4096 KB

Some variation beyond that may exist, but that is the span (and all
are Intel, 8 cores or more).

numactl --show on older machines:

policy: default
preferred node: current
physcpubind: 0 1 2 3 4 5 6 7
cpubind: 0
nodebind: 0
membind: 0

And on newer machines:

policy: default
preferred node: current
physcpubind: 0 1 2 3 4 5 6 7
cpubind: 0 1
nodebind: 0 1
membind: 0 1

-- 
/ Peter Schuller aka scode
