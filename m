Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0DOXIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011Ab0DOXHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:07:44 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 35/35] union-mount: Implement union-aware utimensat()
Date: Thu, 15 Apr 2010 16:04:42 -0700
Message-Id: <1271372682-21225-36-git-send-email-vaurora@redhat.com>
In-Reply-To: <1271372682-21225-35-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
 <1271372682-21225-13-git-send-email-vaurora@redhat.com>
 <1271372682-21225-14-git-send-email-vaurora@redhat.com>
 <1271372682-21225-15-git-send-email-vaurora@redhat.com>
 <1271372682-21225-16-git-send-email-vaurora@redhat.com>
 <1271372682-21225-17-git-send-email-vaurora@redhat.com>
 <1271372682-21225-18-git-send-email-vaurora@redhat.com>
 <1271372682-21225-19-git-send-email-vaurora@redhat.com>
 <1271372682-21225-20-git-send-email-vaurora@redhat.com>
 <1271372682-21225-21-git-send-email-vaurora@redhat.com>
 <1271372682-21225-22-git-send-email-vaurora@redhat.com>
 <1271372682-21225-23-git-send-email-vaurora@redhat.com>
 <1271372682-21225-24-git-send-email-vaurora@redhat.com>
 <1271372682-21225-25-git-send-email-vaurora@redhat.com>
 <1271372682-21225-26-git-send-email-vaurora@redhat.com>
 <1271372682-21225-27-git-send-email-vaurora@redhat.com>
 <1271372682-21225-28-git-send-email-vaurora@redhat.com>
 <1271372682-21225-29-git-send-email-vaurora@redhat.com>
 <1271372682-21225-30-git-send-email-vaurora@redhat.com>
 <1271372682-21225-31-git-send-email-vaurora@redhat.com>
 <1271372682-21225-32-git-send-email-vaurora@redhat.com>
 <1271372682-21225-33-git-send-email-vaurora@redhat.com>
 <1271372682-21225-34-git-send-email-vaurora@redhat.com>
 <1271372682-21225-35-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XXX - doesn't implement NOFOLLOW correctly
---
 fs/utimes.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index e4c75db..82feca2 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,6 +8,7 @@
 #include <linux/stat.h>
 #include <linux/utime.h>
 #include <linux/syscalls.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
@@ -152,18 +153,26 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
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

