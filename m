Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0HBJtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0HBJtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/8] GFS2: Make "try" lock not try quite so hard
Date: Mon,  2 Aug 2010 10:27:56 +0100
Message-Id: <1280741279-6782-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a big change, but in reality its only a single line of actual
code change, the rest is just moving a function to before its new caller.
The "try" flag for glocks is a rather subtle and delicate setting since it
requires that the state machine tries just hard enough to ensure that it has
a good chance of getting the requested lock, but no so hard that the
request can land up blocked behind another.

The patch adds in an additional check which will fail any queued try
locks if there is another request blocking the try lock request which
is not granted and compatible, nor in progress already. The check is made
only after all pending locks which may be granted have been granted.

I've checked this with the reproducer for the reported flock bug which
this is intended to fix, and it now passes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 0898f3e..717531d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -328,6 +328,30 @@ static void gfs2_holder_wake(struct gfs2_holder *gh)
 }
 
 /**
+ * do_error - Something unexpected has happened during a lock request
+ *
+ */
+
+static inline void do_error(struct gfs2_glock *gl, const int ret)
+{
+	struct gfs2_holder *gh, *tmp;
+
+	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			continue;
+		if (ret & LM_OUT_ERROR)
+			gh->gh_error = -EIO;
+		else if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))
+			gh->gh_error = GLR_TRYFAILED;
+		else
+			continue;
+		list_del_init(&gh->gh_list);
+		trace_gfs2_glock_queue(gh, 0);
+		gfs2_holder_wake(gh);
+	}
+}
+
+/**
  * do_promote - promote as many requests as possible on the current queue
  * @gl: The glock
  * 
@@ -375,36 +399,13 @@ restart:
 		}
 		if (gh->gh_list.prev == &gl->gl_holders)
 			return 1;
+		do_error(gl, 0);
 		break;
 	}
 	return 0;
 }
 
 /**
- * do_error - Something unexpected has happened during a lock request
- *
- */
-
-static inline void do_error(struct gfs2_glock *gl, const int ret)
-{
-	struct gfs2_holder *gh, *tmp;
-
-	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
-		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
-			continue;
-		if (ret & LM_OUT_ERROR)
-			gh->gh_error = -EIO;
-		else if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))
-			gh->gh_error = GLR_TRYFAILED;
-		else
-			continue;
-		list_del_init(&gh->gh_list);
-		trace_gfs2_glock_queue(gh, 0);
-		gfs2_holder_wake(gh);
-	}
-}
-
-/**
  * find_first_waiter - find the first gh that's waiting for the glock
  * @gl: the glock
  */
-- 
1.7.1.1

