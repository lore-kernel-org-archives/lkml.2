Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab2LHA3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:29:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2LHA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:29:08 -0500
Date: Fri, 7 Dec 2012 16:29:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>,
        logfs@logfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: logfs NULL pointer check added
Message-Id: <20121207162907.a9e4a3d9.akpm@linux-foundation.org>
In-Reply-To: <1354015498-8986-1-git-send-email-abhi.c.pawar@gmail.com>
References: <1354015498-8986-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 16:54:58 +0530
Abhijit Pawar <abhi.c.pawar@gmail.com> wrote:

> This patch fixes  Bug 49921 - Missing NULL check of return value of logfs_get_write_page() in function btree_write_block()
> 
> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
> ---
>  fs/logfs/readwrite.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
> index e1a3b6b..53596ce 100644
> --- a/fs/logfs/readwrite.c
> +++ b/fs/logfs/readwrite.c
> @@ -2202,6 +2202,7 @@ void btree_write_block(struct logfs_block *block)
>  
>  	inode = logfs_safe_iget(block->sb, block->ino, &cookie);
>  	page = logfs_get_write_page(inode, block->bix, block->level);
> +	BUG_ON(!page);
>  
>  	err = logfs_readpage_nolock(page);
>  	BUG_ON(err);

We don't gain anything from this change.  If page==NULL then
logfs_readpage_nolock() will oops and will provide the same information
as BUG().


A better fix would be to teach logfs_get_write_page() to return a
proper ERR_PTR errno (not just a gee-i-goofed boolean, guys) then teach
btree_write_block() to process that error appropriately: clean up and
propagate it back.

Right now, a visit from the oom-killer will cause btree_write_block()
to kill the kernel.

