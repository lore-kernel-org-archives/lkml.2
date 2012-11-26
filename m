Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2KZSJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:09:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2KZRD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Kent <ikent@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 067/270] autofs4 - fix reset pending flag on mount fail
Date: Mon, 26 Nov 2012 14:55:57 -0200
Message-Id: <1353949160-26803-68-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Kent <raven@themaw.net>

commit 49999ab27eab6289a8e4f450e148bdab521361b2 upstream.

In autofs4_d_automount(), if a mount fail occurs the AUTOFS_INF_PENDING
mount pending flag is not cleared.

One effect of this is when using the "browse" option, directory entry
attributes show up with all "?"s due to the incorrect callback and
subsequent failure return (when in fact no callback should be made).

Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/autofs4/root.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 75e5f1c..8c4292f 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -392,10 +392,12 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
 		status = autofs4_mount_wait(dentry);
-		if (status)
-			return ERR_PTR(status);
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_PENDING;
+		if (status) {
+			spin_unlock(&sbi->fs_lock);
+			return ERR_PTR(status);
+		}
 	}
 done:
 	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
-- 
1.7.9.5

