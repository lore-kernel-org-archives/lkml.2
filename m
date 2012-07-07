Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2GGXrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:47:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55429 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GGXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:47:04 -0400
Date: Sat, 7 Jul 2012 16:46:59 -0700
From: "'Tejun Heo'" <tj@kernel.org>
To: Shyju PV <shyju.pv@huawei.com>
Cc: "'Li Zefan'" <lizefan@huawei.com>,
        "'Sanil kumar'" <sanil.kumar@huawei.com>,
        "'Masanari Iida'" <standby24x7@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Cgroups'" <cgroups@vger.kernel.org>, viro@zeniv.linux.org.uk,
        levinsasha928@gmail.com, nagamani.mantha@huawei.com
Subject: [PATCH 2/2] cgroup: fix cgroup hierarchy umount race
Message-ID: <20120707234659.GD16783@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4ff55c60.27da440a.65ec.ffff83dfSMTPIN_ADDED@mx.google.com>
 <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707234634.GC16783@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5db9a4d99b0157a513944e9a44d29c9cec2e91dc Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 7 Jul 2012 16:08:18 -0700

48ddbe1946 "cgroup: make css->refcnt clearing on cgroup removal
optional" allowed a css to linger after the associated cgroup is
removed.  As a css holds a reference on the cgroup's dentry, it means
that cgroup dentries may linger for a while.

Destroying a superblock which has dentries with positive refcnts is a
critical bug and triggers BUG() in vfs code.  As each cgroup dentry
holds an s_active reference, any lingering cgroup has both its dentry
and the superblock pinned and thus preventing premature release of
superblock.

Unfortunately, after 48ddbe1946, there's a small window while
releasing a cgroup which is directly under the root of the hierarchy.
When a cgroup directory is released, vfs layer first deletes the
corresponding dentry and then invokes dput() on the parent, which may
recurse further, so when a cgroup directly below root cgroup is
released, the cgroup is first destroyed - which releases the s_active
it was holding - and then the dentry for the root cgroup is dput().

This creates a window where the root dentry's refcnt isn't zero but
superblock's s_active is.  If umount happens before or during this
window, vfs will see the root dentry with non-zero refcnt and trigger
BUG().

Before 48ddbe1946, this problem didn't exist because the last dentry
reference was guaranteed to be put synchronously from rmdir(2)
invocation which holds s_active around the whole process.

Fix it by holding an extra superblock->s_active reference across
dput() from css release, which is the dput() path added by 48ddbe1946
and the only one which doesn't hold an extra s_active ref across the
final cgroup dput().

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4FEEA5CB.8070809@huawei.com>
Reported-by: shyju pv <shyju.pv@huawei.com>
Tested-by: shyju pv <shyju.pv@huawei.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5f134a0..b303dfc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3883,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
+	struct dentry *dentry = css->cgroup->dentry;
+	struct super_block *sb = dentry->d_sb;
 
-	dput(css->cgroup->dentry);
+	atomic_inc(&sb->s_active);
+	dput(dentry);
+	deactivate_super(sb);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
-- 
1.7.7.3

