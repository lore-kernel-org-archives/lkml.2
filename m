Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0IGOhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:37:33 -0400
Received: from www.tglx.de ([62.245.132.106]:43768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0IGOdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:15 -0400
Message-Id: <20100907125056.228874895@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [patch 16/30] hpfs: Convert sbi->hpfs_creation_de to mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=hpfs-sema-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbi->hpfs_creation_de is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org

---
 fs/hpfs/buffer.c  |    4 ++--
 fs/hpfs/hpfs_fn.h |    2 +-
 fs/hpfs/super.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/hpfs/buffer.c
===================================================================
--- linux-2.6.orig/fs/hpfs/buffer.c
+++ linux-2.6/fs/hpfs/buffer.c
@@ -14,7 +14,7 @@ void hpfs_lock_creation(struct super_blo
 #ifdef DEBUG_LOCKS
 	printk("lock creation\n");
 #endif
-	down(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_lock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 void hpfs_unlock_creation(struct super_block *s)
@@ -22,7 +22,7 @@ void hpfs_unlock_creation(struct super_b
 #ifdef DEBUG_LOCKS
 	printk("unlock creation\n");
 #endif
-	up(&hpfs_sb(s)->hpfs_creation_de);
+	mutex_unlock(&hpfs_sb(s)->hpfs_creation_de);
 }
 
 /* Map a sector into a buffer and return pointers to it and to the buffer. */
Index: linux-2.6/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.orig/fs/hpfs/hpfs_fn.h
+++ linux-2.6/fs/hpfs/hpfs_fn.h
@@ -87,7 +87,7 @@ struct hpfs_sb_info {
 	unsigned *sb_bmp_dir;		/* main bitmap directory */
 	unsigned sb_c_bitmap;		/* current bitmap */
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
-	struct semaphore hpfs_creation_de; /* when creating dirents, nobody else
+	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
 					   can alloc blocks */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
Index: linux-2.6/fs/hpfs/super.c
===================================================================
--- linux-2.6.orig/fs/hpfs/super.c
+++ linux-2.6/fs/hpfs/super.c
@@ -487,7 +487,7 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_bmp_dir = NULL;
 	sbi->sb_cp_table = NULL;
 
-	init_MUTEX(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->hpfs_creation_de);
 
 	uid = current_uid();
 	gid = current_gid();


