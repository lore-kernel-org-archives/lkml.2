Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0EYIaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:30:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51320 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0EYIaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:30:05 -0400
Date: Tue, 25 May 2010 10:30:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ciprian Docan <docan@eden.rutgers.edu>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: don't hold s_umount over close_bdev_exclusive()
	call
Message-ID: <20100525083003.GE23411@kernel.dk>
References: <Pine.SOC.4.64.1005201226440.1441@er1.rutgers.edu> <20100521141445.bae41292.akpm@linux-foundation.org> <4BF7EFA4.4050901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF7EFA4.4050901@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22 2010, Tejun Heo wrote:
> This patch fixes an obscure AB-BA deadlock in get_sb_bdev().
> 
> When a superblock is mounted more than once get_sb_bdev() calls
> close_bdev_exclusive() to drop the extra bdev reference while holding
> s_umount.  However, sb->s_umount nests inside bd_mutex during
> __invalidate_device() and close_bdev_exclusive() acquires bd_mutex
> during blkdev_put(); thus creating an AB-BA deadlock.
> 
> This condition doesn't trigger frequently.  For this condition to be
> visible to lockdep, the filesystem must occupy the whole device (as
> __invalidate_device() only grabs bd_mutex for the whole device), the
> FS must be mounted more than once and partition rescan should be
> issued while the FS is still mounted.
> 
> Fix it by dropping s_umount over close_bdev_exclusive().

Looks safe to me, since it has (as you note) an elevated ref count.

Acked-by: Jens Axboe <jens.axboe@oracle.com>


-- 
Jens Axboe

