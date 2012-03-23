Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2CWWpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:45:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2CWWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:45:05 -0400
Date: Fri, 23 Mar 2012 15:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 01/19] mm: Make default vm_ops provide ->page_mkwrite
 handler
Message-Id: <20120323154502.8072a755.akpm@linux-foundation.org>
In-Reply-To: <1330963277-26336-2-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-2-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Mar 2012 17:00:59 +0100
Jan Kara <jack@suse.cz> wrote:

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1759,8 +1759,28 @@ page_not_uptodate:
>  }
>  EXPORT_SYMBOL(filemap_fault);
>  
> +int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	struct page *page = vmf->page;
> +	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> +	int ret = VM_FAULT_LOCKED;
> +
> +	file_update_time(vma->vm_file);
> +	lock_page(page);
> +	if ((page->mapping != inode->i_mapping) ||
> +	    (page_offset(page) > i_size_read(inode))) {

Would benefit from a comment explaining how the page can come to be
outside i_size, and why we fail in that case.

I don't think i_mutex is held here, so this test is rather meaningless
and racy anyway?

> +		unlock_page(page);
> +		ret = VM_FAULT_NOPAGE;
> +		goto out;
> +	}
> +out:
> +	return ret;
> +}
> +EXPORT_SYMBOL(filemap_page_mkwrite);
