Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab0E0Epm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:45:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49060 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab0E0Epk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:45:40 -0400
Date: Thu, 27 May 2010 05:45:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ciprian Docan <docan@eden.rutgers.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: don't hold s_umount over close_bdev_exclusive() call
Message-ID: <20100527044528.GZ31073@ZenIV.linux.org.uk>
References: <Pine.SOC.4.64.1005201226440.1441@er1.rutgers.edu>
 <20100521141445.bae41292.akpm@linux-foundation.org>
 <4BF7EFA4.4050901@kernel.org>
 <20100525083003.GE23411@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525083003.GE23411@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:30:03AM +0200, Jens Axboe wrote:
> On Sat, May 22 2010, Tejun Heo wrote:
> > This patch fixes an obscure AB-BA deadlock in get_sb_bdev().
> > 
> > When a superblock is mounted more than once get_sb_bdev() calls
> > close_bdev_exclusive() to drop the extra bdev reference while holding
> > s_umount.  However, sb->s_umount nests inside bd_mutex during
> > __invalidate_device() and close_bdev_exclusive() acquires bd_mutex
> > during blkdev_put(); thus creating an AB-BA deadlock.
> > 
> > This condition doesn't trigger frequently.  For this condition to be
> > visible to lockdep, the filesystem must occupy the whole device (as
> > __invalidate_device() only grabs bd_mutex for the whole device), the
> > FS must be mounted more than once and partition rescan should be
> > issued while the FS is still mounted.
> > 
> > Fix it by dropping s_umount over close_bdev_exclusive().
> 
> Looks safe to me, since it has (as you note) an elevated ref count.

Ehh...  It's probably OK, but I'm worried about the interplay with
->bd_fsfreeze_mutex logics there ;-/
