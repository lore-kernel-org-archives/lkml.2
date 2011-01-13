Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1AMNyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:54:47 -0500
Received: from www.tglx.de ([62.245.132.106]:46566 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1AMNyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:54:45 -0500
Date: Thu, 13 Jan 2011 14:54:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <npiggin@kernel.dk>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: [PATCH] fs: Work around NFS wreckage
Message-ID: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dcache scalability work broke NFS root filesystems.

"cd /" results in the following problem:

    link_path_walk("/",...);
	jumps to return_reval
	need_reval_dot() returns true for NFS
	d_revalidate()
		dentry->d_op->d_revalidate(dentry, nd);
		 	returns -ECHILD due to nd->flags & LOOKUP_RCU
		nameidata_dentry_drop_rcu()
			spin_lock(&parent->d_lock);
			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);

			This deadlocks because dentry == parent

This problem exists for any filesystem which implements d_revalidate.

Uwe bisected is down to commit 34286d6(fs: rcu-walk aware d_revalidate
method), but reverting that patch causes different wreckage to show up.

Check for parent equal dentry and skip the nested lock to avoid the
deadlock. I'm sure this is the wrong fix, but at least it "works" :)

Reported-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Reported-by: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Not-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/namei.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -487,6 +487,8 @@ static int nameidata_dentry_drop_rcu(str
 			goto err_root;
 	}
 	spin_lock(&parent->d_lock);
+	if (parent == dentry)
+		goto same;
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	if (!__d_rcu_to_refcount(dentry, nd->seq))
 		goto err;
@@ -499,6 +501,8 @@ static int nameidata_dentry_drop_rcu(str
 	BUG_ON(!parent->d_count);
 	parent->d_count++;
 	spin_unlock(&dentry->d_lock);
+
+same:
 	spin_unlock(&parent->d_lock);
 	if (nd->root.mnt) {
 		path_get(&nd->root);
