Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1GGNO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:14:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab1GGNO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:14:57 -0400
Date: Thu, 7 Jul 2011 15:14:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: wzt <wzt.wzt@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
Message-ID: <20110707131455.GB4078@tiehlicka.suse.cz>
References: <20110705062148.GA6056@program>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705062148.GA6056@program>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-07-11 14:21:48, wzt wrote:
> Fix memory leak of init_vdso_vars().
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

The patch looks correct but it could be cleaned up a bit IMO.
See bellow.

> 
> ---
>  arch/x86/vdso/vma.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 4b5d26f..c6b0308 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -44,19 +44,19 @@ static int __init init_vdso_vars(void)
>  	vdso_size = npages << PAGE_SHIFT;
>  	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
>  	if (!vdso_pages)
> -		goto oom;
> +		goto oom1;

I wouldn't rename the label. It just makes the patch bigger for no good
reason. The new naming is not anyhow useful.

>  	for (i = 0; i < npages; i++) {
>  		struct page *p;
>  		p = alloc_page(GFP_KERNEL);
>  		if (!p)
> -			goto oom;
> +			goto oom2;

Waht about goto oom_free_pages instead?

>  		vdso_pages[i] = p;
>  		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
>  	}
>  
>  	vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
>  	if (!vbase)
> -		goto oom;
> +		goto oom2;
>  
>  	if (memcmp(vbase, "\177ELF", 4)) {
>  		printk("VDSO: I'm broken; not ELF\n");
> @@ -70,7 +70,13 @@ static int __init init_vdso_vars(void)
>  	vunmap(vbase);
>  	return 0;
>  
> - oom:
> +oom2:
> +	i--;
> +	for (; i >= 0; i--)
> +		__free_page(vdso_pages[i]);

Why not 
	for (; i > 0; i--)
		__free_page(vdso_pages[i-1]);

> +	__free_page(vdso_pages);
> +
> +oom1:
>  	printk("Cannot allocate vdso\n");
>  	vdso_enabled = 0;
>  	return -ENOMEM;

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
