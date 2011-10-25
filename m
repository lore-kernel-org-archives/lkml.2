Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1JYUHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:07:51 -0400
Received: from peace.netnation.com ([204.174.223.2]:46849 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1JYUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:07:50 -0400
Date: Tue, 25 Oct 2011 13:07:48 -0700
From: Simon Kirby <sim@hostway.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111025200748.GA25043@hostway.ca>
References: <20111020224214.GC22772@hostway.ca> <20111021132240.GA24136@infradead.org> <20111021202857.GB30100@hostway.ca> <20111024082219.GA19941@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024082219.GA19941@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 04:22:19AM -0400, Christoph Hellwig wrote:

> On Fri, Oct 21, 2011 at 01:28:57PM -0700, Simon Kirby wrote:
> > > So we're waiting for the inode to be flushed, aka I/O again.
> > 
> > But I don't seem to see any queued I/O, hmm.
> 
> Well, as far as XFS is concerned the inode is beeing flushed and
> the buffer is locked.  It could be stuck in the XFS internal delwri
> list because a buffer for example is pinned.
> 
> If that is the case the big hammer patch I attached below - probably
> not the final issue, but it should fix the hang if that is the case.
> 
> > > If this doesn't help I'll probably need to come up with some tracing
> > > patches for you.
> > 
> > It seemes 3.0.7+gregkh's stable-queue queue-3.0 patches seems to be
> > running fine without blocking at all on this SSD box, so that should
> > narrow it down significantly.
> > 
> > Hmm, looking at git diff --stat v3.0.7..v3.1-rc10 fs/xfs , maybe not.. :)
> > 
> > Maybe 3.1 fs/xfs would transplant into 3.0 or vice-versa?
> 
> If the patch above doesn't work I'll prepare a backport for you.
> 
> Index: linux-2.6/fs/xfs/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_sync.c	2011-10-24 10:02:27.361971264 +0200
> +++ linux-2.6/fs/xfs/xfs_sync.c	2011-10-24 10:11:03.301036954 +0200
> @@ -764,7 +764,8 @@ xfs_reclaim_inode(
>  	struct xfs_perag	*pag,
>  	int			sync_mode)
>  {
> -	int	error;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
>  
>  restart:
>  	error = 0;
> @@ -772,6 +773,18 @@ restart:
>  	if (!xfs_iflock_nowait(ip)) {
>  		if (!(sync_mode & SYNC_WAIT))
>  			goto out;
> +
> +		/*
> +		 * If the inode is flush locked we probably had someone else
> +		 * push it to the buffer and the buffer is now sitting in
> +		 * the delwri list.
> +		 *
> +		 * Use the big hammer to force it.
> +		 */
> +		xfs_log_force(mp, XFS_LOG_SYNC);
> +		set_bit(XBT_FORCE_FLUSH, &mp->m_ddev_targp->bt_flags);
> +		wake_up_process(mp->m_ddev_targp->bt_task);
> +
>  		xfs_iflock(ip);
>  	}
>  

This patch seems to work, at least on an SSD box. No more hung task
warnings, and everything appears normal.

Do we know what caused this regression and/or how to fix it without the
big hammer, or do we need to break it down further?

Thanks!

Simon-
