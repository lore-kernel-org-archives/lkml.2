Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1EJMlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:41:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab1EJMlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:41:22 -0400
Date: Tue, 10 May 2011 14:41:03 +0200
From: Jan Kara <jack@suse.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCH 2/7] fs: block_page_mkwrite should wait for writeback
 to finish
Message-ID: <20110510124103.GC4402@quack.suse.cz>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <20110509230334.19566.17603.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509230334.19566.17603.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-05-11 16:03:34, Darrick J. Wong wrote:
> For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
> function to wait for pending writeback before allowing the page to become
> writable.  This is needed to stabilize pages during writeback for those two
> filesystems.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
>  fs/buffer.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a08bb8e..cf9a795 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2361,6 +2361,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	if (!ret)
>  		ret = block_commit_write(page, 0, end);
>  
> +	wait_on_page_writeback(page);
  Not that it matters much but it would seem more logical to me if we
waited only in not-error case (i.e. after the error handling below).

								Honza
>  	if (unlikely(ret)) {
>  		unlock_page(page);
>  		if (ret == -ENOMEM)
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
