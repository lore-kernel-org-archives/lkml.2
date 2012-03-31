Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838Ab2CaMJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:09:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37466 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab2CaMJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <201203301941.q2UJfo11007111@farm-0012.internal.tilera.com>
References: <201203301941.q2UJfo11007111@farm-0012.internal.tilera.com>
Date: Sat, 31 Mar 2012 20:09:29 +0800
Message-ID: <CAJd=RBDWhNmeqPE=PGWmma63LATOY=mhQ14E1j+y9Kxnznrzww@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: support multiple huge page sizes dynamically
From: Hillf Danton <dhillf@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris

On Sat, Mar 31, 2012 at 3:37 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change adds support for a new "super" bit in the tile PTE, and a
> new arch_make_huge_pte() method called from make_huge_pte().
> The Tilera hypervisor sees the bit set at a given level of the page
> table and gangs together 4, 16, or 64 consecutive pages from
> that level of the hierarchy to create a larger TLB entry.
>
> One extra "super" page size can be specified at each of the
> three levels of the page table hierarchy on tilegx, using the
> "hugepagesz" argument on the boot command line.  A new hypervisor
> API is added to allow Linux to tell the hypervisor how many PTEs
> to gang together at each level of the page table.
>
> To allow pre-allocating huge pages larger than the buddy allocator
> can handle, this change modifies the Tilera bootmem support to
> put all of memory on tilegx platforms into bootmem.
>
> As part of this change I eliminate the vestigial CONFIG_HIGHPTE
> support, which never worked anyway, and eliminate the hv_page_size()
> API in favor of the standard vma_kernel_pagesize() API.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---

[...]

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a876871..4531be2 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2123,6 +2123,9 @@ static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
>        }
>        entry = pte_mkyoung(entry);
>        entry = pte_mkhuge(entry);
> +#ifdef arch_make_huge_pte
> +       entry = arch_make_huge_pte(entry, vma, page, writable);
> +#endif
>
Would you please make arch_make_huge_pte() the way
that arch_prepare_hugepage() is implemented, or similar?

>        return entry;
>  }
> --
> 1.6.5.2
>
