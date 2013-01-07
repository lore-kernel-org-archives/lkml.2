Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3AGONl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:13:41 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:49970 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3AGONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:13:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Date: Mon, 07 Jan 2013 15:15:16 +0100
Message-ID: <3603534.Q7XcdlK8lK@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121216200446.GF4939@ZenIV.linux.org.uk>
References: <20121215201237.GW4939@ZenIV.linux.org.uk> <1355688070.767.4.camel@x61.thuisdomein> <20121216200446.GF4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2012 20:04:46 Al Viro wrote:
> On Sun, Dec 16, 2012 at 09:01:10PM +0100, Paul Bolle wrote:
> > > +	vma = find_vma(mm, virtp);
> > > 
> > >  	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> > 
> > Shouldn't that line become
> > 
> >     if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> > 
> > so that this actually compiles?
> 
> *Do'h*
> 
> Yes, it should.  Mea culpa...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> diff --git a/drivers/media/platform/omap/omap_vout.c
> b/drivers/media/platform/omap/omap_vout.c index 9935040..cb564d0 100644
> --- a/drivers/media/platform/omap/omap_vout.c
> +++ b/drivers/media/platform/omap/omap_vout.c
> @@ -207,19 +207,21 @@ static u32 omap_vout_uservirt_to_phys(u32 virtp)
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm = current->mm;
> 
> -	vma = find_vma(mm, virtp);
>  	/* For kernel direct-mapped memory, take the easy way */
> -	if (virtp >= PAGE_OFFSET) {
> -		physp = virt_to_phys((void *) virtp);
> -	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> +	if (virtp >= PAGE_OFFSET)
> +		return virt_to_phys((void *) virtp);
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma(mm, virtp);
> +	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
>  		/* this will catch, kernel-allocated, mmaped-to-usermode
>  		   addresses */
>  		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
> +		up_read(&current->mm->mmap_sem);
>  	} else {
>  		/* otherwise, use get_user_pages() for general userland pages */
>  		int res, nr_pages = 1;
>  		struct page *pages;
> -		down_read(&current->mm->mmap_sem);
> 
>  		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
>  				0, &pages, NULL);

-- 
Regards,

Laurent Pinchart

