Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1JMH4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:56:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34630 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1JMH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:56:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<m1wrc99vjx.fsf@fess.ebiederm.org>
	<m1sjmx9vhf.fsf_-_@fess.ebiederm.org>
Date: Thu, 13 Oct 2011 00:56:25 -0700
In-Reply-To: <m1sjmx9vhf.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 13 Oct 2011 00:55:08 -0700")
Message-ID: <m1mxd59vfa.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19VlmbQSHNLQsWq0+7NoC0Reuh9HJapkRI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, David Miller
	<davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: [PATCH 3/5] bonding: Use a per netns implementation of /sys/class/net/bonding_masters.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a network namespace misfeature that bonding_masters looked at
current instead of the remembering the context where in which
/sys/class/net/bonding_masters was opened in to see which network
namespace to act upon.

This removes the need for sysfs to handle tagged directories with
untagged members allowing for a conceptually simpler sysfs
implementation.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/net/bonding/bond_main.c  |    7 +----
 drivers/net/bonding/bond_sysfs.c |   45 ++++++++++++++++++++++++++-----------
 drivers/net/bonding/bonding.h    |    7 ++++-
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6d79b78..e084b1c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4898,6 +4898,7 @@ static int __net_init bond_net_init(struct net *net)
 	INIT_LIST_HEAD(&bn->dev_list);
 
 	bond_create_proc_dir(bn);
+	bond_create_sysfs(bn);
 	
 	return 0;
 }
@@ -4906,6 +4907,7 @@ static void __net_exit bond_net_exit(struct net *net)
 {
 	struct bond_net *bn = net_generic(net, bond_net_id);
 
+	bond_destroy_sysfs(bn);
 	bond_destroy_proc_dir(bn);
 }
 
@@ -4943,10 +4945,6 @@ static int __init bonding_init(void)
 			goto err;
 	}
 
-	res = bond_create_sysfs();
-	if (res)
-		goto err;
-
 	register_netdevice_notifier(&bond_netdev_notifier);
 	register_inetaddr_notifier(&bond_inetaddr_notifier);
 out:
@@ -4964,7 +4962,6 @@ static void __exit bonding_exit(void)
 	unregister_netdevice_notifier(&bond_netdev_notifier);
 	unregister_inetaddr_notifier(&bond_inetaddr_notifier);
 
-	bond_destroy_sysfs();
 	bond_destroy_debugfs();
 
 	rtnl_link_unregister(&bond_link_ops);
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 2dfb4bf..6044ff8 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -55,8 +55,8 @@ static ssize_t bonding_show_bonds(struct class *cls,
 				  struct class_attribute *attr,
 				  char *buf)
 {
-	struct net *net = current->nsproxy->net_ns;
-	struct bond_net *bn = net_generic(net, bond_net_id);
+	struct bond_net *bn =
+		container_of(attr, struct bond_net, class_attr_bonding_masters);
 	int res = 0;
 	struct bonding *bond;
 
@@ -79,9 +79,8 @@ static ssize_t bonding_show_bonds(struct class *cls,
 	return res;
 }
 
-static struct net_device *bond_get_by_name(struct net *net, const char *ifname)
+static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifname)
 {
-	struct bond_net *bn = net_generic(net, bond_net_id);
 	struct bonding *bond;
 
 	list_for_each_entry(bond, &bn->dev_list, bond_list) {
@@ -103,7 +102,8 @@ static ssize_t bonding_store_bonds(struct class *cls,
 				   struct class_attribute *attr,
 				   const char *buffer, size_t count)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct bond_net *bn =
+		container_of(attr, struct bond_net, class_attr_bonding_masters);
 	char command[IFNAMSIZ + 1] = {0, };
 	char *ifname;
 	int rv, res = count;
@@ -116,7 +116,7 @@ static ssize_t bonding_store_bonds(struct class *cls,
 
 	if (command[0] == '+') {
 		pr_info("%s is being created...\n", ifname);
-		rv = bond_create(net, ifname);
+		rv = bond_create(bn->net, ifname);
 		if (rv) {
 			if (rv == -EEXIST)
 				pr_info("%s already exists.\n", ifname);
@@ -128,7 +128,7 @@ static ssize_t bonding_store_bonds(struct class *cls,
 		struct net_device *bond_dev;
 
 		rtnl_lock();
-		bond_dev = bond_get_by_name(net, ifname);
+		bond_dev = bond_get_by_name(bn, ifname);
 		if (bond_dev) {
 			pr_info("%s is being deleted...\n", ifname);
 			unregister_netdevice(bond_dev);
@@ -150,9 +150,24 @@ err_no_cmd:
 	return -EPERM;
 }
 
+static const void *bonding_namespace(struct class *cls,
+				     const struct class_attribute *attr)
+{
+	const struct bond_net *bn =
+		container_of(attr, struct bond_net, class_attr_bonding_masters);
+	return bn->net;
+}
+
 /* class attribute for bond_masters file.  This ends up in /sys/class/net */
-static CLASS_ATTR(bonding_masters,  S_IWUSR | S_IRUGO,
-		  bonding_show_bonds, bonding_store_bonds);
+static const struct class_attribute class_attr_bonding_masters = {
+	.attr = {
+		.name = "bonding_masters",
+		.mode = S_IWUSR | S_IRUGO,
+	},
+	.show = bonding_show_bonds,
+	.store = bonding_store_bonds,
+	.namespace = bonding_namespace,
+};
 
 int bond_create_slave_symlinks(struct net_device *master,
 			       struct net_device *slave)
@@ -1655,11 +1670,13 @@ static struct attribute_group bonding_group = {
  * Initialize sysfs.  This sets up the bonding_masters file in
  * /sys/class/net.
  */
-int bond_create_sysfs(void)
+int bond_create_sysfs(struct bond_net *bn)
 {
 	int ret;
 
-	ret = netdev_class_create_file(&class_attr_bonding_masters);
+	bn->class_attr_bonding_masters = class_attr_bonding_masters;
+
+	ret = netdev_class_create_file(&bn->class_attr_bonding_masters);
 	/*
 	 * Permit multiple loads of the module by ignoring failures to
 	 * create the bonding_masters sysfs file.  Bonding devices
@@ -1673,7 +1690,7 @@ int bond_create_sysfs(void)
 	 */
 	if (ret == -EEXIST) {
 		/* Is someone being kinky and naming a device bonding_master? */
-		if (__dev_get_by_name(&init_net,
+		if (__dev_get_by_name(bn->net,
 				      class_attr_bonding_masters.attr.name))
 			pr_err("network device named %s already exists in sysfs",
 			       class_attr_bonding_masters.attr.name);
@@ -1687,9 +1704,9 @@ int bond_create_sysfs(void)
 /*
  * Remove /sys/class/net/bonding_masters.
  */
-void bond_destroy_sysfs(void)
+void bond_destroy_sysfs(struct bond_net *bn)
 {
-	netdev_class_remove_file(&class_attr_bonding_masters);
+	netdev_class_remove_file(&bn->class_attr_bonding_masters);
 }
 
 /*
diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index 43526a2..1007f9a 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -380,11 +380,13 @@ static inline bool bond_is_slave_inactive(struct slave *slave)
 	return slave->inactive;
 }
 
+struct bond_net;
+
 struct vlan_entry *bond_next_vlan(struct bonding *bond, struct vlan_entry *curr);
 int bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
 int bond_create(struct net *net, const char *name);
-int bond_create_sysfs(void);
-void bond_destroy_sysfs(void);
+int bond_create_sysfs(struct bond_net *net);
+void bond_destroy_sysfs(struct bond_net *net);
 void bond_prepare_sysfs_group(struct bonding *bond);
 int bond_create_slave_symlinks(struct net_device *master, struct net_device *slave);
 void bond_destroy_slave_symlinks(struct net_device *master, struct net_device *slave);
@@ -410,6 +412,7 @@ struct bond_net {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *	proc_dir;
 #endif
+	struct class_attribute	class_attr_bonding_masters;
 };
 
 #ifdef CONFIG_PROC_FS
-- 
1.7.2.5

