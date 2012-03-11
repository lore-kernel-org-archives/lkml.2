Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2CKQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 12:23:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33224 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2CKQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 12:23:23 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RT] staging/pohmelfs: convert struct fs->lock usage to seq_spin_{,un}lock
Date: Sun, 11 Mar 2012 17:23:19 +0100
Message-Id: <1331482999-32252-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

	drivers/staging/pohmelfs/path_entry.c:47:2: warning: passing argument 1 of ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
	include/linux/spinlock_rt.h:19:56: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct seqlock_t *’
	drivers/staging/pohmelfs/path_entry.c:49:2: warning: passing argument 1 of ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
	include/linux/spinlock_rt.h:22:56: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct seqlock_t *’
	drivers/staging/pohmelfs/path_entry.c:95:2: warning: passing argument 1 of ‘rt_spin_lock’ from incompatible pointer type [enabled by default]
	include/linux/spinlock_rt.h:19:56: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct seqlock_t *’
	drivers/staging/pohmelfs/path_entry.c:97:2: warning: passing argument 1 of ‘rt_spin_unlock’ from incompatible pointer type [enabled by default]
	include/linux/spinlock_rt.h:22:56: note: expected ‘struct spinlock_t *’ but argument is of type ‘struct seqlock_t *’

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello Thomas,

you probably want to squash that into fs-struct-use-seqlock.patch
It's only compile tested.

Best regards
Uwe

 drivers/staging/pohmelfs/path_entry.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/pohmelfs/path_entry.c b/drivers/staging/pohmelfs/path_entry.c
index 400a9fc..fc0c3fe 100644
--- a/drivers/staging/pohmelfs/path_entry.c
+++ b/drivers/staging/pohmelfs/path_entry.c
@@ -44,9 +44,9 @@ int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, void *data, int le
 		return -ENOENT;
 	}
 
-	spin_lock(&current->fs->lock);
+	seq_spin_lock(&current->fs->lock);
 	path.mnt = mntget(current->fs->root.mnt);
-	spin_unlock(&current->fs->lock);
+	seq_spin_unlock(&current->fs->lock);
 
 	path.dentry = d;
 
@@ -92,9 +92,9 @@ int pohmelfs_path_length(struct pohmelfs_inode *pi)
 		return -ENOENT;
 	}
 
-	spin_lock(&current->fs->lock);
+	seq_spin_lock(&current->fs->lock);
 	root = dget(current->fs->root.dentry);
-	spin_unlock(&current->fs->lock);
+	seq_spin_unlock(&current->fs->lock);
 
 rename_retry:
 	len = 1; /* Root slash */
-- 
1.7.9.1

