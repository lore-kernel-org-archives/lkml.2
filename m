Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2JBSRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:17:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62288 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2JBSQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:16:56 -0400
Date: Tue, 2 Oct 2012 11:16:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jan Beulich <JBeulich@suse.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Jamie Gloudon <jamie.gloudon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: x86_64: wrong DirectMap kB
In-Reply-To: <506B141F020000780009F19A@nat28.tlf.novell.com>
Message-ID: <alpine.LSU.2.00.1210021048110.1348@eggly.anvils>
References: <alpine.LSU.2.00.1210010116570.6566@eggly.anvils> <506B141F020000780009F19A@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Jan Beulich wrote:
> >>> On 01.10.12 at 10:37, Hugh Dickins <hughd@google.com> wrote:
> > I noticed yesterday that the DirectMap counts at the bottom of x86_64's
> > /proc/meminfo are wrong on v3.5 and v3.6.  For example, I happen to have
> > booted this laptop with mem=700M to run a test, but /proc/meminfo shows
> > 
> > DirectMap4k:        4096 kB
> > DirectMap2M:    18446744073709547520 kB
> 
> I cannot see such odd effect with "mem="; with I can (for any
                               without
> value up to around 1G).

Yes, only with a small "mem=" was my 2M number so low that it actually
wrapped around to look so obviously wrong - I presume once pat came to
carve a piece out of 0.

But even without "mem=" the DirectMap numbers were wrong, adding up
to less than the MemTotal: I did show numbers to make that clearer to
Jamie yesterday, but missed that all but lkml had dropped from the Cc.

> 
> > Or if I boot with the full amount of physical memory, the DirectMap
> > numbers do not add up to the full amount of physical memory, as they
> > used to do on v3.4 and before.
> 
> That one I can see how could have happened, in that said patch
> went a little too far: Dropping the "pages" increments from
> phys_p[um]d_init() is necessary only for the hotplug case (as
> otherwise duplicating accounting already done earlier), while
> at boot time we would want to do the accounting.
> 
> > Whilst I've not yet tried reverting it, I strongly suspect your
> > 20167d3421a0 "x86-64: Fix accounting in kernel_physical_mapping_init()".
> > 
> > Either it was a complete misunderstanding, totally bogus, and should
> > simply be reverted; or perhaps you really noticed something wrong in
> > your code inspection, but didn't get the fix quite right?
> 
> The latter, apparently. The patch below should fix both aspects.

Thanks, Jan, certainly this patch puts my "mem=700M" DirectMap numbers
back to exactly what I would expect; and without any "mem=", the ~8GB
total of DirectMap4k and DirectMap2M back to what it was with v3.4.

I'm wording it like that because these days I see 2048 kB of 4k instead
of 4096 kB of 4k, but that's most probably due to other differences.

Hugh

> 
> Jan
> 
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
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
