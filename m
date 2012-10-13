Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2JMKMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:12:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2JMKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:12:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UAPI: Unexport linux/blk_types.h [ver #2]
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 13 Oct 2012 11:12:35 +0100
Message-ID: <20121013101234.10350.9980.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that was linux/blk_types.h incorrectly exported to fix up some missing
bits required by the exported parts of linux/fs.h (READ, WRITE, READA, etc.).

So unexport linux/blk_types.h and unexport the relevant bits of linux/fs.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jens Axboe <jaxboe@fusionio.com>
cc: Tejun Heo <tj@kernel.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>
---

 include/linux/Kbuild |    1 
 include/linux/fs.h   |  119 +++++++++++++++++++++++++-------------------------
 2 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index d114db9..e2a1346 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -69,7 +69,6 @@ header-y += b1lli.h
 header-y += baycom.h
 header-y += bfs_fs.h
 header-y += binfmts.h
-header-y += blk_types.h
 header-y += blkpg.h
 header-y += blktrace_api.h
 header-y += bpqether.h
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65fbf57..8cb86cf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,7 +8,6 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
-#include <linux/blk_types.h>
 #include <linux/types.h>
 
 /*
@@ -118,65 +117,6 @@ struct inodes_stat_t {
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
- * The below are the various read and write types that we support. Some of
- * them include behavioral modifiers that send information down to the
- * block layer and IO scheduler. Terminology:
- *
- *	The block layer uses device plugging to defer IO a little bit, in
- *	the hope that we will see more IO very shortly. This increases
- *	coalescing of adjacent IO and thus reduces the number of IOs we
- *	have to send to the device. It also allows for better queuing,
- *	if the IO isn't mergeable. If the caller is going to be waiting
- *	for the IO, then he must ensure that the device is unplugged so
- *	that the IO is dispatched to the driver.
- *
- *	All IO is handled async in Linux. This is fine for background
- *	writes, but for reads or writes that someone waits for completion
- *	on, we want to notify the block layer and IO scheduler so that they
- *	know about it. That allows them to make better scheduling
- *	decisions. So when the below references 'sync' and 'async', it
- *	is referencing this priority hint.
- *
- * With that in mind, the available types are:
- *
- * READ			A normal read operation. Device will be plugged.
- * READ_SYNC		A synchronous read. Device is not plugged, caller can
- *			immediately wait on this read without caring about
- *			unplugging.
- * READA		Used for read-ahead operations. Lower priority, and the
- *			block layer could (in theory) choose to ignore this
- *			request if it runs into resource problems.
- * WRITE		A normal async write. Device will be plugged.
- * WRITE_SYNC		Synchronous write. Identical to WRITE, but passes down
- *			the hint that someone will be waiting on this IO
- *			shortly. The write equivalent of READ_SYNC.
- * WRITE_ODIRECT	Special case write for O_DIRECT only.
- * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
- * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
- *			non-volatile media on completion.
- * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA. The IO is preceded
- *			by a cache flush and data is guaranteed to be on
- *			non-volatile media on completion.
- *
- */
-#define RW_MASK			REQ_WRITE
-#define RWA_MASK		REQ_RAHEAD
-
-#define READ			0
-#define WRITE			RW_MASK
-#define READA			RWA_MASK
-#define KERNEL_READ		(READ|REQ_KERNEL)
-#define KERNEL_WRITE		(WRITE|REQ_KERNEL)
-
-#define READ_SYNC		(READ | REQ_SYNC)
-#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
-#define WRITE_ODIRECT		(WRITE | REQ_SYNC)
-#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
-#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
-#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
-
-
-/*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
  * valid, but not check the memory that the iovec elements
@@ -417,6 +357,7 @@ struct inodes_stat_t {
 #include <linux/uidgid.h>
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/blk_types.h>
 
 #include <asm/byteorder.h>
 
@@ -454,6 +395,64 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			bool is_async);
 
 /*
+ * The below are the various read and write types that we support. Some of
+ * them include behavioral modifiers that send information down to the
+ * block layer and IO scheduler. Terminology:
+ *
+ *	The block layer uses device plugging to defer IO a little bit, in
+ *	the hope that we will see more IO very shortly. This increases
+ *	coalescing of adjacent IO and thus reduces the number of IOs we
+ *	have to send to the device. It also allows for better queuing,
+ *	if the IO isn't mergeable. If the caller is going to be waiting
+ *	for the IO, then he must ensure that the device is unplugged so
+ *	that the IO is dispatched to the driver.
+ *
+ *	All IO is handled async in Linux. This is fine for background
+ *	writes, but for reads or writes that someone waits for completion
+ *	on, we want to notify the block layer and IO scheduler so that they
+ *	know about it. That allows them to make better scheduling
+ *	decisions. So when the below references 'sync' and 'async', it
+ *	is referencing this priority hint.
+ *
+ * With that in mind, the available types are:
+ *
+ * READ			A normal read operation. Device will be plugged.
+ * READ_SYNC		A synchronous read. Device is not plugged, caller can
+ *			immediately wait on this read without caring about
+ *			unplugging.
+ * READA		Used for read-ahead operations. Lower priority, and the
+ *			block layer could (in theory) choose to ignore this
+ *			request if it runs into resource problems.
+ * WRITE		A normal async write. Device will be plugged.
+ * WRITE_SYNC		Synchronous write. Identical to WRITE, but passes down
+ *			the hint that someone will be waiting on this IO
+ *			shortly. The write equivalent of READ_SYNC.
+ * WRITE_ODIRECT	Special case write for O_DIRECT only.
+ * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
+ * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
+ *			non-volatile media on completion.
+ * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA. The IO is preceded
+ *			by a cache flush and data is guaranteed to be on
+ *			non-volatile media on completion.
+ *
+ */
+#define RW_MASK			REQ_WRITE
+#define RWA_MASK		REQ_RAHEAD
+
+#define READ			0
+#define WRITE			RW_MASK
+#define READA			RWA_MASK
+#define KERNEL_READ		(READ|REQ_KERNEL)
+#define KERNEL_WRITE		(WRITE|REQ_KERNEL)
+
+#define READ_SYNC		(READ | REQ_SYNC)
+#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
+#define WRITE_ODIRECT		(WRITE | REQ_SYNC)
+#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
+#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
+#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+
+/*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
  */

