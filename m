Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2CEQFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:05:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2CEQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:38 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>, cluster-devel@redhat.com,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/19] gfs2: Convert to new freezing mechanism
Date: Mon,  5 Mar 2012 17:01:11 +0100
Message-Id: <1330963277-26336-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is enough to update gfs2_page_mkwrite() to use new freeze protection.
Rest is handled by the generic code.

CC: cluster-devel@redhat.com
CC: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/file.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1f03531..806b7a4 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -369,11 +369,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -457,14 +453,9 @@ out:
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

