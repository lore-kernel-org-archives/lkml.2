Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2BFGXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:23:22 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:21287 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2BFGXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:23:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFxuL095LD+b/2dsb2JhbABDrzaBBoFyAQEEATocIwULCAMOCi4UJQMhE4d8uGgTi1cCAgkFDAcGAQsBCAUDAwkGBA8GhB4BAwEEGAIEglZjBJUniTCJQA
Date: Mon, 6 Feb 2012 17:23:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
 xfs_setattr_nonsize()
Message-ID: <20120206062319.GB12836@dastard>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 10:23:44PM +0100, Jesper Juhl wrote:
> In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
> _xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
> fail and return NULL. So this:
> 
> 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> 
> may result in a NULL 'tp'.
> If it does, then the call:
> 
> 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> 
> with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
> its first argument unconditionally.

xfs_trans_alloc() can't fail. It will sleep forever until the memory
allocation succeeds.

There's 35 other places in XFS where this xfs_trans_alloc/
xfs_trans_reserve pattern occurs - none of them check whether tp is
null, either.

> And if the memory allocation for 'tp' goes well (and thus
> xfs_trans_reserve() does not explode) then we may leak the memory
> allocated to 'tp' if xfs_trans_reserve() returns error.

yes, that's a problem, though will only happen if a filesystem
shutdown occurs between the start of the function and that check.

> 
> I believe this patch should fix both issues, but I'm not intimate with
> the XFS code at all, so there can easily be something I overlooked or
> something that should be done differently than what I did.

Only need to fix the leak of tp.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
