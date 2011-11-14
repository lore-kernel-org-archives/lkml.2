Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1KNXMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:12:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56646 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab1KNXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:12:49 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] pstore: pass allocated memory region back to caller
Date: Mon, 14 Nov 2011 15:12:36 -0800
Message-Id: <1321312358-11234-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321312358-11234-1-git-send-email-keescook@chromium.org>
References: <1321312358-11234-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buf_lock cannot be held while populating the inodes, so make the backend
pass forward an allocated and filled buffer instead. Solves this backtrace:

[   59.691019] BUG: sleeping function called from invalid context at .../mm/slub.c:847
[   59.691019] in_atomic(): 0, irqs_disabled(): 1, pid: 1819, name: mount
[   59.691019] Pid: 1819, comm: mount Not tainted 3.0.8 #1
[   59.691019] Call Trace:
[   59.691019]  [<810252d5>] __might_sleep+0xc3/0xca
[   59.691019]  [<810a26e6>] kmem_cache_alloc+0x32/0xf3
[   59.691019]  [<810b53ac>] ? __d_lookup_rcu+0x6f/0xf4
[   59.691019]  [<810b68b1>] alloc_inode+0x2a/0x64
[   59.691019]  [<810b6903>] new_inode+0x18/0x43
[   59.691019]  [<81142447>] pstore_get_inode.isra.1+0x11/0x98
[   59.691019]  [<81142623>] pstore_mkfile+0xae/0x26f
[   59.691019]  [<810a2a66>] ? kmem_cache_free+0x19/0xb1
[   59.691019]  [<8116c821>] ? ida_get_new_above+0x140/0x158
[   59.691019]  [<811708ea>] ? __init_rwsem+0x1e/0x2c
[   59.691019]  [<810b67e8>] ? inode_init_always+0x111/0x1b0
[   59.691019]  [<8102127e>] ? should_resched+0xd/0x27
[   59.691019]  [<8137977f>] ? _cond_resched+0xd/0x21
[   59.691019]  [<81142abf>] pstore_get_records+0x52/0xa7
[   59.691019]  [<8114254b>] pstore_fill_super+0x7d/0x91
[   59.691019]  [<810a7ff5>] mount_single+0x46/0x82
[   59.691019]  [<8114231a>] pstore_mount+0x15/0x17
[   59.691019]  [<811424ce>] ? pstore_get_inode.isra.1+0x98/0x98
[   59.691019]  [<810a8199>] mount_fs+0x5a/0x12d
[   59.691019]  [<810b9174>] ? alloc_vfsmnt+0xa4/0x14a
[   59.691019]  [<810b9474>] vfs_kern_mount+0x4f/0x7d
[   59.691019]  [<810b9d7e>] do_kern_mount+0x34/0xb2
[   59.691019]  [<810bb15f>] do_mount+0x5fc/0x64a
[   59.691019]  [<810912fb>] ? strndup_user+0x2e/0x3f
[   59.691019]  [<810bb3cb>] sys_mount+0x66/0x99
[   59.691019]  [<8137b537>] sysenter_do_call+0x12/0x26

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c   |   14 +++++++-------
 include/linux/pstore.h |    3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 2bd620f..c09cbb4 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -195,30 +195,30 @@ EXPORT_SYMBOL_GPL(pstore_register);
 void pstore_get_records(int quiet)
 {
 	struct pstore_info *psi = psinfo;
+	char			*buf = NULL;
 	ssize_t			size;
 	u64			id;
 	enum pstore_type_id	type;
 	struct timespec		time;
 	int			failed = 0, rc;
-	unsigned long		flags;
 
 	if (!psi)
 		return;
 
-	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	rc = psi->open(psi);
 	if (rc)
 		goto out;
 
-	while ((size = psi->read(&id, &type, &time, psi)) > 0) {
-		rc = pstore_mkfile(type, psi->name, id, psi->buf, (size_t)size,
+	while ((size = psi->read(&id, &type, &time, &buf, psi)) > 0) {
+		rc = pstore_mkfile(type, psi->name, id, buf, (size_t)size,
 				  time, psi);
+		kfree(buf);
+		buf = NULL;
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 	}
 	psi->close(psi);
 out:
-	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	if (failed)
 		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
@@ -259,10 +259,10 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	memcpy(psinfo->buf, buf, size);
 	ret = psinfo->write(type, &id, 0, size, psinfo);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 	if (ret == 0 && pstore_is_mounted())
-		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
+		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, buf,
 			      size, CURRENT_TIME, psinfo);
-	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 
 	return 0;
 }
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ea56732..781cf43 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -38,7 +38,8 @@ struct pstore_info {
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
-			struct timespec *time, struct pstore_info *psi);
+			struct timespec *time, char **buf,
+			struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type, u64 *id,
 			unsigned int part, size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
-- 
1.7.0.4

