Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2JHTwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:52:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46205 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:52:28 -0400
Date: Mon, 8 Oct 2012 12:52:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Aristeu Rozanski <aris@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cgroup.h:566 suspicious rcu_dereference_check() usage!
Message-ID: <20121008195207.GG2453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121006131607.GA12798@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121006131607.GA12798@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100819-5518-0000-0000-0000083CE137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 09:16:07PM +0800, Fengguang Wu wrote:
> Hi Aristeu,
> 
> I got the below warning in linus/master and linux-next, and it's
> bisected down to:

Cristian Rodríguez reported what looks like the same bug.  Does the
patch below fix it?

							Thanx, Paul

------------------------------------------------------------------------

device_cgroup: Restore rcu_read_lock() protection to devcgroup_inode_mknod()

Commit ad676077 (device_cgroup: convert device_cgroup internally to
policy + exceptions) restructured devcgroup_inode_mknod(), removing
rcu_read_lock() in the process.  However, RCU read-side protection
is required by the call to task_devcgroup(), so this commit restores
the rcu_read_lock() and rcu_read_unlock().

Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
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

