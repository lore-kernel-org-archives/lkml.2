Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2CHHsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:48:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2CHHsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:48:10 -0500
Date: Wed, 7 Mar 2012 23:50:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120307235012.847af577.akpm@linux-foundation.org>
In-Reply-To: <20120308184105.5b03ec90bcddf90562181277@canb.auug.org.au>
References: <20120308175307.b295b1013728a5666fe4571a@canb.auug.org.au>
	<20120307233220.5a76aa3c.akpm@linux-foundation.org>
	<20120308184105.5b03ec90bcddf90562181277@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 18:41:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 7 Mar 2012 23:32:20 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Actually they're different.  I reworked the earlier patch as below.
> 
> OK.  But some comments.
> 
> > diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
> > --- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
> > +++ a/arch/x86/mm/hugetlbpage.c
> > @@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
> >  {
> >  	struct hstate *h = hstate_file(file);
> >  	struct mm_struct *mm = current->mm;
> > -	struct vm_area_struct *vma, *prev_vma;
> > +	struct vm_area_struct *vma;
> 
> You still remove prev_vma ...
> 
> >  	unsigned long base = mm->mmap_base, addr = addr0;
> >  	unsigned long largest_hole = mm->cached_hole_size;
> >  	int first_time = 1;
> > @@ -334,25 +334,16 @@ try_again:
> >  		 * i.e. return with success:
> >  		 */
> >  		vma = find_vma(mm, addr);
> > -		if (!vma)
> > -			return addr;
> > -
> > -		/*
> > -		 * new region fits between prev_vma->vm_end and
> > -		 * vma->vm_start, use it:
> > -		 */
> > -		prev_vma = vma->vm_prev;
> > -		if (addr + len <= vma->vm_start &&
> > -		            (!prev_vma || (addr >= prev_vma->vm_end))) {
> > +		if (vma)
> > +			prev_vma = vma->vm_prev;
> 
> But then assign to it ...
> 
> > +		if (!vma || addr + len <= vma->vm_start) {
> >  			/* remember the address as a hint for next time */
> >  		        mm->cached_hole_size = largest_hole;
> >  		        return (mm->free_area_cache = addr);
> > -		} else {
> > +		} else if (mm->free_area_cache == vma->vm_end) {
> >  			/* pull free_area_cache down to the first hole */
> > -		        if (mm->free_area_cache == vma->vm_end) {
> > -				mm->free_area_cache = vma->vm_start;
> > -				mm->cached_hole_size = largest_hole;
> > -			}
> > +			mm->free_area_cache = vma->vm_start;
> > +			mm->cached_hole_size = largest_hole;
> >  		}
> >  
> >  		/* remember the largest hole we saw so far */
> 
> But it never gets used.

Doh.  The author reviewed that for me too!

I'll drop it - please rework, retest and resend?

