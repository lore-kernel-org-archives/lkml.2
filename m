Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2BFV2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:28:02 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26604 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817Ab2BFV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:27:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQEAG1FME95LD+bgWdsb2JhbABDr0QjAQEWJiWBcgEBBAE6HCMFCwgDDgouFCUDIROHfLhwE4shAgIJBQwHBgELAQgFAwMJBgQPBoQeAQMBBBgCBIJWYwSVJ4kwiUA
Date: Tue, 7 Feb 2012 08:27:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>, xfs@oss.sgi.com,
        xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
 xfs_setattr_nonsize()
Message-ID: <20120206212754.GC12836@dastard>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
 <20120206091100.GA4350@Xye>
 <alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 09:51:54PM +0100, Jesper Juhl wrote:
> On Mon, 6 Feb 2012, Raghavendra D Prabhu wrote:
> > As far as second one is concerned, looks fine, though this one should also do
> > the same.
> > 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ab30253..d331f5b 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -730,9 +730,9 @@ xfs_setattr_nonsize(
> >         return 0;
> > 
> > out_trans_cancel:
> > -       xfs_trans_cancel(tp, 0);
> >         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > out_dqrele:
> > +       xfs_trans_cancel(tp, 0);
> >         xfs_qm_dqrele(udqp);
> >         xfs_qm_dqrele(gdqp);
> >         return error;
> > 
> 
> Thank you for the feedback.
> 
> I worry about the fact that this suddenly calls xfs_trans_cancel() without 
> holding the lock. I don't know if that's actually significant though. 

You're right to worry about it, because it is significant.

The transaction needs to be cancelled before we unlock the inode
because the transaction cancel cleans up state on the inode if the
inode has been joined to the transaction.  Unlocking the inode
before the transaction is cancelled means some other transaction can
lock the inode and join it to a new transaction before the old one
is cleaned up. Then Bad Stuff Happens.

IOWs, the above change is not safe to make.

> If it *is* significant, then I think the patch I just submitted in reply to 
> Dave Chinner is better since there we do the alloc and cancel before even 
> taking the lock at all in the leaky case and all other case have 
> identical behaviour as before.

I'll go check it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
