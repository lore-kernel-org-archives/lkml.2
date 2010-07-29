Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0G2IMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:12:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0G2IMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:12:12 -0400
Date: Thu, 29 Jul 2010 04:12:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100729081210.GA395@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280250301-17603-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that we only need the per-mapping one for the bdev fs what about
doing:

/*
 * Return the writeback-relevant backing device for this inode.
 *
 * For a normal filesystem this must always be the bdi hanging off the
 * superblock, given that we only expect one bdi per filesystems in
 * the per-superblock sync functions.  But the block device special
 * filesystem requires a quick given that it contains the internal
 * I/O inodes for block devices on a single superblock.  This works
 * because the block deevice filesystem inodes are never user visible
 * and we will never do a per-superblock sync on it.
 */
static struct backing_dev_info *inode_to_bdi(struct inode *inode)
{
	if (inode->i_sb == blockdev_superblock)
		return inode->i_mapping->backing_dev_info;
	return inode->i_sb->s_bdi;
}

that also avoids the need for doing the bdi capabilities audit ASAP.
