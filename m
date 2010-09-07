Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab0IGOhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:37:42 -0400
Received: from www.tglx.de ([62.245.132.106]:43760 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab0IGOdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:12 -0400
Message-Id: <20100907125056.136212826@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [patch 15/30] smbfs: Convert server->sem to mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=smbfs-sema-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

server->sem is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org

---
 fs/smbfs/inode.c          |    2 +-
 include/linux/smb_fs_sb.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/smbfs/inode.c
===================================================================
--- linux-2.6.orig/fs/smbfs/inode.c
+++ linux-2.6/fs/smbfs/inode.c
@@ -536,7 +536,7 @@ static int smb_fill_super(struct super_b
 	server->mnt = NULL;
 	server->sock_file = NULL;
 	init_waitqueue_head(&server->conn_wq);
-	init_MUTEX(&server->sem);
+	mutex_init(&server->mutex);
 	INIT_LIST_HEAD(&server->entry);
 	INIT_LIST_HEAD(&server->xmitq);
 	INIT_LIST_HEAD(&server->recvq);
Index: linux-2.6/include/linux/smb_fs_sb.h
===================================================================
--- linux-2.6.orig/include/linux/smb_fs_sb.h
+++ linux-2.6/include/linux/smb_fs_sb.h
@@ -58,7 +58,7 @@ struct smb_sb_info {
 	struct smb_conn_opt opt;
 	wait_queue_head_t conn_wq;
 	int conn_complete;
-	struct semaphore sem;
+	struct mutex mutex;
 
 	unsigned char      header[SMB_HEADER_LEN + 20*2 + 2];
 	u32                header_len;
@@ -82,19 +82,19 @@ struct smb_sb_info {
 static inline int
 smb_lock_server_interruptible(struct smb_sb_info *server)
 {
-	return down_interruptible(&(server->sem));
+	return mutex_lock_interruptible(&server->mutex);
 }
 
 static inline void
 smb_lock_server(struct smb_sb_info *server)
 {
-	down(&(server->sem));
+	mutex_lock(&server->mutex);
 }
 
 static inline void
 smb_unlock_server(struct smb_sb_info *server)
 {
-	up(&(server->sem));
+	mutex_unlock(&server->mutex);
 }
 
 #endif


