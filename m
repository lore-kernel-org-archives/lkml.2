Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299Ab2B1U0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:26:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab2B1U0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:26:17 -0500
Date: Tue, 28 Feb 2012 12:26:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Truelove <steven.truelove@utoronto.ca>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Correct alignment of huge page requests.
Message-Id: <20120228122616.de510ae2.akpm@linux-foundation.org>
In-Reply-To: <1330401628-30818-1-git-send-email-steven.truelove@utoronto.ca>
References: <1330401628-30818-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 23:00:28 -0500
Steven Truelove <steven.truelove@utoronto.ca> wrote:

> When calling shmget() with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup() to align requests to the huge page size.  Also modified mmap_pgoff() to avoid duplicating this check and to align against the start address.
> 

I don't think this is quite right.

Suppose huge_page_size is 4096, addr=4095, len=4098.  So we're mapping
three pages: the last byte of the first page, all of the second page
and the first byte of the third page. 

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
> +	num_pages = ALIGN(size, huge_page_size(hstate)) >>
> +			huge_page_shift(hstate);
>  	error = -ENOMEM;
> -	if (hugetlb_reserve_pages(inode, 0,
> -			size >> huge_page_shift(hstate_inode(inode)), NULL,
> -			acctflag))
> +	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
>  		goto out_inode;
>  
>  	d_instantiate(path.dentry, inode);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3f758c7..1f44ccf 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1098,8 +1098,12 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
>  		 * taken when vm_ops->mmap() is called
>  		 * A dummy user value is used because we are not locking
>  		 * memory so no accounting is necessary
> +		 * Length is increased by the amount necessary to align
> +		 * the base address to the huge page size.
> +		 * hugetlb_file_setup() aligns the end of the buffer to
> +		 * the huge page size.
>  		 */
> -		len = ALIGN(len, huge_page_size(&default_hstate));
> +		len += ALIGN(addr, huge_page_size(&default_hstate)) - addr;
>  		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
>  						&user, HUGETLB_ANONHUGE_INODE);

mmap_pgoff() will change `len' from 4098 to 4099.  hugetlb_file_setup()
will round that up to 8192 and will decide to reserve two pages, not
three.

