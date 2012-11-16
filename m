Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2KPTUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:20:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56204 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2KPTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:20:48 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] netprio_cgroup: implement hierarchy support
Date: Fri, 16 Nov 2012 11:20:24 -0800
Message-Id: <1353093624-22608-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353093624-22608-1-git-send-email-tj@kernel.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement hierarchy support.  Each netprio_cgroup inherits its
parent's prio config for any net_device which it doesn't have local
config on.

As each netprio_cgroup is fully ready after ->css_alloc() and config
inheritance doesn't affect the parent, netprio_cgroup doesn't need to
strictly distinguish on and offline cgroups and can get by simply
inheriting the parent's configuration from ->css_online() and
propagating config updates downwards in write_priomap().

* As ->css_online() inherits prios on all netdevs from the parent,
  clearing priomap on ->css_free() is no longer necessary.  Removed.

* Error out on nesting in ->css_alloc() removed along with
  ss->broken_hierarchy marking.

Note that this patch changes userland-visible behavior.  Nesting is
now allowed and priority configuration is inherited through hierarchy.
This especially changes how the first level cgroups below the root
cgroup behave - any unconfigured pairs now inherit priorities from the
root cgroup instead of assuming 0.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/cgroups/net_prio.txt |  21 +++++-
 net/core/netprio_cgroup.c          | 130 ++++++++++++++++++++++++++++++-------
 2 files changed, 125 insertions(+), 26 deletions(-)

diff --git a/Documentation/cgroups/net_prio.txt b/Documentation/cgroups/net_prio.txt
index 01b3226..4dcca61 100644
--- a/Documentation/cgroups/net_prio.txt
+++ b/Documentation/cgroups/net_prio.txt
@@ -22,13 +22,15 @@ With the above step, the initial group acting as the parent accounting group
 becomes visible at '/sys/fs/cgroup/net_prio'.  This group includes all tasks in
 the system. '/sys/fs/cgroup/net_prio/tasks' lists the tasks in this cgroup.
 
-Each net_prio cgroup contains two files that are subsystem specific
+Each net_prio cgroup contains three files that are subsystem specific
+
+* net_prio.prioidx
 
-net_prio.prioidx
 This file is read-only, and is simply informative.  It contains a unique integer
 value that the kernel uses as an internal representation of this cgroup.
 
-net_prio.ifpriomap
+* net_prio.ifpriomap
+
 This file contains a map of the priorities assigned to traffic originating from
 processes in this group and egressing the system on various interfaces. It
 contains a list of tuples in the form <ifname priority>.  Contents of this file
@@ -51,3 +53,16 @@ One usage for the net_prio cgroup is with mqprio qdisc allowing application
 traffic to be steered to hardware/driver based traffic classes. These mappings
 can then be managed by administrators or other networking protocols such as
 DCBX.
+
+If priority is not set for an interface, the parent's priority is inherited.
+For the root cgroup, there's no parent and all unset priorities are zero.
+Priority can be unset by echoing negative value to ifpriomap.  For example,
+the following would undo the configuration done above and make iscsi cgroup
+to inherit prio for eth0 from the root cgroup.
+
+echo "eth0 -1" > /sys/fs/cgroups/net_prio/iscsi/net_prio.ifpriomap
+
+* net_prio.is_local
+
+This file is read-only and shows whether the net_prio cgroup has its own
+priority configured or inherited priority from its parent for each interface.
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index e7a5b03..bf9aac7 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -163,9 +163,6 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 {
 	struct cgroup_netprio_state *cs;
 
-	if (cgrp->parent && cgrp->parent->id)
-		return ERR_PTR(-EINVAL);
-
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
@@ -173,16 +170,37 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 	return &cs->css;
 }
 
-static void cgrp_css_free(struct cgroup *cgrp)
+static int cgrp_css_online(struct cgroup *cgrp)
 {
-	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
+	struct cgroup *parent = cgrp->parent;
 	struct net_device *dev;
+	int ret = 0;
+
+	if (!parent)
+		return 0;
 
 	rtnl_lock();
-	for_each_netdev(&init_net, dev)
-		WARN_ON_ONCE(netprio_set_prio(cgrp, dev, 0, false));
+	/*
+	 * Inherit prios from the parent.  In netprio, a child node has no
+	 * affect on the parent making prio propagation happening before
+	 * this perfectly fine.  No need to mark on/offline.  Also, as all
+	 * prios are set during onlining, there is no need to clear them on
+	 * offline.
+	 */
+	for_each_netdev(&init_net, dev) {
+		u32 prio = netprio_prio(parent, dev, NULL);
+
+		ret = netprio_set_prio(cgrp, dev, prio, false);
+		if (ret)
+			break;
+	}
 	rtnl_unlock();
-	kfree(cs);
+	return ret;
+}
+
+static void cgrp_css_free(struct cgroup *cgrp)
+{
+	kfree(cgrp_netprio_state(cgrp));
 }
 
 static u64 read_prioidx(struct cgroup *cgrp, struct cftype *cft)
@@ -202,29 +220,104 @@ static int read_priomap(struct cgroup *cont, struct cftype *cft,
 	return 0;
 }
 
+/**
+ * netprio_propagate_prio - propagate prio configuration downwards
+ * @root: cgroup to propagate prio config down from
+ * @dev: net_device whose prio will be propagated
+ *
+ * Propagate @dev's prio configuration to descendants of @root.  Each
+ * descendant of @root re-inherits from its parent in pre-order tree walk.
+ * This should be called after the prio of @root-@dev pair is changed to
+ * keep the descendants up-to-date.
+ *
+ * This may race with a new cgroup coming online and propagation may happen
+ * before finishing ->css_online() or while being taken offline.  As a
+ * netprio css is ready after ->css_alloc() and propagation doesn't affect
+ * the parent, this is safe.
+ *
+ * Should be called with rtnl lock held.
+ */
+static int netprio_propagate_prio(struct cgroup *root, struct net_device *dev)
+{
+	struct cgroup *pos;
+	int ret = 0;
+
+	ASSERT_RTNL();
+	rcu_read_lock();
+
+	cgroup_for_each_descendant_pre(pos, root) {
+		bool is_local;
+		u32 prio;
+		int tmp;
+
+		/*
+		 * Don't propagate if @pos has local configuration.  We can
+		 * skip @pos's subtree but don't have to.  Just propagate
+		 * through for simplicity.
+		 */
+		netprio_prio(pos, dev, &is_local);
+		if (is_local)
+			continue;
+
+		/*
+		 * Set priority.  On failure, record the error value but
+		 * continue propagating.  This is depended upon by
+		 * write_priomap() when reverting failed propagation.
+		 */
+		prio = netprio_prio(pos->parent, dev, NULL);
+		tmp = netprio_set_prio(pos, dev, prio, false);
+		ret = ret ?: tmp;
+	}
+
+	rcu_read_unlock();
+	return ret;
+}
+
 static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 			 const char *buffer)
 {
 	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
 	s64 v;
-	u32 prio;
-	bool is_local;
+	u32 old_prio, prio;
+	bool old_is_local, is_local;
 	int ret;
 
 	if (sscanf(buffer, "%"__stringify(IFNAMSIZ)"s %lld", devname, &v) != 2)
 		return -EINVAL;
 
-	prio = clamp_val(v, 0, UINT_MAX);
-	is_local = v >= 0;
-
 	dev = dev_get_by_name(&init_net, devname);
 	if (!dev)
 		return -ENODEV;
 
 	rtnl_lock();
 
+	/*
+	 * Positive @v is local config which takes precedence.  Negative @v
+	 * deletes local config and inherits prio from the parent.
+	 */
+	is_local = v >= 0;
+	if (is_local || !cgrp->parent)
+		prio = clamp_val(v, 0, UINT_MAX);
+	else
+		prio = netprio_prio(cgrp->parent, dev, NULL);
+
+	/*
+	 * Record the current config and try to update prio and propagate,
+	 * which may fail under memory pressure.  On failure, we revert.
+	 * Note that reverting itself may fail but it's guaranteed that at
+	 * least all the existing priomaps are reverted, which is enough.
+	 * Some packets may go out while reverting.  We don't care.
+	 */
+	old_prio = netprio_prio(cgrp, dev, &old_is_local);
 	ret = netprio_set_prio(cgrp, dev, prio, is_local);
+	if (!ret)
+		ret = netprio_propagate_prio(cgrp, dev);
+
+	if (ret) {
+		netprio_set_prio(cgrp, dev, old_prio, old_is_local);
+		netprio_propagate_prio(cgrp, dev);
+	}
 
 	rtnl_unlock();
 	dev_put(dev);
@@ -289,21 +382,12 @@ static struct cftype ss_files[] = {
 struct cgroup_subsys net_prio_subsys = {
 	.name		= "net_prio",
 	.css_alloc	= cgrp_css_alloc,
+	.css_online	= cgrp_css_online,
 	.css_free	= cgrp_css_free,
 	.attach		= net_prio_attach,
 	.subsys_id	= net_prio_subsys_id,
 	.base_cftypes	= ss_files,
 	.module		= THIS_MODULE,
-
-	/*
-	 * net_prio has artificial limit on the number of cgroups and
-	 * disallows nesting making it impossible to co-mount it with other
-	 * hierarchical subsystems.  Remove the artificially low PRIOIDX_SZ
-	 * limit and properly nest configuration such that children follow
-	 * their parents' configurations by default and are allowed to
-	 * override and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 
 static int netprio_device_event(struct notifier_block *unused,
-- 
1.7.11.7

