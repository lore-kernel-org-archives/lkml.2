Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab1DNSMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:12:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:41982 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab1DNR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 156/209] fuse: verify ioctl retries
Date: Thu, 14 Apr 2011 13:55:14 -0400
Message-Id: <1302803767-9715-43-git-send-email-paul.gortmaker@windriver.com>
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

commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 upstream.

Verify that the total length of the iovec returned in FUSE_IOCTL_RETRY
doesn't overflow iov_length().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fuse/file.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cbd2214..db2814f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1619,6 +1619,20 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
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
@@ -1812,6 +1826,14 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
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
 
-- 
1.7.4.4

