Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2HSRRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2HSRRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:17:11 -0400
Date: Sun, 19 Aug 2012 19:13:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Arapov <anton@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uprobes: mmap_region() corrupts mm->mm_rb if
	uprobe_mmap() fails
Message-ID: <20120819171340.GC26957@redhat.com>
References: <20120819170917.GA26953@redhat.com> <20120819170937.GA26957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819170937.GA26957@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OOPS, sorry, wrong subject. Ignore this email, see the next one.

On 08/19, Oleg Nesterov wrote:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=843640
>
> If mmap_region()->uprobe_mmap() fails, unmap_and_free_vma path
> does unmap_region() but does not remove the soon-to-be-freed vma
> from rb tree. Actually there are more problems but this is how
> William noticed this bug.
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
> And, if nothing else, both mmap_region() and dup_mmap() return
> success if uprobe_mmap() fails. Change them to ignore the error
> code from uprobe_mmap().
>
> Reported-and-tested-by: William Cohen <wcohen@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
> --
> 1.5.5.1
>

