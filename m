Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2G3NWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2G3NWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:22:24 -0400
Message-ID: <50168A80.10805@redhat.com>
Date: Mon, 30 Jul 2012 09:22:08 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120714 Thunderbird/10.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: mmap_region() corrupts mm->mm_rb if uprobe_mmap()
 fails
References: <20120728163157.GA22719@redhat.com>
In-Reply-To: <20120728163157.GA22719@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2012 12:31 PM, Oleg Nesterov wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=843640

Hi Oleg,

I checked the following patch and it does fix the problem on the 3.5.0+ kernel.

-Will

> 
> If mmap_region()->uprobe_mmap() fails, unmap_and_free_vma path
> does unmap_region() but does not remove the soon-to-be-freed vma
> from rb tree (actually there are more problems).
> 
> Perhaps we could do do_munmap() + return in this case, but in fact
> it is simply wrong to abort if uprobe_mmap() fails. Until at least
> we move the !UPROBE_COPY_INSN code from install_breakpoint() to
> uprobe_register().
> 
> For example, uprobe_mmap()->install_breakpoint() can fail if the
> probed insn is not supported (remember, uprobe_register() succeeds
> if nobody mmaps inode/offset), mmap() should not fail in this case.
> 
> dup_mmap()->uprobe_mmap() is wrong too by the same reason, fork()
> can race with uprobe_register() and fail for no reason if it wins
> the race and does install_breakpoint() first.
> 
> Change mmap_region() and dup_mmap() to ignore the error code from
> uprobe_mmap().
> 
> Reported-by: William Cohen <wcohen@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org> # v3.5
> ---
>  kernel/fork.c |    4 ++--
>  mm/mmap.c     |    5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index ab5211b..54bb88a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -454,8 +454,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  		if (retval)
>  			goto out;
>  
> -		if (file && uprobe_mmap(tmp))
> -			goto out;
> +		if (file)
> +			uprobe_mmap(tmp);
>  	}
>  	/* a new mm has just been created */
>  	arch_dup_mmap(oldmm, mm);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4fe2697..f25fd3f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1355,9 +1355,8 @@ out:
>  	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
>  		make_pages_present(addr, addr + len);
>  
> -	if (file && uprobe_mmap(vma))
> -		/* matching probes but cannot insert */
> -		goto unmap_and_free_vma;
> +	if (file)
> +		uprobe_mmap(vma);
>  
>  	return addr;
>  

