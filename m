Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1JXMro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:39 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/24] GFS2: Fix lseek after SEEK_DATA, SEEK_HOLE have been added
Date: Mon, 24 Oct 2011 13:48:23 +0100
Message-Id: <1319460518-9046-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to take the inode's glock whenever the inode's size
is referenced, otherwise it might not be uptodate. Even
though generic_file_llseek_unlocked() doesn't implement
SEEK_DATA, SEEK_HOLE directly, it does reference the inode's
size in those cases, so we need to add them to the list
of origins which need the glock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4416a1c..d717b72 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -59,15 +59,24 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int origin)
 	struct gfs2_holder i_gh;
 	loff_t error;
 
-	if (origin == 2) {
+	switch (origin) {
+	case SEEK_END: /* These reference inode->i_size */
+	case SEEK_DATA:
+	case SEEK_HOLE:
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
 			error = generic_file_llseek_unlocked(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
-	} else
+		break;
+	case SEEK_CUR:
+	case SEEK_SET:
 		error = generic_file_llseek_unlocked(file, offset, origin);
+		break;
+	default:
+		error = -EINVAL;
+	}
 
 	return error;
 }
-- 
1.7.4.4

