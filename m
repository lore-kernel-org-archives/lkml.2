Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1LVI4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:56:01 -0500
Received: from mga06.intel.com ([134.134.136.21]:19899 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754825Ab1LVIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:55:55 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [PATCH v2 1/2] vfs: iversion truncate bug fix
Date: Thu, 22 Dec 2011 10:55:25 +0200
Message-Id: <3a31f5a68221d29c818d6edb7d5134b2dbd5051c.1324543719.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1324543719.git.dmitry.kasatkin@intel.com>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1324543719.git.dmitry.kasatkin@intel.com>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file is opened with O_TRUNC or truncated with truncate()/ftruncate(),
and then closed, iversion is not updated. This patch uses ATTR_OPEN flag,
which is currently used to identify files opened with O_TRUNC,
as an indication to increment iversion.
Also it adds passing of this flag from do_sys_truncate and do_sys_ftruncate.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/attr.c |    3 +++
 fs/open.c |    5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 7ee7ba4..e02370d 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,6 +176,9 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_OPEN) && IS_I_VERSION(inode))
+		inode_inc_iversion(inode);
+
 	if ((ia_valid & ATTR_MODE)) {
 		mode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */
diff --git a/fs/open.c b/fs/open.c
index 22c41b5..4ee6847 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -113,7 +113,7 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (!error)
 		error = security_path_truncate(&path);
 	if (!error)
-		error = do_truncate(path.dentry, length, 0, NULL);
+		error = do_truncate(path.dentry, length, ATTR_OPEN, NULL);
 
 put_write_and_out:
 	put_write_access(inode);
@@ -168,7 +168,8 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!error)
 		error = security_path_truncate(&file->f_path);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = do_truncate(dentry, length,
+				    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN, file);
 out_putf:
 	fput(file);
 out:
-- 
1.7.4.1

