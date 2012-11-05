Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2KEPXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:23:51 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54428 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab2KEPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:23:23 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 33/34] vfs: make number of ESTALE retries tunable
Date: Mon,  5 Nov 2012 10:22:12 -0500
Message-Id: <1352128933-28526-34-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some situations, when there is a lot of "churn", a single retry is
simply not enough. Since there is no single correct value for the
number of times that these retries should occur, it makes some sense
to allow the admin to tune that value.

This patch adds a sysctl to allow the admin to tune the number of
times to retry these operations before giving up.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c         | 2 ++
 include/linux/fs.h | 7 ++++---
 kernel/sysctl.c    | 7 +++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f0916e6..70592ec 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -110,6 +110,8 @@
  * any extra contention...
  */
 
+unsigned int estale_retries __read_mostly = 1;
+
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
  * kernel data space before using them..
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3e42289..1789199 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2023,14 +2023,15 @@ extern int finish_open(struct file *file, struct dentry *dentry,
 			int *opened);
 extern int finish_no_open(struct file *file, struct dentry *dentry);
 
+extern unsigned int estale_retries;
+
 /**
  * retry_estale - determine whether the caller should retry an operation
  * @error: the error that would currently be returned
  * @try: number of tries already performed
  *
  * Check to see if the error code was -ESTALE, and then determine whether
- * to retry the call based on the number of tries so far. Currently, we only
- * retry the call once.
+ * to retry the call based on the number of tries so far.
  *
  * Returns true if the caller should try the operation again.
  */
@@ -2040,7 +2041,7 @@ retry_estale(const long error, const unsigned int try)
 	if (likely(error != -ESTALE))
 		return false;
 
-	return !try;
+	return (try <= estale_retries);
 }
 
 /* fs/ioctl.c */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 26f65ea..24735db 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1545,6 +1545,13 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "estale_retries",
+		.data		= &estale_retries,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.11.7

