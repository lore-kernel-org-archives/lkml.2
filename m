Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0EREpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:45:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35255 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab0EREpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:45:23 -0400
Date: Mon, 17 May 2010 23:45:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Daniel P. Berrange" <berrange@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: cgroup whitelist permission fix
Message-ID: <20100518044525.GA5625@us.ibm.com>
References: <20100514074003.GK28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514074003.GK28034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> The cgroup device whitelist code gets confused when trying to grant
> permission to a disk partition that is not currently open.  Part of
> blkdev_open() includes __blkdev_get() on the whole disk.  This simply
> avoids the cgroup check for the whole disk case when opening a
> partition.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=589662
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Thanks, Chris, sorry for the delay.

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>

> ---
>  fs/block_dev.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 6dcee88..d4d19ac 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1192,10 +1192,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  	/*
>  	 * hooks: /n/, see "layering violations".
>  	 */
> -	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
> -	if (ret != 0) {
> -		bdput(bdev);
> -		return ret;
> +	if (!for_part) {
> +		ret = devcgroup_inode_permission(bdev->bd_inode, perm);
> +		if (ret != 0) {
> +			bdput(bdev);
> +			return ret;
> +		}
>  	}
> 
>  	lock_kernel();
