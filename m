Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0LISkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:40:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51904 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0LISkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:40:51 -0500
Date: Thu, 9 Dec 2010 10:38:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tavis Ormandy <taviso@cmpxchg8b.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org,
        kees@ubuntu.com, eugene@redhat.com
Subject: Re: [PATCH] install_special_mapping skips security_file_mmap check.
Message-Id: <20101209103853.89bd577b.randy.dunlap@oracle.com>
In-Reply-To: <20101209142942.GB9267@cmpxchg8b.com>
References: <20101209142942.GB9267@cmpxchg8b.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010 15:29:42 +0100 Tavis Ormandy wrote:

> Signed-off-by: Tavis Ormandy <taviso@google.com>
> Acked-by: Kees Cook <kees@ubuntu.com>
> Acked-by: Robert Swiecki <swiecki@google.com>
> ---
> 
>  fs/exec.c |    7 +++++++
>  mm/mmap.c |    5 +++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index d68c378..7e8c4b6 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -275,7 +275,14 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>     vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
>     vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>     INIT_LIST_HEAD(&vma->anon_vma_chain);
> +
> +   err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
> +
> +   if (err)
> +       goto err;
> +
>     err = insert_vm_struct(mm, vma);
> +
>     if (err)
>         goto err;
>  

Uh, something happened to the tabs at the beginning of each line...
I.e., the original file content has been mucked up.


> diff --git a/mm/mmap.c b/mm/mmap.c
> index b179abb..1de3f4b 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2479,6 +2479,11 @@ int install_special_mapping(struct mm_struct *mm,
>     vma->vm_ops = &special_mapping_vmops;
>     vma->vm_private_data = pages;
>  
> +   if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
> +       kmem_cache_free(vm_area_cachep, vma);
> +       return -EPERM;
> +   }
> +
>     if (unlikely(insert_vm_struct(mm, vma))) {
>         kmem_cache_free(vm_area_cachep, vma);
>         return -ENOMEM;
> 
> 
> -- 
> -------------------------------------


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
