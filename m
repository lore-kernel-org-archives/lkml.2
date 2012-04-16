Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2DPQSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:18:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2DPQOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:14:24 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/27] gfs2: Convert to new freezing mechanism
Date: Mon, 16 Apr 2012 18:13:58 +0200
Message-Id: <1334592845-22862-21-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is enough to update gfs2_page_mkwrite() to use new freeze protection.
Rest is handled by the generic code.

CC: cluster-devel@redhat.com
CC: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/file.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 151d667..87f5aa8 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -370,11 +370,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 
-	/* Wait if fs is frozen. This is racy so we check again later on
-	 * and retry if the fs has been frozen after the page lock has
-	 * been acquired
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_pagefault(inode->i_sb);
 
 	/* Update file times before taking page lock */
 	file_update_time(vma->vm_file);
@@ -458,14 +454,9 @@ out:
 	gfs2_holder_uninit(&gh);
 	if (ret == 0) {
 		set_page_dirty(page);
-		/* This check must be post dropping of transaction lock */
-		if (inode->i_sb->s_frozen == SB_UNFROZEN) {
-			wait_on_page_writeback(page);
-		} else {
-			ret = -EAGAIN;
-			unlock_page(page);
-		}
+		wait_on_page_writeback(page);
 	}
+	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
 }
 
-- 
1.7.1

