Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1LAOTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:19:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab1LAOTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:19:43 -0500
Date: Thu, 1 Dec 2011 15:19:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/3] frv: remove irqsave pgd_lock locking
Message-ID: <20111201141941.GA4490@tiehlicka.suse.cz>
References: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On Wed 09-11-11 16:47:17, Michal Hocko wrote:
> a79e53d8: x86/mm: Fix pgd_lock deadlock dropped irqsave locking to fix a
> deadlock. pgd_lock is not used from an irq context so we can drop
> irqsave locking here as well.
> The original patch was x86 only but the same applies here because both
> pgd_ctor (aka mm_alloc_pgd) and pgd_dtor (aka mm_free_pgd) are not used
> from an interrupt contexts.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/frv/mm/pgalloc.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
> index 4fb63a3..9df65c6 100644
> --- a/arch/frv/mm/pgalloc.c
> +++ b/arch/frv/mm/pgalloc.c
> @@ -104,10 +104,8 @@ static inline void pgd_list_del(pgd_t *pgd)
>  
>  void pgd_ctor(void *pgd)
>  {
> -	unsigned long flags;
> -
>  	if (PTRS_PER_PMD == 1)
> -		spin_lock_irqsave(&pgd_lock, flags);
> +		spin_lock(&pgd_lock);
>  
>  	memcpy((pgd_t *) pgd + USER_PGDS_IN_LAST_PML4,
>  	       swapper_pg_dir + USER_PGDS_IN_LAST_PML4,
> @@ -117,18 +115,16 @@ void pgd_ctor(void *pgd)
>  		return;
>  
>  	pgd_list_add(pgd);
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	spin_unlock(&pgd_lock);
>  	memset(pgd, 0, USER_PGDS_IN_LAST_PML4 * sizeof(pgd_t));
>  }
>  
>  /* never called when PTRS_PER_PMD > 1 */
>  void pgd_dtor(void *pgd)
>  {
> -	unsigned long flags; /* can be called from interrupt context */
> -
> -	spin_lock_irqsave(&pgd_lock, flags);
> +	spin_lock(&pgd_lock);
>  	pgd_list_del(pgd);
> -	spin_unlock_irqrestore(&pgd_lock, flags);
> +	spin_unlock(&pgd_lock);
>  }
>  
>  pgd_t *pgd_alloc(struct mm_struct *mm)
> -- 
> 1.7.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
