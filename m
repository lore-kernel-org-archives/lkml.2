Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0CQClQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:41:16 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:34687 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752380Ab0CQClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:41:15 -0400
Date: Wed, 17 Mar 2010 13:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       aelder@sgi.com
Subject: Re: [PATCH] xfs: Fix integer overflow in
 fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100317024101.GH12369@dastard>
References: <20100316155350.GB18579@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316155350.GB18579@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 11:53:50PM +0800, wzt.wzt@gmail.com wrote:
> STATIC int
> xfs_compat_attrmulti_by_handle(
>         struct file                             *parfilp,
>         void                                    __user *arg)
> {
> ...
>         if (copy_from_user(&am_hreq, arg,
>                            sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
>                 return -XFS_ERROR(EFAULT);
> ...
>         error = E2BIG;
>         /* Not check the am_hreq.opcount max value from userspace, 
>         m_hreq.opcount * sizeof(compat_xfs_attr_multiop_t) can make
>         integer overflow, and the if condition can be bypass. Though,
>         it can not make security problem, but fix it maybe better. */
>         size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
>         if (!size || size > 16 * PAGE_SIZE)
>                 goto out_dput;
> ...
> }

This description could use a little work. ;)

Perhaps something like:

The am_hreq.opcount field in the xfs_attrmulti_by_handle() interface
is not bounded correctly. The opcount is used to determine the size
of the buffer required. The size is bounded, but can overflow and so
the size checks may not be sufficient to catch invalid opcounts.
Fix it by catching opcount values that would cause overflows before
calculating the size.


> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
>  fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index 4ea1ee1..b05b3b7 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
>  	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
>  		return -XFS_ERROR(EFAULT);
>  
> +	/* overflow check */
> +	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
> +		return -ENOMEM;
> +

The code currently return E2BIG for an opcount that is too large.
I think this should also return E2BIG rather then ENOMEM. Does that
seem reasonable?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
