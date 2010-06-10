Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0FJEnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:43:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:36601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0FJEnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:43:02 -0400
Date: Thu, 10 Jun 2010 14:42:35 +1000
From: Nick Piggin <npiggin@suse.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610044234.GD26335@laptop>
References: <1276141986-9200-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276141986-9200-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 11:53:06AM +0800, Tao Ma wrote:
> Let ocfs2 use the new truncate sequence. The changes include:
> 1. Remove the extra check for inode_newsize_ok since Christoph
>    has moved it into inode_change_ok. So we will check it at the
>    beginning of ocfs2_setattr.

So this deals with our questions regarding check of i_size outside
the inode cluster lock? (see fsdevel discussion)


> 2. Use truncate_setsize directly since we don't implement our
>    own ->truncate and what we need is "update i_size and
>    truncate_pagecache" which truncate_setsize now does.
> 3. For direct write, ocfs2 actually don't allow write to pass
>    i_size(see ocfs2_prepare_inode_for_write), so we don't have
>    a chance to increase i_size. So remove the bogus check.
> 
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/file.c |   34 +++++-----------------------------
>  1 files changed, 5 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 1fb0985..764fffb 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -983,10 +983,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	if (size_change && attr->ia_size != i_size_read(inode)) {
> -		status = inode_newsize_ok(inode, attr->ia_size);
> -		if (status)
> -			goto bail_unlock;
> -
>  		if (i_size_read(inode) > attr->ia_size) {

While you're here, you should be able to use inode->i_size if you're
under i_mutex, no?

