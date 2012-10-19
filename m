Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2JSDAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:00:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:52238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964870Ab2JSCtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Kent <ikent@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 40/76] autofs4 - fix reset pending flag on mount fail
Date: Thu, 18 Oct 2012 19:47:04 -0700
Message-Id: <20121019024356.563250978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/autofs4/root.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -392,10 +392,12 @@ static struct vfsmount *autofs4_d_automo
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


