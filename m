Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0F3H15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:27:57 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:40131 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682Ab0F3H1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:27:55 -0400
Date: Wed, 30 Jun 2010 17:27:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-ID: <20100630072702.GF24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030730.245992858@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030730.245992858@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:41PM +1000, npiggin@suse.de wrote:
> Protect inode->i_count with i_lock, rather than having it atomic.
> Next step should also be to move things together (eg. the refcount increment
> into d_instantiate, which will remove a lock/unlock cycle on i_lock).
.....
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c
> +++ linux-2.6/fs/inode.c
> @@ -33,14 +33,13 @@
>   * inode_hash_lock protects:
>   *   inode hash table, i_hash
>   * inode->i_lock protects:
> - *   i_state
> + *   i_state, i_count
>   *
>   * Ordering:
>   * inode_lock
>   *   sb_inode_list_lock
>   *     inode->i_lock
> - * inode_lock
> - *   inode_hash_lock
> + *       inode_hash_lock
>   */

I thought that the rule governing the use of inode->i_lock was that
it can be used anywhere as long as it is the innermost lock.

Hmmm, no references in the code or documentation. Google gives a
pretty good reference:

http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02584.html

Perhaps a different/new lock needs to be used here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
