Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0IPWOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab0IPWOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 09/34] union-mount: Add two superblock fields for union mounts
Date: Thu, 16 Sep 2010 15:12:00 -0700
Message-Id: <1284675145-4391-10-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two fields to struct super_block to support union mounts.
s_union_lower_mnts is a pointer to a cloned vfsmount tree of all the
lower (read-only) mounts unioned with the topmost (read-write)
vfsmount.  These mounts may have submounts which will also be unioned;
hence we copy the entire vfsmount tree, not just the root vfsmounts.
s_union_count is the number of lower mounts unioned at the root of the
file system.  This count is the maximum number of directories that
will ever be unioned with a single directory.  We use it to allocate a
union stack of the correct size for each directory.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 include/linux/fs.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2e3d745..5e35b03 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1397,6 +1397,18 @@ struct super_block {
 	 * Decremented by free_vfsmnt() if MNT_HARD_READONLY is set.
 	 */
 	int s_hard_readonly_users;
+
+	/*
+	 * Root of the private cloned vfsmount tree of the read-only
+	 * mounts in this union (set in topmost vfsmount only)
+	 */
+	struct vfsmount *s_union_lower_mnts;
+
+	/*
+	 * Number of layers in this union, not counting the topmost or
+	 * submounts.
+	 */
+	unsigned int s_union_count;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
-- 
1.6.3.3

