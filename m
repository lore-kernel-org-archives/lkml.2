Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab1CAFHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:07:06 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:49157
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab1CAFHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:07:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC8LbE18qV3C/2dsb2JhbACEJ6IjdKolkHSBJ4NEdgSFEIpnggM
X-IronPort-AV: E=Sophos;i="4.62,245,1297008000"; 
   d="scan'208";a="246289453"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 4/4] autofs4 - fix autofs4_expire_indirect() traversal
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 12:57:20 +0800
Message-ID: <20110301045720.4615.33245.stgit@localhost6.localdomain6>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfs-scale changes changed the traversal used in
autofs4_expire_indirect() from a list to a depth first tree traversal
which isn't right.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index c403abc..bc482e0 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -87,6 +87,56 @@ done:
 }
 
 /*
+ * Calculate and dget next entry in the subdirs list under root.
+ */
+static struct dentry *get_next_positive_subdir(struct dentry *prev,
+						struct dentry *root)
+{
+	struct list_head *next;
+	struct dentry *p, *q;
+
+	spin_lock(&autofs4_lock);
+
+	if (prev == NULL) {
+		spin_lock(&root->d_lock);
+		prev = dget_dlock(root);
+		next = prev->d_subdirs.next;
+		p = prev;
+		goto start;
+	}
+
+	p = prev;
+	spin_lock(&p->d_lock);
+again:
+	next = p->d_u.d_child.next;
+start:
+	if (next == &root->d_subdirs) {
+		spin_unlock(&p->d_lock);
+		spin_unlock(&autofs4_lock);
+		dput(prev);
+		return NULL;
+	}
+
+	q = list_entry(next, struct dentry, d_u.d_child);
+
+	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
+	/* Negative dentry - try next */
+	if (!simple_positive(q)) {
+		spin_unlock(&p->d_lock);
+		p = q;
+		goto again;
+	}
+	dget_dlock(q);
+	spin_unlock(&q->d_lock);
+	spin_unlock(&p->d_lock);
+	spin_unlock(&autofs4_lock);
+
+	dput(prev);
+
+	return q;
+}
+
+/*
  * Calculate and dget next entry in top down tree traversal.
  */
 static struct dentry *get_next_positive_dentry(struct dentry *prev,
@@ -333,7 +383,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 	timeout = sbi->exp_timeout;
 
 	dentry = NULL;
-	while ((dentry = get_next_positive_dentry(dentry, root))) {
+	while ((dentry = get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
 		/* No point expiring a pending mount */

