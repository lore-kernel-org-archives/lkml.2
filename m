Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab0FBULL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:11:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2581 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531Ab0FBULI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:11:08 -0400
Subject: [PATCH] drivers/staging/batman-adv: Use (pr|netdev)_<level> macro
 helpers
From: Joe Perches <joe@perches.com>
To: Marek Lindner <lindner_marek@yahoo.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Andrew Lunn <andrew@lunn.ch>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
       b.a.t.m.a.n@lists.open-mesh.net
In-Reply-To: <1275498615.23599.12.camel@Joe-Laptop.home>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 13:11:06 -0700
Message-ID: <1275509466.23599.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested only

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Remove "batman-adv:" from format strings
Use pr_<level>
Use netdev_<level>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/batman-adv/aggregation.c       |    2 +
 drivers/staging/batman-adv/bat_sysfs.c         |   53 ++++++++++++-----------
 drivers/staging/batman-adv/bitarray.c          |    2 +
 drivers/staging/batman-adv/device.c            |   19 ++++----
 drivers/staging/batman-adv/hard-interface.c    |   31 +++++--------
 drivers/staging/batman-adv/main.c              |   17 +++----
 drivers/staging/batman-adv/main.h              |   18 ++++----
 drivers/staging/batman-adv/originator.c        |   17 +++----
 drivers/staging/batman-adv/routing.c           |   14 +++----
 drivers/staging/batman-adv/send.c              |   11 ++---
 drivers/staging/batman-adv/translation-table.c |    8 ++--
 drivers/staging/batman-adv/vis.c               |   11 +++--
 12 files changed, 98 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/batman-adv/aggregation.c b/drivers/staging/batman-adv/aggregation.c
index ce8b8a6..66ee09e 100644
--- a/drivers/staging/batman-adv/aggregation.c
+++ b/drivers/staging/batman-adv/aggregation.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "aggregation.h"
 #include "send.h"
diff --git a/drivers/staging/batman-adv/bat_sysfs.c b/drivers/staging/batman-adv/bat_sysfs.c
index e2c000b..5da7b92 100644
--- a/drivers/staging/batman-adv/bat_sysfs.c
+++ b/drivers/staging/batman-adv/bat_sysfs.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "bat_sysfs.h"
 #include "translation-table.h"
@@ -99,18 +101,19 @@ static ssize_t store_aggr_ogm(struct kobject *kobj, struct attribute *attr,
 		if (buff[count - 1] == '\n')
 			buff[count - 1] = '\0';
 
-		printk(KERN_INFO "batman-adv:Invalid parameter for 'aggregate OGM' setting on mesh %s received: %s\n",
-		       net_dev->name, buff);
+		netdev_info(net_dev,
+			    "Invalid parameter for 'aggregate OGM' setting on mesh received: %s\n",
+			    buff);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&bat_priv->aggregation_enabled) == aggr_tmp)
 		return count;
 
-	printk(KERN_INFO "batman-adv:Changing aggregation from: %s to: %s on mesh: %s\n",
-	       atomic_read(&bat_priv->aggregation_enabled) == 1 ?
-	       "enabled" : "disabled", aggr_tmp == 1 ? "enabled" : "disabled",
-	       net_dev->name);
+	netdev_info(net_dev, "Changing aggregation from: %s to: %s on mesh\n",
+		    atomic_read(&bat_priv->aggregation_enabled) == 1 ?
+		    "enabled" : "disabled",
+		    aggr_tmp == 1 ? "enabled" : "disabled");
 
 	atomic_set(&bat_priv->aggregation_enabled, (unsigned)aggr_tmp);
 	return count;
@@ -152,18 +155,18 @@ static ssize_t store_vis_mode(struct kobject *kobj, struct attribute *attr,
 		if (buff[count - 1] == '\n')
 			buff[count - 1] = '\0';
 
-		printk(KERN_INFO "batman-adv:Invalid parameter for 'vis mode' setting on mesh %s received: %s\n",
-		       net_dev->name, buff);
+		netdev_info(net_dev, "Invalid parameter for 'vis mode' setting on mesh received: %s\n",
+			    buff);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&bat_priv->vis_mode) == vis_mode_tmp)
 		return count;
 
-	printk(KERN_INFO "batman-adv:Changing vis mode from: %s to: %s on mesh: %s\n",
-	       atomic_read(&bat_priv->vis_mode) == VIS_TYPE_CLIENT_UPDATE ?
-	       "client" : "server", vis_mode_tmp == VIS_TYPE_CLIENT_UPDATE ?
-	       "client" : "server", net_dev->name);
+	netdev_info(net_dev, "Changing vis mode from: %s to: %s on mesh\n",
+		    atomic_read(&bat_priv->vis_mode) == VIS_TYPE_CLIENT_UPDATE ?
+		    "client" : "server",
+		    vis_mode_tmp == VIS_TYPE_CLIENT_UPDATE ? "client" : "server");
 
 	atomic_set(&bat_priv->vis_mode, (unsigned)vis_mode_tmp);
 	return count;
@@ -190,23 +193,23 @@ static ssize_t store_orig_interval(struct kobject *kobj, struct attribute *attr,
 
 	ret = strict_strtoul(buff, 10, &orig_interval_tmp);
 	if (ret) {
-		printk(KERN_INFO "batman-adv:Invalid parameter for 'orig_interval' setting on mesh %s received: %s\n",
-		       net_dev->name, buff);
+		netdev_info(net_dev, "Invalid parameter for 'orig_interval' setting on mesh received: %s\n",
+			    buff);
 		return -EINVAL;
 	}
 
 	if (orig_interval_tmp <= JITTER * 2) {
-		printk(KERN_INFO "batman-adv:New originator interval too small: %li (min: %i)\n",
-		       orig_interval_tmp, JITTER * 2);
+		netdev_info(net_dev, "New originator interval too small: %li (min: %i)\n",
+			    orig_interval_tmp, JITTER * 2);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&bat_priv->orig_interval) == orig_interval_tmp)
 		return count;
 
-	printk(KERN_INFO "batman-adv:Changing originator interval from: %i to: %li on mesh: %s\n",
-	       atomic_read(&bat_priv->orig_interval),
-	       orig_interval_tmp, net_dev->name);
+	netdev_info(net_dev, "Changing originator interval from: %i to: %li on mesh\n",
+		    atomic_read(&bat_priv->orig_interval),
+		    orig_interval_tmp);
 
 	atomic_set(&bat_priv->orig_interval, orig_interval_tmp);
 	return count;
@@ -297,7 +300,7 @@ int sysfs_add_meshif(struct net_device *dev)
 	bat_priv->mesh_obj = kobject_create_and_add(SYSFS_IF_MESH_SUBDIR,
 						    batif_kobject);
 	if (!bat_priv->mesh_obj) {
-		printk(KERN_ERR "batman-adv:Can't add sysfs directory: %s/%s\n",
+		pr_err("Can't add sysfs directory: %s/%s\n",
 		       dev->name, SYSFS_IF_MESH_SUBDIR);
 		goto out;
 	}
@@ -306,7 +309,7 @@ int sysfs_add_meshif(struct net_device *dev)
 		err = sysfs_create_file(bat_priv->mesh_obj,
 					&((*bat_attr)->attr));
 		if (err) {
-			printk(KERN_ERR "batman-adv:Can't add sysfs file: %s/%s/%s\n",
+			pr_err("Can't add sysfs file: %s/%s/%s\n",
 			       dev->name, SYSFS_IF_MESH_SUBDIR,
 			       ((*bat_attr)->attr).name);
 			goto rem_attr;
@@ -316,7 +319,7 @@ int sysfs_add_meshif(struct net_device *dev)
 	for (bin_attr = mesh_bin_attrs; *bin_attr; ++bin_attr) {
 		err = sysfs_create_bin_file(bat_priv->mesh_obj, (*bin_attr));
 		if (err) {
-			printk(KERN_ERR "batman-adv:Can't add sysfs file: %s/%s/%s\n",
+			pr_err("Can't add sysfs file: %s/%s/%s\n",
 			       dev->name, SYSFS_IF_MESH_SUBDIR,
 			       ((*bin_attr)->attr).name);
 			goto rem_bin_attr;
@@ -390,7 +393,7 @@ static ssize_t store_mesh_iface(struct kobject *kobj, struct attribute *attr,
 		if (buff[count - 1] == '\n')
 			buff[count - 1] = '\0';
 
-		printk(KERN_ERR "batman-adv:Invalid parameter for 'mesh_iface' setting received: %s\n",
+		pr_err("Invalid parameter for 'mesh_iface' setting received: %s\n",
 		       buff);
 		return -EINVAL;
 	}
@@ -453,7 +456,7 @@ int sysfs_add_hardif(struct kobject **hardif_obj, struct net_device *dev)
 						    hardif_kobject);
 
 	if (!*hardif_obj) {
-		printk(KERN_ERR "batman-adv:Can't add sysfs directory: %s/%s\n",
+		pr_err("Can't add sysfs directory: %s/%s\n",
 		       dev->name, SYSFS_IF_BAT_SUBDIR);
 		goto out;
 	}
@@ -461,7 +464,7 @@ int sysfs_add_hardif(struct kobject **hardif_obj, struct net_device *dev)
 	for (hardif_attr = batman_attrs; *hardif_attr; ++hardif_attr) {
 		err = sysfs_create_file(*hardif_obj, &((*hardif_attr)->attr));
 		if (err) {
-			printk(KERN_ERR "batman-adv:Can't add sysfs file: %s/%s/%s\n",
+			pr_err("Can't add sysfs file: %s/%s/%s\n",
 			       dev->name, SYSFS_IF_BAT_SUBDIR,
 			       ((*hardif_attr)->attr).name);
 			goto rem_attr;
diff --git a/drivers/staging/batman-adv/bitarray.c b/drivers/staging/batman-adv/bitarray.c
index 2fef6e3..d493625 100644
--- a/drivers/staging/batman-adv/bitarray.c
+++ b/drivers/staging/batman-adv/bitarray.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "bitarray.h"
 
diff --git a/drivers/staging/batman-adv/device.c b/drivers/staging/batman-adv/device.c
index 7eb6559..d4c4e7d 100644
--- a/drivers/staging/batman-adv/device.c
+++ b/drivers/staging/batman-adv/device.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/slab.h>
 #include "main.h"
@@ -57,17 +59,15 @@ int bat_device_setup(void)
 	/* register our device - kernel assigns a free major number */
 	tmp_major = register_chrdev(0, DRIVER_DEVICE, &fops);
 	if (tmp_major < 0) {
-		printk(KERN_ERR "batman-adv:"
-		       "Registering the character device failed with %d\n",
-			  tmp_major);
+		pr_err("Registering the character device failed with %d\n",
+		       tmp_major);
 		return 0;
 	}
 
 	batman_class = class_create(THIS_MODULE, "batman-adv");
 
 	if (IS_ERR(batman_class)) {
-		printk(KERN_ERR "batman-adv:"
-		       "Could not register class 'batman-adv'\n");
+		pr_err("Could not register class 'batman-adv'\n");
 		return 0;
 	}
 
@@ -110,8 +110,7 @@ int bat_device_open(struct inode *inode, struct file *file)
 	}
 
 	if (i == ARRAY_SIZE(device_client_hash)) {
-		printk(KERN_ERR "batman-adv:"
-		       "Error - can't add another packet client: "
+		pr_err("Error - can't add another packet client: "
 		       "maximum number of clients reached\n");
 		kfree(device_client);
 		return -EXFULL;
@@ -213,7 +212,7 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 	unsigned long flags;
 
 	if (len < sizeof(struct icmp_packet)) {
-		bat_dbg(DBG_BATMAN, "batman-adv:"
+		bat_dbg(DBG_BATMAN,
 			"Error - can't send packet from char device: "
 			"invalid packet size\n");
 		return -EINVAL;
@@ -226,14 +225,14 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 		return -EFAULT;
 
 	if (icmp_packet.packet_type != BAT_ICMP) {
-		bat_dbg(DBG_BATMAN, "batman-adv:"
+		bat_dbg(DBG_BATMAN,
 			"Error - can't send packet from char device: "
 			"got bogus packet type (expected: BAT_ICMP)\n");
 		return -EINVAL;
 	}
 
 	if (icmp_packet.msg_type != ECHO_REQUEST) {
-		bat_dbg(DBG_BATMAN, "batman-adv:"
+		bat_dbg(DBG_BATMAN,
 			"Error - can't send packet from char device: "
 			"got bogus message type (expected: ECHO_REQUEST)\n");
 		return -EINVAL;
diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index 7a582e8..1c6cdd7 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "hard-interface.h"
 #include "soft-interface.h"
@@ -149,12 +151,9 @@ static void check_known_mac_addr(uint8_t *addr)
 		if (!compare_orig(batman_if->net_dev->dev_addr, addr))
 			continue;
 
-		printk(KERN_WARNING "batman-adv:"
-		    "The newly added mac address (%pM) already exists on: %s\n",
-		    addr, batman_if->dev);
-		printk(KERN_WARNING "batman-adv:"
-		    "It is strongly recommended to keep mac addresses unique"
-		    "to avoid problems!\n");
+		pr_warning("The newly added mac address (%pM) already exists on: %s\n",
+			   addr, batman_if->dev);
+		pr_warning("It is strongly recommended to keep mac addresses unique to avoid problems!\n");
 	}
 	rcu_read_unlock();
 }
@@ -206,8 +205,7 @@ static void hardif_activate_interface(struct bat_priv *bat_priv,
 	if (!bat_priv->primary_if)
 		set_primary_if(bat_priv, batman_if);
 
-	printk(KERN_INFO "batman-adv:Interface activated: %s\n",
-	       batman_if->dev);
+	pr_info("Interface activated: %s\n", batman_if->dev);
 
 	if (atomic_read(&module_state) == MODULE_INACTIVE)
 		activate_module();
@@ -226,8 +224,7 @@ static void hardif_deactivate_interface(struct batman_if *batman_if)
 
 	batman_if->if_status = IF_INACTIVE;
 
-	printk(KERN_INFO "batman-adv:Interface deactivated: %s\n",
-	       batman_if->dev);
+	pr_info("Interface deactivated: %s\n", batman_if->dev);
 
 	update_min_mtu();
 }
@@ -245,8 +242,7 @@ int hardif_enable_interface(struct batman_if *batman_if)
 	batman_if->packet_buff = kmalloc(batman_if->packet_len, GFP_ATOMIC);
 
 	if (!batman_if->packet_buff) {
-		printk(KERN_ERR "batman-adv:"
-		       "Can't add interface packet (%s): out of memory\n",
+		pr_err("Can't add interface packet (%s): out of memory\n",
 		       batman_if->dev);
 		goto err;
 	}
@@ -265,14 +261,12 @@ int hardif_enable_interface(struct batman_if *batman_if)
 	orig_hash_add_if(batman_if, bat_priv->num_ifaces);
 
 	atomic_set(&batman_if->seqno, 1);
-	printk(KERN_INFO "batman-adv:Adding interface: %s\n", batman_if->dev);
+	pr_info("Adding interface: %s\n", batman_if->dev);
 
 	if (hardif_is_iface_up(batman_if))
 		hardif_activate_interface(bat_priv, batman_if);
 	else
-		printk(KERN_ERR "batman-adv:"
-		       "Not using interface %s "
-		       "(retrying later): interface not active\n",
+		pr_err("Not using interface %s (retrying later): interface not active\n",
 		       batman_if->dev);
 
 	/* begin scheduling originator messages on that interface */
@@ -296,7 +290,7 @@ void hardif_disable_interface(struct batman_if *batman_if)
 	if (batman_if->if_status != IF_INACTIVE)
 		return;
 
-	printk(KERN_INFO "batman-adv:Removing interface: %s\n", batman_if->dev);
+	pr_info("Removing interface: %s\n", batman_if->dev);
 	bat_priv->num_ifaces--;
 	orig_hash_del_if(batman_if, bat_priv->num_ifaces);
 
@@ -323,8 +317,7 @@ static struct batman_if *hardif_add_interface(struct net_device *net_dev)
 
 	batman_if = kmalloc(sizeof(struct batman_if), GFP_ATOMIC);
 	if (!batman_if) {
-		printk(KERN_ERR "batman-adv:"
-		       "Can't add interface (%s): out of memory\n",
+		pr_err("Can't add interface (%s): out of memory\n",
 		       net_dev->name);
 		goto out;
 	}
diff --git a/drivers/staging/batman-adv/main.c b/drivers/staging/batman-adv/main.c
index 72851cd..46682c0 100644
--- a/drivers/staging/batman-adv/main.c
+++ b/drivers/staging/batman-adv/main.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "bat_sysfs.h"
 #include "routing.h"
@@ -99,16 +101,14 @@ int init_module(void)
 				   interface_setup);
 
 	if (!soft_device) {
-		printk(KERN_ERR "batman-adv:"
-		       "Unable to allocate the batman interface\n");
+		pr_err("Unable to allocate the batman interface\n");
 		goto end;
 	}
 
 	retval = register_netdev(soft_device);
 
 	if (retval < 0) {
-		printk(KERN_ERR "batman-adv:"
-		       "Unable to register the batman interface: %i\n", retval);
+		pr_err("Unable to register the batman interface: %i\n", retval);
 		goto free_soft_device;
 	}
 
@@ -120,9 +120,8 @@ int init_module(void)
 	register_netdevice_notifier(&hard_if_notifier);
 	dev_add_pack(&batman_adv_packet_type);
 
-	printk(KERN_INFO "batman-adv:"
-	       "B.A.T.M.A.N. advanced %s%s (compatibility version %i) loaded\n",
-	       SOURCE_VERSION, REVISION_VERSION_STR, COMPAT_VERSION);
+	pr_info("B.A.T.M.A.N. advanced %s%s (compatibility version %i) loaded\n",
+		SOURCE_VERSION, REVISION_VERSION_STR, COMPAT_VERSION);
 
 	return 0;
 
@@ -182,9 +181,7 @@ void activate_module(void)
 	goto end;
 
 err:
-	printk(KERN_ERR "batman-adv:"
-	       "Unable to allocate memory for mesh information structures: "
-	       "out of mem ?\n");
+	pr_err("Unable to allocate memory for mesh information structures: out of mem ?\n");
 	deactivate_module();
 end:
 	return;
diff --git a/drivers/staging/batman-adv/main.h b/drivers/staging/batman-adv/main.h
index 5f8343d..afc322d 100644
--- a/drivers/staging/batman-adv/main.h
+++ b/drivers/staging/batman-adv/main.h
@@ -85,15 +85,17 @@
 extern int debug;
 
 extern int bat_debug_type(int type);
-#define bat_dbg(type, fmt, arg...) do {					\
-		if (bat_debug_type(type))				\
-			printk(KERN_DEBUG "batman-adv:" fmt, ## arg);	\
-	}								\
-	while (0)
+#define bat_dbg(type, fmt, arg...)				\
+do {								\
+	if (bat_debug_type(type))				\
+		printk(KERN_DEBUG pr_fmt(fmt), ##arg);		\
+} while (0)
 #else /* !CONFIG_BATMAN_ADV_DEBUG */
-#define bat_dbg(type, fmt, arg...) do {		\
-	}					\
-	while (0)
+#define bat_dbg(type, fmt, arg...)				\
+do {								\
+	if (0)							\
+		printk(KERN_DEBUG pr_fmt(fmt), ##arg);		\
+} while (0)
 #endif
 
 /*
diff --git a/drivers/staging/batman-adv/originator.c b/drivers/staging/batman-adv/originator.c
index 568aef8..1a61887 100644
--- a/drivers/staging/batman-adv/originator.c
+++ b/drivers/staging/batman-adv/originator.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* increase the reference counter for this originator */
 
 #include "main.h"
@@ -163,8 +165,7 @@ struct orig_node *get_orig_node(uint8_t *addr)
 		swaphash = hash_resize(orig_hash, orig_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR
-			       "batman-adv:Couldn't resize orig hash table\n");
+			pr_err("Couldn't resize orig hash table\n");
 		else
 			orig_hash = swaphash;
 	}
@@ -373,8 +374,7 @@ static int orig_node_add_if(struct orig_node *orig_node, int max_if_num)
 	data_ptr = kmalloc(max_if_num * sizeof(TYPE_OF_WORD) * NUM_WORDS,
 			   GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR
-		       "batman-adv:Can't resize orig: out of memory\n");
+		pr_err("Can't resize orig: out of memory\n");
 		return -1;
 	}
 
@@ -385,8 +385,7 @@ static int orig_node_add_if(struct orig_node *orig_node, int max_if_num)
 
 	data_ptr = kmalloc(max_if_num * sizeof(uint8_t), GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR
-		       "batman-adv:Can't resize orig: out of memory\n");
+		pr_err("Can't resize orig: out of memory\n");
 		return -1;
 	}
 
@@ -435,8 +434,7 @@ static int orig_node_del_if(struct orig_node *orig_node,
 	chunk_size = sizeof(TYPE_OF_WORD) * NUM_WORDS;
 	data_ptr = kmalloc(max_if_num * chunk_size, GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR
-		       "batman-adv:Can't resize orig: out of memory\n");
+		pr_err("Can't resize orig: out of memory\n");
 		return -1;
 	}
 
@@ -457,8 +455,7 @@ free_bcast_own:
 
 	data_ptr = kmalloc(max_if_num * sizeof(uint8_t), GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR
-		       "batman-adv:Can't resize orig: out of memory\n");
+		pr_err("Can't resize orig: out of memory\n");
 		return -1;
 	}
 
diff --git a/drivers/staging/batman-adv/routing.c b/drivers/staging/batman-adv/routing.c
index 066dc8b..b04ddcb 100644
--- a/drivers/staging/batman-adv/routing.c
+++ b/drivers/staging/batman-adv/routing.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "routing.h"
 #include "send.h"
@@ -731,10 +733,8 @@ static int recv_icmp_ttl_exceeded(struct sk_buff *skb)
 
 	/* send TTL exceeded if packet is an echo request (traceroute) */
 	if (icmp_packet->msg_type != ECHO_REQUEST) {
-		printk(KERN_WARNING "batman-adv:"
-		       "Warning - can't forward icmp packet from %pM to %pM: "
-		       "ttl exceeded\n",
-		       icmp_packet->orig, icmp_packet->dst);
+		pr_warning("Warning - can't forward icmp packet from %pM to %pM: ttl exceeded\n",
+			   icmp_packet->orig, icmp_packet->dst);
 		return NET_RX_DROP;
 	}
 
@@ -899,10 +899,8 @@ int recv_unicast_packet(struct sk_buff *skb)
 
 	/* TTL exceeded */
 	if (unicast_packet->ttl < 2) {
-		printk(KERN_WARNING "batman-adv:Warning - "
-		       "can't forward unicast packet from %pM to %pM: "
-		       "ttl exceeded\n",
-		       ethhdr->h_source, unicast_packet->dest);
+		pr_warning("Warning - can't forward unicast packet from %pM to %pM: ttl exceeded\n",
+			   ethhdr->h_source, unicast_packet->dest);
 		return NET_RX_DROP;
 	}
 
diff --git a/drivers/staging/batman-adv/send.c b/drivers/staging/batman-adv/send.c
index ac69ed8..f5d6b69 100644
--- a/drivers/staging/batman-adv/send.c
+++ b/drivers/staging/batman-adv/send.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "send.h"
 #include "routing.h"
@@ -64,10 +66,8 @@ int send_skb_packet(struct sk_buff *skb,
 		goto send_skb_err;
 
 	if (!(batman_if->net_dev->flags & IFF_UP)) {
-		printk(KERN_WARNING
-		       "batman-adv:Interface %s "
-		       "is not up - can't send packet via that interface!\n",
-		       batman_if->dev);
+		pr_warning("Interface %s is not up - can't send packet via that interface!\n",
+			   batman_if->dev);
 		goto send_skb_err;
 	}
 
@@ -179,8 +179,7 @@ static void send_packet(struct forw_packet *forw_packet)
 	unsigned char directlink = (batman_packet->flags & DIRECTLINK ? 1 : 0);
 
 	if (!forw_packet->if_incoming) {
-		printk(KERN_ERR "batman-adv: Error - can't forward packet: "
-		       "incoming iface not specified\n");
+		pr_err("Error - can't forward packet: incoming iface not specified\n");
 		return;
 	}
 
diff --git a/drivers/staging/batman-adv/translation-table.c b/drivers/staging/batman-adv/translation-table.c
index 63d0967..a41bedd 100644
--- a/drivers/staging/batman-adv/translation-table.c
+++ b/drivers/staging/batman-adv/translation-table.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "translation-table.h"
 #include "soft-interface.h"
@@ -111,8 +113,7 @@ void hna_local_add(uint8_t *addr)
 				       hna_local_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:"
-			       "Couldn't resize local hna hash table\n");
+			pr_err("Couldn't resize local hna hash table\n");
 		else
 			hna_local_hash = swaphash;
 	}
@@ -364,8 +365,7 @@ void hna_global_add_orig(struct orig_node *orig_node,
 				       hna_global_hash->size * 2);
 
 		if (swaphash == NULL)
-			printk(KERN_ERR "batman-adv:"
-			       "Couldn't resize global hna hash table\n");
+			pr_err("Couldn't resize global hna hash table\n");
 		else
 			hna_global_hash = swaphash;
 	}
diff --git a/drivers/staging/batman-adv/vis.c b/drivers/staging/batman-adv/vis.c
index 1d3d954..380e996 100644
--- a/drivers/staging/batman-adv/vis.c
+++ b/drivers/staging/batman-adv/vis.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "main.h"
 #include "send.h"
 #include "translation-table.h"
@@ -628,7 +630,7 @@ static void send_vis_packet(struct vis_info *info)
 	int packet_length;
 
 	if (info->packet.ttl < 2) {
-		printk(KERN_WARNING "batman-adv: Error - can't send vis packet: ttl exceeded\n");
+		pr_warning("Error - can't send vis packet: ttl exceeded\n");
 		return;
 	}
 
@@ -690,13 +692,13 @@ int vis_init(void)
 
 	vis_hash = hash_new(256, vis_info_cmp, vis_info_choose);
 	if (!vis_hash) {
-		printk(KERN_ERR "batman-adv:Can't initialize vis_hash\n");
+		pr_err("Can't initialize vis_hash\n");
 		goto err;
 	}
 
 	my_vis_info = kmalloc(1000, GFP_ATOMIC);
 	if (!my_vis_info) {
-		printk(KERN_ERR "batman-adv:Can't initialize vis packet\n");
+		pr_err("Can't initialize vis packet\n");
 		goto err;
 	}
 
@@ -717,8 +719,7 @@ int vis_init(void)
 	memcpy(my_vis_info->packet.sender_orig, mainIfAddr, ETH_ALEN);
 
 	if (hash_add(vis_hash, my_vis_info) < 0) {
-		printk(KERN_ERR
-		       "batman-adv:Can't add own vis packet into hash\n");
+		pr_err("Can't add own vis packet into hash\n");
 		/* not in hash, need to remove it manually. */
 		kref_put(&my_vis_info->refcount, free_info);
 		goto err;



