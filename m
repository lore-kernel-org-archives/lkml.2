Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab0GIEjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 00:39:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52416 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab0GIEjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 00:39:45 -0400
Date: Fri, 9 Jul 2010 14:39:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: build failure after merge of the final tree (block tree
 related)
Message-Id: <20100709143940.f0f06690.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

After merging the final tree, today's linux-next build (powerpc64
allnoconfig) failed like this:

block/compat_ioctl.c: In function 'compat_blkdev_ioctl':
block/compat_ioctl.c:754: error: 'BLKTRACESETUP32' undeclared (first use in this function)

Caused by commit adf8c9c97ba7c66fe51007beddb4af3301620eb5 ("block: push
BKL into blktrace ioctls").  In its new location, BLKTRACESETUP32 is only
defined if CONFIG_BLK_DEV_IO_TRACE is defined.

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 9 Jul 2010 14:24:38 +1000
Subject: [PATCH] block: fix for block tracing build error

block/compat_ioctl.c: In function 'compat_blkdev_ioctl':
block/compat_ioctl.c:754: error: 'BLKTRACESETUP32' undeclared (first use in this function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/blktrace_api.h |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 07c6986..3395cf7 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -204,17 +204,6 @@ extern int blk_trace_init_sysfs(struct device *dev);
 
 extern struct attribute_group blk_trace_attr_group;
 
-struct compat_blk_user_trace_setup {
-	char name[32];
-	u16 act_mask;
-	u32 buf_size;
-	u32 buf_nr;
-	compat_u64 start_lba;
-	compat_u64 end_lba;
-	u32 pid;
-};
-#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
-
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 # define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 # define blk_trace_shutdown(q)				do { } while (0)
@@ -232,6 +221,21 @@ static inline int blk_trace_init_sysfs(struct device *dev)
 
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
+#ifdef CONFIG_COMPAT
+
+struct compat_blk_user_trace_setup {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
+
+#endif
+
 #if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
 
 static inline int blk_cmd_buf_len(struct request *rq)
-- 
1.7.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
