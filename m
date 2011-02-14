Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1BNLqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:46:35 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5995 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab1BNLqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:46:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG6iWE15LMsw/2dsb2JhbACmBXS5Tg2FUQSRSQ
Date: Mon, 14 Feb 2011 22:46:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: aelder@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, security@kernel.org
Subject: Re: [PATCH] xfs: prevent leaking uninitialized stack memory in
 FSGEOMETRY_V1
Message-ID: <20110214114629.GA13052@dastard>
References: <1297347904.13370.9.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297347904.13370.9.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 09:25:04AM -0500, Dan Rosenberg wrote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.  Since all other members are filled in all code
> paths and there are no padding bytes in this structure, it's safe to
> avoid an expensive memset() in favor of just clearing this one field.

If this really is a security problem, then it should use a memset.
This is not a performance critical path and there are differences in
the padding of the structure between 32 bit and 64 bit ioctl
variants (it has a compat ioctl handler) and that can only be
correctly handled by memset().

Also, using a memset means we won't have the problem of introducing
new uninitialised fields or padding if we ever rev the structure
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
