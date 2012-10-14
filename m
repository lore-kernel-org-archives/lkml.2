Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2JNOmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46285 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab2JNOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:28 -0400
Message-Id: <20121014143549.840039515@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Kent <raven@themaw.net>, Ian Kent <ikent@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 119/147] autofs4 - fix reset pending flag on mount fail
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/autofs4/root.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


