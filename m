Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab1DNSMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:12:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:41988 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab1DNR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 157/209] fuse: fix ioctl when server is 32bit
Date: Thu, 14 Apr 2011 13:55:15 -0400
Message-Id: <1302803767-9715-44-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit d9d318d39dd5cb686660504a3565aac453709ccc upstream.

If a 32bit CUSE server is run on 64bit this results in EIO being
returned to the caller.

The reason is that FUSE_IOCTL_RETRY reply was defined to use 'struct
iovec', which is different on 32bit and 64bit archs.

Work around this by looking at the size of the reply to determine
which struct was used.  This is only needed if CONFIG_COMPAT is
defined.

A more permanent fix for the interface will be to use the same struct
on both 32bit and 64bit.

Reported-by: "ccmail111" <ccmail111@yahoo.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fuse/file.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index db2814f..edfce0b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -1634,6 +1635,44 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
 }
 
 /*
+ * CUSE servers compiled on 32bit broke on 64bit kernels because the
+ * ABI was defined to be 'struct iovec' which is different on 32bit
+ * and 64bit.  Fortunately we can determine which structure the server
+ * used from the size of the reply.
+ */
+static int fuse_copy_ioctl_iovec(struct iovec *dst, void *src,
+				 size_t transferred, unsigned count,
+				 bool is_compat)
+{
+#ifdef CONFIG_COMPAT
+	if (count * sizeof(struct compat_iovec) == transferred) {
+		struct compat_iovec *ciov = src;
+		unsigned i;
+
+		/*
+		 * With this interface a 32bit server cannot support
+		 * non-compat (i.e. ones coming from 64bit apps) ioctl
+		 * requests
+		 */
+		if (!is_compat)
+			return -EINVAL;
+
+		for (i = 0; i < count; i++) {
+			dst[i].iov_base = compat_ptr(ciov[i].iov_base);
+			dst[i].iov_len = ciov[i].iov_len;
+		}
+		return 0;
+	}
+#endif
+
+	if (count * sizeof(struct iovec) != transferred)
+		return -EIO;
+
+	memcpy(dst, src, transferred);
+	return 0;
+}
+
+/*
  * For ioctls, there is no generic way to determine how much memory
  * needs to be read and/or written.  Furthermore, ioctls are allowed
  * to dereference the passed pointer, so the parameter requires deep
@@ -1814,14 +1853,13 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		    in_iovs + out_iovs > FUSE_IOCTL_MAX_IOV)
 			goto out;
 
-		err = -EIO;
-		if ((in_iovs + out_iovs) * sizeof(struct iovec) != transferred)
-			goto out;
-
-		/* okay, copy in iovs and retry */
 		vaddr = kmap_atomic(pages[0], KM_USER0);
-		memcpy(page_address(iov_page), vaddr, transferred);
+		err = fuse_copy_ioctl_iovec(page_address(iov_page), vaddr,
+					    transferred, in_iovs + out_iovs,
+					    (flags & FUSE_IOCTL_COMPAT) != 0);
 		kunmap_atomic(vaddr, KM_USER0);
+		if (err)
+			goto out;
 
 		in_iov = page_address(iov_page);
 		out_iov = in_iov + in_iovs;
-- 
1.7.4.4

