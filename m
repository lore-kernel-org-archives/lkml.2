Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab0EUQ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:56:12 -0400
Received: from kroah.org ([198.145.64.141]:39187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934289Ab0EUQyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/38] net: Expose all network devices in a namespaces in sysfs
Date: Fri, 21 May 2010 09:54:08 -0700
Message-Id: <1274460848-11377-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This reverts commit aaf8cdc34ddba08122f02217d9d684e2f9f5d575.

Drivers like the ipw2100 call device_create_group when they
are initialized and device_remove_group when they are shutdown.
Moving them between namespaces deletes their sysfs groups early.

In particular the following call chain results.
netdev_unregister_kobject -> device_del -> kobject_del -> sysfs_remove_dir
With sysfs_remove_dir recursively deleting all of it's subdirectories,
and nothing adding them back.

Ouch!

Therefore we need to call something that ultimate calls sysfs_mv_dir
as that sysfs function can move sysfs directories between namespaces
without deleting their subdirectories or their contents.   Allowing
us to avoid placing extra boiler plate into every driver that does
something interesting with sysfs.

Currently the function that provides that capability is device_rename.
That is the code works without nasty side effects as originally written.

So remove the misguided fix for moving devices between namespaces.  The
bug in the kobject layer that inspired it has now been recognized and
fixed.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c       |   28 +++++-----------------------
 net/core/net-sysfs.c |   16 +---------------
 net/core/net-sysfs.h |    1 -
 3 files changed, 6 insertions(+), 39 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c82065..d273e4e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1002,15 +1002,10 @@ int dev_change_name(struct net_device *dev, const char *newname)
 		return err;
 
 rollback:
-	/* For now only devices in the initial network namespace
-	 * are in sysfs.
-	 */
-	if (net_eq(net, &init_net)) {
-		ret = device_rename(&dev->dev, dev->name);
-		if (ret) {
-			memcpy(dev->name, oldname, IFNAMSIZ);
-			return ret;
-		}
+	ret = device_rename(&dev->dev, dev->name);
+	if (ret) {
+		memcpy(dev->name, oldname, IFNAMSIZ);
+		return ret;
 	}
 
 	write_lock_bh(&dev_base_lock);
@@ -4994,8 +4989,6 @@ int register_netdevice(struct net_device *dev)
 	if (dev->features & NETIF_F_SG)
 		dev->features |= NETIF_F_GSO;
 
-	netdev_initialize_kobject(dev);
-
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
 	if (ret)
@@ -5547,15 +5540,6 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	if (dev->features & NETIF_F_NETNS_LOCAL)
 		goto out;
 
-#ifdef CONFIG_SYSFS
-	/* Don't allow real devices to be moved when sysfs
-	 * is enabled.
-	 */
-	err = -EINVAL;
-	if (dev->dev.parent)
-		goto out;
-#endif
-
 	/* Ensure the device has been registrered */
 	err = -EINVAL;
 	if (dev->reg_state != NETREG_REGISTERED)
@@ -5606,8 +5590,6 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	dev_uc_flush(dev);
 	dev_mc_flush(dev);
 
-	netdev_unregister_kobject(dev);
-
 	/* Actually switch the network namespace */
 	dev_net_set(dev, net);
 
@@ -5620,7 +5602,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	}
 
 	/* Fixup kobjects */
-	err = netdev_register_kobject(dev);
+	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
 
 	/* Add the device back in the hashes */
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 6881e65..99e7052 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -808,9 +808,6 @@ static int netdev_uevent(struct device *d, struct kobj_uevent_env *env)
 	struct net_device *dev = to_net_dev(d);
 	int retval;
 
-	if (!net_eq(dev_net(dev), &init_net))
-		return 0;
-
 	/* pass interface to uevent. */
 	retval = add_uevent_var(env, "INTERFACE=%s", dev->name);
 	if (retval)
@@ -869,9 +866,6 @@ void netdev_unregister_kobject(struct net_device * net)
 
 	kobject_get(&dev->kobj);
 
-	if (!net_eq(dev_net(net), &init_net))
-		return;
-
 #ifdef CONFIG_RPS
 	rx_queue_remove_kobjects(net);
 #endif
@@ -886,6 +880,7 @@ int netdev_register_kobject(struct net_device *net)
 	const struct attribute_group **groups = net->sysfs_groups;
 	int error = 0;
 
+	device_initialize(dev);
 	dev->class = &net_class;
 	dev->platform_data = net;
 	dev->groups = groups;
@@ -908,9 +903,6 @@ int netdev_register_kobject(struct net_device *net)
 #endif
 #endif /* CONFIG_SYSFS */
 
-	if (!net_eq(dev_net(net), &init_net))
-		return 0;
-
 	error = device_add(dev);
 	if (error)
 		return error;
@@ -939,12 +931,6 @@ void netdev_class_remove_file(struct class_attribute *class_attr)
 EXPORT_SYMBOL(netdev_class_create_file);
 EXPORT_SYMBOL(netdev_class_remove_file);
 
-void netdev_initialize_kobject(struct net_device *net)
-{
-	struct device *device = &(net->dev);
-	device_initialize(device);
-}
-
 int netdev_kobject_init(void)
 {
 	kobj_ns_type_register(&net_ns_type_operations);
diff --git a/net/core/net-sysfs.h b/net/core/net-sysfs.h
index 14e7524..805555e 100644
--- a/net/core/net-sysfs.h
+++ b/net/core/net-sysfs.h
@@ -4,5 +4,4 @@
 int netdev_kobject_init(void);
 int netdev_register_kobject(struct net_device *);
 void netdev_unregister_kobject(struct net_device *);
-void netdev_initialize_kobject(struct net_device *);
 #endif
-- 
1.7.0.3

