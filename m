Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1AGH3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:29:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1AGH3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:29:35 -0500
Date: Fri, 7 Jan 2011 02:29:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107072934.GA2849@infradead.org>
References: <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104092501.GB2760@infradead.org>
 <20110104094922.GA4812@amd>
 <20110106204510.GA2872@infradead.org>
 <20110107044734.GA4552@amd>
 <20110107072430.GA32308@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107072430.GA32308@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:24:30AM -0500, Christoph Hellwig wrote:
> On Fri, Jan 07, 2011 at 03:47:34PM +1100, Nick Piggin wrote:
> > No, you misunderstand 1. I am saying they should be treated as
> > WB_SYNC_NONE.
> > 
> > In fact 2 would cause much more IO, because dirty writeout would
> > never clean them so it will just keep writing them out. I don't
> > know how 2 could be feasible.
> 
> WB_SYNC_NONE means ->write_inode behaves non-blocking.  That is
> we do not block on memory allocations, and we do not take locks
> blocking.  Most journaling filesystems currently take the easy
> way out an make it a no-op due to that, but take a look at XFS
> how complicated it is to avoid the blocking if you want a non-noop
> implementation.

Btw, there's an easy way how we could get this right, in fact
the write_inode in XFS is already trying to do it, it's just the
caller not copying with it:

 - if we can't get locks for a non-blocking ->write_inode we return
   EAGAIN, and the callers sets the dirty bits again.
