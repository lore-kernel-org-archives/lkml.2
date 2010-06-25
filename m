Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0FYTH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab0FYTH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:07:28 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 36/38] union-mount: Implement union-aware utimensat()
Date: Fri, 25 Jun 2010 12:05:26 -0700
Message-Id: <1277492728-11446-37-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/utimes.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index e4c75db..e83b6bd 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -8,8 +8,10 @@
 #include <linux/stat.h>
 #include <linux/utime.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include "union.h"
 
 #ifdef __ARCH_WANT_SYS_UTIME
 
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

