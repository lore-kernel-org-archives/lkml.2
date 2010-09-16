Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0IPWTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:19:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab0IPWO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:57 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 22/34] union-mount: Prevent improper union-related remounts
Date: Thu, 16 Sep 2010 15:12:13 -0700
Message-Id: <1284675145-4391-23-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A remount request must (a) not convert a union to a non-union (or vice
versa), or (b) make the topmost layer of a union read-only.

Note that we only have to worry about attempts to remount the vfsmount
of the topmost read-write of the union (the one with MNT_UNION set).
The vfsmounts of the read-only layers are hidden in a cloned tree
hanging of the superblock of the topmost layer and aren't visible to
userspace.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ff83cee..61256e6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1824,6 +1824,18 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (!check_mnt(path->mnt))
 		return -EINVAL;
 
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    !(mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((mnt_flags & MNT_UNION) &&
+	    !(path->mnt->mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    (mnt_flags & MNT_READONLY))
+		return -EINVAL;
+
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
-- 
1.6.3.3

