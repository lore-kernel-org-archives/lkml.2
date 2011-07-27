Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1G0SxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:53:02 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53457 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1G0Sw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:52:59 -0400
Date: Wed, 27 Jul 2011 21:52:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] proc: make struct proc_dir_entry::name a terminal array
 rather than a pointer
Message-ID: <20110727185255.GA2750@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d073571917b6c1206dd87d52d429a48c646b330d Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Wed, 27 Jul 2011 21:47:03 +0300
Subject: [PATCH 1/1] proc: make struct proc_dir_entry::name a terminal array rather than a pointer

Since __proc_create() appends the name it is given to the end of the PDE
structure that it allocates, there isn't a need to store a name pointer.
Instead we can just replace the name pointer with a terminal char array of
_unspecified_ length.  The compiler will simply append the string to statically
defined variables of PDE type overlapping any hole at the end of the structure
and, unlike specifying an explicitly _zero_ length array, won't give a warning
if you try to statically initialise it with a string of more than zero length.

Also, whilst we're at it:

 (1) Move namelen to end just prior to name and reduce it to a single byte
     (name shouldn't be longer than NAME_MAX).

 (2) Move pde_unload_lock two places further on so that if it's four bytes in
     size on a 64-bit machine, it won't cause an unused hole in the PDE struct.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/generic.c       |    3 +--
 fs/proc/proc_net.c      |    4 ++--
 fs/proc/root.c          |    2 +-
 include/linux/proc_fs.h |    6 +++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index f1637f1..9d99131 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -620,8 +620,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	if (!ent) goto out;
 
 	memset(ent, 0, sizeof(struct proc_dir_entry));
-	memcpy(((char *) ent) + sizeof(struct proc_dir_entry), fn, len + 1);
-	ent->name = ((char *) ent) + sizeof(*ent);
+	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 9020ac1..f738024 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -197,15 +197,15 @@ static __net_init int proc_net_ns_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	netd = kzalloc(sizeof(*netd), GFP_KERNEL);
+	netd = kzalloc(sizeof(*netd) + 4, GFP_KERNEL);
 	if (!netd)
 		goto out;
 
 	netd->data = net;
 	netd->nlink = 2;
-	netd->name = "net";
 	netd->namelen = 3;
 	netd->parent = &proc_root;
+	memcpy(netd->name, "net", 4);
 
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index d6c3b41..9a8a2b7 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -186,13 +186,13 @@ static const struct inode_operations proc_root_inode_operations = {
 struct proc_dir_entry proc_root = {
 	.low_ino	= PROC_ROOT_INO, 
 	.namelen	= 5, 
-	.name		= "/proc",
 	.mode		= S_IFDIR | S_IRUGO | S_IXUGO, 
 	.nlink		= 2, 
 	.count		= ATOMIC_INIT(1),
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
+	.name		= "/proc",
 };
 
 int pid_ns_prepare_proc(struct pid_namespace *ns)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 650af6d..643b96c 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -50,8 +50,6 @@ typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
 
 struct proc_dir_entry {
 	unsigned int low_ino;
-	unsigned int namelen;
-	const char *name;
 	mode_t mode;
 	nlink_t nlink;
 	uid_t uid;
@@ -73,9 +71,11 @@ struct proc_dir_entry {
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
 	int pde_users;	/* number of callers into module in progress */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
+	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	u8 namelen;
+	char name[];
 };
 
 enum kcore_type {
-- 
1.7.3.4

