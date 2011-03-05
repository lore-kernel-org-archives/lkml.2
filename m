Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab1CEBMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:12:12 -0500
Received: from kroah.org ([198.145.64.141]:50293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760387Ab1CEBA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.480692678@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [40/73] ocfs2: Check heartbeat mode for kernel stacks only
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Fasheh <mfasheh@suse.com>

commit 52c303c56c3638944b5f733e3961dc58eb8c7270 upstream.

Commit 2c442719e90a44a6982c033d69df4aae4b167cfa added some checks for proper
heartbeat mode when the o2cb stack is running.  Unfortunately, it didn't
take into account that a userpsace stack could be running. Fix this by only
doing the check if o2cb is in use. This patch allows userspace stacks to
mount the fs again.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/super.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1310,7 +1310,7 @@ static int ocfs2_parse_options(struct su
 			       struct mount_options *mopt,
 			       int is_remount)
 {
-	int status;
+	int status, user_stack = 0;
 	char *p;
 	u32 tmp;
 
@@ -1453,6 +1453,15 @@ static int ocfs2_parse_options(struct su
 			memcpy(mopt->cluster_stack, args[0].from,
 			       OCFS2_STACK_LABEL_LEN);
 			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
+			/*
+			 * Open code the memcmp here as we don't have
+			 * an osb to pass to
+			 * ocfs2_userspace_stack().
+			 */
+			if (memcmp(mopt->cluster_stack,
+				   OCFS2_CLASSIC_CLUSTER_STACK,
+				   OCFS2_STACK_LABEL_LEN))
+				user_stack = 1;
 			break;
 		case Opt_inode64:
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
@@ -1508,13 +1517,16 @@ static int ocfs2_parse_options(struct su
 		}
 	}
 
-	/* Ensure only one heartbeat mode */
-	tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
-				 OCFS2_MOUNT_HB_NONE);
-	if (hweight32(tmp) != 1) {
-		mlog(ML_ERROR, "Invalid heartbeat mount options\n");
-		status = 0;
-		goto bail;
+	if (user_stack == 0) {
+		/* Ensure only one heartbeat mode */
+		tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL |
+					 OCFS2_MOUNT_HB_GLOBAL |
+					 OCFS2_MOUNT_HB_NONE);
+		if (hweight32(tmp) != 1) {
+			mlog(ML_ERROR, "Invalid heartbeat mount options\n");
+			status = 0;
+			goto bail;
+		}
 	}
 
 	status = 1;


