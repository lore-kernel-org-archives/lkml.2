Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0F3TMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:12:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60526 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab0F3TMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:12:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH -rt 2/2] Make sure d_kill sets d_parent to null
Date: Wed, 30 Jun 2010 12:12:25 -0700
Message-Id: <1277925145-8355-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1277925145-8355-1-git-send-email-johnstul@us.ibm.com>
References: <1277925145-8355-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against currrent 2.6.33-rt tree.

This patch is an alternative fix to the select_parent panic that was
suggested by Nick Piggin.

It resolves the issue by making sure d_parent is set to null so that
the dentry ascending code in select_parent will restart if the child
or next dentry was dkilled while the locks were released.

Credit and thanks to Nick for finding the solution.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Nick Piggin <npiggin@suse.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: John Kacur <jkacur@redhat.com>
---
 fs/dcache.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index da90157..c9d21ae 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -225,13 +225,15 @@ static struct dentry *d_kill(struct dentry *dentry)
 {
 	struct dentry *parent;
 
-	list_del(&dentry->d_u.d_child);
-	if (dentry->d_parent && dentry != dentry->d_parent)
-		spin_unlock(&dentry->d_parent->d_lock);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
+
+	dentry->d_parent = NULL;
+	list_del(&dentry->d_u.d_child);
+	if (parent)
+		spin_unlock(&parent->d_lock);
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
 	d_free(dentry);
-- 
1.6.0.4

