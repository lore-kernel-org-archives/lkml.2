Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2JKAAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777Ab2JKAAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:00:37 -0400
From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] autofs4 - fix reset pending flag on mount fail
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Date: Thu, 11 Oct 2012 08:00:33 +0800
Message-ID: <20121011000033.3407.91516.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

In autofs4_d_automount(), if a mount fail occurs the AUTOFS_INF_PENDING
mount pending flag is not cleared.

One effect of this is when using the "browse" option, directory entry
attributes show up with all "?"s due to the incorrect callback and
subsequent failure return (when in fact no callback should be made).

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: stable@vger.kernel.org
---

 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index e7396cf..91b1165 100644
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

