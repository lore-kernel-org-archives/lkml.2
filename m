Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2BPNtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:49:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2BPNqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:46:52 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 06/11] 9p: Push file_update_time() into v9fs_vm_page_mkwrite()
Date: Thu, 16 Feb 2012 14:46:14 +0100
Message-Id: <1329399979-3647-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1329399979-3647-1-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Ron Minnich <rminnich@sandia.gov>
CC: Latchesar Ionkov <lucho@ionkov.net>
CC: v9fs-developer@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/9p/vfs_file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

  BTW: I see you don't check whether the page you locked isn't beyond i_size.
Cannot your code race with truncate? See checks in __block_page_mkwrite()...

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index fc06fd2..dd6f7ee 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -610,6 +610,9 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	p9_debug(P9_DEBUG_VFS, "page %p fid %lx\n",
 		 page, (unsigned long)filp->private_data);
 
+	/* Update file times before taking page lock */
+	file_update_time(filp);
+
 	v9inode = V9FS_I(inode);
 	/* make sure the cache has finished storing the page */
 	v9fs_fscache_wait_on_page_write(inode, page);
-- 
1.7.1

