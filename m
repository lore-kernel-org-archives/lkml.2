Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0G0UMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:12:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0G0UMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:12:09 -0400
Date: Tue, 27 Jul 2010 16:12:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727201207.GA16335@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
 <20100727172437.GE6820@quack.suse.cz>
 <20100727172731.GA25727@infradead.org>
 <20100727180131.GG6820@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727180131.GG6820@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 08:01:31PM +0200, Jan Kara wrote:
> > It shouldn't.  Block device nodes are on the bdev filesystems, and
>   Ok, so inode->i_sb->s_bdi will actually point to noop_backing_dev_info
> as set by set_anon_super(). Or am I completely out?

I think you're right.  This seems rather bad if it's indeed true. I'll
quickly verify it using Dave's new tracing once I've built a block
tree kernel.

> > we twist the file->mapping pointer so that all the low-level read/write
> > code always deals with the bdev fs inode, and not the device node
> > filesystem.
>
> Yes, I know this but I fail to see how this influences where </dev/sda's
> inode>->i_sb->s_bdi ends up...

Ok, let's say we write to /dev/sda.  For this we call

	blkdev_aio_write -> __generic_file_aio_write

There we get the inode we operate on as

	struct file *file = iocb->ki_filp;
	struct address_space * mapping = file->f_mapping;
	struct inode    *inode = mapping->host;

Now file->f_mapping gets set up in blkdev_open as:

	filp->f_mapping = bdev->bd_inode->i_mapping;

so it does not point to the inode of the device node, but an inode on
the bdev filesystem.
