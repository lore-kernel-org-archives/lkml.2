Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab0KRXEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:04:10 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42959 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab0KRXEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:04:06 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.2 5/5] IMA: making i_readcount a first class inode citizen
Date: Thu, 18 Nov 2010 18:03:02 -0500
Message-Id: <1290121382-4039-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, remove the ifdef's around i_readcount, making it a full
inode citizen so that other subsystems, such as leases, could use it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/fs.h |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6b7e2fb..1024da1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -786,9 +786,7 @@ struct inode {
 
 	unsigned int		i_flags;
 
-#ifdef CONFIG_IMA
 	atomic_t		i_readcount; /* struct files open RO */
-#endif
 	atomic_t		i_writecount;
 #ifdef CONFIG_SECURITY
 	void			*i_security;
@@ -2176,7 +2174,7 @@ static inline void allow_write_access(struct file *file)
 	if (file)
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
-#ifdef CONFIG_IMA
+
 static inline void i_readcount_dec(struct inode *inode)
 {
 	BUG_ON(!atomic_read(&inode->i_readcount));
@@ -2186,16 +2184,7 @@ static inline void i_readcount_inc(struct inode *inode)
 {
 	atomic_inc(&inode->i_readcount);
 }
-#else
-static inline void i_readcount_dec(struct inode *inode)
-{
-	return;
-}
-static inline void i_readcount_inc(struct inode *inode)
-{
-	return;
-}
-#endif
+
 extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f, int flags);
 extern struct file *create_write_pipe(int flags);
-- 
1.7.2.2

