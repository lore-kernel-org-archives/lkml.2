Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1FJEIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:08:41 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:59479
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab1FJEIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:08:39 -0400
X-Greylist: delayed 748 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 00:08:39 EDT
Date: Thu, 9 Jun 2011 23:55:08 -0400
From: drepper@akkadia.org
Message-Id: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wilsons@start.ca
Subject: [PATCH] Add cloexec information to fdinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one piece of information about a file descriptor which is
currently not visible from the outside: the close-on-exec flag.  The
/proc/PID/fdinfo/* files have the mode information but this is
missing.  Is the following patch acceptable?

What I don't know is whether the RCU locking is needed given that
real locks are taken.  Someone with more knowledge could just
remove those two lines.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 base.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 14def99..bda3651 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1924,12 +1924,23 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 				*path = file->f_path;
 				path_get(&file->f_path);
 			}
-			if (info)
+			if (info) {
+				int cloexec;
+				struct fdtable *fdt;
+
+				rcu_read_lock();
+				fdt = files_fdtable(files);
+				cloexec = FD_ISSET(fd, fdt->close_on_exec);
+				rcu_read_unlock();
+
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
+					 "flags:\t0%o\n"
+					 "cloexec: %d\n",
 					 (long long) file->f_pos,
-					 file->f_flags);
+					 file->f_flags,
+					 cloexec);
+			}
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
