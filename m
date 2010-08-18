Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0HRABE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:01:04 -0400
Received: from shutemov.name ([188.40.19.243]:53914 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0HRAA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:00:58 -0400
Date: Wed, 18 Aug 2010 03:00:56 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Imre Deak <imre.deak@nokia.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tom Zanussi <tzanussi@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jamie Lokier <jamie@shareable.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 01/20] Create generic alignment API (v8)
Message-ID: <20100818000056.GA5874@shutemov.name>
References: <20100817231619.277457797@efficios.com>
 <20100817232150.251244768@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817232150.251244768@efficios.com>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:16:20PM -0400, Mathieu Desnoyers wrote:
> Rather than re-doing the "alignment on a type size" trick all over again at
> different levels, import the "ltt_align" from LTTng into kernel.h and make this
> available to everyone. Renaming to:
> 
> - object_align()
> - object_align_floor()
> - offset_align()
> - offset_align_floor()
> 
> Changelog since v7:
> - Add missing include/linux/Kconfig header-y.
> 
> Changelog since v6:
> - Adapt to changes introduced by
>   commit a79ff731a1b277d0e92d9453bdf374e04cec717a
> - Use __alignof__() instead of sizeof() to support compound types.
> 
> Changelog since v5:
> - moved alignment apis to a separate header file so that it is possible
>   to use them from other header files which are, for example, included
>   from kernel.h.
> 
> Changelog since v4:
> - add missing ( ) around parameters within object_align() and
>   object_align_floor().
> - More coding style cleanups to ALIGN() (checkpatch.pl is happy now).
> 
> Changelog since v3:
> - optimize object_align*() so fewer instructions are needed for alignment of
>   addresses known dynamically. Use the (already existing) "ALIGN()", and create
>   the "ALIGN_FLOOR()" macro.
> - While we are there, let's clean up the ALIGN() macros wrt coding style. e.g.
>   missing parenthesis around the first use of the "x" parameter in ALIGN().
> 
> Changelog since v2:
> - Fix object_align*(): should use object size alignment, not pointer alignment.
> 
> Changelog since v1:
> - Align on the object natural alignment
>     (rather than min(arch word alignment, natural alignment))
> 
> The advantage of separating the API in "object alignment" and "offset alignment"
> is that it gives more freedom to play with offset alignment. Very useful to
> implement a tracer ring-buffer alignment. (hint hint)
> 
> Typical users will use "object alignment", but infrastructures like tracers
> which need to perform alignment of statically known base+offsets will typically
> use "offset alignment", because it allows to align with respect to a base rather
> than to pass an absolute address.
> 
> We use "sizeof(object)" rather than "__alignof__()" object because alignof
> returns "recommended" object alignment for the architecture, which can be
> sub-optimal on some architectures. By ensuring alignment on the object size, we
> are sure to make the right choice.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
> CC: linux-arm-kernel@lists.infradead.org
> CC: Imre Deak <imre.deak@nokia.com>
> CC: Jamie Lokier <jamie@shareable.org>
> CC: rostedt@goodmis.org
> CC: mingo@elte.hu
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  include/linux/Kbuild   |    1 
>  include/linux/align.h  |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/kernel.h |    8 -------
>  3 files changed, 58 insertions(+), 7 deletions(-)
>  create mode 100644 include/linux/align.h
> 
> Index: linux.trees.git/include/linux/align.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux.trees.git/include/linux/align.h	2010-08-17 16:31:50.000000000 -0400
> @@ -0,0 +1,56 @@
> +#ifndef _LINUX_ALIGN_H
> +#define _LINUX_ALIGN_H
> +
> +#define __ALIGN_KERNEL(x, a)	__ALIGN_KERNEL_MASK((x), (typeof(x))(a) - 1)
                                                    ^^^
Unnecessary braces. And many below.

> +#define __ALIGN_KERNEL_MASK(x, mask) \
> +				(((x) + (mask)) & ~(mask))
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +
> +#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> +#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
> +#define PTR_ALIGN(p, a)		((typeof(p)) ALIGN((unsigned long) (p), (a)))
> +#define ALIGN_FLOOR(x, a)	__ALIGN_FLOOR_MASK((x), (typeof(x)) (a) - 1)
> +#define __ALIGN_FLOOR_MASK(x, mask)	((x) & ~(mask))
> +#define PTR_ALIGN_FLOOR(p, a) \
> +			((typeof(p)) ALIGN_FLOOR((unsigned long) (p), (a)))
> +#define IS_ALIGNED(x, a)	(((x) & ((typeof(x)) (a) - 1)) == 0)
> +
> +/*
> + * Align pointer on natural object alignment. Object size must be power of two.
> + */
> +#define object_align(obj)	PTR_ALIGN((obj), __alignof__(*(obj)))
> +#define object_align_floor(obj)	PTR_ALIGN_FLOOR((obj), __alignof__(*(obj)))
> +
> +/**
> + * offset_align - Calculate the offset needed to align an object on its natural
> + *                alignment towards higher addresses.
> + * @align_drift:  object offset from an "alignment"-aligned address.
> + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> + *
> + * Returns the offset that must be added to align towards higher
> + * addresses.
> + */
> +static inline size_t offset_align(size_t align_drift, size_t alignment)
> +{
> +	return (alignment - align_drift) & (alignment - 1);
> +}
> +
> +/**
> + * offset_align_floor - Calculate the offset needed to align an object
> + *                      on its natural alignment towards lower addresses.
> + * @align_drift:  object offset from an "alignment"-aligned address.
> + * @alignment:    natural object alignment. Must be non-zero, power of 2.
> + *
> + * Returns the offset that must be substracted to align towards lower addresses.
> + */
> +static inline size_t offset_align_floor(size_t align_drift, size_t alignment)
> +{
> +	return (align_drift - alignment) & (alignment - 1);
> +}
> +
> +#endif /* __KERNEL__ */
> +
> +#endif
> Index: linux.trees.git/include/linux/kernel.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/kernel.h	2010-08-17 16:28:25.000000000 -0400
> +++ linux.trees.git/include/linux/kernel.h	2010-08-17 16:31:50.000000000 -0400
> @@ -4,8 +4,7 @@
>  /*
>   * 'kernel.h' contains some often-used function prototypes etc
>   */
> -#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> -#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
> +#include <linux/align.h>
>  
>  #ifdef __KERNEL__
>  
> @@ -39,11 +38,6 @@ extern const char linux_proc_banner[];
>  
>  #define STACK_MAGIC	0xdeadbeef
>  
> -#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
> -#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
> -#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
> -#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
> -
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
>  /*
> Index: linux.trees.git/include/linux/Kbuild
> ===================================================================
> --- linux.trees.git.orig/include/linux/Kbuild	2010-08-17 16:28:25.000000000 -0400
> +++ linux.trees.git/include/linux/Kbuild	2010-08-17 16:32:30.000000000 -0400
> @@ -38,6 +38,7 @@ header-y += adfs_fs.h
>  header-y += affs_hardblocks.h
>  header-y += agpgart.h
>  header-y += aio_abi.h
> +header-y += align.h
>  header-y += apm_bios.h
>  header-y += arcfb.h
>  header-y += atalk.h
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
 Kirill A. Shutemov
