Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1F3X5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:57:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1F3X5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:57:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 1 Jul 2011 08:50:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
Message-Id: <20110701085013.4e8cbb02.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110630130134.63a1dd37.akpm@linux-foundation.org>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630130134.63a1dd37.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 13:01:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Jun 2011 19:03:25 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Each memory cgroup has 'swappiness' value and it can be accessed by
> > get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> > and swappiness is passed by argument. It's propagated by scan_control.
> > 
> > get_swappiness is static function but some planned updates will need to
> > get swappiness from files other than memcontrol.c
> > This patch exports get_swappiness() as mem_cgroup_swappiness().
> > By this, we can remove the argument of swapiness from try_to_free...
> > and drop swappiness from scan_control. only memcg uses it.
> 
> x86_64 allnoconfig (aka Documentation/SubmitChecklist, section 2b):
> 
> mm/vmscan.c: In function 'vmscan_swappiness':
> mm/vmscan.c:1734: error: implicit declaration of function 'mem_cgroup_swappiness'
> 
> This is pretty broken.  I think we do want to implement this for
> CONFIG_CGROUP_MEM_RES_CTLR=y, CONFIG_SWAP=n:
> 
> --- a/include/linux/swap.h~memcg-export-memory-cgroups-swappiness-fix
> +++ a/include/linux/swap.h
> @@ -365,17 +365,12 @@ static inline void put_swap_token(struct
>  extern void
>  mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
>  extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
> -extern unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem);
>  #else
>  static inline void
>  mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
>  {
>  }
>  
> -static inline unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem)
> -{
> -	return vm_swappiness;
> -}
>  #endif
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
> @@ -510,5 +505,15 @@ mem_cgroup_count_swap_user(swp_entry_t e
>  #endif
>  
>  #endif /* CONFIG_SWAP */
> +
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> +extern unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem);
> +#else
> +static inline unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem)
> +{
> +	return vm_swappiness;
> +}
> +#endif
> +
>  #endif /* __KERNEL__*/
>  #endif /* _LINUX_SWAP_H */
> 
> But what is the role of CONFIG_CGROUP_MEM_RES_CTLR_SWAP?
> 
> And in the above circumstances, vmscan_swappiness() devolves into
> 
> static int vmscan_swappiness(struct scan_control *sc)
> {
>        if (scanning_global_lru(sc))
>                return vm_swappiness;
>        return vm_swappiness;
> }
> 
> which I guess makes sense but seems a bit odd.
> 
> Anyway, my confidence level is low so I think I'll drop this patch. 
> Please have a think about the interplay between
> CONFIG_CGROUP_MEM_RES_CTLR, CONFIG_CGROUP_MEM_RES_CTLR_SWAP and
> CONFIG_SWAP.
> 
> 

Ok, I'll check it. Maybe I miss !CONFIG_SWAP...

Thanks,
-Kame

