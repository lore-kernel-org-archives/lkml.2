Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2HFBh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2HFBh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:37:56 -0400
From: Ian Kent <ikent@redhat.com>
Subject: [PATCH] autofs4 - fix get_next_positive_subdir()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Jan Sanislo <oystr@cs.washington.edu>
Date: Mon, 06 Aug 2012 09:37:47 +0800
Message-ID: <20120806013747.2915.64344.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <raven@themaw.net>

Following a report of a crash during an automount expire I found that
the locking in fs/autofs4/expire.c:get_next_positive_subdir() was wrong.
Not only is the locking wrong but the function is more complex than it
needs to be.

The function is meant to calculate (and dget) the next entry in the list
of directories contained in the root of an autofs mount point (an autofs
indirect mount to be precise). The main problem was that the d_lock of
the owner of the list was not being taken when walking the list, which
lead to list corruption under load. The only other lock that needs to
be taken is against the next dentry candidate so it can be checked for
usability.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 1feb68e..8c0e56d 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -94,25 +94,21 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
-	struct dentry *p, *q;
+	struct dentry *q;
 
 	spin_lock(&sbi->lookup_lock);
+	spin_lock(&root->d_lock);
 
-	if (prev == NULL) {
-		spin_lock(&root->d_lock);
+	if (prev)
+		next = prev->d_u.d_child.next;
+	else {
 		prev = dget_dlock(root);
 		next = prev->d_subdirs.next;
-		p = prev;
-		goto start;
 	}
 
-	p = prev;
-	spin_lock(&p->d_lock);
-again:
-	next = p->d_u.d_child.next;
-start:
+cont:
 	if (next == &root->d_subdirs) {
-		spin_unlock(&p->d_lock);
+		spin_unlock(&root->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		dput(prev);
 		return NULL;
@@ -121,16 +117,15 @@ start:
 	q = list_entry(next, struct dentry, d_u.d_child);
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
-	/* Negative dentry - try next */
-	if (!simple_positive(q)) {
-		spin_unlock(&p->d_lock);
-		lock_set_subclass(&q->d_lock.dep_map, 0, _RET_IP_);
-		p = q;
-		goto again;
+	/* Already gone or negative dentry (under construction) - try next */
+	if (q->d_count == 0 || !simple_positive(q)) {
+		spin_unlock(&q->d_lock);
+		next = q->d_u.d_child.next;
+		goto cont;
 	}
 	dget_dlock(q);
 	spin_unlock(&q->d_lock);
-	spin_unlock(&p->d_lock);
+	spin_unlock(&root->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);

