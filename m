Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2GCUTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:19:06 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56432 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298Ab2GCUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120703011750.GA19682@herton-Z68MA-D2H-B3>
References: <20120701172006.535271340@decadent.org.uk>
	<20120701172007.694144055@decadent.org.uk>
	<20120702234610.GB3552@herton-Z68MA-D2H-B3>
	<20120702235631.GC3552@herton-Z68MA-D2H-B3>
	<20120703011750.GA19682@herton-Z68MA-D2H-B3>
Date: Tue, 3 Jul 2012 13:19:01 -0700
Message-ID: <CALnjE+q8T=Lr4fYQUoex5Amhdjv4Jw6UyJ2f0PaiXBZigf6fXQ@mail.gmail.com>
Subject: Re: [ 07/48] mm: fix slab->page _count corruption when using slub
From: Pravin Shelar <pshelar@nicira.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amey Bhide <abhide@nicira.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying just this patch does not solve whole problem. There is
another patch which needs to be backported. Discussion on that is not
concluded yet. so I think we can drop this patch for now.
ref : http://www.vacationhomexchg.com/lists/linux-mm/msg36054.html

Thanks,
Pravin.

On Mon, Jul 2, 2012 at 6:17 PM, Herton Ronaldo Krzesinski
<herton.krzesinski@canonical.com> wrote:
> On Mon, Jul 02, 2012 at 08:56:32PM -0300, Herton Ronaldo Krzesinski wrote:
>> So, 3.2 didn't have the CONFIG_HAVE_CMPXCHG_DOUBLE and
>> CONFIG_HAVE_ALIGNED_STRUCT_PAGE defines, it had instead CMPXCHG_DOUBLE
>> and HAVE_ALIGNED_STRUCT_PAGE is a new logic. So the patch is broken for
>> 3.2 indeed.
>
> So here is a proposed backport for 3.2, I tested it etc., but please
> someone review/ack it as well...
>
> From: Pravin B Shelar <pshelar@nicira.com>
> Subject: mm: fix slab->page _count corruption when using slub
>
> commit abca7c4965845924f65d40e0aa1092bdd895e314 upstream.
>
> On arches that do not support this_cpu_cmpxchg_double() slab_lock is used
> to do atomic cmpxchg() on double word which contains page->_count.  The
> page count can be changed from get_page() or put_page() without taking
> slab_lock.  That corrupts page counter.
>
> Fix it by moving page->_count out of cmpxchg_double data.  So that slub
> does no change it while updating slub meta-data in struct page.
>
> [akpm@linux-foundation.org: use standard comment layout, tweak comment text]
> Reported-by: Amey Bhide <abhide@nicira.com>
> Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> [herton: backport to 3.2, use CONFIG_CMPXCHG_DOUBLE]
> Signed-off-by: Herton R. Krzesinski <herton@canonical.com>
> ---
>  include/linux/mm_types.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5b42f1b..2153639 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -56,8 +56,17 @@ struct page {
>                 };
>
>                 union {
> +#ifdef CONFIG_CMPXCHG_DOUBLE
>                         /* Used for cmpxchg_double in slub */
>                         unsigned long counters;
> +#else
> +                       /*
> +                        * Keep _count separate from slub cmpxchg_double data.
> +                        * As the rest of the double word is protected by
> +                        * slab_lock but _count is not.
> +                        */
> +                       unsigned counters;
> +#endif
>
>                         struct {
>
> --
> 1.7.9.5
>
>
> --
> []'s
> Herton
