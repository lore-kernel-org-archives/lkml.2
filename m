Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2IXR0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:26:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46650 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2IXR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:26:05 -0400
Message-ID: <50609794.8030508@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 12:25:40 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120921161252.GV11266@suse.de> <20120921180222.GA7220@phenom.dumpdata.com> <505CB9BC.8040905@linux.vnet.ibm.com> <42d62a30-bd6c-4bd7-97d1-bec2f237756b@default>
In-Reply-To: <42d62a30-bd6c-4bd7-97d1-bec2f237756b@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092417-6148-0000-0000-000009F1B3CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 03:35 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [RFC] mm: add support for zsmalloc and zcache
>>
>> On 09/21/2012 01:02 PM, Konrad Rzeszutek Wilk wrote:
>>> On Fri, Sep 21, 2012 at 05:12:52PM +0100, Mel Gorman wrote:
>>>> On Tue, Sep 04, 2012 at 04:34:46PM -0500, Seth Jennings wrote:
>>>>> zcache is the remaining piece of code required to support in-kernel
>>>>> memory compression.  The other two features, cleancache and frontswap,
>>>>> have been promoted to mainline in 3.0 and 3.5 respectively.  This
>>>>> patchset promotes zcache from the staging tree to mainline.
>>
>>>>
>>>> Very broadly speaking my initial reaction before I reviewed anything was
>>>> that *some* sort of usable backend for cleancache or frontswap should exist
>>>> at this point. My understanding is that Xen is the primary user of both
>>>> those frontends and ramster, while interesting, is not something that a
>>>> typical user will benefit from.
>>>
>>> Right, the majority of users do not use virtualization. Thought embedded
>>> wise .. well, there are a lot of Android users - thought I am not 100%
>>> sure they are using it right now (I recall seeing changelogs for the clones
>>> of Android mentioning zcache).
>>>>
>>>> That said, I worry that this has bounced around a lot and as Dan (the
>>>> original author) has a rewrite. I'm wary of spending too much time on this
>>>> at all. Is Dan's new code going to replace this or what? It'd be nice to
>>>> find a definitive answer on that.
>>>
>>> The idea is to take parts of zcache2 as seperate patches and stick it
>>> in the code you just reviewed (those that make sense as part of unstaging).
>>
>> I agree with this.  Only the changes from zcache2 (Dan's
>> rewrite) that are necessary for promotion should be
>> considered right now.  Afaict, none of the concerns raised
>> in these comments are addressed by the changes in zcache2.
> 
> While I may agree with the proposed end result, this proposal
> is a _very_ long way away from a solution.  To me, it sounds like
> a "split the baby in half" proposal (cf. wisdom of Solomon)
> which may sound reasonable to some but, in the end, everyone loses.
> 
> I have proposed a reasonable compromise offlist to Seth, but
> it appears that it has been silently rejected; I guess it is
> now time to take the proposal public. I apologize in advance
> for my characteristic bluntness...
> 
> So let's consider two proposals and the pros and cons of them,
> before we waste any further mm developer time.  (Fortunately,
> most of Mel's insightful comments apply to both versions, though
> he did identify some of the design issues that led to zcache2!)
> 
> The two proposals:
> A) Recreate all the work done for zcache2 as a proper sequence of
>    independent patches and apply them to zcache1. (Seth/Konrad)
> B) Add zsmalloc back in to zcache2 as an alternative allocator
>    for frontswap pages. (Dan)
> 
> Pros for (A):
> 1. It better preserves the history of the handful of (non-zsmalloc)
>    commits in the original zcache code.
> 2. Seth[1] can incrementally learn the new designs by reading
>    normal kernel patches.

It's not a matter of breaking the patches up so that I can
understand them.  I understand them just fine as indicated
by my responses to the attempt to overwrite zcache/remove
zsmalloc:

https://lkml.org/lkml/2012/8/14/347
https://lkml.org/lkml/2012/8/17/498

zcache2 also crashes on PPC64, which uses 64k pages, because
a 4k maximum page size is hard coded into the new zbudpage
struct.

The point is to discuss and adopt each change on it's own
merits instead of this "take a 10k line patch or leave it"
approach.

> 3. For kernel purists, it is the _right_ way dammit (and Dan
>    should be shot for redesigning code non-incrementally, even
>    if it was in staging, etc.)

Dan says "dammit" to add a comic element to this point,
however, it is a valid point (minus the firing squad).

Lets be clear about what zcache2 is.  It is not a rewrite in
the way most people think: a refactored codebase the caries
out the same functional set as an original codebase.  It is
an _overwrite_ to accommodate an entirely new set of
functionally whose code doubles the size of the origin
codebase and regresses performance on the original
functionality.

> 4. Seth believes that zcache will be promoted out of staging sooner
>    because, except for a few nits, it is ready today.
> 
> Cons for (A):
> 1. Nobody has signed up to do the work, including testing.  It
>    took the author (and sole expert on all the components
>    except zsmalloc) between two and three months essentially
>    fulltime to move zcache1->zcache2.  So forward progress on
>    zcache will likely be essentially frozen until at least the
>    end of 2012, possibly a lot longer.

This is not true.  I have agreed to do the work necessary to
make zcache1 acceptable for mainline, which can include
merging changes from zcache2 if people agree it is a blocker.

> 2. The end result (if we reach one) is almost certainly a
>    _third_ implementation of zcache: "zcache 1.5".  So
>    we may not be leveraging much of the history/testing
>    from zcache1 anyway!
> 3. Many of the zcache2 changes are closely interwoven so
>    a sequence of patches may not be much more incrementally
>    readable than zcache2.
> 4. The merge with ramster will likely be very low priority
>    so the fork between the two will continue.
> 5. Dan believes that, if zcache1 does indeed get promoted with
>    few or none of the zcache2 redesigns, zcache will never
>    get properly finished.

What is "properly finished"?

> Pros for (B):
> 1. Many of the design issues/constraints of zcache are resolved
>    in code that has already been tested approximately as well
>    as the original. All of the redesign (zcache1->zcache2) has
>    been extensively discussed on-list; only the code itself is
>    "non-incremental".
> 2. Both allocators (which AFAIK is the only technical area
>    of controversy) will be supported in the same codebase.
> 3. Dan (especially with help from Seth) can do the work in a
>    week or two, and then we can immediately move forward
>    doing useful work and adding features on a solid codebase.

The continuous degradation of zcache as "demo" and the
assertion that zcache2 is the "solid codebase" is tedious.
zcache is actually being worked on by others and has been in
staging for years.  By definition, _it_ is the more
hardended codebase.

If there are results showing that zcache2 has superior
performance and stability on the existing use cases please
share them.  Otherwise this characterization is just propaganda.

> 4. Zcache2 already has the foundation in place for "reclaim
>    frontswap zpages", which mm experts have noted is a critical
>    requirement for broader zcache acceptance (e.g. KVM).

This is dead code in zcache2 right now and relies on
yet-to-be-posted changes to the core mm to work.

My impression is that folks are ok with adding this
functionality to zcache if/when a good way to do it is
presented, and it's absence is not a blocker for acceptance.

> 5. Ramster is already a small incremental addition to core zcache2 code
>    rather than a fork.

According to Greg's staging-next, ramster adds 6000 lines of
new code to zcache.

In summary, I really don't understand the objection to
promoting zcache and integrating zcache2 improvements and
features incrementally.  It seems very natural and
straightforward to me.  Rewrites can even happen in
mainline, as James pointed out.  Adoption in mainline just
provides a more stable environment for more people to use
and contribute to zcache.

--
Seth

