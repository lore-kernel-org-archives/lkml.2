Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1LGWn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:43:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab1LGWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:43:57 -0500
Date: Wed, 7 Dec 2011 14:43:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct
 entires
Message-Id: <20111207144355.c889e22d.akpm@linux-foundation.org>
In-Reply-To: <20111207122718.GF21678@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.912537377@openvz.org>
	<20111129201938.GP5169@outflux.net>
	<20111129202951.GG1775@moon>
	<20111129203714.GH1775@moon>
	<CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
	<20111130173739.GI14515@moon>
	<CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
	<20111130182310.GL14515@moon>
	<20111130210622.GM14515@moon>
	<20111207122718.GF21678@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 16:27:18 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> At process of task restoration we need a way to tune up
> a few members of mm_struct structure such as start_code,
> end_code, start_data, end_data, start_stack, start_brk, brk.

I don't really know what "tune up" means in this context.  Can we
please be more specific and detailed here?  It appears that the patch
permits userspace to directly modify these fields.

> While most of them have a statistical nature (their values
> are involved into calculation of /proc/<pid>/statm output)
> the start_brk and brk values are used to compute an allowed
> size of program data segment expansion. Which means an arbitrary
> changes of this value might be a bit dangerous operation.
> 
> To restrict access to this facility the following requirements
> applied to prctl users:
> 
>  - The process has to have CAP_SYS_ADMIN capability granted.
>  - For all opcodes except start_brk/brk members an appropriate
>    VMA area must be existing and should fit certain VMA flags,
>    such as:
>    - code segment must be executable but not writable;
>    - data segment must not be executable.
> 
> start_brk/brk values must not intersect with data segment
> and must not exceed RLIMIT_DATA resource limit.
> 
> Still the main guard is CAP_SYS_ADMIN capability check.
>
> ...
>
>  include/linux/prctl.h |   12 +++++
>  kernel/sys.c          |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++

The prctl(2) manpage will need to be updated.  Please Cc Michael on all
such changes.

> 
> Index: linux-2.6.git/include/linux/prctl.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/prctl.h
> +++ linux-2.6.git/include/linux/prctl.h
> @@ -102,4 +102,16 @@
>  
>  #define PR_MCE_KILL_GET 34
>  
> +/*
> + * Tune up process memory map specifics.
> + */
> +#define PR_SET_MM		35
> +# define PR_SET_MM_START_CODE		1
> +# define PR_SET_MM_END_CODE		2
> +# define PR_SET_MM_START_DATA		3
> +# define PR_SET_MM_END_DATA		4
> +# define PR_SET_MM_START_STACK		5
> +# define PR_SET_MM_START_BRK		6
> +# define PR_SET_MM_BRK			7
> +
>  #endif /* _LINUX_PRCTL_H */
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1692,6 +1692,118 @@ SYSCALL_DEFINE1(umask, int, mask)
>  	return mask;
>  }
>  
> +static int prctl_set_mm(int opt, unsigned long addr)
> +{
> +	unsigned long rlim = rlimit(RLIMIT_DATA);
> +	unsigned long vm_req_flags;
> +	unsigned long vm_bad_flags;
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	int error = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (addr >= TASK_SIZE)
> +		return -EINVAL;
> +
> +	mm = get_task_mm(current);

Is it necessaary to run the expensive get_task_mm() for `current'? 
`current' is known to be running and you have control of it here -
nobody will be taking our mm away.  Simply use current->mm?  The
function actually uses current->mm later on in several places.

> +	if (!mm)
> +		return -ENOENT;
> +
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, addr);
> +
> +	if (opt != PR_SET_MM_START_BRK &&
> +	    opt != PR_SET_MM_BRK) {

80 columns, not 40 :)

> +		/* It must be existing VMA */
> +		if (!vma || vma->vm_start > addr)
> +			goto out;
> +	}
> +
> +	error = -EINVAL;
> +	switch (opt) {
> +	case PR_SET_MM_START_CODE:
> +	case PR_SET_MM_END_CODE:
> +

You're adding unneeded and unconventional newlines after the `case'
statements.

> +		vm_req_flags = VM_READ | VM_EXEC;
> +		vm_bad_flags = VM_WRITE | VM_MAYSHARE;
> +
> +		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
> +		    (vma->vm_flags & vm_bad_flags))
> +			goto out;
> +
> +		if (opt == PR_SET_MM_START_CODE)
> +			current->mm->start_code = addr;
> +		else
> +			current->mm->end_code = addr;
> +		break;
> +
> +	case PR_SET_MM_START_DATA:
> +	case PR_SET_MM_END_DATA:
> +
> +		vm_req_flags = VM_READ | VM_WRITE;
> +		vm_bad_flags = VM_EXEC | VM_MAYSHARE;
> +
> +		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
> +		    (vma->vm_flags & vm_bad_flags))
> +			goto out;
> +
> +		if (opt == PR_SET_MM_START_DATA)
> +			current->mm->start_data = addr;
> +		else
> +			current->mm->end_data = addr;
> +		break;
> +
> +	case PR_SET_MM_START_STACK:
> +
> +#ifdef CONFIG_STACK_GROWSUP
> +		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
> +#else
> +		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
> +#endif
> +		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
> +			goto out;
> +
> +		current->mm->start_stack = addr;
> +		break;
> +
> +	case PR_SET_MM_START_BRK:
> +		if (addr <= mm->end_data)
> +			goto out;
> +
> +		if (rlim < RLIM_INFINITY &&
> +		    (mm->brk - addr) + (mm->end_data - mm->start_data) > rlim)
> +			goto out;
> +
> +		current->mm->start_brk = addr;
> +		break;
> +
> +	case PR_SET_MM_BRK:
> +		if (addr <= mm->end_data)
> +			goto out;
> +
> +		if (rlim < RLIM_INFINITY &&
> +		    (addr - mm->start_brk) + (mm->end_data - mm->start_data) > rlim)
> +			goto out;
> +
> +		current->mm->brk = addr;
> +		break;
> +
> +	default:
> +		error = -EINVAL;
> +		goto out;
> +	}
> +
> +	error = 0;
> +
> +out:
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +
> +	return error;
> +}

This is starting to add a non-trivial amount of code.  Perhaps we need
to introduce a Kconfig variable to control such things as this, to
prevent bloating up kernels which aren't require to support c/r?

>
> ...
>
