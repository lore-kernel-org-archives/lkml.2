Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2AZUC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:02:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61374 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2AZUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:02:26 -0500
Date: Thu, 26 Jan 2012 12:01:53 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Roland Dreier <roland@kernel.org>
cc: linux-rdma@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages()
 parameters
In-Reply-To: <1327557574-6125-1-git-send-email-roland@kernel.org>
Message-ID: <alpine.LSU.2.00.1201261133230.1369@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Right now, we always pass write==1 to get_user_pages(), even when we
> only intend to read the memory.  We pass force==1 if we're going for
> read-only and force==0 if we want writable.  The reasoning behind this
> seems to be contained in this out-of-tree changelog from 2005:
> 
>     Always ask get_user_pages() for writable pages, but pass force=1
>     if the consumer has only asked for read-only pages.  This fixes a
>     problem registering memory that has just been allocated but not
>     touched yet, while allowing registration of read-only memory to
>     continue to work.
> 
> However, I don't think the mm works like this today, and indeed GUP
> will fault in pages for an untouched read-only mapping just fine with
> write and force set to 0.  In fact, always passing 1 for write causes
> problems with modern kernels, because we end up hitting the "early
> C-O-W break" case in __do_fault(), even for read-only mappings where
> this makes no sense.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

I'd love to say go ahead with this, it looks so obviously correct...
... so obviously correct that it made me wonder why on earth the old
code was writing for read, and how to make make sense of the paragraph
you very helpfully quote above.

I think this is largely about the ZERO_PAGE.  If you do a read fault
on an untouched anonymous area, it maps in the ZERO_PAGE, and will
only give you your own private zeroed page when there's a write fault
to touch it.

I think your ib_umem_get() is making sure to give the process its own
private zeroed page: if the area is PROT_READ, MAP_PRIVATE, userspace
will not be wanting to write into it, but presumably it expects to see
data placed in that page by the underlying driver, and it would be very
bad news if the driver wrote its data into the ZERO_PAGE.

We did go through a phase (2.6.24 through 2.6.31) of not using the
ZERO_PAGE, but that presented its own problems, so it was reinstated.

So, ugly as it looks, I think you have to stick with write=1 force=!write.
Does that make sense now?

And although the ZERO_PAGE gives the most vivid example, I think it goes
beyond that to the wider issue of pages COWed after fork() - GUPping in
this way fixes the easy cases (and I've no desire again to go down that
rathole of fixing the most general cases).

Hugh

> ---
> This patch comes from me trying to do userspace RDMA on a memory
> region exported from a character driver and mapped with
> 
>     mmap(... PROT_READ, MAP_PRIVATE ...)
> 
> The character driver has a trivial mmap method that just sets vm_ops
> and and equally trivial fault method that essentially just does
> 
>     vmf->page = vmalloc_to_page(buf + (vmf->pgoff << PAGE_SHIFT));
> 
> ie the most elementary way to export a vmalloc'ed buffer to userspace.
> 
> However, when I tried doing
> 
>     ibv_reg_mr(... IBV_ACCESS_REMOTE_READ ...)
> 
> in userspace on that mmap region, I found that COW was happening and
> so neither userspace nor the registered memory ended up pointing at
> the kernel buffer anymore, exactly because of the COW in __do_fault()
> I mention in the changelog above.
> 
> The patch below fixes my test case, and doesn't seem to break any of
> the ibverbs examples and other simple tests of userspace verbs that I
> tried.  But that's far from an exhaustive test suite.
> 
> I'd definitely appreciate comments from MM experts here, since I'm not
> positive of my understand of G-U-P and friends, and I don't want to
> apps because this is wrong in some special case I didn't try.
> 
> Also testing from anyone with an RDMA app that does anything at all
> fancy with memory allocation or registration would be helpful.
> 
> Thanks!
> 
> PS Let me know if I didn't go on long enough about this one-line patch
> and I can write some more.
> 
>  drivers/infiniband/core/umem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 71f0c0f..fb5abd3 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -152,7 +152,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  		ret = get_user_pages(current, current->mm, cur_base,
>  				     min_t(unsigned long, npages,
>  					   PAGE_SIZE / sizeof (struct page *)),
> -				     1, !umem->writable, page_list, vma_list);
> +				     umem->writable, 0, page_list, vma_list);
>  
>  		if (ret < 0)
>  			goto out;
> -- 
> 1.7.8.3
> 
> 
