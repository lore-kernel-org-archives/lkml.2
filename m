Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0G0RZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:25:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:45771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0G0RZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:25:04 -0400
Date: Tue, 27 Jul 2010 19:24:38 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727172437.GE6820@quack.suse.cz>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727170903.GA9034@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-07-10 13:09:03, Christoph Hellwig wrote:
> > +static struct backing_dev_info *inode_to_bdi(struct inode *inode)
> > +{
> > +	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
> > +
> > +	/*
> > +	 * This is a hack but it solves a problem with device inode
> > +	 * for e.g. /dev/zero getting dirty (via touch or so) and confusing
> > +	 * writeback code. In such cases we return the "parent" filesystem's
> > +	 * bdi.
> > +	 */
> > +	if (bdi_cap_writeback_dirty(bdi))
> > +		return bdi;
> > +	return inode->i_sb->s_bdi;
> 
> When do we ever have a writeback-capable bdi that sits inside another
> filesystem?  I think just always using inode->i_sb->s_bdi is the right
> thing here.
  Always returning inode->i_sb->s_bdi wouldn't be a right thing IMHO.
That would file inode for /dev/sda to BDI list of tmpfs mounted on /dev/
which isn't what you want...

> And btw, having a BDI_CAP_NO_WRITEBACK instead of a BDI_CAP_WRITEBACK
> is rather dumb, we'd better fix it up while we're at it.
  Yes, that seems reasonable. I'm just not sure how many places one has
to change to fix this and how to find them... Maybe grepping for BDI_CAP_
will be enough but I'm not sure.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
