Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab0IHJHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:07:22 -0400
Received: from r00tworld.com ([212.85.137.21]:51950 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab0IHJHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:07:20 -0400
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2010 05:07:19 EDT
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>
Date: Wed, 08 Sep 2010 10:29:58 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
Message-ID: <4C874986.23581.F34F4BD@pageexec.freemail.hu>
In-reply-to: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>, <Roland McGrath's message of  Tuesday, 7 September 2010 19:34:17 -0700 <20100908023417.8B055401AF@magilla.sf.frob.com>>, <20100908023549.BFFA8401AF@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 08 Sep 2010 10:29:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Sep 2010 at 19:35, Roland McGrath wrote:

> Check that the initial stack is not too large to make it possible
> to map in any executable.  We're not checking that the actual
> executable (or intepreter, for binfmt_elf) will fit.  So those
> mappings might clobber part of the initial stack mapping.  But
> that is just userland lossage that userland made happen, not a
> kernel problem.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  fs/exec.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 2d94552..1b63237 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -594,6 +594,11 @@ int setup_arg_pages(struct linux_binprm *bprm,
>  #else
>  	stack_top = arch_align_stack(stack_top);
>  	stack_top = PAGE_ALIGN(stack_top);
> +
> +	if (unlikely(stack_top < mmap_min_addr) ||

this could arguably elicit some warning, or even better, prevent the sysctl from
setting mmap_min_addr too high in the first place. or alternatively, just check
for

	mmap_min_addr > stack_top - (vma->vm_end - vma->vm_start)

which i think is more clear as to the intent of the check. and since the next
line already computes stack_shift as vma->vm_end - stack_top, you could do the
whole check afterwards as:

	mmap_min_addr > vma->vm_start - stack_shift

which is even simpler and more to the point (you want what is called new_start in
shift_arg_pages to not violate mmap_min_addr). now you just need the int overflow
check, say: vma->vm_start < stack_shift, so the whole thing would become:

	if (vma->vm_start < stack_shift || mmap_min_addr > vma->vm_start - stack_shift)
		return -EFAULT;

which looks even better if done in shift_arg_pages as i've done it in PaX:

-       BUG_ON(new_start > new_end);
+       if (new_start >= new_end || new_start < mmap_min_addr)
+               return -EFAULT;

 +	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))

i think the = case is as valid as any other value close to it ;). also this code
is not a fast path, no need for unlikely i think.

> +		return -ENOMEM;

i'd say EFAULT is more consistent, ENOMEM is used for cases when the kernel
couldn't allocate physical memory for something, EFAULT is when there's some
issue with the address space itself (based on the reaction to find_vma or
expand_stack failures).

also what about the BUG_ON in shift_arg_pages? it could go now, right?

personally, i prefer to do this the way i did it in PaX: move up the
shift_arg_pages call a bit and turn the BUG_ON into a proper check.

>  	stack_shift = vma->vm_end - stack_top;
>  
>  	bprm->p -= stack_shift;
> 



