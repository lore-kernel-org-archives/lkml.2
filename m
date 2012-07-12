Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2GLF5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:57:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37435 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2GLF5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:57:04 -0400
Date: Thu, 12 Jul 2012 11:26:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: fix overflow in
 vma_address/find_active_uprobe
Message-ID: <20120712055655.GB3598@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120708203006.GA18233@redhat.com>
 <1341782304.13174.21.camel@joe2Laptop>
 <20120709105445.GA32699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120709105445.GA32699@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071205-7606-0000-0000-000001F024D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-09 12:54:45]:

> On 07/08, Joe Perches wrote:
> >
> > On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> > > @@ -1450,7 +1450,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
> > >
> > >  			inode = vma->vm_file->f_mapping->host;
> > >  			offset = bp_vaddr - vma->vm_start;
> > > -			offset += (vma->vm_pgoff << PAGE_SHIFT);
> > > +			offset += ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> >
> > It's be nice to take remove the unnecessary parenthesis
> > and make it consistent with the vaddr use above it too.
> 
> OK, please find v2 below.
> 
> ------------------------------------------------------------------------------
> Subject: [PATCH] uprobes: fix overflow in vma_address/find_active_uprobe
> 
> vma->vm_pgoff is "unsigned long", it should be promoted to loff_t
> before the multiplication to avoid the overflow.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 47c4e24..6194edb 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -117,7 +117,7 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
>  	loff_t vaddr;
> 
>  	vaddr = vma->vm_start + offset;
> -	vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> 
>  	return vaddr;
>  }
> @@ -1450,7 +1450,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
> 
>  			inode = vma->vm_file->f_mapping->host;
>  			offset = bp_vaddr - vma->vm_start;
> -			offset += (vma->vm_pgoff << PAGE_SHIFT);
> +			offset += (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>  			uprobe = find_uprobe(inode, offset);
>  		}
> 

