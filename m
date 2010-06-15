Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab0FOSsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:48:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439Ab0FOSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:42:07 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 36/38] union-mount: Implement union-aware utimensat()
Date: Tue, 15 Jun 2010 11:40:06 -0700
Message-Id: <1276627208-17242-37-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
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

