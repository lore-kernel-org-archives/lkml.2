Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2JHTtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:49:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49309 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2JHTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:49:32 -0400
Date: Mon, 8 Oct 2012 12:49:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: include/linux/cgroup.h:566 suspicious rcu_dereference_check()
 usage!
Message-ID: <20121008194921.GF2453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <506F649F.4050109@opensuse.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <506F649F.4050109@opensuse.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100819-2398-0000-0000-00000C06CD05
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00180767; UDB=6.00040942; UTC=2012-10-08
 19:49:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 07:52:15PM -0300, Cristian Rodríguez wrote:
> Hi:
> I am getting this in the current linus tree.
> 
> [    0.408781] ===============================
> [    0.408783] [ INFO: suspicious RCU usage. ]
> [    0.408786] 3.6.0-canneverbe-07124-g5f3d2f2 #18 Not tainted
> [    0.408789] -------------------------------
> [    0.408791] include/linux/cgroup.h:566 suspicious
> rcu_dereference_check() usage!
> [    0.408795]
> [    0.408795] other info that might help us debug this:
> [    0.408795]
> [    0.408799]
> [    0.408799] rcu_scheduler_active = 1, debug_locks = 0
> [    0.408802] 2 locks held by kdevtmpfs/49:
> [    0.408804]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff8119a2ef>]
> mnt_want_write+0x1f/0x50
> [    0.408814]  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at:
> [<ffffffff811857cf>] kern_path_create+0x7f/0x170
> [    0.408822]
> [    0.408822] stack backtrace:
> [    0.408825] Pid: 49, comm: kdevtmpfs Not tainted
> 3.6.0-canneverbe-07124-g5f3d2f2 #18
> [    0.408829] Call Trace:
> [    0.408834]  [<ffffffff8109fabd>] lockdep_rcu_suspicious+0xfd/0x130
> [    0.408838]  [<ffffffff812a876d>] devcgroup_inode_mknod+0x18d/0x230
> [    0.408843]  [<ffffffff8126f923>] ? security_capable+0x13/0x20
> [    0.408848]  [<ffffffff8104a06f>] ? ns_capable+0x3f/0x80
> [    0.408851]  [<ffffffff81186c09>] vfs_mknod+0x79/0x140
> [    0.408856]  [<ffffffff813a6df2>] handle_create.isra.2+0x72/0x200
> [    0.408860]  [<ffffffff813a702c>] ? devtmpfsd+0xac/0x140
> [    0.408863]  [<ffffffff813a7094>] devtmpfsd+0x114/0x140
> [    0.408867]  [<ffffffff813a6f80>] ? handle_create.isra.2+0x200/0x200
> [    0.408871]  [<ffffffff81064de6>] kthread+0xd6/0xe0
> [    0.408877]  [<ffffffff81578cb4>] kernel_thread_helper+0x4/0x10
> [    0.408881]  [<ffffffff8156f85c>] ? retint_restore_args+0xe/0xe
> [    0.408885]  [<ffffffff81064d10>] ? flush_kthread_work+0x190/0x190
> [    0.408889]  [<ffffffff81578cb0>] ? gs_change+0xb/0xb
> 
> 
> Hope someone can take a look at it.

It looks to me like commit #ad676077 (device_cgroup: convert device_cgroup
internally to policy + exceptions) removed a needed rcu_read_lock().
See below for an untested patch restoring rcu_read_lock().

							Thanx, Paul

------------------------------------------------------------------------

device_cgroup: Restore rcu_read_lock() protection to devcgroup_inode_mknod()

Commit ad676077 (device_cgroup: convert device_cgroup internally to
policy + exceptions) restructured devcgroup_inode_mknod(), removing
rcu_read_lock() in the process.  However, RCU read-side protection
is required by the call to task_devcgroup(), so this commit restores
the rcu_read_lock() and rcu_read_unlock().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 44dfc41..c686110 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -576,9 +576,12 @@ int __devcgroup_inode_permission(struct inode *inode, int mask)
 
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
+	struct dev_cgroup *dev_cgroup;
+	int ret;
 	short type;
 
+	rcu_read_lock();
+	dev_cgroup = task_devcgroup(current);
 	if (!S_ISBLK(mode) && !S_ISCHR(mode))
 		return 0;
 
@@ -587,7 +590,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 	else
 		type = DEV_CHAR;
 
-	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
+	ret =  __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
 					    MINOR(dev), ACC_MKNOD);
+	rcu_read_unlock();
+	return ret;
 
 }

