Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1CAE5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:57:18 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:41808
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab1CAE5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:57:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKYLbE18qV3C/2dsb2JhbACEJ6IjdKookHSBJ4NEdgSFEIpnggM
X-IronPort-AV: E=Sophos;i="4.62,245,1297008000"; 
   d="scan'208";a="765797922"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 3/4] autofs4 - fix dentry leak in autofs4_expire_direct()
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 12:57:13 +0800
Message-ID: <20110301045713.4615.89336.stgit@localhost6.localdomain6>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missing dput() when returning from autofs4_expire_direct()
when we see that the dentry is already a pending mount.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index c896dd6..c403abc 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -290,10 +290,8 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(root);
 	/* No point expiring a pending mount */
-	if (ino->flags & AUTOFS_INF_PENDING) {
-		spin_unlock(&sbi->fs_lock);
-		return NULL;
-	}
+	if (ino->flags & AUTOFS_INF_PENDING)
+		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
 		struct autofs_info *ino = autofs4_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
@@ -301,6 +299,7 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 		spin_unlock(&sbi->fs_lock);
 		return root;
 	}
+out:
 	spin_unlock(&sbi->fs_lock);
 	dput(root);
 

