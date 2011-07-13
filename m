Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab1GML24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:28:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915Ab1GML2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:28:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=UXVfectwwPJQ5Wg3WwMOCXth9lGjhcg2r8SctVTrnThEhw/WFgsnO06D8HAQVGE4y
	C2QJVzbRBHSWChwxBF2TQ==
Date: Wed, 13 Jul 2011 04:28:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.DEB.2.00.1107121046000.2530@router.home>
Message-ID: <alpine.LSU.2.00.1107130357560.4184@sister.anvils>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home> <alpine.DEB.2.00.1107121046000.2530@router.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Christoph Lameter wrote:
> I wish there would be some easier way to overlay fields.

Yes, struct page has become ... a mess.

(I'd use stronger language, but I'm being a little careful at the
moment, not to say something that Andrew might then throw back at
me in our radix-tree discussion ;)

I'd be happy for the 32bit and 64bit cases to be separated entirely,
if that would help seeing their layouts clearly (but I don't think 
that's actually the problem).

It is the (standard e.g. x86_64) 64bit layout to which you are adding
8 bytes, isn't it?  Not in the patch below, but in your cmpxchg_double
slub series.  Which aligns it nicely for everyone, but does use
significantly more mem_map memory - I wonder how many people
have really taken that on board.

> The counters
> field exists to allow an easier reference to the bitfield structure in
> order to pass it to cmpxchg_double_slab.
> 
> In 64 bit the counters field needs to overlay the bitfields and _count
> since we can only pass 64 bits integers to cmpxchg_double_slab.
> 
> On 32 bit counters field only covers the bitfields.
> 
> The "new" page struct in __slab_free is only partially populated and the
> overlays are used for conversion between structs and words in order to be
> able to pass the struct contents by value.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

As I reported in Fengguang's more_io thread, I couldn't get this patch
to apply, unsurprisingly to mmotm, more surprisingly to Pekka's for-next
(which adds in the _count build fix).  Did you try to tidy up the
indentations a little in between?

At the bottom I've put the patch against mmotm which I started testing
instead on ppc64 a few hours ago.  It again seized up in __slab_free()
after two and a half hours.  So either I screwed up my transliteration
of your patch, or your patch is still wrong.  Please check mine out.

Is yours actually tested on PowerPC or ARM, say?  I wonder if you're
making endianness or bitfield ordering assumptions; but I've made no
attempt to work it out.  Anything I can send you?  Disassembly of
__slab_free()?

I didn't actually try the patch on x86 at all.

> 
> ---
>  include/linux/mm_types.h |   22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm_types.h	2011-07-12 10:14:08.057706223 -0500
> +++ linux-2.6/include/linux/mm_types.h	2011-07-12 10:14:14.117706184 -0500
> @@ -56,20 +56,26 @@ struct page {
>  		};
> 
>  		union {
> -			atomic_t _mapcount;	/* Count of ptes mapped in mms,
> +			/* Used for cmpxchg_double in slub */
> +			unsigned long counters;
> +
> +			struct {
> +
> +				union {
> +					atomic_t _mapcount;	/* Count of ptes mapped in mms,
>  							 * to show when page is mapped
>  							 * & limit reverse map searches.
>  							 */
> 
> -			/* Used for cmpxchg_double in slub */
> -			unsigned long counters;
> -			struct {
> -				unsigned inuse:16;
> -				unsigned objects:15;
> -				unsigned frozen:1;
> +					struct {
> +						unsigned inuse:16;
> +						unsigned objects:15;
> +						unsigned frozen:1;
> +					};
> +				};
> +				atomic_t _count;		/* Usage count, see below. */
>  			};
>  		};
> -		atomic_t _count;		/* Usage count, see below. */
>  	};
> 
>  	/* Third double word block */

This is what I tested with: is it what you intended against mmotm?

--- mmotm/include/linux/mm_types.h	2011-07-09 11:25:18.000000000 -0700
+++ linux/include/linux/mm_types.h	2011-07-12 22:04:01.000000000 -0700
@@ -49,30 +49,31 @@ struct page {
 					 * see PAGE_MAPPING_ANON below.
 					 */
 	/* Second double word */
-	union {
-		struct {
+	struct {
+		union {
 			pgoff_t index;		/* Our offset within mapping. */
-			atomic_t _mapcount;	/* Count of ptes mapped in mms,
+			void *freelist;		/* slub first free object */
+		};
+
+		union {
+			/* Used for cmpxchg_double in slub */
+			unsigned long counters;
+
+			struct {
+
+				union {
+					atomic_t _mapcount;	/* Count of ptes mapped in mms,
 							 * to show when page is mapped
 							 * & limit reverse map searches.
 							 */
-			atomic_t _count;		/* Usage count, see below. */
-		};
 
-		struct {			/* SLUB cmpxchg_double area */
-			void *freelist;
-			union {
-				unsigned long counters;
-				struct {
-					unsigned inuse:16;
-					unsigned objects:15;
-					unsigned frozen:1;
-					/*
-					 * Kernel may make use of this field even when slub
-					 * uses the rest of the double word!
-					 */
-					atomic_t _count;
+					struct {
+						unsigned inuse:16;
+						unsigned objects:15;
+						unsigned frozen:1;
+					};
 				};
+				atomic_t _count;		/* Usage count, see below. */
 			};
 		};
 	};
