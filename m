Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0J3IQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:16:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0J3IQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:16:40 -0400
Date: Sat, 30 Oct 2010 08:16:01 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        hch@infradead.org
In-Reply-To: <20100907125056.228874895@linutronix.de>
References: <20100907125056.228874895@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] hpfs: Convert sbi->hpfs_creation_de to mutex
Message-ID: <tip-117bf5fbdbdc7a5394e5718b3354238961c83067@git.kernel.org>
Git-Commit-ID: 117bf5fbdbdc7a5394e5718b3354238961c83067
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 08:16:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  117bf5fbdbdc7a5394e5718b3354238961c83067
Gitweb:     http://git.kernel.org/tip/117bf5fbdbdc7a5394e5718b3354238961c83067
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 30 Oct 2010 10:12:03 +0200

hpfs: Convert sbi->hpfs_creation_de to mutex

sbi->hpfs_creation_de is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
LKML-Reference: <20100907125056.228874895@linutronix.de>

---
 fs/hpfs/buffer.c  |    4 ++--
 fs/hpfs/hpfs_fn.h |    2 +-
 fs/hpfs/super.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hpfs/buffer.c b/fs/hpfs/buffer.c
index eac5f96..793cb9d 100644
--- a/fs/hpfs/buffer.c
+++ b/fs/hpfs/buffer.c
@@ -14,7 +14,7 @@ void hpfs_lock_creation(struct super_block *s)
 #ifdef DEBUG_LOCKS
 	printk("lock creation\n");
 #endif
-	down(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_lock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 void hpfs_unlock_creation(struct super_block *s)
@@ -22,7 +22,7 @@ void hpfs_unlock_creation(struct super_block *s)
 #ifdef DEBUG_LOCKS
 	printk("unlock creation\n");
 #endif
-	up(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_unlock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 /* Map a sector into a buffer and return pointers to it and to the buffer. */
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index b59eac0..2fee17d 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -87,7 +87,7 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	struct semaphore hpfs_creation_de; /* when creating dirents, nobody else
+	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
 					   can alloc blocks */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index c969a1a..18e1d45 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -491,7 +491,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
-	init_MUTEX(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
 	gid = current_gid();
