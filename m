Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0DTCfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:35:03 -0400
Received: from ozlabs.org ([203.10.76.45]:35724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab0DTCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:35:00 -0400
Date: Tue, 20 Apr 2010 12:30:47 +1000
From: Anton Blanchard <anton@samba.org>
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block devices
Message-ID: <20100420023047.GN11751@kryten>
References: <20100415044039.GJ11751@kryten>
 <20100415104224.GA27482@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415104224.GA27482@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We are seeing a large regression in database performance on recent kernels.
The database opens a block device with O_DIRECT|O_SYNC and a number of threads
write to different regions of the file at the same time.

A simple test case is below. I haven't defined DEVICE since getting it wrong
will destroy your data :) On an 3 disk LVM with a 64k chunk size we see about
17MB/sec and only a few threads in IO wait:

procs  -----io---- -system-- -----cpu------
 r  b     bi    bo   in   cs us sy id wa st
 0  3      0 16170  656 2259  0  0 86 14  0
 0  2      0 16704  695 2408  0  0 92  8  0
 0  2      0 17308  744 2653  0  0 86 14  0
 0  2      0 17933  759 2777  0  0 89 10  0

Most threads are blocking in vfs_fsync_range, which has:

        mutex_lock(&mapping->host->i_mutex);
        err = fop->fsync(file, dentry, datasync);
        if (!ret)
                ret = err;
        mutex_unlock(&mapping->host->i_mutex);

commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new helpers for
syncing after writing to O_SYNC file or IS_SYNC inode) offers some explanation
of what is going on:

    Use these new helpers for syncing from generic VFS functions. This makes
    O_SYNC writes to block devices acquire i_mutex for syncing. If we really
    care about this, we can make block_fsync() drop the i_mutex and reacquire
    it before it returns.

Thanks Jan for such a good commit message! As well as dropping i_mutex,
Christoph suggests we should remove the call to sync_blockdev():

> sync_blockdev is an overcomplicated alias for filemap_write_and_wait on
> the block device inode, which is exactly what we did just before calling
> into ->fsync

The patch below incorporates both suggestions. With it the testcase improves
from 17MB/s to 68M/sec:

procs  -----io---- -system-- -----cpu------
 r  b     bi    bo   in   cs us sy id wa st
 0  7      0 65536 1000 3878  0  0 70 30  0
 0 34      0 69632 1016 3921  0  1 46 53  0
 0 57      0 69632 1000 3921  0  0 55 45  0
 0 53      0 69640  754 4111  0  0 81 19  0


Testcase:

#define _GNU_SOURCE
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define NR_THREADS 64
#define BUFSIZE (64 * 1024)

#define DEVICE "/dev/mapper/XXXXXX"

#define ALIGN(VAL, SIZE) (((VAL)+(SIZE)-1) & ~((SIZE)-1))

static int fd;

static void *doit(void *arg)
{
	unsigned long offset = (long)arg;
	char *b, *buf;

	b = malloc(BUFSIZE + 1024);
	buf = (char *)ALIGN((unsigned long)b, 1024);
	memset(buf, 0, BUFSIZE);

	while (1)
		pwrite(fd, buf, BUFSIZE, offset);
}

int main(int argc, char *argv[])
{
	int flags = O_RDWR|O_DIRECT;
	int i;
	unsigned long offset = 0;

	if (argc > 1 && !strcmp(argv[1], "O_SYNC"))
		flags |= O_SYNC;

	fd = open(DEVICE, flags);
	if (fd == -1) {
		perror("open");
		exit(1);
	}

	for (i = 0; i < NR_THREADS-1; i++) {
		pthread_t tid;
		pthread_create(&tid, NULL, doit, (void *)offset);
		offset += BUFSIZE;
	}
	doit((void *)offset);

	return 0;
}


Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2010-04-20 11:28:32.000000000 +1000
+++ linux-2.6/fs/block_dev.c	2010-04-20 11:36:46.000000000 +1000
@@ -406,16 +406,23 @@ static loff_t block_llseek(struct file *
  
 int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
 {
-	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
+	struct inode *bd_inode = filp->f_mapping->host;
+	struct block_device *bdev = I_BDEV(bd_inode);
 	int error;
 
-	error = sync_blockdev(bdev);
-	if (error)
-		return error;
-	
+	/*
+	 * There is no need to serialise calls to blkdev_issue_flush with
+	 * i_mutex and doing so causes performance issues with concurrent
+	 * O_SYNC writers to a block device.
+	 */
+	mutex_unlock(&bd_inode->i_mutex);
+
 	error = blkdev_issue_flush(bdev, NULL);
 	if (error == -EOPNOTSUPP)
 		error = 0;
+
+	mutex_lock(&bd_inode->i_mutex);
+
 	return error;
 }
 EXPORT_SYMBOL(blkdev_fsync);
