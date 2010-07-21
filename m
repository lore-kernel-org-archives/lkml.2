Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0GUKPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 06:15:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33018 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0GUKO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 06:14:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 21 Jul 2010 12:16:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100720145238.29111716@bike.lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.vf6utfgd7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <20100720145238.29111716@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan,

Thank you for review and comments!

> On Tue, 20 Jul 2010 17:51:25 +0200 Michal Nazarewicz wrote:
>> The Contiguous Memory Allocator framework is a set of APIs for
>> allocating physically contiguous chunks of memory.
>>
>> Various chips require contiguous blocks of memory to operate.  Those
>> chips include devices such as cameras, hardware video decoders and
>> encoders, etc.

On Tue, 20 Jul 2010 22:52:38 +0200, Jonathan Corbet <corbet@lwn.net> wrote:
> Certainly this is something that many of us have run into; a general
> solution would make life easier. I do wonder if this implementation
> isn't a bit more complex than is really needed, though.
>
>> diff --git a/Documentation/cma.txt b/Documentation/cma.txt
>
> "cma.txt" is not a name that will say much to people browsing the
> directory, especially since you didn't add a 00-INDEX entry for it.  Maybe
> something like contiguous-memory.txt would be better?

Will fix.

>> +    For instance, let say that there are two memory banks and for
>> +    performance reasons a device uses buffers in both of them.  In
>> +    such case, the device driver would define two kinds and use it for
>> +    different buffers.  Command line arguments could look as follows:
>> +
>> +            cma=a=32M@0,b=32M@512M cma_map=foo/a=a;foo/b=b

> About the time I get here I really have to wonder if we *really* need all
> of this.  A rather large portion of the entire patch is parsing code.  Are
> there real-world use cases for this kind of functionality?

As of "cma" parameter: we encountered a system where all of the information
(expect for allocator) that it is possible to specify is needed.

1. The size is needed from obvious reasons.
2. Our platform have two banks of memory and one of the devices needs
     some buffers to be allocated in one bank and other buffers in the
     other bank.  The start address that can be specified let us
     specify regions in both banks.
3. At least one of our drivers needs a buffer for firmware that is aligned
     to 128K (if recall correctly).  Due to other, unrelated reasons it needs
     to be in a region on its own so we need to reserve a region aligned
     at least to 128K.
4. As of allocator, we use only best-fit but I believe that letting user
     specify desired allocator is desirable.

As of "cma_map" parameter: It is needed because different devices are
assigned to different regions.  Also, at least one of our drivers uses
three kinds of memory (bank 1, bank 2 and firmware) and hence we also
need the optional kind.

The remaining question is whether we need the pattern matching (like '?'
and '*').  I agree that the matching code may be not the most beautiful
piece of software but I believe it may be useful.  In particular letting
user write something like the following may be nice:

    cma_map=foo-dev=foo-region;*/*=bar-region

This lets one say that foo-dev should use its own region and all other
devices should share the other region.  Similarly, if at one point the driver
I described above (that uses 3 kinds) were to receive a firmware upgrade or
be installed on different platform and regions in two banks would no longer
be necessary the command line could be set to:

    cma_map=baz-dev/firmware=baz-firmware;baz-dev/*=baz-region

and everything would start working fine without the need to change the
driver itself -- it would be completely unaware of the change.

Generally I see that the asterisk may be quite useful.

>> +    And whenever the driver allocated the memory it would specify the
>> +    kind of memory:
>> +
>> +            buffer1 = cma_alloc(dev, 1 << 20, 0, "a");
>> +            buffer2 = cma_alloc(dev, 1 << 20, 0, "b");

> This example, above, is not consistent with:

>> +
>> +    There are four calls provided by the CMA framework to devices.  To
>> +    allocate a chunk of memory cma_alloc() function needs to be used:
>> +
>> +            unsigned long cma_alloc(const struct device *dev,
>> +                                    const char *kind,
>> +                                    unsigned long size,
>> +                                    unsigned long alignment);

> It looks like the API changed and the example didn't get updated?

Yep, will fix.

>> +
>> +    If required, device may specify alignment that the chunk need to
>> +    satisfy.  It have to be a power of two or zero.  The chunks are
>> +    always aligned at least to a page.
>
> So is the alignment specified in bytes or pages?

In bytes, will fix.

>> +    Allocated chunk is freed via a cma_put() function:
>> +
>> +            int cma_put(unsigned long addr);
>> +
>> +    It takes physical address of the chunk as an argument and
>> +    decreases it's reference counter.  If the counter reaches zero the
>> +    chunk is freed.  Most of the time users do not need to think about
>> +    reference counter and simply use the cma_put() as a free call.
>
> A return value from a put() function is mildly different;

Not sure what you mean.  cma_put() returns either -ENOENT if there is no
chunk with given address or whatever kref_put() returned.

> when would that value be useful?

I dunno.  I'm just returning what kref_put() returns.

>
>> +    If one, however, were to share a chunk with others built in
>> +    reference counter may turn out to be handy.  To increment it, one
>> +    needs to use cma_get() function:
>> +
>> +            int cma_put(unsigned long addr);
>
> Somebody's been cut-n-pasting a little too quickly...:)

Will fix.

>> +    Creating an allocator for CMA needs four functions to be
>> +    implemented.
>> +
>> +
>> +    The first two are used to initialise an allocator far given driver
>> +    and clean up afterwards:
>> +
>> +            int  cma_foo_init(struct cma_region *reg);
>> +            void cma_foo_done(struct cma_region *reg);
>> +
>> +    The first is called during platform initialisation.  The
>> +    cma_region structure has saved starting address of the region as
>> +    well as its size.  It has also alloc_params field with optional
>> +    parameters passed via command line (allocator is free to interpret
>> +    those in any way it pleases).  Any data that allocate associated
>> +    with the region can be saved in private_data field.
>> +
>> +    The second call cleans up and frees all resources the allocator
>> +    has allocated for the region.  The function can assume that all
>> +    chunks allocated form this region have been freed thus the whole
>> +    region is free.
>> +
>> +
>> +    The two other calls are used for allocating and freeing chunks.
>> +    They are:
>> +
>> +            struct cma_chunk *cma_foo_alloc(struct cma_region *reg,
>> +                                            unsigned long size,
>> +                                            unsigned long alignment);
>> +            void cma_foo_free(struct cma_chunk *chunk);
>> +
>> +    As names imply the first allocates a chunk and the other frees
>> +    a chunk of memory.  It also manages a cma_chunk object
>> +    representing the chunk in physical memory.
>> +
>> +    Either of those function can assume that they are the only thread
>> +    accessing the region.  Therefore, allocator does not need to worry
>> +    about concurrency.
>> +
>> +
>> +    When allocator is ready, all that is left is register it by adding
>> +    a line to "mm/cma-allocators.h" file:
>> +
>> +            CMA_ALLOCATOR("foo", foo)
>> +
>> +    The first "foo" is a named that will be available to use with
>> +    command line argument.  The second is the part used in function
>> +    names.

> This is a bit of an awkward way to register new allocators.  Why not just
> have new allocators fill in an operations structure can call something like
> cma_allocator_register() at initialization time?  That would let people
> write allocators as modules and would eliminate the need to add allocators
> to a central include file.  It would also get rid of some ugly and (IMHO)
> unnecessary preprocessor hackery.

At the moment the list of allocators has to be available early during boot up.
This is because regions are initialised (that is allocators are attached to
regions) from initcall (subsys_initcall to be precise).  This means
allocators cannot be modules (ie. they cannot be dynamically loaded) but
only compiled in.  Because of all those, I decided that creating an array with
all allocators would be, maybe not very beautiful, but a good solution.

Even if I were to provide a “cma_register_allocator()” call it would have to be
called before subsys initcalls and as such it would be of little usefulness I
believe.

I agree that it would be nice to be able to have allocators loaded dynamically
but it is not possible as of yet.

>> +** Future work
>> +
>> +    In the future, implementation of mechanisms that would allow the
>> +    free space inside the regions to be used as page cache, filesystem
>> +    buffers or swap devices is planned.  With such mechanisms, the
>> +    memory would not be wasted when not used.
>
> Ouch.  You'd need to be able to evacuate that space again when it's needed,
> or the whole point of CMA has been lost.  Once again, is it worth the
> complexity?

I believe it is.  All of the regions could well take like 64M or so.  If most
of the times the device drivers would not be used the space would be wasted.
If, instead, it could be used for some read-only data or other data that is
easy to remove from memory the whole system could benefit.

Still, this is a future work so for now it's in the dominion of dreams and
good-night stories. ;)  Bottom line is, we will think about it when the time
will come.

>> diff --git a/include/linux/cma-int.h b/include/linux/cma-int.h
>> new file mode 100644
>> index 0000000..b588e9b
>> --- /dev/null
>> +++ b/include/linux/cma-int.h
>
>> +struct cma_region {
>> +	const char *name;
>> +	unsigned long start;
>> +	unsigned long size, free_space;
>> +	unsigned long alignment;
>> +
>> +	struct cma_allocator *alloc;
>> +	const char *alloc_name;
>> +	const char *alloc_params;
>> +	void *private_data;
>> +
>> +	unsigned users;
>> +	/*
>> +	 * Protects the "users" and "free_space" fields and any calls
>> +	 * to allocator on this region thus guarantees only one call
>> +	 * to allocator will operate on this region..
>> +	 */
>> +	struct mutex mutex;
>> +};

> The use of mutexes means that allocation/free functions cannot be called
> from atomic context.  Perhaps that will never be a problem, but it might
> also be possible to use spinlocks instead?

Mutexes should not be a problem.  In all use cases that we came up with,
allocation and freeing was done from user context when some operation
is initialised.  User launches an application to record video with a
camera or launches a video player and at this moment buffers are
initialised.  We don't see any use case where CMA would be used from
an interrupt or some such.

At the same time, the use of spinlocks would limit allocators (which is
probably a minor issue) but what's more it would limit our possibility to
use unused space of the regions for page cache/buffers/swap/you-name-it.

In general, I believe that requiring that cma_alloc()/cma_put() cannot be
called from atomic context have more benefits then drawbacks (the latter
could check if it is called from atomic context and if so let a worker do
the actual freeing if there would be cases where it would be nice to use
cma_put() in atomic context).

>> diff --git a/mm/cma-allocators.h b/mm/cma-allocators.h
>> new file mode 100644
>> index 0000000..564f705
>> --- /dev/null
>> +++ b/mm/cma-allocators.h
>> @@ -0,0 +1,42 @@
>> +#ifdef __CMA_ALLOCATORS_H
>> +
>> +/* List all existing allocators here using CMA_ALLOCATOR macro. */
>> +
>> +#ifdef CONFIG_CMA_BEST_FIT
>> +CMA_ALLOCATOR("bf", bf)
>> +#endif
>
> This is the kind of thing I think it would be nice to avoid; is there any
> real reason why allocators need to be put into this central file?
>
> This is some weird ifdef stuff as well; it processes the CMA_ALLOCATOR()
> invocations if it's included twice?

I wanted to make registering of entries in the array as easy as possible.
The idea is that allocator authors just add a single line to the file and
do not have to worry about the rest.  To put it in other words, add a line
and do not worry about how it works. ;)

>> +
>> +#  undef CMA_ALLOCATOR
>> +#else
>> +#  define __CMA_ALLOCATORS_H
>> +
>> +/* Function prototypes */
>> +#  ifndef __LINUX_CMA_ALLOCATORS_H
>> +#    define __LINUX_CMA_ALLOCATORS_H
>> +#    define CMA_ALLOCATOR(name, infix)				\
>> +	extern int cma_ ## infix ## _init(struct cma_region *);		\
>> +	extern void cma_ ## infix ## _cleanup(struct cma_region *);	\
>> +	extern struct cma_chunk *					\
>> +	cma_ ## infix ## _alloc(struct cma_region *,			\
>> +			      unsigned long, unsigned long);		\
>> +	extern void cma_ ## infix ## _free(struct cma_chunk *);
>> +#    include "cma-allocators.h"
>> +#  endif
>> +
>> +/* The cma_allocators array */
>> +#  ifdef CMA_ALLOCATORS_LIST
>> +#    define CMA_ALLOCATOR(_name, infix) {		\
>> +		.name    = _name,			\
>> +		.init    = cma_ ## infix ## _init,	\
>> +		.cleanup = cma_ ## infix ## _cleanup,	\
>> +		.alloc   = cma_ ## infix ## _alloc,	\
>> +		.free    = cma_ ## infix ## _free,	\
>> +	},
>
> Different implementations of the macro in different places in the same
> kernel can cause confusion.  To what end?  As I said before, a simple
> registration function called by the allocators would eliminate the need for
> this kind of stuff.

Yes, it would, expect at the moment, a registration function may be not
the best option...  I'm still trying to think how it could work (dynamic
allocators that is).

>> diff --git a/mm/cma-best-fit.c b/mm/cma-best-fit.c
>
> [...]
>
>> +int cma_bf_init(struct cma_region *reg)
>> +{
>> +	struct cma_bf_private *prv;
>> +	struct cma_bf_item *item;
>> +
>> +	prv = kzalloc(sizeof *prv, GFP_NOWAIT);
>> +	if (unlikely(!prv))
>> +		return -ENOMEM;
>
> I'll say this once, but the comment applies all over this code: I hate it
> when people go nuts with likely/unlikely().  This is an initialization
> function, we don't actually care if the branch prediction gets it wrong.
> Classic premature optimization.  The truth of the matter is that
> *programmers* often get this wrong.  Have you profiled all these
> ocurrences?  Maybe it would be better to take them out?

My rule of thumbs is that errors are unlikely and I use that consistently
among all of my code.  The other rational is that we want error-free code
to work as fast as possible letting the error-recovery path be slower.

>> +struct cma_chunk *cma_bf_alloc(struct cma_region *reg,
>> +			       unsigned long size, unsigned long alignment)
>> +{
>> +	struct cma_bf_private *prv = reg->private_data;
>> +	struct rb_node *node = prv->by_size_root.rb_node;
>> +	struct cma_bf_item *item = NULL;
>> +	unsigned long start, end;
>> +
>> +	/* First first item that is large enough */
>> +	while (node) {
>> +		struct cma_bf_item *i =
>> +			rb_entry(node, struct cma_bf_item, by_size);
>
> This is about where I start to wonder about locking.  I take it that the
> allocator code is relying upon locking at the CMA level to prevent
> concurrent calls?  If so, it would be good to document what guarantees the
> CMA level provides.

The cma-int.h says:

> /**
> * struct cma_allocator - a CMA allocator.
[...]
> * @alloc:	Allocates a chunk of memory of given size in bytes and
> * 		with given alignment.  Alignment is a power of
> * 		two (thus non-zero) and callback does not need to check it.
> * 		May also assume that it is the only call that uses given
> * 		region (ie. access to the region is synchronised with
> * 		a mutex).  This has to allocate the chunk object (it may be
> * 		contained in a bigger structure with allocator-specific data.
> * 		May sleep.
> * @free:	Frees allocated chunk.  May also assume that it is the only
> * 		call that uses given region.  This has to kfree() the chunk
> * 		object as well.  May sleep.
> */

Do you think that it needs more clarification?  In more places?  If so where?

>> +/************************* Basic Tree Manipulation *************************/
>> +
>> +#define __CMA_BF_HOLE_INSERT(root, node, field) ({			\
>> +	bool equal = false;						\
>> +	struct rb_node **link = &(root).rb_node, *parent = NULL;	\
>> +	const unsigned long value = item->field;			\
>> +	while (*link) {							\
>> +		struct cma_bf_item *i;					\
>> +		parent = *link;						\
>> +		i = rb_entry(parent, struct cma_bf_item, node);		\
>> +		link = value <= i->field				\
>> +			? &parent->rb_left				\
>> +			: &parent->rb_right;				\
>> +		equal = equal || value == i->field;			\
>> +	}								\
>> +	rb_link_node(&item->node, parent, link);			\
>> +	rb_insert_color(&item->node, &root);				\
>> +	equal;								\
>> +})
>
> Is there a reason why this is a macro?  The code might be more readable if
> you just wrote out the two versions that you need.

I didn't want to duplicate the code but will fix per request.

>> diff --git a/mm/cma.c b/mm/cma.c
>> new file mode 100644
>> index 0000000..6a0942f
>> --- /dev/null
>> +++ b/mm/cma.c
>
> [...]
>
>> +static const char *__must_check
>> +__cma_where_from(const struct device *dev, const char *kind)
>> +{
>> +	/*
>> +	 * This function matches the pattern given at command line
>> +	 * parameter agains given device name and kind.  Kind may be
>> +	 * of course NULL or an emtpy string.
>> +	 */
>> +
>> +	const char **spec, *name;
>> +	int name_matched = 0;
>> +
>> +	/* Make sure dev was given and has name */
>> +	if (unlikely(!dev))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	name = dev_name(dev);
>> +	if (WARN_ON(!name || !*name))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/* kind == NULL is just like an empty kind */
>> +	if (!kind)
>> +		kind = "";
>> +
>> +	/*
>> +	 * Now we go throught the cma_map array.  It is an array of
>> +	 * pointers to chars (ie. array of strings) so in each
>> +	 * iteration we take each of the string.  The strings is
>> +	 * basically what user provided at the command line separated
>> +	 * by semicolons.
>> +	 */
>> +	for (spec = cma_map; *spec; ++spec) {
>> +		/*
>> +		 * This macro tries to match pattern pointed by s to
>> +		 * @what.  If, while reading the spec, we ecnounter
>> +		 * comma it means that the pattern does not match and
>> +		 * we need to start over with another spec.  If there
>> +		 * is a character that does not match, we neet to try
>> +		 * again looking if there is another spec.
>> +		 */
>> +#define TRY_MATCH(what) do {				\
>> +		const char *c = what;			\
>> +		for (; *s != '*' && *c; ++c, ++s)	\
>> +			if (*s == ',')			\
>> +				goto again;		\
>> +			else if (*s != '?' && *c != *s)	\
>> +				goto again_maybe;	\
>> +		if (*s == '*')				\
>> +			++s;				\
>> +	} while (0)

> This kind of thing rarely contributes to the readability or maintainability
> of the code.  Is it really necessary?  Or (as asked before) is all this
> functionality really necessary?

Removed the macro.  As of whether the functionality is needed, as explained
above, I believe it is.

> One other comment: it might be nice if drivers could provide allocation
> regions of their own.  The viafb driver, for example, really needs an
> allocator to hand out chunks of framebuffer memory - including large chunks
> for things like video frames.  If that driver could hand responsibility
> for that over to CMA, it could eliminate the need for yet another
> driver-quality memory manager.

Are we talking about viafb having access to some “magic” memory known only for
itself?  If so, it should be fairly easy to let drivers add their own, already
reserved regions.  As a matter of fact, the region could be completely unnamed
and private for the device, ie:

	... device reserves some memory ...
	struct cma_region *reg = kmalloc(sizeof *reg, GFP_KERNEL);

	reg->size  = ... size ...;
	reg->start = ... start ...;
	reg->alloc_name = ... allocator name or NULL ...;

	ret = cma_region_init(reg);
	if (ret)
		/* Failed to initialise */
		return ret;

and then later, when allocating:

	addr = cma_alloc_from_region(reg, ... size ..., ... alignment ...);

and when unloading:

	cma_region_cleanup(reg);

what do you think?

On Wed, 21 Jul 2010 02:12:39 +0200, Jonathan Corbet <corbet@lwn.net> wrote:
> One other thing occurred to me as I was thinking about this...

>> +    There are four calls provided by the CMA framework to devices.  To
>> +    allocate a chunk of memory cma_alloc() function needs to be used:
>> +
>> +            unsigned long cma_alloc(const struct device *dev,
>> +                                    const char *kind,
>> +                                    unsigned long size,
>> +                                    unsigned long alignment);
>
> The purpose behind this interface, I believe, is pretty much always
> going to be to allocate memory for DMA buffers.  Given that, might it
> make more sense to integrate the API with the current DMA mapping API?
> Then the allocation function could stop messing around with long values
> and, instead, just hand back a void * kernel-space pointer and a
> dma_addr_t to hand to the device.  That would make life a little easier
> in driverland...

In our use cases mapping the region was never needed.  It is mostly used
with V4L which handles mapping, cache coherency, etc.  It also is outside
of the scope of the CMA framework.

As of changing the type to dma_addr_t it may be a good idea, I'm going to
change that.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
