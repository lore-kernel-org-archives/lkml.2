Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2HCNlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:41:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2HCNlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:41:42 -0400
Date: Fri, 3 Aug 2012 15:38:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120803133825.GA2131@redhat.com>
References: <20120728163157.GA22719@redhat.com> <20120731064730.GB5087@linux.vnet.ibm.com> <20120731124805.GA485@redhat.com> <20120802100515.GC5782@linux.vnet.ibm.com> <20120802135313.GA4334@redhat.com> <20120803121342.GD3748@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803121342.GD3748@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Srikar Dronamraju wrote:
>
> > But mmap_region() is worse, much worse. It simply can _not_ fail
> > after uprobe_mmap (of course, I am not saying this is unfixable)
> > without the crash. And note that the crash is "delayed". And btw,
> > like dup_mmap(), mmap_region() doesn't return the error too.
> >
> > Srikar, I strongly believe this horror must not exist. Either
> > we should teach mmap_region() and dup_mmap() (and vma_adjust!)
> > to fail correctly, or we should ignore the error code.
> >
> > It is that simple, isn't it?
>
> I think you would have thought of this approach already but just wanted
> to check if below is fine with you.
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1355,9 +1355,12 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>  	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
>  		make_pages_present(addr, addr + len);
>
> -	if (file && uprobe_mmap(vma))
> +	if (file) {
> +		error = uprobe_mmap(vma)
>  		/* matching probes but cannot insert */
> -		goto unmap_and_free_vma;
> +		if (error)
> +			goto unmap_and_free_vma;

No, this is wrong.

Please look at the code under unmap_and_free_vma. The main part is
unmap_region(), but this does NOT remove vma from mm->mm_rb and then
this vma is kmem_cache_free'ed. IOW, this leaves the freed object
in rb tree.

Afaics, there are other things this error path doesn't do but this
is how William noticed the bug (kernel hang). I don't think the fix
is suitable for stable.

Srikar, can't we make these fixes on top of my simple patch which
fixes the easy-to-trigger kernel crashes/hangs?

If yes, may be you can ack that patch for Ingo?


And yes, uprobe_mmap() needs changes too. But can't we do this a
bit later? Currently uprobes_state.count is very wrong, it simply
does not count uprobes correctly even in the very simple cases.

Oleg.

