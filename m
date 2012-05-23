Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2EWFyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:54:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34767 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2EWFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:54:03 -0400
Date: Wed, 23 May 2012 01:54:02 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Message-ID: <20120523055402.GC14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523050808.GA29976@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523050808.GA29976@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:08:08PM -0700, Tejun Heo wrote:
> Block layer just fixed a uuid print buffer overflow bug caused by use
> of sprintf() - vsnprintf used more delimiters than the code calling it
> expected.  When think kind of bugs trigger on stack buffer, they can
> be quite a headache.  IMHO it's much more preferable to have an extra
> argument to limit buffer size in most cases.

Well, with the removal of hprint() all uses of sprintf() that are left
save one are in sysfs.c, where size would be PAGE_SIZE.

(The one in super.c I really ought to get rid of, though).

> 
> > > This doesn't build.  While loop var decl in for loop is nice, the
> > > kernel isn't built in c99 mode.  If you want to enable c99 mode
> > > kernel-wide, you're welcome to try but you can't flip that
> > > per-component.
> > 
> > If patches to enable c99 mode would be accepted I'd be happy to work on
> > them (provided I can find time, but I doubt it'd be much work).
> 
> I don't think it's gonna be acceptable.  There isn't enough benefit at
> this point to justify the churn - the only thing I can think of is
> loop variable declaration which I don't think is enough.

If it would end up being more than a couple patches I'd definitely
agree. It would be handy though for compiling the kernel with clang -
not that I care about running kernels built with clang, but I would
happily take advantage of the compiler warnings.

But for the moment I think I'll chip away at c99 only stuff in bcache,
most of the use cases I really don't care about (maybe all of them now).

> 
> > > > +EXPORT_SYMBOL_GPL(parse_uuid);
> > > 
> > > Hmmm... can't we just enforce fixed format used by vsnprintf()?
> > 
> > I don't follow - vsnprintf() is output, this is input...
> 
> Oh, I meant, can't we just require input to use the same exact format
> used by vsnprintf().  Kernel being kind on pparameter inputs isn't
> necessary and often leads to unexpected bugs anyway and if the format
> is fixed, single call to sscanf() is enough.

Ahh - that is a good idea. Yeah, I'll have a look.

> 
> > > > +	bv->bv_offset = base ? ((unsigned long) base) % PAGE_SIZE : 0;
> > > > +	goto start;
> > > > +
> > > > +	for (; size; bio->bi_vcnt++, bv++) {
> > > > +		bv->bv_offset	= 0;
> > > > +start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
> > > > +					size);
> > > 
> > > Please don't do this.
> > 
> > I don't really get your objection to jumping into the middle of loops...
> > sure it shouldn't be the first way you try to write something, but I
> > don't see anything inherently wrong with it. IMO it _can_ make the code
> > easier to follow.
> 
> Easier for whom is the question, I guess.  We have only a couple
> different patterns of goto in use in kernel.  When usage deviates from
> those, people get annoyed.  It's not like goto is a pretty thing to
> begin with.
> 
> > > These are now separate patch series, right?  But, please don't use
> > > nested functions.  Apart from being very unconventional (does gnu99
> > > even allow this?), the implicit outer scope access is dangerous when
> > > mixed with context bouncing which is rather common in kernel.  We
> > > (well, at least I) actually want cross stack frame accesses to be
> > > explicit.
> > 
> > Yes. I took out the nested function in the newer version (I never liked
> > the way allocation worked in the old code and I finally figured out a
> > sane way of doing it).
> > 
> > What do you mean by context bouncing? IME the problem with nested
> > functions in the kernel is the trampolines gcc can silently generate
> > (which is a serious problem).
> 
> I meant async execution.  e.g. Passing nested function to workqueue.
> By the time the nested function executes the parent frame is already
> gone.

Oh, that would be bad :)

> 
> > > How are these different from bitmap_weight()?
> > 
> > No important difference, I just never saw bitmap_weight() before - I'll
> > switch to that. (These are faster, but bigger and in the kernel I highly
> > doubt we've a workload where the performance of popcount justifies the
> > extra memory).
> 
> I don't think these will be actually faster.  bitmap_weight() is
> pretty heavily optimized with constant shortcuts and arch dependent
> implementations.

Ah, I didn't notice the arch specific versions in my brief cscoping,
just an ffs() based one.

> 
> > > > +static inline void SET_##name(type *k, uint64_t v)		\
> > > > +{								\
> > > > +	k->field &= ~(~((uint64_t) ~0 << size) << offset);	\
> > > > +	k->field |= v << offset;				\
> > > > +}
> > > 
> > > More function defining macros.
> > 
> > This one I'm not getting rid of unless you know a better way of doing it
> > than I do - I use it all over the place and well, duplication.
> 
> I think that macro abuses tend to lead to worse code in general.
> Exotic stuff becomes less painful with magic macros which in turn make
> people use magic stuff even when more conventional mechanisms can do.
> Maybe these are simple enough.  Maybe, I don't know.

Well, I'd really prefer it if C bitfields were well defined enough to
use them for an on disk format, but... they aren't. That's all it's
implementing.

> > > > +#define DECLARE_HEAP(type, name)					\
> > > > +	struct {							\
> > > > +		size_t size, used;					\
> > > > +		type *data;						\
> > > > +	} name
> > > > +
> > > > +#define init_heap(heap, _size, gfp)					\
> > > 
> > > Ummm.... so, essentially templates done in macros.  Please don't do
> > > that.  Definitely NACK on this.
> > 
> > I have a passionate... dislike of templates, but do you have any
> > alternatives? I don't know any other way of implementing this that
> > doesn't give up typechecking, and especially for the fifo code that
> > typechecking is just too important to give up.
> 
> Unsure but either giving up type safety or implementing logic as
> functions and wrap them with macros doing typechecks would be better.
> Can't you use the existing prio_tree or prio_heap?

I'd definitely be fine with implementing both the heap and the fifo code
as functions wrapped in macros that provided the typechecking.

The existing prio_heap code isn't sufficient to replace my heap code -
it's missing heap_sift() and heap_full() (well, heap_full() could be
open coded with prio_heap).

Suppose it wouldn't be that much work to add that to the existing
prio_heap code and wrap it in some typechecking macros.

> Is type-dependent variable limit really necessary?  A lot of sysfs and
> other interface doesn't care about input validation as long as it
> doesn't break kernel.

For raw integers I wouldn't care much, but where integers with human
readable units are accepted I'd really hate to lose the input validation
as it's really easy for a user to accidently overflow an integer.
