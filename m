Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab0KRXDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:03:30 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44325 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab0KRXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:03:26 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.2 2/5] IMA: define readcount functions
Date: Thu, 18 Nov 2010 18:02:59 -0500
Message-Id: <1290121382-4039-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define i_readcount_inc/dec() functions to be called from the VFS layer.

Changelog:
- renamed iget/iput_readcount to i_readcount_inc/dec (Dave Chinner's suggestion)
- removed i_lock in iput_readcount() (based on comments:Dave Chinner,Eric Paris)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Eric Paris <eparis@redhat.com>
---
 include/linux/fs.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 442fceb..6b7e2fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2176,6 +2176,26 @@ static inline void allow_write_access(struct file *file)
 	if (file)
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
+#ifdef CONFIG_IMA
+static inline void i_readcount_dec(struct inode *inode)
+{
+	BUG_ON(!atomic_read(&inode->i_readcount));
+	atomic_dec(&inode->i_readcount);
+}
+static inline void i_readcount_inc(struct inode *inode)
+{
+	atomic_inc(&inode->i_readcount);
+}
+#else
+static inline void i_readcount_dec(struct inode *inode)
+{
+	return;
+}
+static inline void i_readcount_inc(struct inode *inode)
+{
+	return;
+}
+#endif
 extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f, int flags);
 extern struct file *create_write_pipe(int flags);
-- 
1.7.2.2

