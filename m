Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0IPWOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0IPWOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 02/34] VFS: Add CL_NO_SHARED flag to clone_mnt()/copy_tree()
Date: Thu, 16 Sep 2010 15:11:53 -0700
Message-Id: <1284675145-4391-3-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing the CL_NO_SHARED flag to clone_mnt() causes the clone to fail
if the source mnt is shared.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |    3 +++
 fs/pnode.h     |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5566524..eeb4c22 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -562,6 +562,9 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 	struct vfsmount *mnt;
 	int err;
 
+	if ((flag & CL_NO_SHARED) && (IS_MNT_SHARED(old)))
+		return ERR_PTR(-EINVAL);
+
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/pnode.h b/fs/pnode.h
index 1ea4ae1..bcb3c47 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -22,6 +22,7 @@
 #define CL_COPY_ALL 		0x04
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
+#define CL_NO_SHARED 		0x20
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
-- 
1.6.3.3

