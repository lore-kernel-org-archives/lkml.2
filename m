Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2IYJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:33:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46029 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2IYJdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:33:24 -0400
Date: Tue, 25 Sep 2012 14:35:09 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: Restrict valid_vma(false) to skip
 VM_SHARED
Message-ID: <20120925090509.GC18334@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120916175210.GA32337@redhat.com>
 <20120916175248.GA32373@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120916175248.GA32373@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092509-5406-0000-0000-0000008F2FC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-16 19:52:48]:

> valid_vma(false) ignores ->vm_flags, this is not actually right.
> We should never try to write into MAP_SHARED mapping, this can
> confuse an apllication which actually writes to ->vm_file.

Agree,

> 
> With this patch valid_vma(false) ignores VM_WRITE only but checks
> other (immutable) bits checked by valid_vma(true).

Yes, checking for other immutable flags other than VM_WRITE is good.

> This can also
> speedup uprobe_munmap() and uprobe_unregister().
> 

I didnt get how it speeds up uprobe_munmap() and uprobe_unregister()?

> Note: even after this patch _unregister can confuse the probed
> application if it does mprotect(PROT_WRITE) after _register and
> installs "int3", but this is hardly possible to avoid and this
> doesn't differ from gdb case.
> 

Again I didnt quite understand how unregister can confuse the probed
application.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


The changes look good.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index b9b50dd..78364a2 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -100,17 +100,12 @@ struct uprobe {
>   */
>  static bool valid_vma(struct vm_area_struct *vma, bool is_register)
>  {
> -	if (!vma->vm_file)
> -		return false;
> -
> -	if (!is_register)
> -		return true;
> +	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
> 
> -	if ((vma->vm_flags & (VM_HUGETLB | VM_WRITE | VM_MAYEXEC | VM_SHARED))
> -				== VM_MAYEXEC)
> -		return true;
> +	if (is_register)
> +		flags |= VM_WRITE;
> 
> -	return false;
> +	return vma->vm_file && (vma->vm_flags & flags) == VM_MAYEXEC;
>  }
> 
>  static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
> -- 
> 1.5.5.1
> 

