Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3ACOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:55:16 -0500
Received: from mout.gmx.net ([212.227.15.18]:52287 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab3ACOzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:55:13 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Kqp5NSj6KdqyBbnxY7lwU1i/m4gWYpxll2Id9XO
	FbeK4+FkUZjHMT
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] fs/autofs: Fix sparse warning: context imbalance in 'autofs4_d_automount' - different lock contexts for basic block
Date: Thu,  3 Jan 2013 15:52:13 +0100
Message-Id: <1357224733-31251-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse complains:
+ fs/autofs4/root.c:409:9: sparse: context imbalance in
'autofs4_d_automount' - different lock contexts for basic block

This was introduced by commit
f55fb0c243 autofs4 - dont clear DCACHE_NEED_AUTOMOUNT on rootless mount

The function autofs4_d_automount can be left with the (&sbi->fs_lock)
held if sbi->version <= 4 and simple_empty(dentry) == false so the warning seems valid.

--> Add an spin_unlock in this case before we jump to done

Unfortunately compile tested only.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 fs/autofs4/root.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index c934476..74a299f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -383,8 +383,10 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 				goto done;
 			}
 		} else {
-			if (!simple_empty(dentry))
+			if (!simple_empty(dentry)) {
+				spin_unlock(&sbi->fs_lock);
 				goto done;
+			}
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-- 
1.7.8.6

