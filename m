Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0EASsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:48:38 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:58886 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab0EASsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:48:35 -0400
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 May 2010 14:48:35 EDT
Date: Sat, 1 May 2010 21:35:44 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Imre Deak <imre.deak@nokia.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] create generic alignment api (v5)
Message-ID: <20100501183544.GC27062@shisha.kicks-ass.net>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Imre Deak <imre.deak@nokia.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Jamie Lokier <jamie@shareable.org>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100328012247.GA17763@Krystal>
 <20100328154029.GA21061@localhost>
 <20100329000900.GB27379@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329000900.GB27379@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 08:09:00 -0400, Mathieu Desnoyers wrote:
> Rather than re-doing the "alignment on a type size" trick all over again at
> different levels, import the "ltt_align" from LTTng into kernel.h and make this
> available to everyone. Renaming to:
> 
> - object_align()
> - object_align_floor()
> - offset_align()
> - offset_align_floor()

Do you plan to have this integrated to the mainline? I'd like to use one of
these in my next version of the __xchg patch. So, do you need any help or
feedback or whatnot with this one?

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
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Alexander Shishkin <virtuoso@slind.org>,
> CC: linux-arm-kernel@lists.infradead.org
> CC: Imre Deak <imre.deak@nokia.com>
> CC: Jamie Lokier <jamie@shareable.org>
> CC: rostedt@goodmis.org
> CC: mingo@elte.hu

Acked-by: Alexander Shishkin <virtuoso@slind.org>

> ---
>  include/linux/kernel.h |   45 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/kernel.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/kernel.h	2010-03-27 20:46:07.000000000 -0400
> +++ linux-2.6-lttng/include/linux/kernel.h	2010-03-28 20:06:27.000000000 -0400
> @@ -37,10 +37,47 @@ extern const char linux_proc_banner[];
>  
>  #define STACK_MAGIC	0xdeadbeef
>  
> -#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
> -#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> -#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
> -#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
> +#define ALIGN(x, a)		__ALIGN_MASK((x), (typeof(x)) (a) - 1)
> +#define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
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
> +#define object_align(obj)	PTR_ALIGN((obj), sizeof(*(obj)))
> +#define object_align_floor(obj)	PTR_ALIGN_FLOOR((obj), sizeof(*(obj)))
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
>  
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
