Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0IPWPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0IPWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:15:00 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 23/34] union-mount: Prevent topmost file system from being mounted elsewhere
Date: Thu, 16 Sep 2010 15:12:14 -0700
Message-Id: <1284675145-4391-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device underlying the topmost read-write layer of a file system
cannot be mounted anywhere else on the system.  We keep a pointer to
the union stack in the dentry of the topmost directory, so that dentry
can't be part of a different mount, since dentries are shared between
different mounts of the same device.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 61256e6..26efaf3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1998,6 +1998,11 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/* Top layers of union mounts can't be mounted elsewhere */
+	err = -EBUSY;
+	if (newmnt->mnt_sb->s_union_lower_mnts)
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
-- 
1.6.3.3

