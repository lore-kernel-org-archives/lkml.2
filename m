Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0EZPyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:54:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40688 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab0EZPyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:54:44 -0400
Date: Wed, 26 May 2010 17:54:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/17] fs: Add missing mutex_unlock
Message-ID: <Pine.LNX.4.64.1005261754220.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.  At other exists from the
function that return an error flag, the mutex is unlocked, so do the same
here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/pipe.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index d79872e..60da077 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1169,14 +1169,18 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case F_SETPIPE_SZ:
-		if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages)
-			return -EINVAL;
+		if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages) {
+			ret = -EINVAL;
+			goto out;
+		}
 		/*
 		 * The pipe needs to be at least 2 pages large to
 		 * guarantee POSIX behaviour.
 		 */
-		if (arg < 2)
-			return -EINVAL;
+		if (arg < 2) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = pipe_set_size(pipe, arg);
 		break;
 	case F_GETPIPE_SZ:
@@ -1187,6 +1191,7 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
+out:
 	mutex_unlock(&pipe->inode->i_mutex);
 	return ret;
 }
