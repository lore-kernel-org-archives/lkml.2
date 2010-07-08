Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0GHX7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:36344 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab0GHX7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:59:37 -0400
Date: Fri, 9 Jul 2010 08:59:19 +0900
To: axboe@kernel.dk, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix BLKTRACESETUP32 compile error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100709085858U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 09 Jul 2010 08:59:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following compile error with block's for-2.6.36 tree:

block/compat_ioctl.c: In function compat_blkdev_ioctl:
block/compat_ioctl.c:754: error: BLKTRACESETUP32 undeclared (first use in this function)
block/compat_ioctl.c:754: error: (Each undeclared identifier is reported only once
block/compat_ioctl.c:754: error: for each function it appears in.)


This is due to "block: push BKL into blktrace ioctls" patch.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix BLKTRACESETUP32 compile error

We need BLKTRACESETUP32 even with CONFIG_BLK_DEV_IO_TRACE disabled.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/blktrace_api.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 07c6986..a19b85f 100644
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
@@ -232,6 +221,17 @@ static inline int blk_trace_init_sysfs(struct device *dev)
 
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
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
 #if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
 
 static inline int blk_cmd_buf_len(struct request *rq)
-- 
1.6.5

