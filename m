Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2JJWHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:07:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59709 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab2JJWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:07:21 -0400
Date: Wed, 10 Oct 2012 15:07:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix page table accounting
In-Reply-To: <506DAFBA020000780009FA8C@nat28.tlf.novell.com>
Message-ID: <alpine.LSU.2.00.1210101458310.2002@eggly.anvils>
References: <506DAFBA020000780009FA8C@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Jan Beulich wrote:

> Commit 20167d3421a089a1bf1bd680b150dc69c9506810 ("x86-64: Fix
> accounting in kernel_physical_mapping_init()") went a little too far
> by entirely removing the counting of pre-populated page tables: This
> should be done at boot time (to cover the page tables set up in early
> boot code), but shouldn't be done during memory hot add.
> 
> Hence, re-add the removed increments of "pages", but make them and the
> one in phys_pte_init() conditional upon !after_bootmem.
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

I think this has not yet been picked up: perhaps it's awaiting an
Acked-by: Hugh Dickins <hughd@google.com>
or a
Tested-by: Hugh Dickins <hughd@google.com>
but I hesitated to give those because you understand what's going
on here much better than I pretend to.

> 
> ---
> Not sure if this ought to be copied to stable@.

I guess not.  Much as I like my kernels to show good meminfo numbers,
I was recently saying that David Rientjes's patches to get Unevictable
and Mlocked right were not important enough for stable, and I think
those numbers are more interesting to most people than the DirectMaps.
But I'd be happily overruled on all three patches.

Hugh

> 
> ---
>  arch/x86/mm/init_64.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- 3.6/arch/x86/mm/init_64.c
> +++ 3.6-x86_64-page-table-count/arch/x86/mm/init_64.c
> @@ -386,7 +386,8 @@ phys_pte_init(pte_t *pte_page, unsigned
>  		 * these mappings are more intelligent.
>  		 */
>  		if (pte_val(*pte)) {
> -			pages++;
> +			if (!after_bootmem)
> +				pages++;
>  			continue;
>  		}
>  
> @@ -451,6 +452,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
>  			 * attributes.
>  			 */
>  			if (page_size_mask & (1 << PG_LEVEL_2M)) {
> +				if (!after_bootmem)
> +					pages++;
>  				last_map_addr = next;
>  				continue;
>  			}
> @@ -526,6 +529,8 @@ phys_pud_init(pud_t *pud_page, unsigned
>  			 * attributes.
>  			 */
>  			if (page_size_mask & (1 << PG_LEVEL_1G)) {
> +				if (!after_bootmem)
> +					pages++;
>  				last_map_addr = next;
>  				continue;
>  			}
