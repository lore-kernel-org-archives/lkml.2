Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1AEXGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:15 -0500
Received: from kroah.org ([198.145.64.141]:50685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AEXGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:14 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:23 2011
Message-Id: <20110105230323.753661955@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Tejun Heo <tj@kernel.org>
Subject: [04/49] fuse: fix ioctl when server is 32bit
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -1634,6 +1635,44 @@ static int fuse_verify_ioctl_iov(struct
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
@@ -1814,14 +1853,13 @@ long fuse_do_ioctl(struct file *file, un
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


