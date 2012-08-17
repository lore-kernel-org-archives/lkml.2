Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab2HQDJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab2HQDJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:09:09 -0400
From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] autofs4 - fix expire check
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Fri, 17 Aug 2012 11:09:04 +0800
Message-ID: <20120817030903.4054.84138.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

In some cases when an autofs indirect mount is contained in a file
system that is marked as shared (such as when systemd does the
equivalent of "mount --make-rshared /" early in the boot), mounts
stop expiring.

When this happens the first expiry check on a mountpoint dentry in
autofs_expire_indirect() sees a mountpoint dentry with a higher
than minimal reference count. Consequently the dentry is condidered
busy and the actual expiry check is never done.

This particular check was originally meant as an optimisation to
detect a path walk in progress but with the addition of rcu-walk
it can be ineffective anyway.

Removing the test allows automounts to expire again since the
actual expire check doesn't rely on the dentry reference count.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 8c0e56d..842d000 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -399,11 +399,6 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			DPRINTK("checking mountpoint %p %.*s",
 				dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
-			/* Path walk currently on this dentry? */
-			ino_count = atomic_read(&ino->count) + 2;
-			if (dentry->d_count > ino_count)
-				goto next;
-
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, dentry))
 				goto next;

