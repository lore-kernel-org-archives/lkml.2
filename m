Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2GBQAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:00:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48428 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2GBQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <6810708.ZQq4lbXqoi@vlad>
References: <2325453.OX7ktP55U1@vlad> <1793005.iSx5GbFPJq@vlad>
 <CAK-9PRBiqtyiQahunPex9FT2dtKA0k0gv9PR+=sNCXVvn5Bn9Q@mail.gmail.com> <6810708.ZQq4lbXqoi@vlad>
From: Chinmay V S <cvs268@gmail.com>
Date: Mon, 2 Jul 2012 21:30:04 +0530
Message-ID: <CAK-9PRCb1jJdejvim48LP7GN6jHKDdkKVx-UY1Gpsbx1ROyQvQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] fs: Move bh_cachep to the __read_mostly section
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shai@scalemp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Sunday 01 July 2012 17:24:34 Chinmay V S wrote:
>> Played around with __read_mostly some time back in an attempt to optimise
>> cache usage.
>> thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.html
>
>Nice article!

Thank you! :)

>U see, if we assume that __read_mostly the way it's currently implemented is a
>bad thing (due to the fact that it implicitly causes the bunching of the
>write-mostly variables) than this means that "const" the way it's currently
>implemented is a bad thing too due to the same reasons. ;)

Every individual instance of __read_mostly may NOT degrade performance.
What *will* degrade the performance is "excessive" use of __read_mostly.
An interesting discussion on similar lines here[2].

>This is an interesting idea however there is (at least) one weakness in it -
>it assumes that linker's heuristics (those that will pack cons and non-const
>variables together in a single cache line) will do a better job than a person
>that writes a specific code section and knows the exact nature and the
>relationship between variables in his/her C code.

True.

>First of all, let me note that saying that C code performance may benefit from
>NOT using the __read_mostly variables is a bit misleading because here u rely
>on something that is not deterministic: a linker decision to pack one (often
>written) variable together with another (read mostly) variable in a single
>cache line boundaries (thus improving the performance); and this decision may
>change due to a minor code change and u will not know about it.

I totally agree that avoiding use of __read_mostly does NOT guarantee any
performance boost. The point i am trying to make is this:

1. Consider a code with NO instances of __read_mostly.

2. Now we go ahead and add __read_mostly to an object.
Note that we are NOT guaranteed that this object is "hot" i.e. accessed
frequently. All that __read_mostly signifies is that the object is rarely
written to i.e. most of the time it is accessed, it is a read operation.

Cost-Benefit analysis:
Currently each CPU keeps its own copy of the __read_mostly(variable) in the
per-cpu L1 cache(any benefits on non-SMP systems?). As the variable is rarely
written to, rarely do we need to sync it across multiple L1 caches i.e.
cacheline-bouncing is very rare.
So the cost is very less.

As the variable is maintained in L1 cache, rather than being shared across
multiple CPUs in L2 or L3 cache, the access is an order of magnitude faster.
Hence the benefit is very high.

3. We continue adding __read_mostly to other genuine read-mostly objects.

As we continue to increase the number of __read_mostly objects, they get moved
from bss to .data.read_mostly section. This IMHO, increase the chances
(as compared to earlier without __read_mostly) that 2 objects in the bss
compete for the same cache-line. But this is NOT directly evident as modern
cpu-caches are N-way associative i.e .each object has a choice of N different
cache-slots. This tends to intially hide the effect of __read_mostly.
(This is the point i make in my article[1]).

After a few iterations of adding __read_mostly, (if) the cache contention
increases to more than N objects competing for the same cache-slot. False
cache-line sharing occurs i.e. 2 or more objects continue to replace
one another from the cache-slot alternatively. i.e cache-thrashing begins.

Note that false cache-line sharing is NOT a one time cost. Cache thrashing will
continue to happen until the context changes sufficiently for one of the
cache-slots to free-up. Hence this scenario must be avoided at all costs.

>I agree that there might be a few places in kernel that suffer from the
>weakness described above. That's why it's important to add __read_mostly in
>small portions (even one by one) in order to ease the bisect if and when the
>performance regression occurs.

Exactly! So we can conclude that "excessive" use of __read_mostly must be
avoided. "Excessive" varies from system to system based on:
- Degree of SMP (no.of cores).
- Levels of cache (and penalties associated between successive levels).
- Associativity of caches.

Without proper understanding of these params, __read_mostly with be a "mostly"
hit-n-miss affair. In fact a quick grep shows ~1300 __read_mostly  scattered
around the kernel code(3.4-rc1) which on certain systems is already detrimental.
Certain architectures(eg-ARM) completely disable __read_mostly as its evident by
their 2-way associative cache that cache-thrashing will occur so quickly that it
voids any potential performance gains.

[1] thecodeartist.blogspot.com/2011/12/why-readmostly-does-not-work-as-it.html

[2] fixunix.com/kernel/262711-rfc-remove-__read_mostly.html

regards
ChinmayVS
