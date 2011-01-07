Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1AGNKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:10:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1AGNKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:10:21 -0500
Date: Fri, 7 Jan 2011 08:10:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110107131015.GA15028@infradead.org>
References: <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104092501.GB2760@infradead.org>
 <20110104094922.GA4812@amd>
 <20110106204510.GA2872@infradead.org>
 <20110107044734.GA4552@amd>
 <20110107072430.GA32308@infradead.org>
 <20110107072934.GA2849@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107072934.GA2849@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:29:34AM -0500, Christoph Hellwig wrote:
> Btw, there's an easy way how we could get this right, in fact
> the write_inode in XFS is already trying to do it, it's just the
> caller not copying with it:
> 
>  - if we can't get locks for a non-blocking ->write_inode we return
>    EAGAIN, and the callers sets the dirty bits again.

I just tried to implement this and noticed we're actually doing this
inside XFS - if we get our EAGAIN error from the lower level code
in ->write_inode we do a manual mark_inode_dirty_sync().  So as far
as XFS is concerned ->write_inode always pushes data into a state
where ->sync_fs writes it out, or if it was called with WB_SYNC_NONE
and couldn't get the locks redirties the inode, and thus is not affected
by the issue you mentioned.  I think this is also a good model for
other filesystems to follow.
