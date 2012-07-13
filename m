Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2GMIN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:13:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47340 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2GMINl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:13:41 -0400
Date: Fri, 13 Jul 2012 13:43:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: kill copy_vma()->uprobe_mmap()
Message-ID: <20120713081333.GB4781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120708202917.GA18188@redhat.com>
 <20120708203008.GA18236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120708203008.GA18236@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071308-8974-0000-0000-00000B20187A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-08 22:30:08]:

> Kill copy_vma()->uprobe_mmap(new_vma), it is absolutely wrong.
> 
> This new_vma was just initialized to represent the new unmapped area,
> [vm_start, vm_end) was returned by get_unmapped_area() in the caller.
> 
> This means that uprobe_mmap()->get_user_pages() will fail for sure,
> simply because find_vma() can never succeed. And I verified that
> sys_mremap()->mremap_to() indeed always fails with the wrong ENOMEM
> code if [addr, addr+old_len] is probed.
> 
> And why this uprobe_mmap() was added? I believe the intent was wrong.
> Note that the caller is going to do move_page_tables(), all registered
> uprobes are already faulted in, we only change the virtual addresses.
> 
> NOTE: However, somehow we need to close the race with uprobe_register()
> which relies on map_info->vaddr. This needs another fix I'll try to do
> later. Probably we need uprobe_mmap() in move_vma() but we can not do
> this right now, this can confuse uprobes_state.counter (which I still
> hope we are going to kill).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  mm/mmap.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3edfcdf..e5a4614 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2418,9 +2418,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  			if (new_vma->vm_file) {
>  				get_file(new_vma->vm_file);
> 
> -				if (uprobe_mmap(new_vma))
> -					goto out_free_mempol;
> -
>  				if (vma->vm_flags & VM_EXECUTABLE)
>  					added_exe_file_vma(mm);
>  			}
> -- 
> 1.5.5.1
> 

