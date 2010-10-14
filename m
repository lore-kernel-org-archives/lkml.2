Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0JNAGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:06:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52479 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0JNAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:06:34 -0400
Date: Wed, 13 Oct 2010 20:06:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: fs: Inode cache scalability V3
Message-ID: <20101014000634.GA21905@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <20101013145102.GA12155@infradead.org>
 <20101013155845.GB22447@infradead.org>
 <20101013214609.GA24695@infradead.org>
 <20101013233647.GA18691@infradead.org>
 <20101013235552.GA4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013235552.GA4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:55:52AM +1100, Dave Chinner wrote:
> > I wonder what's a good workaround for that.  Just flushing out all
> > dirty state of a block device inode on last close would fix, but we'd
> > still have all the dragons hidden underneath until we finally sort
> > out the bdi reference mess.
> 
> Perhaps for the moment make __blkdev_put() move the inode onto the
> dirty lists for the default bdi when it switches them???in the
> mapping? e.g. add a "inode_switch_bdi" helper that is only called in
> this case?

I really hate to sprinkle special cases all over, but given that Linus
decreed he's not going to take larger writeback changes which would be
required to fix this for .37 it'll be hard to avoid this.

Note that it would really be a bdev_inode_switch_bdi - since the move
to using ->s_bdi for all other inodes these hacks aren't required
anymore, it's just the block devices that continue using the bdi
from the mapping that are causing problems.

