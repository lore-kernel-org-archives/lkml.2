Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2EWCtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab2EWCty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:49:54 -0400
From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] autofs4 - fix get_next_positive_subdir()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@linux.kernel.org>
Date: Wed, 23 May 2012 10:49:50 +0800
Message-ID: <20120523024950.3905.89811.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

The locking for the list traversal in get_next_positive_subdir() is
wrong, so fix it.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 1feb68e..20cc9fd 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -97,9 +97,9 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	struct dentry *p, *q;
 
 	spin_lock(&sbi->lookup_lock);
+	spin_lock(&root->d_lock);
 
 	if (prev == NULL) {
-		spin_lock(&root->d_lock);
 		prev = dget_dlock(root);
 		next = prev->d_subdirs.next;
 		p = prev;
@@ -107,12 +107,13 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	}
 
 	p = prev;
-	spin_lock(&p->d_lock);
+	spin_lock_nested(&p->d_lock, DENTRY_D_LOCK_NESTED);
 again:
 	next = p->d_u.d_child.next;
 start:
 	if (next == &root->d_subdirs) {
 		spin_unlock(&p->d_lock);
+		spin_unlock(&root->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		dput(prev);
 		return NULL;
@@ -121,8 +122,8 @@ start:
 	q = list_entry(next, struct dentry, d_u.d_child);
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
-	/* Negative dentry - try next */
-	if (!simple_positive(q)) {
+	/* Negative dentry or already gone - try next */
+	if (q->d_count == 0 || !simple_positive(q)) {
 		spin_unlock(&p->d_lock);
 		lock_set_subclass(&q->d_lock.dep_map, 0, _RET_IP_);
 		p = q;
@@ -131,6 +132,7 @@ start:
 	dget_dlock(q);
 	spin_unlock(&q->d_lock);
 	spin_unlock(&p->d_lock);
+	spin_unlock(&root->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);

