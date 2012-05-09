Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2EIF7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:59:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab2EIFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:46 -0400
Message-Id: <20120509055046.251828483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Tokarev <mjt@tls.msk.ru>,
        David Miller <davem@davemloft.net>, Ian Kent <raven@themaw.net>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: [ 120/167] [PATCH] pipes: add a "packetized pipe" mode for writing
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9883035ae7edef3ec62ad215611cb8e17d6a1a5d upstream.

The actual internal pipe implementation is already really about
individual packets (called "pipe buffers"), and this simply exposes that
as a special packetized mode.

When we are in the packetized mode (marked by O_DIRECT as suggested by
Alan Cox), a write() on a pipe will not merge the new data with previous
writes, so each write will get a pipe buffer of its own.  The pipe
buffer is then marked with the PIPE_BUF_FLAG_PACKET flag, which in turn
will tell the reader side to break the read at that boundary (and throw
away any partial packet contents that do not fit in the read buffer).

End result: as long as you do writes less than PIPE_BUF in size (so that
the pipe doesn't have to split them up), you can now treat the pipe as a
packet interface, where each read() system call will read one packet at
a time.  You can just use a sufficiently big read buffer (PIPE_BUF is
sufficient, since bigger than that doesn't guarantee atomicity anyway),
and the return value of the read() will naturally give you the size of
the packet.

NOTE! We do not support zero-sized packets, and zero-sized reads and
writes to a pipe continue to be no-ops.  Also note that big packets will
currently be split at write time, but that the size at which that
happens is not really specified (except that it's bigger than PIPE_BUF).
Currently that limit is the system page size, but we might want to
explicitly support bigger packets some day.

The main user for this is going to be the autofs packet interface,
allowing us to stop having to care so deeply about exact packet sizes
(which have had bugs with 32/64-bit compatibility modes).  But user
space can create packetized pipes with "pipe2(fd, O_DIRECT)", which will
fail with an EINVAL on kernels that do not support this interface.

Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>
Cc: Ian Kent <raven@themaw.net>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/pipe.c                 |   31 +++++++++++++++++++++++++++++--
 include/linux/pipe_fs_i.h |    1 +
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 25feaa3..fec5e4a 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -346,6 +346,16 @@ static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
+static const struct pipe_buf_operations packet_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = anon_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
 static ssize_t
 pipe_read(struct kiocb *iocb, const struct iovec *_iov,
 	   unsigned long nr_segs, loff_t pos)
@@ -407,6 +417,13 @@ redo:
 			ret += chars;
 			buf->offset += chars;
 			buf->len -= chars;
+
+			/* Was it a packet buffer? Clean up and exit */
+			if (buf->flags & PIPE_BUF_FLAG_PACKET) {
+				total_len = chars;
+				buf->len = 0;
+			}
+
 			if (!buf->len) {
 				buf->ops = NULL;
 				ops->release(pipe, buf);
@@ -459,6 +476,11 @@ redo:
 	return ret;
 }
 
+static inline int is_packetized(struct file *file)
+{
+	return (file->f_flags & O_DIRECT) != 0;
+}
+
 static ssize_t
 pipe_write(struct kiocb *iocb, const struct iovec *_iov,
 	    unsigned long nr_segs, loff_t ppos)
@@ -593,6 +615,11 @@ redo2:
 			buf->ops = &anon_pipe_buf_ops;
 			buf->offset = 0;
 			buf->len = chars;
+			buf->flags = 0;
+			if (is_packetized(filp)) {
+				buf->ops = &packet_pipe_buf_ops;
+				buf->flags = PIPE_BUF_FLAG_PACKET;
+			}
 			pipe->nrbufs = ++bufs;
 			pipe->tmp_page = NULL;
 
@@ -1013,7 +1040,7 @@ struct file *create_write_pipe(int flags)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
 
-	f->f_flags = O_WRONLY | (flags & O_NONBLOCK);
+	f->f_flags = O_WRONLY | (flags & (O_NONBLOCK | O_DIRECT));
 	f->f_version = 0;
 
 	return f;
@@ -1057,7 +1084,7 @@ int do_pipe_flags(int *fd, int flags)
 	int error;
 	int fdw, fdr;
 
-	if (flags & ~(O_CLOEXEC | O_NONBLOCK))
+	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT))
 		return -EINVAL;
 
 	fw = create_write_pipe(flags);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 6d626ff..e1ac1ce 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -6,6 +6,7 @@
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
 #define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
+#define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
 
 /**
  *	struct pipe_buffer - a linux kernel pipe buffer
-- 
1.7.10



