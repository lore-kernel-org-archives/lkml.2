Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2BIIMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:12:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:40895 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab2BIIMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:12:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104820187"
Date: Thu, 9 Feb 2012 16:02:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Shaohua <shaohua.li@intel.com>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120209080224.GA28465@localhost>
References: <20120208110143.GA5550@localhost>
 <20120208232719.GD7479@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208232719.GD7479@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:27:19AM +1100, Dave Chinner wrote:
> On Wed, Feb 08, 2012 at 07:01:44PM +0800, Wu Fengguang wrote:
> > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > handle plug in generic_file_aio_write().
> 
> But generic_sync_write() does issue IO for O_SYNC writes, so unless
> there is plugging at a lower layer in the writeback code then it
> appears to me that plugging is still necessary (at least inside the
> sync branch)....

Good catch! It looks that generic_write_sync() eventually calls into
vfs_fsync_range() which further calls ->fsync(). We may add plugging
around it:

--- linux-next.orig/fs/sync.c   2012-02-09 15:59:52.000000000 +0800
+++ linux-next/fs/sync.c        2012-02-09 16:01:02.000000000 +0800
@@ -164,9 +164,17 @@ SYSCALL_DEFINE1(syncfs, int, fd)
  */
 int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 {
+       struct blk_plug plug;
+       int ret;
+
        if (!file->f_op || !file->f_op->fsync)
                return -EINVAL;
-       return file->f_op->fsync(file, start, end, datasync);
+
+       blk_start_plug(&plug);
+       ret = file->f_op->fsync(file, start, end, datasync);
+       blk_finish_plug(&plug);
+
+       return ret;
 }
 EXPORT_SYMBOL(vfs_fsync_range);

