Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2INJkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:40:23 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:54819 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2INJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:40:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, aris@redhat.com,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com
Subject: [PATCH] cgroup: fix invalid rcu dereference
Date: Fri, 14 Sep 2012 11:40:12 +0200
Message-Id: <1347615612-11450-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <5052F78A.7010007@suse.cz>
References: <5052F78A.7010007@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "device_cgroup: convert device_cgroup internally to policy +
exceptions" removed rcu locks which are needed in task_devcgroup
called in this chain: devcgroup_inode_mknod OR
__devcgroup_inode_permission -> __devcgroup_inode_permission ->
task_devcgroup -> task_subsys_state -> task_subsys_state_check.

Change the code so that task_devcgroup is safely called with rcu read
lock held.

===============================
[ INFO: suspicious RCU usage. ]
3.6.0-rc5-next-20120913+ #42 Not tainted
-------------------------------
/home/latest/linux/include/linux/cgroup.h:553 suspicious
rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
2 locks held by kdevtmpfs/23:
 #0:  (sb_writers){.+.+.+}, at: [<ffffffff8116873f>]
mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff811558af>]
kern_path_create+0x7f/0x170

stack backtrace:
Pid: 23, comm: kdevtmpfs Not tainted 3.6.0-rc5-next-20120913+ #42
Call Trace:
 [<ffffffff810c638d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff8121541d>] devcgroup_inode_mknod+0x19d/0x240
 [<ffffffff8107bf54>] ? ns_capable+0x44/0x80
 [<ffffffff81156b21>] vfs_mknod+0x71/0xf0
 [<ffffffff813a8332>] handle_create.isra.2+0x72/0x200
 [<ffffffff813a85d4>] devtmpfsd+0x114/0x140
 [<ffffffff813a84c0>] ? handle_create.isra.2+0x200/0x200
 [<ffffffff81093ad6>] kthread+0xd6/0xe0
 [<ffffffff81654f24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165369d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81093a00>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff81654f20>] ? gs_change+0xb/0xb

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: aris@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com
---

And this should fix it.

 security/device_cgroup.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8d21ded..2178886 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -524,10 +524,10 @@ struct cgroup_subsys devices_subsys = {
  *
  * returns 0 on success, -EPERM case the operation is not permitted
  */
-static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
-					short type, u32 major, u32 minor,
+static int __devcgroup_check_permission(short type, u32 major, u32 minor,
 				        short access)
 {
+	struct dev_cgroup *dev_cgroup;
 	struct dev_exception_item ex;
 	int rc;
 
@@ -538,6 +538,7 @@ static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
 	ex.access = access;
 
 	rcu_read_lock();
+	dev_cgroup = task_devcgroup(current);
 	rc = may_access(dev_cgroup, &ex);
 	rcu_read_unlock();
 
@@ -549,7 +550,6 @@ static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
 
 int __devcgroup_inode_permission(struct inode *inode, int mask)
 {
-	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
 	short type, access = 0;
 
 	if (S_ISBLK(inode->i_mode))
@@ -561,13 +561,12 @@ int __devcgroup_inode_permission(struct inode *inode, int mask)
 	if (mask & MAY_READ)
 		access |= ACC_READ;
 
-	return __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
-					    iminor(inode), access);
+	return __devcgroup_check_permission(type, imajor(inode), iminor(inode),
+			access);
 }
 
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
 	short type;
 
 	if (!S_ISBLK(mode) && !S_ISCHR(mode))
@@ -578,7 +577,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 	else
 		type = DEV_CHAR;
 
-	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
-					    MINOR(dev), ACC_MKNOD);
+	return __devcgroup_check_permission(type, MAJOR(dev), MINOR(dev),
+			ACC_MKNOD);
 
 }
-- 
1.7.11.5


