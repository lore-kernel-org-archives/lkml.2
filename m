Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab1CDWWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:22:55 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34153 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab1CDWWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:22:54 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=dyVpuHYQJROgCHwBBw1H+I+7e1rgZIKdHwrI0HSbuo4= c=1 sm=1
 a=WKMNdXk8PrIA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=evzLwH17iOcCeDFJ8nUA:9 a=gtjsmCH9Vjgmw397naMA:7
 a=FGaQGwpRsN35CIcH8KLmnSQZ1W0A:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10
 a=e6qwrDixvCFvde8a:21 a=Vx_Oe6OF1rowUdLz:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [RFC] block integrity: Fix write after checksum calculation	problem
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110304210724.GF27190@tux1.beaverton.ibm.com>
Date: Fri, 4 Mar 2011 15:22:30 -0700
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8C2F258E-60BE-45F8-B6E2-87988DEE2776@dilger.ca>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <yq1vd0cf26f.fsf@sermon.lab.mkp.net> <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04, at 2:07 PM, Darrick J. Wong wrote:
> Ok, here's what I have so far.  I took everyone's suggestions of where to add
> calls to wait_on_page_writeback, which seems to handle the multiple-write case
> adequately.  Unfortunately, it is still possible to generate checksum errors by
> scribbling furiously on a mmap'd region, even after adding the writeback wait
> in the ext4 writepage function.  Oddly, I couldn't break btrfs with mmap by
> removing its wait_for_page_writeback call, so I suspect there's a bit more
> going on in btrfs than I've been able to figure out.

Did you add this to ext4_page_mkwrite() or only ext4_writepage()?  It wasn't clear from your description above.

> The set_memory_ro debugging trick didn't ferret out any write paths that I
> didn't catch... though it did have the effect of causing occasional fsync()
> deadlocks.  I suppose I could sprinkle in a few more of those write calls to
> see what happens.
> 
> Either way, I'm emailing to ask everyone's advice since I've run out of ideas.
> Or: Did I miss something?
> 
> Thanks all for the feedback so far!
> 
> --
> fs: Wait for page writeback when rewrite detected
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> fs/buffer.c     |    4 +++-
> fs/ext4/inode.c |    3 +++
> mm/filemap.c    |   15 +++++++++++++--
> 3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 2219a76..39e934c 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2379,8 +2379,10 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> 			ret = VM_FAULT_OOM;
> 		else /* -ENOSPC, -EIO, etc */
> 			ret = VM_FAULT_SIGBUS;
> -	} else
> +	} else {
> +		wait_on_page_writeback(page);
> 		ret = VM_FAULT_LOCKED;
> +	}
> 
> out:
> 	return ret;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9f7f9e4..2364704 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2730,12 +2730,15 @@ static int ext4_writepage(struct page *page,
> 	struct inode *inode = page->mapping->host;
> 
> 	trace_ext4_writepage(inode, page);
> +lock_page(page);
> 	size = i_size_read(inode);
> 	if (page->index == size >> PAGE_CACHE_SHIFT)
> 		len = size & ~PAGE_CACHE_MASK;
> 	else
> 		len = PAGE_CACHE_SIZE;
> 
> +wait_on_page_writeback(page);
> +
> 	/*
> 	 * If the page does not have buffers (for whatever reason),
> 	 * try to create them using __block_write_begin.  If this
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 83a45d3..f201d80 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2217,8 +2217,8 @@ EXPORT_SYMBOL(generic_file_direct_write);
>  * Find or create a page at the given pagecache position. Return the locked
>  * page. This function is specifically for buffered writes.
>  */
> -struct page *grab_cache_page_write_begin(struct address_space *mapping,
> -					pgoff_t index, unsigned flags)
> +struct page *__grab_cache_page_write_begin(struct address_space *mapping,
> +					   pgoff_t index, unsigned flags)
> {
> 	int status;
> 	struct page *page;
> @@ -2243,6 +2243,17 @@ repeat:
> 	}
> 	return page;
> }
> +struct page *grab_cache_page_write_begin(struct address_space *mapping,
> +					pgoff_t index, unsigned flags)
> +{
> +	struct page *p;
> +
> +	p = __grab_cache_page_write_begin(mapping, index, flags);
> +	if (p)
> +		wait_on_page_writeback(p);
> +
> +	return p;
> +}
> EXPORT_SYMBOL(grab_cache_page_write_begin);
> 
> static ssize_t generic_perform_write(struct file *file,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





