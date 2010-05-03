Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0ECXQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0ECXOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:14:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 37/39] union-mount: Implement union-aware utimensat()
Date: Mon,  3 May 2010 16:12:36 -0700
Message-Id: <1272928358-20854-38-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/utimes.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index e4c75db..fb32111 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,6 +8,8 @@
 #include <linux/stat.h>
 #include <linux/utime.h>
 #include <linux/syscalls.h>
+#include <linux/union.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
@@ -152,18 +154,26 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
 		error = utimes_common(&file->f_path, times);
 		fput(file);
 	} else {
+		struct nameidata nd;
+		char *tmp;
 		struct path path;
 		int lookup_flags = 0;
 
 		if (!(flags & AT_SYMLINK_NOFOLLOW))
 			lookup_flags |= LOOKUP_FOLLOW;
 
-		error = user_path_at(dfd, filename, lookup_flags, &path);
+		error = user_path_nd(dfd, filename, lookup_flags, &nd, &path,
+				     &tmp);
 		if (error)
 			goto out;
 
-		error = utimes_common(&path, times);
+		error = union_copyup(&nd, &path);
+
+		if (!error)
+			error = utimes_common(&path, times);
 		path_put(&path);
+		path_put(&nd.path);
+		putname(tmp);
 	}
 
 out:
-- 
1.6.3.3

