Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1F3Umv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:42:51 -0400
Received: from sandeen.net ([63.231.237.45]:54593 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1F3Ums (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:42:48 -0400
X-Greylist: delayed 1834 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 16:42:48 EDT
Message-ID: <4E0CD89D.3080001@sandeen.net>
Date: Thu, 30 Jun 2011 15:12:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Lachlan McIlroy <lmcilroy@redhat.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: initialise bd_super in bdget()
References: <1309395705-4473-1-git-send-email-lmcilroy@redhat.com>
In-Reply-To: <1309395705-4473-1-git-send-email-lmcilroy@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/11 8:01 PM, Lachlan McIlroy wrote:
> bd_super is currently reset to NULL in kill_block_super() so we rely on previous
> users of the block_device object to initialise this value for the next user.
> This quirk was exposed on RHEL5 when a third party filesystem did not always use
> kill_block_super() and therefore bd_super wasn't being reset when a block_device
> object was recycled within the cache.  This may not be a problem upstream but
> makes sense to be defensive.
> 
> Signed-off-by: Lachlan McIlroy <lmcilroy@redhat.com>
> ---

This seems reasonable to me, I think it's dangerous to assume the prior user
will "put it away" properly.

blkdev_releasepage() then may try to deref it and go boom, without this
explicit initialization.

And there is already other initialization in bdget()...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  fs/block_dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 610e8e0..2b0dc33 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -547,6 +547,7 @@ struct block_device *bdget(dev_t dev)
>  
>  	if (inode->i_state & I_NEW) {
>  		bdev->bd_contains = NULL;
> +		bdev->bd_super = NULL;
>  		bdev->bd_inode = inode;
>  		bdev->bd_block_size = (1 << inode->i_blkbits);
>  		bdev->bd_part_count = 0;

