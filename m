Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab2LHAtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:49:02 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39844 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2LHAtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:49:00 -0500
Date: Fri, 7 Dec 2012 16:48:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@air.linux-foundation.org
To: Milan Broz <mbroz@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Read O_DIRECT regression in 3.7-rc8 (bisected)
In-Reply-To: <50C2820B.5060005@redhat.com>
Message-ID: <alpine.LFD.2.02.1212071640510.24455@air.linux-foundation.org>
References: <50C2820B.5060005@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2012, Milan Broz wrote:
> 
> seems this commit in 3.7-rc8 caused regression for O_DIRECT
> read near the end of the device.

Oh, good find, and thanks for the test-case. I had looked at the O_DIRECT 
side, and convinced myself that it already truncates to i_size_read(), but 
it looks like that actually only happens for the *write* side for some 
reason.

So apparently the read side doesn't have anything like that.

This (TOTALLY UNTESTED) patch adds it the same iov_shorten() logic that 
the write side has. It does it differently (in fs/block_dev.c rather than 
in mm/filemap.c), but I actually suspect this is a nicer way to do it, and 
maybe we should do the write side truncation this way too.

But as mentioned, it's untested.. Does it work for you? I'll reboot and 
test myself, but I'm on my laptop right now, so it's easier to send it out 
before the compile has even finished..

		Linus

---

 fs/block_dev.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index a1e09b4fe1ba..ab3a456f6650 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1544,6 +1544,22 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
+static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *bd_inode = file->f_mapping->host;
+	loff_t size = i_size_read(bd_inode);
+
+	if (pos >= size)
+		return 0;
+
+	size -= pos;
+	if (size < INT_MAX)
+		nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
+	return generic_file_aio_read(iocb, iov, nr_segs, pos);
+}
+
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
@@ -1574,7 +1590,7 @@ const struct file_operations def_blk_fops = {
 	.llseek		= block_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= blkdev_aio_read,
 	.aio_write	= blkdev_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= blkdev_fsync,
