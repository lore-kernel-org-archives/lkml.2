Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2IUTQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:16:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38340 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2IUTP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:15:56 -0400
MIME-Version: 1.0
Message-ID: <15c1d12a-0e29-478f-97e0-ee4063e2cba5@default>
Date: Fri, 21 Sep 2012 12:14:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Mel Gorman <mgorman@suse.de>, Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120921161252.GV11266@suse.de>
In-Reply-To: <20120921161252.GV11266@suse.de>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel --

Wow!  An incredibly wonderfully detailed response!  Thank you very
much for taking the time to read through all of zcache!

Your comments run the gamut from nit and code style, to design,
architecture and broad naming.  Until the choice-of-codebase issue
is resolved, I'll avoid the nits and codestyle comments and respond
to the higher level strategic and design questions.  Since a couple
of your questions are repeated and the specific code which provoked
your question is not isolated, I hope it is OK if I answer those
first out-of-context from your original comments in the code.
(This should also make this easier to read and to extract optimal
meaning, for you and for posterity.)

> That said, I worry that this has bounced around a lot and as Dan (the
> original author) has a rewrite. I'm wary of spending too much time on this
> at all. Is Dan's new code going to replace this or what? It'd be nice to
> find a definitive answer on that.

Replacing this code was my intent, but that was blocked.  IMHO zcache2
is _much_ better than the "demo version" of zcache (aka zcache1).
Hopefully a middle ground can be reached.  I've proposed one privately
offlist.

Seth, please feel free to augment or correct anything below, or
respond to anything I haven't commented on.

> Anyway, here goes

Repeated comments answered first out-of-context:

1) The interrupt context for zcache (and any tmem backend) is imposed
   by the frontend callers.  Cleancache_put [see naming comment below]
   is always called with interrupts disabled.  Cleancache_flush is
   sometimes called with interrupts disabled and sometimes not.
   Cleancache_get is never called in an atomic context.  (I think)
   frontswap_get/put/flush are never called in an atomic context but
   sometimes with the swap_lock held. Because it is dangerous (true?)
   for code to sometimes/not be called in atomic context, much of the
   code in zcache and tmem is forced into atomic context.  BUT Andrea
   observed that there are situations where asynchronicity would be
   preferable and, it turns out that cleancache_get and frontswap_get
   are never called in atomic context.  Zcache2/ramster takes advantage of
   that, and a future KVM backend may want to do so as well.  However,
   the interrupt/atomicity model and assumptions certainly does deserve
   better documentation.

2) The naming of the core tmem functions (put, get, flush) has been
   discussed endlessly, everyone has a different opinion, and the
   current state is a mess: cleancache, frontswap, and the various
   backends are horribly inconsistent.   IMHO, the use of "put"
   and "get" for reference counting is a historical accident, and
   the tmem ABI names were chosen well before I understood the historical
   precedence and the potential for confusion by kernel developers.
   So I don't have a good answer... I'd prefer the ABI-documented
   names, but if they are unacceptable, at least we need to agree
   on a consistent set of names and fix all references in all
   the various tmem parts (and possibly Xen and the kernel<->Xen
   ABI as well).

The rest of my comments/replies are in context.

> > +/*
> > + * A tmem host implementation must use this function to register
> > + * callbacks for a page-accessible memory (PAM) implementation
> > + */
> > +static struct tmem_pamops tmem_pamops;
> > +
> > +void tmem_register_pamops(struct tmem_pamops *m)
> > +{
> > +	tmem_pamops = *m;
> > +}
> > +
> 
> This implies that this can only host one client  at a time. I suppose
> that's ok to start with but is there ever an expectation that zcache +
> something else would be enabled at the same time?

There was some thought that zcache and Xen (or KVM) might somehow "chain"
the implementations.
 
> > +/*
> > + * A tmem_obj contains a radix-tree-like tree in which the intermediate
> > + * nodes are called tmem_objnodes.  (The kernel lib/radix-tree.c implementation
> > + * is very specialized and tuned for specific uses and is not particularly
> > + * suited for use from this code, though some code from the core algorithms has
> 
> This is a bit vague. It asserts that lib/radix-tree is unsuitable but
> not why. I skipped over most of the implementation to be honest.

IIRC, lib/radix-tree is highly tuned for mm's needs.  Things like
tagging and rcu weren't a good fit for tmem, and new things like calling
a different allocator needed to be added.  In the long run it might
be possible for the lib version to serve both needs, but the impediment
and aggravation of merging all necessary changes into lib seemed a high price
to pay for a hundred lines of code implementing a variation of a widely
documented tree algorithm.

> > + * These "tmem core" operations are implemented in the following functions.
> 
> More nits. As this defines a boundary between two major components it
> probably should have its own Documentation/ entry and the APIs should have
> kernel doc comments.

Agreed.

> > + * a corner case: What if a page with matching handle already exists in
> > + * tmem?  To guarantee coherency, one of two actions is necessary: Either
> > + * the data for the page must be overwritten, or the page must be
> > + * "flushed" so that the data is not accessible to a subsequent "get".
> > + * Since these "duplicate puts" are relatively rare, this implementation
> > + * always flushes for simplicity.
> > + */
> 
> At first glance that sounds really dangerous. If two different users can have
> the same oid for different data, what prevents the wrong data being fetched?
> From this level I expect that it's something the layers above it have to
> manage and in practice they must be preventing duplicates ever happening
> but I'm guessing. At some point it would be nice if there was an example
> included here explaining why duplicates are not a bug.

VFS decides when to call cleancache and dups do happen.  Honestly, I don't
know why they happen (though Chris Mason, who wrote the cleancache hooks,
may know) they happen, but the above coherency rules for backend implementation
always work.  The same is true of frontswap.

> > +int tmem_replace(struct tmem_pool *pool, struct tmem_oid *oidp,
> > +			uint32_t index, void *new_pampd)
> > +{
> > +	struct tmem_obj *obj;
> > +	int ret = -1;
> > +	struct tmem_hashbucket *hb;
> > +
> > +	hb = &pool->hashbucket[tmem_oid_hash(oidp)];
> > +	spin_lock(&hb->lock);
> > +	obj = tmem_obj_find(hb, oidp);
> > +	if (obj == NULL)
> > +		goto out;
> > +	new_pampd = tmem_pampd_replace_in_obj(obj, index, new_pampd);
> > +	ret = (*tmem_pamops.replace_in_obj)(new_pampd, obj);
> > +out:
> > +	spin_unlock(&hb->lock);
> > +	return ret;
> > +}
> > +
> 
> Nothin in this patch uses this. It looks like ramster would depend on it
> but at a glance, ramster seems to have its own copy of the code. I guess
> this is what Dan was referring to as the fork and at some point that needs
> to be resolved. Here, it looks like dead code.

Yep, this was a first step toward supporting ramster (and any other
future asynchronous-get tmem backends).

> > +static inline void tmem_oid_set_invalid(struct tmem_oid *oidp)
> > +
> > +static inline bool tmem_oid_valid(struct tmem_oid *oidp)
> > +
> > +static inline int tmem_oid_compare(struct tmem_oid *left,
> > +					struct tmem_oid *right)
> > +{
> > +}
> 
> Holy Branches Batman!
> 
> Bit of a jumble but works at least. Nits: mixes ret = and returns
> mid-way. Could have been implemented with a while loop. Only has one
> caller and should have been in the C file that uses it. There was no need
> to explicitely mark it inline either with just one caller.

It was put here to group object operations together sort
of as if it is an abstract datatype.  No objections
to moving it.

> > +++ b/drivers/mm/zcache/zcache-main.c
> > + *
> > + * Zcache provides an in-kernel "host implementation" for transcendent memory
> > + * and, thus indirectly, for cleancache and frontswap.  Zcache includes two
> > + * page-accessible memory [1] interfaces, both utilizing the crypto compression
> > + * API:
> > + * 1) "compression buddies" ("zbud") is used for ephemeral pages
> > + * 2) zsmalloc is used for persistent pages.
> > + * Xvmalloc (based on the TLSF allocator) has very low fragmentation
> > + * so maximizes space efficiency, while zbud allows pairs (and potentially,
> > + * in the future, more than a pair of) compressed pages to be closely linked
> > + * so that reclaiming can be done via the kernel's physical-page-oriented
> > + * "shrinker" interface.
> > + *
> 
> Doesn't actually explain why zbud is good for one and zsmalloc good for the other.

There's been extensive discussion of that elsewhere and the
equivalent description in zcache2 is better, but I agree this
needs to be in Documentation/, once the zcache1/zcache2 discussion settles.

> > +#if 0
> > +/* this is more aggressive but may cause other problems? */
> > +#define ZCACHE_GFP_MASK	(GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN)
> 
> Why is this "more agressive"? If anything it's less aggressive because it'll
> bail if there is no memory available. Get rid of this.

My understanding (from Jeremy Fitzhardinge I think) was that GFP_ATOMIC
would use a special reserve of pages which might lead to OOMs.
More experimentation may be warranted.

> > +#else
> > +#define ZCACHE_GFP_MASK \
> > +	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
> > +#endif
> > +
> > +#define MAX_CLIENTS 16
> 
> Seems a bit arbitrary. Why 16?

Sasha Levin posted a patch to fix this but it was tied in to
the proposed KVM implementation, so was never merged.

> > +#define LOCAL_CLIENT ((uint16_t)-1)
> > +
> > +MODULE_LICENSE("GPL");
> > +
> > +struct zcache_client {
> > +	struct idr tmem_pools;
> > +	struct zs_pool *zspool;
> > +	bool allocated;
> > +	atomic_t refcount;
> > +};
> 
> why is "allocated" needed. Is the refcount not enough to determine if this
> client is in use or not?

May be a historical accident.  Deserves a second look.

> > + * Compression buddies ("zbud") provides for packing two (or, possibly
> > + * in the future, more) compressed ephemeral pages into a single "raw"
> > + * (physical) page and tracking them with data structures so that
> > + * the raw pages can be easily reclaimed.
> > + *
> 
> Ok, if I'm reading this right it implies that a page must at least compress
> by 50% before zcache even accepts the page.

NO! Zbud matches up pages that compress well with those that don't.
There's a lot more detailed description of this in zcache2.

> > +static atomic_t zcache_zbud_curr_raw_pages;
> > +static atomic_t zcache_zbud_curr_zpages;
> 
> Should not have been necessary to make these atomics. Probably protected
> by zbpg_unused_list_spinlock or something similar.

Agreed, but it gets confusing when monitoring zcache
if certain key counters go negative.  Ideally this
should all be eventually tied to some runtime debug flag
but it's not clear yet what counters might be used
by future userland software.
 
> > +static unsigned long zcache_zbud_curr_zbytes;
> 
> Overkill, this is just
> 
> zcache_zbud_curr_raw_pages << PAGE_SHIFT

No, it allows a measure of the average compression,
irrelevant of the number of pageframes required.
 
> > +static unsigned long zcache_zbud_cumul_zpages;
> > +static unsigned long zcache_zbud_cumul_zbytes;
> > +static unsigned long zcache_compress_poor;
> > +static unsigned long zcache_mean_compress_poor;
> 
> In general the stats keeping is going to suck on larger machines as these
> are all shared writable cache lines. You might be able to mitigate the
> impact in the future by moving these to vmstat. Maybe it doesn't matter
> as such - it all depends on what velocity pages enter and leave zcache.
> If that velocity is high, maybe the performance is shot anyway.

Agreed.  Velocity is on the order of the number of disk
pages read per second plus pswpin+pswpout per second.
It's not clear yet if that is high enough for the
stat counters to affect performance but it seems unlikely
except possibly on huge NUMA machines.

> > +static inline unsigned zbud_max_buddy_size(void)
> > +{
> > +	return MAX_CHUNK << CHUNK_SHIFT;
> > +}
> > +
> 
> Is the max size not half of MAX_CHUNK as the page is split into two buddies?

No, see above.

> > +	if (zbpg == NULL)
> > +		/* none on zbpg list, try to get a kernel page */
> > +		zbpg = zcache_get_free_page();
> 
> So zcache_get_free_page() is getting a preloaded page from a per-cpu magazine
> and that thing blows up if there is no page available. This implies that
> preemption must be disabled for the entire putting of a page into zcache!
>
> > +	if (likely(zbpg != NULL)) {
> 
> It's not just likely, it's impossible because if it's NULL,
> zcache_get_free_page() will already have BUG().
> 
> If it's the case that preemption is *not* disabled and the process gets
> scheduled to a CPU that has its magazine consumed then this will blow up
> in some cases.
> 
> Scary.

This code is all redesigned/rewritten in zcache2.

> Ok, so if this thing fails to allocate a page then what prevents us getting into
> a situation where the zcache grows to a large size and we cannot take decompress
> anything in it because we cannot allocate a page here?
> 
> It looks like this could potentially deadlock the system unless it was possible
> to either discard zcache data and reconstruct it from information on disk.
> It feels like something like a mempool needs to exist that is used to forcibly
> shrink the zcache somehow but I can't seem to find where something like that happens.
> 
> Where is it or is there a risk of deadlock here?

I am fairly sure there is no risk of deadlock here.  The callers
to cleancache_get and frontswap_get always provide a struct page
for the decompression.  Cleancache pages in zcache can always
be discarded whenever required.

The risk for OOMs does exist when we start trying to force
frontswap-zcache zpages out to the swap disk.  This work
is currently in progress and I hope to have a patch for
review soon.

> > +	BUG_ON(!irqs_disabled());
> > +	if (unlikely(dmem == NULL))
> > +		goto out;  /* no buffer or no compressor so can't compress */
> > +	*out_len = PAGE_SIZE << ZCACHE_DSTMEM_ORDER;
> > +	from_va = kmap_atomic(from);
> 
> Ok, so I am running out of beans here but this triggered alarm bells. Is
> zcache stored in lowmem? If so, then it might be a total no-go on 32-bit
> systems if pages from highmem cause increased low memory pressure to put
> the page into zcache.

Personally, I'm neither an expert nor an advocate of lowmem systems
but Seth said he has tested zcache ("demo version") there.

> > +	mb();
> 
> .... Why?

Historical accident...  I think this was required in the Xen version.
 
> > +	if (nr >= 0) {
> > +		if (!(gfp_mask & __GFP_FS))
> > +			/* does this case really need to be skipped? */
> > +			goto out;
> 
> Answer that question. It's not obvious at all why zcache cannot handle
> !__GFP_FS. You're not obviously recursing into a filesystem.

Yep, this is a remaining loose end.  The documentation
of this (in the shrinker code) was pretty vague so this
is "safety" code that probably should be removed after
a decent test proves it can be.

> > +static int zcache_get_page(int cli_id, int pool_id, struct tmem_oid *oidp,
> > +				uint32_t index, struct page *page)
> > +{
> > +	struct tmem_pool *pool;
> > +	int ret = -1;
> > +	unsigned long flags;
> > +	size_t size = PAGE_SIZE;
> > +
> > +	local_irq_save(flags);
> 
> Why do interrupts have to be disabled?
> 
> This makes the locking between tmem and zcache very confusing unfortunately
> because I cannot decide if tmem indirectly depends on disabled interrupts
> or not. It's also not clear why an interrupt handler would be trying to
> get/put pages in tmem.

Yes, irq disablement goes away for gets in zcache2.

> > +	pool = zcache_get_pool_by_id(cli_id, pool_id);
> > +	if (likely(pool != NULL)) {
> > +		if (atomic_read(&pool->obj_count) > 0)
> > +			ret = tmem_get(pool, oidp, index, (char *)(page),
> > +					&size, 0, is_ephemeral(pool));
> 
> It looks like you are disabling interrupts to avoid racing on that atomic
> update.
> 
> This feels very shaky and the layering is being violated. You should
> unconditionally call into tmem_get and not worry about the pool count at
> all. tmem_get should then check the count under the pool lock and make
> obj_count a normal counter instead of an atomic.
> 
> The same comment applies to all the other obj_count locations.

This isn't the reason for irq disabling, see previous.
It's possible atomic obj_count can go away as it may
have only been necessary in a previous tmem locking design.

> > +	/* wait for pool activity on other cpus to quiesce */
> > +	while (atomic_read(&pool->refcount) != 0)
> > +		;
> 
> There *HAS* to be a better way of waiting before destroying the pool
> than than a busy wait.

Most probably.  Pool destruction is relatively very rare (umount and
swapoff), so fixing/testing this has never bubbled up to the top
of the list.

> Feels like this should be in its own file with a clear interface to
> zcache-main.c . Minor point, at this point I'm fatigued reading the code
> and cranky.

Perhaps.  In zcache2, all the zbud code is moved to a separate
code module, so zcache-main.c is much shorter.

> > +static void zcache_cleancache_put_page(int pool_id,
> > +					struct cleancache_filekey key,
> > +					pgoff_t index, struct page *page)
> > +{
> > +	u32 ind = (u32) index;
> 
> This looks like an interesting limitation. How sure are you that index
> will never be larger than u32 and this start behaving badly? I guess it's
> because the index is going to be related to PFN and there are not that
> many 16TB machines lying around but this looks like something that could
> bite us on the ass one day.

The limitation is for a >16TB _file_ on a cleancache-aware filesystem.
And it's not a hard limitation:  Since the definition of tmem/cleancache
allows for it to ignore any put, pages above 16TB in a single file
can be rejected.  So, yes, it will still eventually bite us on
the ass, but not before huge parts of the kernel need to be rewritten too.

> > +/*
> > + * zcache initialization
> > + * NOTE FOR NOW zcache MUST BE PROVIDED AS A KERNEL BOOT PARAMETER OR
> > + * NOTHING HAPPENS!
> > + */
> > +
> 
> ok..... why?
> 
> superficially there does not appear to be anything obvious that stops it
> being turned on at runtime. Hardly a blocked, just odd.

The issue is that zcache must be active when a filesystem is mounted
(and at swapon time) or the filesystem will be ignored.

A patch has been posted by a University team to fix this but
it hasn't been merged yet.  I agree it should before zcache
should be widely used.

> > + * zsmalloc memory allocator
> 
> Ok, I didn't read anything after this point.  It's another allocator that
> may or may not pack compressed pages better. The usual concerns about
> internal fragmentation and the like apply but I'm not going to mull over them
> now.
> The really interesting part was deciding if zcache was ready or not.
> 
> So, on zcache, zbud and the underlying tmem thing;
> 
> The locking is convulated, the interrupt disabling suspicious and there is at
> least one place where it looks like we are depending on not being scheduled
> on another CPU during a long operation. It may actually be that you are
> disabling interrupts to prevent that happening but it's not documented. Even
> if it's the case, disabling interrupts to avoid CPU migration is overkill.

Explained above, but more work may be possible here.

> I'm also worried that there appears to be no control over how large
> the zcache can get

There is limited control in zcache1.  The policy is handled much better
in zcache2.  More work definitely remains.

> and am suspicious it can increase lowmem pressure on
> 32-bit machines.  If the lowmem pressure is real then zcache should not
> be available on machines with highmem at all. I'm *really* worried that
> it can deadlock if a page allocation fails before decompressing a page.

I've explicitly tested cases where page allocation fails in both versions
of zcache so I know it works, though I obviously can't guarantee it _always_
works.  In zcache2, when an alloc_page fails, a cleancache_put will
"eat its own tail" (i.e. reclaim and immediately reuse the LRU zpageframe)
and a frontswap_put will eat the LRU cleancache pageframe.  Zcache1
doesn't fail or deadlock, but just rejects all new frontswap puts when
zsmalloc becomes full.

> That said, my initial feeling still stands. I think that this needs to move
> out of staging because it's in limbo where it is but Andrew may disagree
> because of the reservations. If my reservations are accurate then they
> should at least be *clearly* documented with a note saying that using
> this in production is ill-advised for now. If zcache is activated via the
> kernel parameter, it should print a big dirty warning that the feature is
> still experiemental and leave that warning there until all the issues are
> addressed. Right now I'm not convinced this is production ready but that
> the  issues could be fixed incrementally.

Sounds good... but begs the question whether to promote zcache1
or zcache2.  Or some compromise.

Thanks again, Mel, for taking the (obviously tons of) time to go
through the code and ask intelligent questions and point out the
many nits and minor issues due to my (and others) kernel newbieness!

Dan
