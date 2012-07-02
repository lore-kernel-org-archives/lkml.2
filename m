Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2GBRVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:21:18 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:53957 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2GBRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:21:15 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Chinmay V S <cvs268@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
Date: Mon, 02 Jul 2012 20:21:10 +0300
Message-ID: <2779342.rcjlfQh1rr@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-26-generic; KDE/4.8.3; i686; ; )
In-Reply-To: <CAK-9PRCb1jJdejvim48LP7GN6jHKDdkKVx-UY1Gpsbx1ROyQvQ@mail.gmail.com>
References: <2325453.OX7ktP55U1@vlad> <6810708.ZQq4lbXqoi@vlad> <CAK-9PRCb1jJdejvim48LP7GN6jHKDdkKVx-UY1Gpsbx1ROyQvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 21:30:04 Chinmay V S wrote:
> >On Sunday 01 July 2012 17:24:34 Chinmay V S wrote:
> >> Played around with __read_mostly some time back in an attempt to optimise
> >> cache usage.
> >> thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.htm
> >> l
> >
> >Nice article!
> 
> Thank you! :)
> 
> >U see, if we assume that __read_mostly the way it's currently implemented
> >is a bad thing (due to the fact that it implicitly causes the bunching of
> >the write-mostly variables) than this means that "const" the way it's
> >currently implemented is a bad thing too due to the same reasons. ;)
> 
> Every individual instance of __read_mostly may NOT degrade performance.
> What *will* degrade the performance is "excessive" use of __read_mostly.
> An interesting discussion on similar lines here[2].
> 
> >This is an interesting idea however there is (at least) one weakness in it
> >- it assumes that linker's heuristics (those that will pack cons and
> >non-const variables together in a single cache line) will do a better job
> >than a person that writes a specific code section and knows the exact
> >nature and the relationship between variables in his/her C code.
> 
> True.
> 
> >First of all, let me note that saying that C code performance may benefit
> >from NOT using the __read_mostly variables is a bit misleading because
> >here u rely on something that is not deterministic: a linker decision to
> >pack one (often written) variable together with another (read mostly)
> >variable in a single cache line boundaries (thus improving the
> >performance); and this decision may change due to a minor code change and
> >u will not know about it.
> 
> I totally agree that avoiding use of __read_mostly does NOT guarantee any
> performance boost. The point i am trying to make is this:
> 
> 1. Consider a code with NO instances of __read_mostly.
> 
> 2. Now we go ahead and add __read_mostly to an object.
> Note that we are NOT guaranteed that this object is "hot" i.e. accessed
> frequently. All that __read_mostly signifies is that the object is rarely
> written to i.e. most of the time it is accessed, it is a read operation.
> 
> Cost-Benefit analysis:
> Currently each CPU keeps its own copy of the __read_mostly(variable) in the
> per-cpu L1 cache(any benefits on non-SMP systems?). 

I think it's clear that the whole __read_mostly infrastructure targets the SMP 
platforms. I suppose __read_mostly should be defined to nothing for non-SMP 
kernels. I think Eric already suggested that somewhere on [2] thread.

> As the variable is
> rarely written to, rarely do we need to sync it across multiple L1 caches
> i.e. cacheline-bouncing is very rare.
> So the cost is very less.
> 
> As the variable is maintained in L1 cache, rather than being shared across
> multiple CPUs in L2 or L3 cache, the access is an order of magnitude faster.
> Hence the benefit is very high.
> 
> 3. We continue adding __read_mostly to other genuine read-mostly objects.
> 
> As we continue to increase the number of __read_mostly objects, they get
> moved from bss to .data.read_mostly section. This IMHO, increase the
> chances (as compared to earlier without __read_mostly) that 2 objects in
> the bss compete for the same cache-line. But this is NOT directly evident
> as modern cpu-caches are N-way associative i.e .each object has a choice of
> N different cache-slots. This tends to intially hide the effect of
> __read_mostly. (This is the point i make in my article[1]).
> 
> After a few iterations of adding __read_mostly, (if) the cache contention
> increases to more than N objects competing for the same cache-slot. False
> cache-line sharing occurs i.e. 2 or more objects continue to replace
> one another from the cache-slot alternatively. i.e cache-thrashing begins.

I think your point is clear and has actually been nicely stated at 
thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.htm (by 
u? :))

In the previous e-mail I tried to explain that a root-cause of the problem are 
describing above is not a __read_mostly infrastructure but a bad C code these 
2 variables a used at. The code that doesn't handle the SMP case properly. The 
code that should be fixed. For instance by defining these two frequently used 
variables as __cache_aligned, which would separate them to different cache 
lines. 

Also note that in your reasoning above u are talking about the chances, which 
in particular means that the problem u have described may happen even without 
the usage of __read_mostly qualifiers - simply because the code is bad. What 
I'm proposing is to fix the code that leads to performance degradation and 
this will resolve the problem for good. For good - is very deterministic... ;)

> 
> Note that false cache-line sharing is NOT a one time cost. Cache thrashing
> will continue to happen until the context changes sufficiently for one of
> the cache-slots to free-up. Hence this scenario must be avoided at all
> costs.
> >I agree that there might be a few places in kernel that suffer from the
> >weakness described above. That's why it's important to add __read_mostly in
> >small portions (even one by one) in order to ease the bisect if and when
> >the performance regression occurs.
> 
> Exactly! So we can conclude that "excessive" use of __read_mostly must be
> avoided. "Excessive" varies from system to system based on:
> - Degree of SMP (no.of cores).
> - Levels of cache (and penalties associated between successive levels).
> - Associativity of caches.

The fact that this sort of problems in the code is hard to catch is by itself 
very disturbing and IMHO we should praise anything that helps us to find such 
points in the code. 

What I'm trying to say is that although your reasoning and understanding the 
problem is absolutely correct but the conclusions u jump to are very different 
from those of mine. 

U say: we should be careful (because there is a problematic code with 
frequently written variables) and avoid the excessive usage of __read_mostly 
qualifiers.
I say: we shell go and add __read_mostly where ever we see objects with this 
sort of nature but we shell add them one-by-one in order to be able to find 
the specific variable which was responsible for the degradation in performance 
once it occurs and then find the frequently written objects that were actually 
harmed and fix them appropriately.

> 
> Without proper understanding of these params, __read_mostly with be a
> "mostly" hit-n-miss affair. In fact a quick grep shows ~1300 __read_mostly 
> scattered around the kernel code(3.4-rc1) which on certain systems is
> already detrimental. Certain architectures(eg-ARM) completely disable
> __read_mostly as its evident by their 2-way associative cache that
> cache-thrashing will occur so quickly that it voids any potential
> performance gains.

Again, I disagree with your perception of the problem: we shell say "Thank u!" 
to the one who has invented __read_mostly because it helps us to clean up our 
code!.. ;) Especially on ARM, where, like u said, cache is specifically 
sensitive to bad C code, which doesn't properly handle frequently written 
objects in an SMP environment. 

To put what I've said above in a single sentence: if there is performance 
degradation due to usage of __read_mostly qualifier, then there is a general 
problem with the code that will eventually hit the performance in the future 
(when one adds/removes some variables). 

So, IMHO instead of blaming the __read_mostly we'd better (use it and) fix the 
code that is not written right (for SMP).

Thanks,
vlad

> 
> [1]
> thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.html
> 
> [2] fixunix.com/kernel/262711-rfc-remove-__read_mostly.html
> 
> regards
> ChinmayVS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
