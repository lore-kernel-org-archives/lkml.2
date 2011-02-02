Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1BBBNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:13:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:59383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1BBAnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960259"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: mszeredi@suse.cz, ak@linux.intel.com, tj@kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [2/139] fuse: verify ioctl retries
Message-Id: <20110202004315.C7DB43E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 upstream.

Verify that the total length of the iovec returned in FUSE_IOCTL_RETRY
doesn't overflow iov_length().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/file.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux-2.6.35.y/fs/fuse/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/fuse/file.c
+++ linux-2.6.35.y/fs/fuse/file.c
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
 
