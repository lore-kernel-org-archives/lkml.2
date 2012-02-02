Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2BBX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:27:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2BBX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:27:07 -0500
Date: Thu, 2 Feb 2012 15:27:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch cr 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
Message-Id: <20120202152705.831b00c7.akpm@linux-foundation.org>
In-Reply-To: <20120130141852.466613862@openvz.org>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.466613862@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 18:09:09 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> After restore we would like the 'ps' command show the command
> line and evironment exactly the same it was at checkpoint time.
> 
> So this additional PR_SET_MM_ allow us to do so. Note that
> these members of mm_struct is rather used for output in
> procfs, except auxv vector which is used by ld.so mostly.

This changelog is pretty darned hard to understand.  Can we have a
version 2 please?

>
> ...
>
> @@ -1753,19 +1755,6 @@ static int prctl_set_mm(int opt, unsigne
>  			mm->end_data = addr;
>  		break;
>  
> -	case PR_SET_MM_START_STACK:
> -
> -#ifdef CONFIG_STACK_GROWSUP
> -		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
> -#else
> -		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
> -#endif
> -		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
> -			goto out;
> -
> -		mm->start_stack = addr;
> -		break;
> -
>  	case PR_SET_MM_START_BRK:
>  		if (addr <= mm->end_data)
>  			goto out;
> @@ -1790,16 +1779,53 @@ static int prctl_set_mm(int opt, unsigne
>  		mm->brk = addr;
>  		break;

Here would be a good place to add some nice comments explaining what
these do.  Although I guess that isn't needed if one can get that info
by typing "man prctl".

> +	case PR_SET_MM_START_STACK:
> +	case PR_SET_MM_ARG_START:
> +	case PR_SET_MM_ARG_END:
> +	case PR_SET_MM_ENV_START:
> +	case PR_SET_MM_ENV_END:
> +#ifdef CONFIG_STACK_GROWSUP
> +		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
> +#else
> +		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSDOWN, 0))
> +#endif
> +			goto out;
> +		if (opt == PR_SET_MM_START_STACK)
> +			mm->start_stack = addr;
> +		else if (opt == PR_SET_MM_ARG_START)
> +			mm->arg_start = addr;
> +		else if (opt == PR_SET_MM_ARG_END)
> +			mm->arg_end = addr;
> +		else if (opt == PR_SET_MM_ENV_START)
> +			mm->env_start = addr;
> +		else if (opt == PR_SET_MM_ENV_END)
> +			mm->env_end = addr;
> +		break;
> +
> +	case PR_SET_MM_AUXV: {
> +		unsigned long user_auxv[AT_VECTOR_SIZE];
> +
> +		if (arg4 > sizeof(mm->saved_auxv))
> +			goto out;
> +		up_read(&mm->mmap_sem);
> +
> +		if (copy_from_user(user_auxv, (const void __user *)addr, arg4))
> +			return EFAULT;
> +
> +		task_lock(current);
> +		memcpy(mm->saved_auxv, user_auxv, arg4);
> +		task_unlock(current);
> +
> +		return 0;
> +	}

I worry a bit about this.  We're giving userspace the ability to modify
various mm_struct fields.  Userspace can already do this via
exec(elf-file), but perhaps this opens up a way in which userspace can
newly trigger kernel bugs.


