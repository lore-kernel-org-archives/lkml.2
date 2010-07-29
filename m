Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab0G2MRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:17:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:42978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab0G2MRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:17:49 -0400
Date: Thu, 29 Jul 2010 14:17:21 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100729121721.GC3757@quack.suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100729081210.GA395@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729081210.GA395@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-07-10 04:12:10, Christoph Hellwig wrote:
> Given that we only need the per-mapping one for the bdev fs what about
> doing:
> 
> /*
>  * Return the writeback-relevant backing device for this inode.
>  *
>  * For a normal filesystem this must always be the bdi hanging off the
>  * superblock, given that we only expect one bdi per filesystems in
>  * the per-superblock sync functions.  But the block device special
>  * filesystem requires a quick given that it contains the internal
>  * I/O inodes for block devices on a single superblock.  This works
>  * because the block deevice filesystem inodes are never user visible
>  * and we will never do a per-superblock sync on it.
>  */
> static struct backing_dev_info *inode_to_bdi(struct inode *inode)
> {
> 	if (inode->i_sb == blockdev_superblock)
> 		return inode->i_mapping->backing_dev_info;
> 	return inode->i_sb->s_bdi;
> }
> 
> that also avoids the need for doing the bdi capabilities audit ASAP.
  Well, but I'm not sure we'll help ourselves with having to do audit this
way. Some other pseudofilesystems can play tricks with backing_dev_info as
well and thus inode->i_mapping->backing_dev_info != inode->i_sb->s_bdi. In
particular MTD seems to do such things. As I'm looking at the code, it
looks like a similar case as blockdev filesystem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
