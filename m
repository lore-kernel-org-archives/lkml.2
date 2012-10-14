Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2JNOn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46672 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256Ab2JNOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:52 -0400
Message-Id: <20121014143540.513912147@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 049/147] [SCSI] zfcp: restore refcount check on port_remove
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit d99b601b63386f3395dc26a699ae703a273d9982 upstream.

Upstream commit f3450c7b917201bb49d67032e9f60d5125675d6a
"[SCSI] zfcp: Replace local reference counting with common kref"
accidentally dropped a reference count check before tearing down
zfcp_ports that are potentially in use by zfcp_units.
Even remote ports in use can be removed causing
unreachable garbage objects zfcp_ports with zfcp_units.
Thus units won't come back even after a manual port_rescan.
The kref of zfcp_port->dev.kobj is already used by the driver core.
We cannot re-use it to track the number of zfcp_units.
Re-introduce our own counter for units per port
and check on port_remove.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_aux.c   |    1 +
 drivers/s390/scsi/zfcp_def.h   |    1 +
 drivers/s390/scsi/zfcp_ext.h   |    1 +
 drivers/s390/scsi/zfcp_sysfs.c |   18 ++++++++++++++++--
 drivers/s390/scsi/zfcp_unit.c  |   36 ++++++++++++++++++++++++++----------
 5 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index aff8621..f6adde4 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -519,6 +519,7 @@ struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, u64 wwpn,
 
 	rwlock_init(&port->unit_list_lock);
 	INIT_LIST_HEAD(&port->unit_list);
+	atomic_set(&port->units, 0);
 
 	INIT_WORK(&port->gid_pn_work, zfcp_fc_port_did_lookup);
 	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 5bc4afba..1305955 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -205,6 +205,7 @@ struct zfcp_port {
 	struct zfcp_adapter    *adapter;       /* adapter used to access port */
 	struct list_head	unit_list;	/* head of logical unit list */
 	rwlock_t		unit_list_lock; /* unit list lock */
+	atomic_t		units;	       /* zfcp_unit count */
 	atomic_t	       status;	       /* status of this remote port */
 	u64		       wwnn;	       /* WWNN if known */
 	u64		       wwpn;	       /* WWPN */
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 4eeef78..03441a7f 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -159,6 +159,7 @@ extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
 extern struct attribute_group zfcp_sysfs_unit_attrs;
 extern struct attribute_group zfcp_sysfs_adapter_attrs;
 extern struct attribute_group zfcp_sysfs_port_attrs;
+extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
 
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index c66af27..1e0eb08 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -227,6 +227,8 @@ static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 static ZFCP_DEV_ATTR(adapter, port_rescan, S_IWUSR, NULL,
 		     zfcp_sysfs_port_rescan_store);
 
+DEFINE_MUTEX(zfcp_sysfs_port_units_mutex);
+
 static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
@@ -249,6 +251,16 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 	else
 		retval = 0;
 
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (atomic_read(&port->units) > 0) {
+		retval = -EBUSY;
+		mutex_unlock(&zfcp_sysfs_port_units_mutex);
+		goto out;
+	}
+	/* port is about to be removed, so no more unit_add */
+	atomic_set(&port->units, -1);
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
 	write_unlock_irq(&adapter->port_list_lock);
@@ -289,12 +301,14 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	u64 fcp_lun;
+	int retval;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
-	if (zfcp_unit_add(port, fcp_lun))
-		return -EINVAL;
+	retval = zfcp_unit_add(port, fcp_lun);
+	if (retval)
+		return retval;
 
 	return count;
 }
diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 3f2bff0..1cd2b99 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -104,7 +104,7 @@ static void zfcp_unit_release(struct device *dev)
 {
 	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
 
-	put_device(&unit->port->dev);
+	atomic_dec(&unit->port->units);
 	kfree(unit);
 }
 
@@ -119,16 +119,27 @@ static void zfcp_unit_release(struct device *dev)
 int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 {
 	struct zfcp_unit *unit;
+	int retval = 0;
+
+	mutex_lock(&zfcp_sysfs_port_units_mutex);
+	if (atomic_read(&port->units) == -1) {
+		/* port is already gone */
+		retval = -ENODEV;
+		goto out;
+	}
 
 	unit = zfcp_unit_find(port, fcp_lun);
 	if (unit) {
 		put_device(&unit->dev);
-		return -EEXIST;
+		retval = -EEXIST;
+		goto out;
 	}
 
 	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
-	if (!unit)
-		return -ENOMEM;
+	if (!unit) {
+		retval = -ENOMEM;
+		goto out;
+	}
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
@@ -139,28 +150,33 @@ int zfcp_unit_add(struct zfcp_port *port, u64 fcp_lun)
 	if (dev_set_name(&unit->dev, "0x%016llx",
 			 (unsigned long long) fcp_lun)) {
 		kfree(unit);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto out;
 	}
 
-	get_device(&port->dev);
-
 	if (device_register(&unit->dev)) {
 		put_device(&unit->dev);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto out;
 	}
 
 	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs)) {
 		device_unregister(&unit->dev);
-		return -EINVAL;
+		retval = -EINVAL;
+		goto out;
 	}
 
+	atomic_inc(&port->units); /* under zfcp_sysfs_port_units_mutex ! */
+
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
 
 	zfcp_unit_scsi_scan(unit);
 
-	return 0;
+out:
+	mutex_unlock(&zfcp_sysfs_port_units_mutex);
+	return retval;
 }
 
 /**


