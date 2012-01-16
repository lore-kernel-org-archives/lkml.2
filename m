Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2APL2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:28:09 -0500
Received: from mail2.shareable.org ([80.68.89.115]:34174 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2APL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:28:07 -0500
Date: Mon, 16 Jan 2012 11:28:02 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
Message-ID: <20120116112802.GB7180@jl-vm1.vm.bytemark.co.uk>
References: <1326544511-6547-1-git-send-email-siddhesh.poyarekar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326544511-6547-1-git-send-email-siddhesh.poyarekar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siddhesh Poyarekar wrote:
> Memory mmaped by glibc for a thread stack currently shows up as a simple
> anonymous map, which makes it difficult to differentiate between memory
> usage of the thread on stack and other dynamic allocation. Since glibc
> already uses MAP_STACK to request this mapping, the attached patch
> uses this flag to add additional VM_STACK_FLAGS to the resulting vma
> so that the mapping is treated as a stack and not any regular
> anonymous mapping. Also, one may use vm_flags to decide if a vma is a
> stack.

I think this is fine.

> There is an additional complication with posix threads where the stack
> guard for a thread stack may be larger than a page, unlike the case
> for process stack where the stack guard is a page long. glibc
> implements these guards by calling mprotect on the beginning page(s)
> to remove all permissions. I have used this to remove vmas that have
> the thread stack guard, from the /proc/maps output.

> -	/* We don't show the stack guard page in /proc/maps */
> +	/* We don't show the stack guard pages in /proc/maps */
> +	if (thread_stack_guard(vma))
> +		return;
> +
>  	start = vma->vm_start;
>  	if (stack_guard_page_start(vma, start))
>  		start += PAGE_SIZE;

Hmm, I see why you did this.  The current code already hides one guard
page, which is already dubious for programs that do things like read
/proc/pid/maps to decide if MAP_FIXED would be not clobber an existing
mapping.  At least those programs _could_ know about the stack guard
page address

I wonder if it's a potential security hole: You've just allowed
programs to use two MAP_GROWSUP/DOWN|PROT_NONE to hide vmas from the
user.  Sure, the memory isn't accessible, but it can still store data
and be ephemerally made visible using mprotect() then hidden again.

I would prefer a label like "[stack guard]" or just "[guard]",
both for the thread stacks and the process stack.

With a label like "[guard]" it needn't be limited to stacks; heap
guard pages used by some programs would also be labelled.

> +static inline int vma_is_stack(struct vm_area_struct *vma)
> +{
> +	return vma && (vma->vm_flags & (VM_GROWSUP | VM_GROWSDOWN));
> +}
> +
> +/*
> + * POSIX thread stack guards may be more than a page long and access to it
> + * should return an error (possibly a SIGSEGV). The glibc implementation does
> + * an mprotect(..., ..., PROT_NONE), so our guard vma has no permissions.
> + */
> +static inline int thread_stack_guard(struct vm_area_struct *vma)

Is there a reason the names aren't consistent - i.e. not vma_is_stack_guard()?

> +{
> +	return vma_is_stack(vma) &&
> +		((vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_MAYSHARE)) == 0) &&
> +		vma_is_stack((vma->vm_flags & VM_GROWSDOWN)?vma->vm_next:vma->vm_prev);
> +}
> +

That doesn't check if ->vm_next/prev is adjacent in address space.

You can't assume the program is using Glibc, or that MAP_STACK
mappings are all from Glibc, or that they are in the pattern you expect.

How about simply calling it vma_is_guard(), return 1 if it's PROT_NONE
without checking vma_is_stack() or ->vm_next/prev, and annotate the
maps output like this:

   is_stack              => "[stack]"
   is_guard & is_stack   => "[stack guard]"
   is_guard & !is_stack  => "[guard]"

What do you think?

-- Jamie
