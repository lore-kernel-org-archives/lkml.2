Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab1CDOIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:08:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab1CDOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:08:15 -0500
Date: Fri, 4 Mar 2011 09:08:14 -0500
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "hch@infradead.org" <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110304140814.GA28953@infradead.org>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
 <20110304040907.GB32404@redhat.com>
 <4D70E78D.9000402@fusionio.com>
 <20110304132551.GA2407@infradead.org>
 <4D70EBB9.302@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70EBB9.302@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 02:40:09PM +0100, Jens Axboe wrote:
> > REQ_META?  Maybe we should finally agree what it does and decide if it
> > should be used consistenly.  Especially the priority over REQ_SYNC in
> > cfq still looks somewhat odd, as does the totally inconsequent use.
> 
> For me it was primarily a blktrace hint, but yes it does have prio boost
> properties in CFQ as well. I'm inclined to let those stay the way they
> are. Not sure we can properly call it anything outside of a hint that
> these IO have slightly higher priority, at least I would not want to
> lock the IO scheduler into to something more concrete than that.

The problem is that these two meanings are inherently conflicting.
Metadata updates do not have to be synchronous or have any kind of
priority.  In fact for XFS they normall aren't, and I'd be surprised it
the same isn't true for other journalled filesystems.

Priority metadata goes into the log, which for XFS is always written as
a FLUSH+FUA bio.  Writeback of metadata happens asynchronously in the
background, and only becomes a priority if the journal is full and we'll
need to make space available.

So giving plain REQ_META a priority boost makes it impossible to use it
for the blktrace annotation use case.  One could only apply the boost
for the REQ_SYNC + REQ_META combination, but even that seems rather
hackish to me.  I'd really love to see numbers where the additional
boost of REQ_META over REQ_SYNC makes any difference.

