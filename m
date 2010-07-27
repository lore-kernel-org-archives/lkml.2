Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0G0RJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:09:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0G0RJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:09:05 -0400
Date: Tue, 27 Jul 2010 13:09:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727170903.GA9034@infradead.org>
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

> +static struct backing_dev_info *inode_to_bdi(struct inode *inode)
> +{
> +	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
> +
> +	/*
> +	 * This is a hack but it solves a problem with device inode
> +	 * for e.g. /dev/zero getting dirty (via touch or so) and confusing
> +	 * writeback code. In such cases we return the "parent" filesystem's
> +	 * bdi.
> +	 */
> +	if (bdi_cap_writeback_dirty(bdi))
> +		return bdi;
> +	return inode->i_sb->s_bdi;

When do we ever have a writeback-capable bdi that sits inside another
filesystem?  I think just always using inode->i_sb->s_bdi is the right
thing here.

And btw, having a BDI_CAP_NO_WRITEBACK instead of a BDI_CAP_WRITEBACK
is rather dumb, we'd better fix it up while we're at it.

