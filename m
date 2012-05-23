Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab2EWDMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:12:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2EWDMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:12:14 -0400
Date: Tue, 22 May 2012 23:12:14 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tejun@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Message-ID: <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522211706.GH14339@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> I've been reading the code and am still very far from understanding
> the whole thing but here are general impressions upto this point.
> 
> * I started reading from get_bucket(), mostly because I wasn't sure
>   where to start.  It would be very helpful to the reviewers and
>   future participants if there's a design doc and more comments (much
>   more).  The code is on the big side and the problem is exacerbated
>   by use of somewhat unconventional constructs and conventions and
>   lack of documentation and comments.

Yeah, I'm gonna try and spend more time on documentation. That's gonna
take a bit, though.

> * It's unfortunate but true that different parts of kernel are held to
>   different standards in terms of conformance to overall style and
>   structure.  Code for obscure device, for example, is allowed to be
>   way more weird than common core code.  That said, one thing which is
>   generally frowned upon is bringing in lots of foreign constructs
>   because that tends to make the code much more difficult to follow
>   for other people than plain silly code.  Even for drivers, code with
>   a lot of wrappers and foreign constructs (synchronization, data
>   structure...) tend to get nacked and are recommended to convert to
>   existing infrastructure even if that ends up, say, more verbose
>   code.
> 
>   It is also true that new constructs and mechanisms are constantly
>   being added to kernel and the ones used by bcache could be useful
>   enough to have; however, with my currently limited understanding,
>   the oddities seem too much.
> 
> * Too many smart macros.  Macros suck.  Smart ones double suck.
> 
> * For file internal ones, it's okay to be somewhat relaxed with
>   namespace separation but bcache code seems to be going too far.  It
>   also becomes a lot worse with macros as warnings and errors from
>   compiler get much more difficult to decipher.  e.g. things like
>   next() and end() macros are calling for trouble.

Yes, that's been on the todo list forever - legacy of it starting out as
a single file. I'll try and work some more on namespacing tonight.

> * Somewhat related to the above, I'm not a fan of super-verbose
>   symbols but I *hope* that the variable names were just a tiny bit
>   more descriptive.  At least, the ones used as arguments.

If you want to point out particularly egregious examples in your code
reviews I'll tackle those first. I suffer from being too close to the
code, so I really have a hard time guessing what's going to trip other
people up.

> * The biggest thing that I dislike about closure is that it's not
>   clear what it does when I see one.  Is it a refcount,
>   synchronization construct or asynchronous execution mechanism?  To
>   me, it seems like a construct with too many purposes and too much
>   abstraction, which tends to make it difficult to understand, easy to
>   misuse and difficult to debug.  IMHO, constructs like this could
>   seem very attractive to small group of people with certain concepts
>   firmly on their minds; however, one man's paradise is another man's
>   hell and we're often better off without either.  In many ways,
>   closure feels like kobject and friends.

Heh, it's worse than kobjects in that respect. But I really like the
fact that it's more abstract than kobjects, in that it's not at all tied
to implementation details of sysfs or anything else.

>   I'd like to recommend using something more concerete even if that
>   means more verbosity.  ie. if there are lots of bio sequencing going
>   on, implement and use bio sequencer.  That's way more concerete and
>   concerete stuff tends to be much easier to wrap one's head around
>   mostly because it's much easier to agree upon for different people
>   and they don't have to keep second-guessing what the original author
>   would have on his/her mind while implementing it.

There's got to be some kind of middle ground. Having a unifying
abstraction for refcounty things really is incredibly powerful - the
unified parent mechanism makes a lot of problems go away, I don't think
I can adequately explain how sucessful that was, you had to experience
it.

But nevertheless I sympathize with your basic complaint - it ought to be
possible to restructure something so the code is easier to follow and
it's easier to tell what a given closure is for.

Maybe if I go through and document all the instances where they're
declared it might help.

> On Wed, May 09, 2012 at 11:10:17PM -0400, Kent Overstreet wrote:
> > +#define simple_strtoint(c, end, base)	simple_strtol(c, end, base)
> > +#define simple_strtouint(c, end, base)	simple_strtoul(c, end, base)
> > +
> > +#define STRTO_H(name, type)					\
> > +int name ## _h(const char *cp, type *res)		        \
> > +{								\
> ...
> > +}								\
> > +EXPORT_SYMBOL_GPL(name ## _h);
> > +
> > +STRTO_H(strtoint, int)
> > +STRTO_H(strtouint, unsigned int)
> > +STRTO_H(strtoll, long long)
> > +STRTO_H(strtoull, unsigned long long)
> 
> Function defining macros == bad.  Can't it be implemented with a
> common backend function with wrappers implementing limits?  Why not
> use memparse()?

Had not come across memparse(). I don't think it's a sufficient
replacement for my code because of the per type limits, but we should
definitely get rid of the duplication one way or the other.

As you can probably tell I'm strongly biased against duplication when
it's a question of macros vs. duplication - but if we can make the
commend backend code + wrapper approach work that's even better (smaller
code size ftw). It'll be tricky to get u64 vs. int64 right, but I'll
take a stab at it.

> 
> > +ssize_t hprint(char *buf, int64_t v)
> > +{
> > +	static const char units[] = "?kMGTPEZY";
> > +	char dec[3] = "";
> > +	int u, t = 0;
> > +
> > +	for (u = 0; v >= 1024 || v <= -1024; u++) {
> > +		t = v & ~(~0 << 10);
> > +		v >>= 10;
> > +	}
> > +
> > +	if (!u)
> > +		return sprintf(buf, "%llu", v);
> > +
> > +	if (v < 100 && v > -100)
> > +		sprintf(dec, ".%i", t / 100);
> > +
> > +	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> > +}
> > +EXPORT_SYMBOL_GPL(hprint);
> 
> Not your fault but maybe we want integer vsnprintf modifier for this.

Yes.

> Also, sprintf() sucks.

Yeah, but considering the output is very bounded... you are technically
correct, but I have a hard time caring. Making it a vsnprintf modifier
would make that issue go away though. I'll see if I can figure out how
to do it.


> > +ssize_t sprint_string_list(char *buf, const char * const list[],
> > +			   size_t selected)
> > +{
> > +	char *out = buf;
> > +
> > +	for (size_t i = 0; list[i]; i++)
> > +		out += sprintf(out, i == selected ? "[%s] " : "%s ", list[i]);
> > +
> > +	out[-1] = '\n';
> > +	return out - buf;
> > +}
> > +EXPORT_SYMBOL_GPL(sprint_string_list);
> 
> sprintf() sucks.

Output's again bounded so it's not _buggy_ as is, but this one I agree
more - I'll switch it.

> > +bool is_zero(const char *p, size_t n)
> > +{
> > +	for (size_t i = 0; i < n; i++)
> 
> This doesn't build.  While loop var decl in for loop is nice, the
> kernel isn't built in c99 mode.  If you want to enable c99 mode
> kernel-wide, you're welcome to try but you can't flip that
> per-component.

If patches to enable c99 mode would be accepted I'd be happy to work on
them (provided I can find time, but I doubt it'd be much work).

That said, I'm just as happy to switch to something that builds in c89
mode here.

> > +int parse_uuid(const char *s, char *uuid)
> > +{
> > +	size_t i, j, x;
> > +	memset(uuid, 0, 16);
> > +
> > +	for (i = 0, j = 0;
> > +	     i < strspn(s, "-0123456789:ABCDEFabcdef") && j < 32;
> > +	     i++) {
> > +		x = s[i] | 32;
> > +
> > +		switch (x) {
> > +		case '0'...'9':
> > +			x -= '0';
> > +			break;
> > +		case 'a'...'f':
> > +			x -= 'a' - 10;
> > +			break;
> > +		default:
> > +			continue;
> > +		}
> > +
> > +		if (!(j & 1))
> > +			x <<= 4;
> > +		uuid[j++ >> 1] |= x;
> > +	}
> > +	return i;
> > +}
> > +EXPORT_SYMBOL_GPL(parse_uuid);
> 
> Hmmm... can't we just enforce fixed format used by vsnprintf()?

I don't follow - vsnprintf() is output, this is input...

> 
> > +void time_stats_update(struct time_stats *stats, uint64_t start_time)
> > +{
> > +	uint64_t now		= local_clock();
> > +	uint64_t duration	= time_after64(now, start_time)
> > +		? now - start_time : 0;
> > +	uint64_t last		= time_after64(now, stats->last)
> > +		? now - stats->last : 0;
> > +
> > +	stats->max_duration = max(stats->max_duration, duration);
> > +
> > +	if (stats->last) {
> > +		ewma_add(stats->average_duration, duration, 8, 8);
> > +
> > +		if (stats->average_frequency)
> > +			ewma_add(stats->average_frequency, last, 8, 8);
> > +		else
> > +			stats->average_frequency  = last << 8;
> > +	} else
> > +		stats->average_duration  = duration << 8;
> > +
> > +	stats->last = now ?: 1;
> > +}
> > +EXPORT_SYMBOL_GPL(time_stats_update);
> 
> if {
> } else {
> }
> 
> Even if one of the branches is single line.  Also, I'm not sure this
> (and a few others) is general enough to be common utility.

Yeah, not everything in util.[ch] has to become generic code.

> 
> > +#ifdef CONFIG_BCACHE_LATENCY_DEBUG
> > +unsigned latency_warn_ms;
> > +#endif
> > +
> > +#ifdef CONFIG_BCACHE_EDEBUG
> > +
> > +static void check_bio(struct bio *bio)
> > +{
> > +	unsigned i, size = 0;
> > +	struct bio_vec *bv;
> > +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> 
> New line missing.



> > +	BUG_ON(!bio->bi_vcnt);
> > +	BUG_ON(!bio->bi_size);
> > +
> > +	bio_for_each_segment(bv, bio, i)
> > +		size += bv->bv_len;
> > +
> > +	BUG_ON(size != bio->bi_size);
> > +	BUG_ON(size > queue_max_sectors(q) << 9);
> > +
> > +	blk_recount_segments(q, bio);
> > +	BUG_ON(bio->bi_phys_segments > queue_max_segments(q));
> > +}
> ...
> > +void bio_map(struct bio *bio, void *base)
> > +{
> > +	size_t size = bio->bi_size;
> > +	struct bio_vec *bv = bio->bi_inline_vecs;
> > +
> > +	BUG_ON(!bio->bi_size);
> > +	bio->bi_vcnt	= 0;
> > +	bio->bi_io_vec	= bv;
> 
> I'd prefer these assignments didn't have indentations.

Suppose there's only two of them.

> > +	bv->bv_offset = base ? ((unsigned long) base) % PAGE_SIZE : 0;
> > +	goto start;
> > +
> > +	for (; size; bio->bi_vcnt++, bv++) {
> > +		bv->bv_offset	= 0;
> > +start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
> > +					size);
> 
> Please don't do this.

I don't really get your objection to jumping into the middle of loops...
sure it shouldn't be the first way you try to write something, but I
don't see anything inherently wrong with it. IMO it _can_ make the code
easier to follow.



> > +#undef bio_alloc_pages
> 
> Why is this undef necessary?  If it's necessary, why isn't there any
> explanation?

>From the dynamic fault code, should've been removed.

> 
> > +int bio_alloc_pages(struct bio *bio, gfp_t gfp)
> > +{
> > +	int i;
> > +	struct bio_vec *bv;
> 
> New line missing.
> 
> > +	bio_for_each_segment(bv, bio, i) {
> > +		bv->bv_page = alloc_page(gfp);
> > +		if (!bv->bv_page) {
> > +			while (bv-- != bio->bi_io_vec + bio->bi_idx)
> > +				__free_page(bv->bv_page);
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(bio_alloc_pages);
> > +
> > +struct bio *bio_split_front(struct bio *bio, int sectors, bio_alloc_fn *_alloc,
> > +			    gfp_t gfp, struct bio_set *bs)
> > +{
> > +	unsigned idx, vcnt = 0, nbytes = sectors << 9;
> > +	struct bio_vec *bv;
> > +	struct bio *ret = NULL;
> > +
> > +	struct bio *alloc(int n)
> > +	{
> > +		if (bs)
> > +			return bio_alloc_bioset(gfp, n, bs);
> > +		else if (_alloc)
> > +			return _alloc(gfp, n);
> > +		else
> > +			return bio_kmalloc(gfp, n);
> > +	}
> 
> These are now separate patch series, right?  But, please don't use
> nested functions.  Apart from being very unconventional (does gnu99
> even allow this?), the implicit outer scope access is dangerous when
> mixed with context bouncing which is rather common in kernel.  We
> (well, at least I) actually want cross stack frame accesses to be
> explicit.

Yes. I took out the nested function in the newer version (I never liked
the way allocation worked in the old code and I finally figured out a
sane way of doing it).

What do you mean by context bouncing? IME the problem with nested
functions in the kernel is the trampolines gcc can silently generate
(which is a serious problem).

> > +unsigned popcount_64(uint64_t x)
> > +{
> > +	static const uint64_t m1  = 0x5555555555555555LLU;
> > +	static const uint64_t m2  = 0x3333333333333333LLU;
> > +	static const uint64_t m4  = 0x0f0f0f0f0f0f0f0fLLU;
> > +	static const uint64_t h01 = 0x0101010101010101LLU;
> > +
> > +	x -= (x >> 1) & m1;
> > +	x = (x & m2) + ((x >> 2) & m2);
> > +	x = (x + (x >> 4)) & m4;
> > +	return (x * h01) >> 56;
> > +}
> > +EXPORT_SYMBOL(popcount_64);
> > +
> > +unsigned popcount_32(uint32_t x)
> > +{
> > +	static const uint32_t m1  = 0x55555555;
> > +	static const uint32_t m2  = 0x33333333;
> > +	static const uint32_t m4  = 0x0f0f0f0f;
> > +	static const uint32_t h01 = 0x01010101;
> > +
> > +	x -= (x >> 1) & m1;
> > +	x = (x & m2) + ((x >> 2) & m2);
> > +	x = (x + (x >> 4)) & m4;
> > +	return (x * h01) >> 24;
> > +}
> > +EXPORT_SYMBOL(popcount_32);
> 
> How are these different from bitmap_weight()?

No important difference, I just never saw bitmap_weight() before - I'll
switch to that. (These are faster, but bigger and in the kernel I highly
doubt we've a workload where the performance of popcount justifies the
extra memory).

> 
> > +#ifndef USHRT_MAX
> > +#define USHRT_MAX	((u16)(~0U))
> > +#define SHRT_MAX	((s16)(USHRT_MAX>>1))
> > +#endif
> ...
> 
> These compat macros can be removed for upstream submission, right?

Yeah.

> > +#define BITMASK(name, type, field, offset, size)		\
> > +static inline uint64_t name(const type *k)			\
> > +{ return (k->field >> offset) & ~(((uint64_t) ~0) << size); }	\
> > +								\
> > +static inline void SET_##name(type *k, uint64_t v)		\
> > +{								\
> > +	k->field &= ~(~((uint64_t) ~0 << size) << offset);	\
> > +	k->field |= v << offset;				\
> > +}
> 
> More function defining macros.

This one I'm not getting rid of unless you know a better way of doing it
than I do - I use it all over the place and well, duplication.

> > +#define DECLARE_HEAP(type, name)					\
> > +	struct {							\
> > +		size_t size, used;					\
> > +		type *data;						\
> > +	} name
> > +
> > +#define init_heap(heap, _size, gfp)					\
> 
> Ummm.... so, essentially templates done in macros.  Please don't do
> that.  Definitely NACK on this.

I have a passionate... dislike of templates, but do you have any
alternatives? I don't know any other way of implementing this that
doesn't give up typechecking, and especially for the fifo code that
typechecking is just too important to give up.

> 
> > +#define DECLARE_FIFO(type, name)					\
> > +	struct {							\
> > +		size_t front, back, size, mask;				\
> > +		type *data;						\
> > +	} name
> > +
> > +#define fifo_for_each(c, fifo)						\
> 
> Ditto.  Templates are already yucky enough even with compiler support.
> IMHO, it's a horrible idea to try that with preprocessor in C.
> 
> > +#define DECLARE_ARRAY_ALLOCATOR(type, name, size)			\
> > +	struct {							\
> > +		type	*freelist;					\
> > +		type	data[size];					\
> > +	} name
> 
> Ditto.
> 
> > +#define strtoi_h(cp, res)						\
> > +	(__builtin_types_compatible_p(typeof(*res), int)		\
> > +	? strtoint_h(cp, (void *) res)					\
> > +	:__builtin_types_compatible_p(typeof(*res), long)		\
> > +	? strtol_h(cp, (void *) res)					\
> > +	: __builtin_types_compatible_p(typeof(*res), long long)		\
> > +	? strtoll_h(cp, (void *) res)					\
> > +	: __builtin_types_compatible_p(typeof(*res), unsigned int)	\
> > +	? strtouint_h(cp, (void *) res)					\
> > +	: __builtin_types_compatible_p(typeof(*res), unsigned long)	\
> > +	? strtoul_h(cp, (void *) res)					\
> > +	: __builtin_types_compatible_p(typeof(*res), unsigned long long)\
> > +	? strtoull_h(cp, (void *) res) : -EINVAL)
> 
> Is this *really* necessary?

This one might be excessive - but if we can implement memparse() +
variable limit correctly that would certainly get rid of this.

> 
> > +#define strtoul_safe(cp, var)						\
> > +({									\
> > +	unsigned long _v;						\
> > +	int _r = strict_strtoul(cp, 10, &_v);				\
> > +	if (!_r)							\
> > +		var = _v;						\
> > +	_r;								\
> > +})
> > +
> > +#define strtoul_safe_clamp(cp, var, min, max)				\
> > +({									\
> > +	unsigned long _v;						\
> > +	int _r = strict_strtoul(cp, 10, &_v);				\
> > +	if (!_r)							\
> > +		var = clamp_t(typeof(var), _v, min, max);		\
> > +	_r;								\
> > +})
> > +
> > +#define snprint(buf, size, var)						\
> > +	snprintf(buf, size,						\
> > +		__builtin_types_compatible_p(typeof(var), int)		\
> > +		     ? "%i\n" :						\
> > +		__builtin_types_compatible_p(typeof(var), unsigned)	\
> > +		     ? "%u\n" :						\
> > +		__builtin_types_compatible_p(typeof(var), long)		\
> > +		     ? "%li\n" :					\
> > +		__builtin_types_compatible_p(typeof(var), unsigned long)\
> > +		     ? "%lu\n" :					\
> > +		__builtin_types_compatible_p(typeof(var), int64_t)	\
> > +		     ? "%lli\n" :					\
> > +		__builtin_types_compatible_p(typeof(var), uint64_t)	\
> > +		     ? "%llu\n" :					\
> > +		__builtin_types_compatible_p(typeof(var), const char *)	\
> > +		     ? "%s\n" : "%i\n", var)
> 
> Ditto.

I suppose I could take this out.
