Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0K3Ehy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:37:54 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:51664 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753034Ab0K3Ehx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:37:53 -0500
Date: Tue, 30 Nov 2010 15:37:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Message-ID: <20101130043741.GD3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
 <1290991002-18680-3-git-send-email-david@fromorbit.com>
 <20101129091610.GA13902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129091610.GA13902@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:16:10AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 11:36:40AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS has a per-cpu counter implementation for in-core superblock
> > counters that pre-dated the generic implementation. It is complex
> > and baroque as it is tailored directly to the needs of ENOSPC
> > detection.
> > 
> > Now that the generic percpu counter infrastructure has the
> > percpu_counter_add_unless_lt() function that implements the
> > necessary threshold checks for us, switch the XFS per-cpu
> > superblock counters to use the generic percpu counter
> > infrastructure.
> 
> Looks good, but a few comments below:
> 
> > +/*
> > + * Per-cpu incore superblock counters
> > + *
> > + * Simple concept, difficult implementation, now somewhat simplified by generic
> > + * per-cpu counter support.  This provides distributed per cpu counters for
> > + * contended fields (e.g.  free block count).
> 
> The kind of historic comments like now simplified by  .. don't make any
> sense after only a short while.  I'd just remove the first senstence
> above, as the details of the problems are explained much better later.

Ok, will do.
> 
> > +static inline int
> > +xfs_icsb_add(
> > +	struct xfs_mount	*mp,
> > +	int			counter,
> > +	int64_t			delta,
> > +	int64_t			threshold)
> > +{
> > +	int			ret;
> > +
> > +	ret = percpu_counter_add_unless_lt(&mp->m_icsb[counter], delta,
> > +								threshold);
> > +	if (ret < 0)
> > +		return -ENOSPC;
> > +	return 0;
> > +}
> > +
> > +static inline void
> > +xfs_icsb_set(
> > +	struct xfs_mount	*mp,
> > +	int			counter,
> > +	int64_t			value)
> > +{
> > +	percpu_counter_set(&mp->m_icsb[counter], value);
> > +}
> > +
> > +static inline int64_t
> > +xfs_icsb_sum(
> > +	struct xfs_mount	*mp,
> > +	int			counter)
> > +{
> > +	return percpu_counter_sum_positive(&mp->m_icsb[counter]);
> > +}
> 
> I still don't like these wrappers.  They are all local to xfs_mount.c,
> and only have a single function calling them.  See the RFC patch below
> which removes them, and imho makes the code more readable.  Especially
> in xfs _add case where we can get rid of one level of error remapping,
> and go directly from the weird percpu return values to the positive
> xfs errors instead of doing a detour via the negative linux errors.

Ok, if we need to tweak the batch size in future, then we can deal
with it then. I'll clean it up as you suggest...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
