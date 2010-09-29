Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0I2MTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab0I2MTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:04 -0400
Date: Wed, 29 Sep 2010 14:18:08 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Micha?? Piotrowski <mkkp4x4@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>, kernel@lists.fedoraproject.org
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20100929121808.GB3290@quack.suse.cz>
References: <4C9AA546.6050201@cesarb.net>
 <20100923123849.8975fe47.akpm@linux-foundation.org>
 <20100927222548.GG3610@quack.suse.cz>
 <20100927225452.GG4270@think>
 <20100929081936.GA23322@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929081936.GA23322@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-09-10 10:19:36, Christoph Hellwig wrote:
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH] writeback: always use sb->s_bdi for writeback purposes
> 
...
> The one exception for now is the block device filesystem which really
> wants different writeback contexts for it's different (internal) inodes
> to handle the writeout more efficiently.  For now we do this with
> a hack in fs-writeback.c because we're so late in the cycle, but in
> the future I plan to replace this with a superblock method that allows
> for multiple writeback contexts per filesystem.
  Another exception I know about is mtd_inodefs filesystem
(drivers/mtd/mtdchar.c).

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-09-29 16:58:41.750557721 +0900
> +++ linux-2.6/fs/fs-writeback.c	2010-09-29 17:11:35.040557719 +0900
> @@ -72,22 +72,10 @@ int writeback_in_progress(struct backing
>  static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
> -	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
>  
> -	/*
> -	 * For inodes on standard filesystems, we use superblock's bdi. For
> -	 * inodes on virtual filesystems, we want to use inode mapping's bdi
> -	 * because they can possibly point to something useful (think about
> -	 * block_dev filesystem).
> -	 */
> -	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
> -		/* Some device inodes could play dirty tricks. Catch them... */
> -		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
> -			"Dirtiable inode bdi %s != sb bdi %s\n",
> -			bdi->name, sb->s_bdi->name);
> -		return sb->s_bdi;
> -	}
> -	return bdi;
> +	if (strcmp(sb->s_type->name, "bdev") == 0)
> +		return inode->i_mapping->backing_dev_info;
> +	return sb->s_bdi;
  So at least here you'd need also add a similar exception for
"mtd_inodefs". Because of these exeptions I've chosen the
(sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) check rather than your
exception based check. All in all I don't care much what ends up in the
kernel as it's just a temporary solution...
  Also I've added the warning to catch situations where inodes would get
filed to a different backing device after the patch. So far the reported
warnings were harmless but still I'm more comfortable when it's there
because otherwise we can so easily miss some device-driver-invented
filesystem like mtd_inodefs which would break silently after the change...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
