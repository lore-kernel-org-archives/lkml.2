Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1AFA2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:28:48 -0500
Received: from kroah.org ([198.145.64.141]:35355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab1AFA2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:44 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002256.930987299@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Tejun Heo <tj@kernel.org>
Subject: [002/152] fuse: verify ioctl retries
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 upstream.

Verify that the total length of the iovec returned in FUSE_IOCTL_RETRY
doesn't overflow iov_length().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1627,6 +1627,20 @@ static int fuse_ioctl_copy_user(struct p
 	return 0;
 }
 
+/* Make sure iov_length() won't overflow */
+static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
+{
+	size_t n;
+	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
+
+	for (n = 0; n < count; n++) {
+		if (iov->iov_len > (size_t) max)
+			return -ENOMEM;
+		max -= iov->iov_len;
+	}
+	return 0;
+}
+
 /*
  * For ioctls, there is no generic way to determine how much memory
  * needs to be read and/or written.  Furthermore, ioctls are allowed
@@ -1820,6 +1834,14 @@ long fuse_do_ioctl(struct file *file, un
 		in_iov = page_address(iov_page);
 		out_iov = in_iov + in_iovs;
 
+		err = fuse_verify_ioctl_iov(in_iov, in_iovs);
+		if (err)
+			goto out;
+
+		err = fuse_verify_ioctl_iov(out_iov, out_iovs);
+		if (err)
+			goto out;
+
 		goto retry;
 	}
 


