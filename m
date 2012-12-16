Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2LPUBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:01:14 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:53111 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab2LPUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:01:13 -0500
Message-ID: <1355688070.767.4.camel@x61.thuisdomein>
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
From: Paul Bolle <pebolle@tiscali.nl>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Sun, 16 Dec 2012 21:01:10 +0100
In-Reply-To: <20121215201237.GW4939@ZenIV.linux.org.uk>
References: <20121215201237.GW4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2012 20:01:11.0331 (UTC) FILETIME=[186C5F30:01CDDBC8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-15 at 20:12 +0000, Al Viro wrote:
> 	Walking rbtree while it's modified is a Bad Idea(tm); besides,
> the result of find_vma() can be freed just as it's getting returned
> to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
> earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET -
> in that case we don't even look at its result).
> 
> Cc: stable@vger.kernel.org [2.6.35]
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
> index 9935040..984512f 100644
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
> +	if (virtp >= PAGE_OFFSET)
> +		return virt_to_phys((void *) virtp);
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma(mm, virtp);
>  	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {

Shouldn't that line become 
    if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {

so that this actually compiles?

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


Paul Bolle

