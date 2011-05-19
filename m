Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1ESJOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066Ab1ESJK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:26 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/32] GFS2: Improve bug trap code in ->releasepage()
Date: Thu, 19 May 2011 09:47:12 +0100
Message-Id: <1305794847-3291-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the buffer is dirty or pinned, then as well as printing a
warning, we should also refuse to release the page in
question.

Currently this can occur if there is a race between mmap()ed
writers and O_DIRECT on the same file. With the addition of
->launder_page() in the future, we should be able to close
this gap.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 0f5c4f9..802ac5e 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1076,8 +1076,8 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		bd = bh->b_private;
 		if (bd && bd->bd_ail)
 			goto cannot_release;
-		gfs2_assert_warn(sdp, !buffer_pinned(bh));
-		gfs2_assert_warn(sdp, !buffer_dirty(bh));
+		if (buffer_pinned(bh) || buffer_dirty(bh))
+			goto not_possible;
 		bh = bh->b_this_page;
 	} while(bh != head);
 	gfs2_log_unlock(sdp);
@@ -1107,6 +1107,10 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 	} while (bh != head);
 
 	return try_to_free_buffers(page);
+
+not_possible: /* Should never happen */
+	WARN_ON(buffer_dirty(bh));
+	WARN_ON(buffer_pinned(bh));
 cannot_release:
 	gfs2_log_unlock(sdp);
 	return 0;
-- 
1.7.4

