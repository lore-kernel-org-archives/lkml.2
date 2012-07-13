Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2GMINP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:13:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42996 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab2GMIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:12:56 -0400
Date: Fri, 13 Jul 2012 13:41:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: kill insert_vm_struct()->uprobe_mmap()
Message-ID: <20120713081103.GA4781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120708202917.GA18188@redhat.com>
 <20120708203011.GA18243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120708203011.GA18243@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071308-7408-0000-0000-000006BBB18A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-08 22:30:11]:

> Kill insert_vm_struct()->uprobe_mmap(). It is not needed, nobody
> except arch/ia64/kernel/perfmon.c uses insert_vm_struct(vma) with
> vma->vm_file != NULL.
> 

Right, but somebody else might start using this later.
I cant think of a use case though.

> And it is wrong. Again, get_user_pages() can not succeed before
> vma_link(vma) makes is visible to find_vma(). And even if this
> worked, we must not insert the new bp before this mapping is
> visible to vma_prio_tree_foreach() for uprobe_unregister().
> 

Agree, we are wrong to do it before vma_link.


> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  mm/mmap.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index e5a4614..4fe2697 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2345,9 +2345,6 @@ int insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
>  	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
>  		return -ENOMEM;
> 
> -	if (vma->vm_file && uprobe_mmap(vma))
> -		return -EINVAL;
> -
>  	vma_link(mm, vma, prev, rb_link, rb_parent);
>  	return 0;
>  }

Can we do something like:

	vma_link(mm, vma, prev, rb_link, rb_parent);

	if (vma->vm_file && uprobe_mmap(vma)) {
		/* FIXME: dont know if calling unmap_region is fine here */
		unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end); 
		return -EINVAL;
	}

	return 0;

}

