Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2B0XmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:42:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2B0XmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:42:19 -0500
Date: Mon, 27 Feb 2012 15:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Truelove <steven.truelove@utoronto.ca>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] HUGETLBFS: Align memory request to multiple of huge
 page size to avoid underallocating.
Message-Id: <20120227154217.0a0d5a06.akpm@linux-foundation.org>
In-Reply-To: <1330351768-14874-1-git-send-email-steven.truelove@utoronto.ca>
References: <1330351768-14874-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 09:09:28 -0500
Steven Truelove <steven.truelove@utoronto.ca> wrote:

> When calling shmget with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup to align requests to the huge page size.
> 
> Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
> ---
>  fs/hugetlbfs/inode.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 1e85a7a..6c23f09 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -938,6 +938,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
>  	struct path path;
>  	struct dentry *root;
>  	struct qstr quick_string;
> +	struct hstate *hstate;
> +	int num_pages;
>  
>  	*user = NULL;
>  	if (!hugetlbfs_vfsmount)
> @@ -967,10 +969,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
>  	if (!inode)
>  		goto out_dentry;
>  
> +	hstate = hstate_inode(inode);
> +	num_pages = (size + huge_page_size(hstate) - 1) >>
> +			huge_page_shift(hstate);
>  	error = -ENOMEM;
> -	if (hugetlb_reserve_pages(inode, 0,
> -			size >> huge_page_shift(hstate_inode(inode)), NULL,
> -			acctflag))
> +	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
>  		goto out_inode;
>  
>  	d_instantiate(path.dentry, inode);

A few things...

- sys_mmap_pgoff() does the rounding up prior to calling
  hugetlb_file_setup().  ipc/shm.c:newseg() does not.

  We should be consistent here: do it in the caller or the callee,
  not both (or neither!).  I guess doing it in the callee would be
  best.

- The above code could/should have used ALIGN().  Or round_up(): the
  difference presently escapes me, even though it was so obvious that
  we left all these things undocumented.

- What's the point in aligning the length if we don't also look at
  the start address?  If that isn't a multiple of huge_page_size(), we
  will need an additional page.

