Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0KVXdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:33:42 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:60426 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0KVXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:33:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=subject
	:from:to:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=drama; b=BbTgP
	fBcsEYq3wWKU+IZyut3XkSVbiomJGL5B10fpx/Kt+boQrmbrOJYnHT3o1TrLQwIz
	9AIUDpltdepqD6TgxNBAGXK6jyaMgKzgh4acxVAKOIbJNr+9/nIPZhIU+okEjC93
	ORtf65ihW5tGMI+V0ENzM+IQQObkWRfkT2wYpM=
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: Greg KH <greg@kroah.com>
Cc: sage@newdream.net, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101119020820.GB18767@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
	 <20101117171924.GC12050@kroah.com>
	 <AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
	 <20101118013002.GC8558@kroah.com>
	 <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
	 <20101119020820.GB18767@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 15:33:07 -0800
Message-ID: <1290468787.1792.63.camel@yehudasa-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 19, 2010 at 12:42 PM, Yehuda Sadeh Weinraub <yehuda@hq.newdream.net> wrote:
> One solution would be to create kobjects for (3) and for (4), without
> using a group name. Another way, we can create groups for (2), and (3)
> under (1), but that's about it, you can't create the snap specific
> directory this way without resorting to some internal sysfs directory
> creation, which will be horribly wrong. At that point we don't have
> anything for 'snaps', and we don't really need to do any operations
> under that directory, we just need it to exist so that it contains the
> snapshot-specific directories.
>
> Another way would be to create a group for (2) under (1) and create a
> kobject for (3), for which you can create group per snapshot.
>
> Am I missing something? We already have the first solution (kobjects
> only) implemented, is there some real benefit for using the third
> method? We'll have to manually add remove groups anyway, as snapshots
> can be removed and new snapshots can be added.
>

And following is the implementation for the first solution. It has a device
for the rbd_dev, a kobject for the top snapshot directory and a kobject per
snapshot. Please let me know if there's any issue with this implementation.
We'd like to get this fixed for 2.6.37 and considering the large patch,
it'd be nice getting an ack for it.

Thanks,
Yehuda


Yehuda Sadeh (1):
  rbd: replace the rbd sysfs interface

 Documentation/ABI/testing/sysfs-bus-rbd |   84 ++++
 drivers/block/rbd.c                     |  804 ++++++++++++++++++++-----------
 2 files changed, 611 insertions(+), 277 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rbd
--

From: Yehuda Sadeh <yehuda@hq.newdream.net>
Date: Fri, 19 Nov 2010 14:51:04 -0800
Subject: [PATCH 1/1] rbd: replace the rbd sysfs interface

The new interface creates directories per mapped image
and under each it creates a subdir per available snapshot.
This allows keeping a cleaner interface within the sysfs
guidelines. The ABI documentation was updated too.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 Documentation/ABI/testing/sysfs-bus-rbd |   84 ++++
 drivers/block/rbd.c                     |  804 ++++++++++++++++++++-----------
 2 files changed, 611 insertions(+), 277 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-rbd b/Documentation/ABI/testing/sysfs-bus-rbd
new file mode 100644
index 0000000..0cadb84
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-rbd
@@ -0,0 +1,84 @@
+What:		/sys/bus/rbd/
+Date:		November 2010
+Contact:	Yehuda Sadeh <yehuda@hq.newdream.net>,
+		Sage Weil <sage@newdream.net>
+Description:
+
+Being used for adding and removing rbd block devices.
+
+Usage: <mon ip addr> <options> <pool name> <rbd image name> [snap name]
+
+ $ echo "192.168.0.1 name=admin rbd foo" > /sys/bus/rbd/add
+
+The snapshot name can be "-" or omitted to map the image read/write. A <dev-id>
+will be assigned for any registered block device. If snapshot is used, it will
+be mapped read-only.
+
+Removal of a device:
+
+  $ echo <dev-id> > /sys/bus/rbd/remove
+
+Entries under /sys/bus/rbd/devices/<dev-id>/
+--------------------------------------------
+
+client_id
+
+	The ceph unique client id that was assigned for this specific session.
+
+major
+
+	The block device major number.
+
+name
+
+	The name of the rbd image.
+
+pool
+
+	The pool where this rbd image resides. The pool-name pair is unique
+	per rados system.
+
+size
+
+	The size (in bytes) of the mapped block device.
+
+refresh
+
+	Writing to this file will reread the image header data and set
+	all relevant datastructures accordingly.
+
+snap_current
+
+	The current snapshot for which the device is mapped.
+
+snap_create
+
+	Create a snapshot:
+
+	 $ echo <snap-name> > /sys/bus/rbd/devices/<dev-id>/snap_create
+
+snap_rollback
+
+	Rolls back data to the specified snapshot. This goes over the entire
+	list of rados blocks and sends a rollback command to each.
+
+	 $ echo <snap-name> > /sys/bus/rbd/devices/<dev-id>/snap_rollback
+
+snaps/
+
+	The snaps directory will hold a directory per snapshot that exists
+        for this rbd image.
+
+
+Entries under /sys/bus/rbd/devices/<dev-id>/snaps/<snap-name>
+-------------------------------------------------------------
+
+id
+
+	The rados internal snapshot id assigned for this snapshot
+
+size
+
+	The size of the image when this snapshot was taken.
+
+
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6ec9d53..9ac0368 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -21,80 +21,9 @@
 
 
 
-   Instructions for use
-   --------------------
+   For usage instructions, please refer to:
 
-   1) Map a Linux block device to an existing rbd image.
-
-      Usage: <mon ip addr> <options> <pool name> <rbd image name> [snap name]
-
-      $ echo "192.168.0.1 name=admin rbd foo" > /sys/class/rbd/add
-
-      The snapshot name can be "-" or omitted to map the image read/write.
-
-   2) List all active blkdev<->object mappings.
-
-      In this example, we have performed step #1 twice, creating two blkdevs,
-      mapped to two separate rados objects in the rados rbd pool
-
-      $ cat /sys/class/rbd/list
-      #id     major   client_name     pool    name    snap    KB
-      0       254     client4143      rbd     foo     -      1024000
-
-      The columns, in order, are:
-      - blkdev unique id
-      - blkdev assigned major
-      - rados client id
-      - rados pool name
-      - rados block device name
-      - mapped snapshot ("-" if none)
-      - device size in KB
-
-
-   3) Create a snapshot.
-
-      Usage: <blkdev id> <snapname>
-
-      $ echo "0 mysnap" > /sys/class/rbd/snap_create
-
-
-   4) Listing a snapshot.
-
-      $ cat /sys/class/rbd/snaps_list
-      #id     snap    KB
-      0       -       1024000 (*)
-      0       foo     1024000
-
-      The columns, in order, are:
-      - blkdev unique id
-      - snapshot name, '-' means none (active read/write version)
-      - size of device at time of snapshot
-      - the (*) indicates this is the active version
-
-   5) Rollback to snapshot.
-
-      Usage: <blkdev id> <snapname>
-
-      $ echo "0 mysnap" > /sys/class/rbd/snap_rollback
-
-
-   6) Mapping an image using snapshot.
-
-      A snapshot mapping is read-only. This is being done by passing
-      snap=<snapname> to the options when adding a device.
-
-      $ echo "192.168.0.1 name=admin,snap=mysnap rbd foo" > /sys/class/rbd/add
-
-
-   7) Remove an active blkdev<->rbd image mapping.
-
-      In this example, we remove the mapping with blkdev unique id 1.
-
-      $ echo 1 > /sys/class/rbd/remove
-
-
-   NOTE:  The actual creation and deletion of rados objects is outside the scope
-   of this driver.
+                 Documentation/ABI/testing/sysfs-bus-rbd
 
  */
 
@@ -163,6 +92,18 @@ struct rbd_request {
 	u64			len;
 };
 
+struct rbd_snaps {
+	struct kobject		kobj;
+};
+
+struct rbd_snap {
+	struct kobject		kobj;
+	const char		*name;
+	size_t			size;
+	struct list_head	node;
+	u64			id;
+};
+
 /*
  * a single device
  */
@@ -193,21 +134,55 @@ struct rbd_device {
 	int read_only;
 
 	struct list_head	node;
+
+	/* list of snapshots */
+	struct list_head	snaps;
+
+	/* sysfs related */
+	struct device		dev;
+	struct rbd_snaps	*snaps_kobj;
 };
 
+
 static spinlock_t node_lock;      /* protects client get/put */
 
-static struct class *class_rbd;	  /* /sys/class/rbd */
 static DEFINE_MUTEX(ctl_mutex);	  /* Serialize open/close/setup/teardown */
 static LIST_HEAD(rbd_dev_list);    /* devices */
 static LIST_HEAD(rbd_client_list);      /* clients */
 
+static int __rbd_init_snaps_header(struct rbd_device *rbd_dev);
+static void rbd_dev_release(struct device *dev);
+static ssize_t rbd_snap_rollback(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t size);
+static ssize_t rbd_snap_add(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf,
+			    size_t count);
+
+static struct rbd_device *dev_to_rbd(struct device *dev)
+{
+	return container_of(dev, struct rbd_device, dev);
+}
+
+static struct device *rbd_get_dev(struct rbd_device *rbd_dev)
+{
+	return get_device(&rbd_dev->dev);
+}
+
+static void rbd_put_dev(struct rbd_device *rbd_dev)
+{
+	put_device(&rbd_dev->dev);
+}
 
 static int rbd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct rbd_device *rbd_dev = disk->private_data;
 
+	rbd_get_dev(rbd_dev);
+
 	set_device_ro(bdev, rbd_dev->read_only);
 
 	if ((mode & FMODE_WRITE) && rbd_dev->read_only)
@@ -216,9 +191,19 @@ static int rbd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int rbd_release(struct gendisk *disk, fmode_t mode)
+{
+	struct rbd_device *rbd_dev = disk->private_data;
+
+	rbd_put_dev(rbd_dev);
+
+	return 0;
+}
+
 static const struct block_device_operations rbd_bd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= rbd_open,
+	.release		= rbd_release,
 };
 
 /*
@@ -361,7 +346,6 @@ static int rbd_header_from_disk(struct rbd_image_header *header,
 	int ret = -ENOMEM;
 
 	init_rwsem(&header->snap_rwsem);
-
 	header->snap_names_len = le64_to_cpu(ondisk->snap_names_len);
 	header->snapc = kmalloc(sizeof(struct ceph_snap_context) +
 				snap_count *
@@ -1256,10 +1240,29 @@ bad:
 	return -ERANGE;
 }
 
+static void __rbd_remove_snaps_kobj(struct rbd_device *rbd_dev)
+{
+	struct rbd_snap *snap;
+
+	while (!list_empty(&rbd_dev->snaps)) {
+		snap = list_first_entry(&rbd_dev->snaps, struct rbd_snap, node);
+		list_del_init(&snap->node);
+		kobject_put(&snap->kobj);
+	}
+}
+
+static void rbd_snap_release(struct kobject *kobj)
+{
+	struct rbd_snap *snap = container_of(kobj, struct rbd_snap, kobj);
+
+	kfree(snap->name);
+	kfree(snap);
+}
+
 /*
  * only read the first part of the ondisk header, without the snaps info
  */
-static int rbd_update_snaps(struct rbd_device *rbd_dev)
+static int __rbd_update_snaps(struct rbd_device *rbd_dev)
 {
 	int ret;
 	struct rbd_image_header h;
@@ -1280,12 +1283,15 @@ static int rbd_update_snaps(struct rbd_device *rbd_dev)
 	rbd_dev->header.total_snaps = h.total_snaps;
 	rbd_dev->header.snapc = h.snapc;
 	rbd_dev->header.snap_names = h.snap_names;
+	rbd_dev->header.snap_names_len = h.snap_names_len;
 	rbd_dev->header.snap_sizes = h.snap_sizes;
 	rbd_dev->header.snapc->seq = snap_seq;
 
+	ret = __rbd_init_snaps_header(rbd_dev);
+
 	up_write(&rbd_dev->header.snap_rwsem);
 
-	return 0;
+	return ret;
 }
 
 static int rbd_init_disk(struct rbd_device *rbd_dev)
@@ -1300,6 +1306,11 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	if (rc)
 		return rc;
 
+	/* no need to lock here, as rbd_dev is not registered yet */
+	rc = __rbd_init_snaps_header(rbd_dev);
+	if (rc)
+		return rc;
+
 	rc = rbd_header_set_snap(rbd_dev, rbd_dev->snap_name, &total_size);
 	if (rc)
 		return rc;
@@ -1343,54 +1354,408 @@ out:
 	return rc;
 }
 
-/********************************************************************
- * /sys/class/rbd/
- *                   add	map rados objects to blkdev
- *                   remove	unmap rados objects
- *                   list	show mappings
- *******************************************************************/
+/*
+  sysfs
+*/
+
+static ssize_t rbd_size_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "%llu\n", (unsigned long long)rbd_dev->header.image_size);
+}
+
+static ssize_t rbd_major_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "%d\n", rbd_dev->major);
+}
 
-static void class_rbd_release(struct class *cls)
+static ssize_t rbd_client_id_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
-	kfree(cls);
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "client%lld\n", ceph_client_id(rbd_dev->client));
 }
 
-static ssize_t class_rbd_list(struct class *c,
-			      struct class_attribute *attr,
-			      char *data)
+static ssize_t rbd_pool_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
-	int n = 0;
-	struct list_head *tmp;
-	int max = PAGE_SIZE;
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "%s\n", rbd_dev->pool_name);
+}
+
+static ssize_t rbd_name_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "%s\n", rbd_dev->obj);
+}
+
+static ssize_t rbd_snap_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "%s\n", rbd_dev->snap_name);
+}
+
+static ssize_t rbd_image_refresh(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t size)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+	int rc;
+	int ret = size;
 
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
-	n += snprintf(data, max,
-		      "#id\tmajor\tclient_name\tpool\tname\tsnap\tKB\n");
+	rc = __rbd_update_snaps(rbd_dev);
+	if (rc < 0)
+		ret = rc;
 
-	list_for_each(tmp, &rbd_dev_list) {
-		struct rbd_device *rbd_dev;
+	mutex_unlock(&ctl_mutex);
+	return ret;
+}
 
-		rbd_dev = list_entry(tmp, struct rbd_device, node);
-		n += snprintf(data+n, max-n,
-			      "%d\t%d\tclient%lld\t%s\t%s\t%s\t%lld\n",
-			      rbd_dev->id,
-			      rbd_dev->major,
-			      ceph_client_id(rbd_dev->client),
-			      rbd_dev->pool_name,
-			      rbd_dev->obj, rbd_dev->snap_name,
-			      rbd_dev->header.image_size >> 10);
-		if (n == max)
+static DEVICE_ATTR(size, S_IRUGO, rbd_size_show, NULL);
+static DEVICE_ATTR(major, S_IRUGO, rbd_major_show, NULL);
+static DEVICE_ATTR(client_id, S_IRUGO, rbd_client_id_show, NULL);
+static DEVICE_ATTR(pool, S_IRUGO, rbd_pool_show, NULL);
+static DEVICE_ATTR(name, S_IRUGO, rbd_name_show, NULL);
+static DEVICE_ATTR(refresh, S_IWUSR, NULL, rbd_image_refresh);
+static DEVICE_ATTR(snap_current, S_IRUGO, rbd_snap_show, NULL);
+static DEVICE_ATTR(snap_create, S_IWUSR, NULL, rbd_snap_add);
+static DEVICE_ATTR(snap_rollback, S_IWUSR, NULL, rbd_snap_rollback);
+
+static struct attribute *rbd_attrs[] = {
+	&dev_attr_size.attr,
+	&dev_attr_major.attr,
+	&dev_attr_client_id.attr,
+	&dev_attr_pool.attr,
+	&dev_attr_name.attr,
+	&dev_attr_snap_current.attr,
+	&dev_attr_refresh.attr,
+	&dev_attr_snap_create.attr,
+	&dev_attr_snap_rollback.attr,
+	NULL
+};
+
+static struct attribute_group rbd_attr_group = {
+	.attrs = rbd_attrs,
+};
+
+static const struct attribute_group *rbd_attr_groups[] = {
+	&rbd_attr_group,
+	NULL
+};
+
+static void rbd_sysfs_dev_release(struct device *dev)
+{
+}
+
+static struct device_type rbd_device_type = {
+	.name		= "rbd",
+	.groups		= rbd_attr_groups,
+	.release	= rbd_sysfs_dev_release,
+};
+
+
+/*
+  sysfs - snapshots
+*/
+
+static ssize_t rbd_snap_size(struct rbd_snap *snap,
+			     char *buf)
+{
+	return sprintf(buf, "%lld\n", (long long)snap->size);
+}
+
+static ssize_t rbd_snap_id(struct rbd_snap *snap,
+			   char *buf)
+{
+	return sprintf(buf, "%lld\n", (long long)snap->id);
+}
+
+struct rbd_snap_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct rbd_snap *, char *);
+	ssize_t (*store)(struct rbd_snap *, const char *, size_t);
+};
+
+#define RBD_SNAP_ATTR(name, mode, show, store) \
+static struct rbd_snap_attr rbd_snap_attr_##name = \
+					__ATTR(name, mode, show, store)
+
+RBD_SNAP_ATTR(size, S_IRUGO, rbd_snap_size, NULL);
+RBD_SNAP_ATTR(id, S_IRUGO, rbd_snap_id, NULL);
+
+static ssize_t rbd_snap_attr_show(struct kobject *obj,
+				  struct attribute *attr,
+				  char *buf)
+{
+	struct rbd_snap *snap =
+			container_of(obj, struct rbd_snap, kobj);
+	struct rbd_snap_attr *snaps_attr =
+			container_of(attr, struct rbd_snap_attr, attr);
+
+	return (snaps_attr->show ? snaps_attr->show(snap, buf) : 0);
+}
+
+static ssize_t rbd_snap_attr_store(struct kobject *kobj,
+				   struct attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct rbd_snap *snap =
+			container_of(kobj, struct rbd_snap, kobj);
+	struct rbd_snap_attr *snaps_attr =
+			container_of(attr, struct rbd_snap_attr, attr);
+
+	return (snaps_attr->store ? snaps_attr->store(snap, buf, len) : 0);
+}
+
+
+static struct attribute *rbd_snap_attrs[] = {
+	&rbd_snap_attr_size.attr,
+	&rbd_snap_attr_id.attr,
+	NULL
+};
+
+static const struct sysfs_ops rbd_snap_attr_ops = {
+	.show  = rbd_snap_attr_show,
+	.store = rbd_snap_attr_store,
+};
+
+static struct kobj_type rbd_snap_type = {
+	.default_attrs	= rbd_snap_attrs,
+	.release	= rbd_snap_release,
+	.sysfs_ops	= &rbd_snap_attr_ops,
+};
+
+static void __rbd_remove_snap_dev(struct rbd_device *rbd_dev,
+				  struct rbd_snap *snap)
+{
+	list_del(&snap->node);
+	kobject_put(&snap->kobj);
+}
+
+static int rbd_register_snap_kobj(struct rbd_device *rbd_dev,
+				  struct rbd_snap *snap,
+				  struct kobject *parent)
+{
+	return kobject_init_and_add(&snap->kobj,
+				    &rbd_snap_type,
+				    parent,
+				    "%s", snap->name);
+}
+
+static int __rbd_add_snap_dev(struct rbd_device *rbd_dev,
+			      int i, const char *name,
+			      struct rbd_snap **snapp)
+{
+	int ret;
+	struct rbd_snap *snap = kzalloc(sizeof(*snap), GFP_KERNEL);
+	if (!snap)
+		return -ENOMEM;
+	snap->name = kstrdup(name, GFP_KERNEL);
+	snap->size = rbd_dev->header.snap_sizes[i];
+	snap->id = rbd_dev->header.snapc->snaps[i];
+	if (device_is_registered(&rbd_dev->dev)) {
+		ret = rbd_register_snap_kobj(rbd_dev, snap,
+					     &rbd_dev->snaps_kobj->kobj);
+		if (ret < 0)
+			goto err;
+	}
+	*snapp = snap;
+	return 0;
+err:
+	kfree(snap->name);
+	kfree(snap);
+	return ret;
+}
+
+/*
+ * search for the previous snap in a null delimited string list
+ */
+const char *rbd_prev_snap_name(const char *name, const char *start)
+{
+	if (name < start + 2)
+		return NULL;
+
+	name -= 2;
+	while (*name) {
+		if (name == start)
+			return start;
+		name--;
+	}
+	return name + 1;
+}
+
+/*
+ * compare the old list of snapshots that we have to what's in the header
+ * and update it accordingly. Note that the header holds the snapshots
+ * in a reverse order (from newest to oldest) and we need to go from
+ * older to new so that we don't get a duplicate snap name when
+ * doing the process (e.g., removed snapshot and recreated a new
+ * one with the same name.
+ */
+static int __rbd_init_snaps_header(struct rbd_device *rbd_dev)
+{
+	const char *name, *first_name;
+	int i = rbd_dev->header.total_snaps;
+	struct rbd_snap *snap, *old_snap = NULL;
+	int ret;
+	struct list_head *p, *n;
+
+	first_name = rbd_dev->header.snap_names;
+	name = first_name + rbd_dev->header.snap_names_len;
+
+	list_for_each_prev_safe(p, n, &rbd_dev->snaps) {
+		u64 cur_id;
+
+		old_snap = list_entry(p, struct rbd_snap, node);
+
+		if (i)
+			cur_id = rbd_dev->header.snapc->snaps[i - 1];
+
+		if (!i || old_snap->id < cur_id) {
+			/* old_snap->id was skipped, thus was removed */
+			__rbd_remove_snap_dev(rbd_dev, old_snap);
+			continue;
+		}
+		if (old_snap->id == cur_id) {
+			/* we have this snapshot already */
+			i--;
+			name = rbd_prev_snap_name(name, first_name);
+			continue;
+		}
+		for (; i > 0;
+		     i--, name = rbd_prev_snap_name(name, first_name)) {
+			if (!name) {
+				WARN_ON(1);
+				return -EINVAL;
+			}
+			cur_id = rbd_dev->header.snapc->snaps[i];
+			/* snapshot removal? handle it above */
+			if (cur_id >= old_snap->id)
+				break;
+			/* a new snapshot */
+			ret = __rbd_add_snap_dev(rbd_dev, i - 1, name, &snap);
+			if (ret < 0)
+				return ret;
+
+			/* note that we add it backward so using n and not p */
+			list_add(&snap->node, n);
+			p = &snap->node;
+		}
+	}
+	/* we're done going over the old snap list, just add what's left */
+	for (; i > 0; i--) {
+		name = rbd_prev_snap_name(name, first_name);
+		if (!name) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+		ret = __rbd_add_snap_dev(rbd_dev, i - 1, name, &snap);
+		if (ret < 0)
+			return ret;
+		list_add(&snap->node, &rbd_dev->snaps);
+	}
+
+	return 0;
+}
+
+static void rbd_release_snaps(struct kobject *kobj)
+{
+	struct rbd_snaps *snaps = container_of(kobj, struct rbd_snaps, kobj);
+	kfree(snaps);
+}
+
+static struct kobj_type rbd_snaps_type = {
+	.release	= rbd_release_snaps,
+};
+
+static int rbd_register_snaps_kobj(struct rbd_snaps *snaps,
+				   struct kobject *parent)
+{
+	return kobject_init_and_add(&snaps->kobj,
+				    &rbd_snaps_type,
+				    parent,
+				    "snaps");
+}
+
+static struct bus_type rbd_bus_type = {
+	.name		= "rbd",
+};
+
+static void rbd_root_dev_release(struct device *dev)
+{
+}
+
+static struct device rbd_root_dev = {
+	.init_name =    "rbd",
+	.release =      rbd_root_dev_release,
+};
+
+static int rbd_bus_add_dev(struct rbd_device *rbd_dev)
+{
+	int ret = -ENOMEM;
+	struct device *dev;
+	struct rbd_snap *snap;
+
+	rbd_dev->snaps_kobj = kzalloc(sizeof(*rbd_dev->snaps_kobj), GFP_KERNEL);
+	if (!rbd_dev)
+		goto done;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+	dev = &rbd_dev->dev;
+
+	dev->bus = &rbd_bus_type;
+	dev->type = &rbd_device_type;
+	dev->parent = &rbd_root_dev;
+	dev->release = rbd_dev_release;
+	dev_set_name(dev, "%d", rbd_dev->id);
+	ret = device_register(dev);
+	if (ret < 0)
+		goto done_free;
+
+	ret = rbd_register_snaps_kobj(rbd_dev->snaps_kobj, &dev->kobj);
+	if (ret < 0)
+		goto done_err;
+
+	list_for_each_entry(snap, &rbd_dev->snaps, node) {
+		ret = rbd_register_snap_kobj(rbd_dev, snap,
+					     &rbd_dev->snaps_kobj->kobj);
+		if (ret < 0)
 			break;
 	}
+done:
+	mutex_unlock(&ctl_mutex);
+	return 0;
 
+done_err:
+	device_unregister(dev);
+done_free:
 	mutex_unlock(&ctl_mutex);
-	return n;
+	kfree(rbd_dev->snaps_kobj);
+	return ret;
+}
+
+static void rbd_bus_del_dev(struct rbd_device *rbd_dev)
+{
+	kobject_put(&rbd_dev->snaps_kobj->kobj);
+	device_unregister(&rbd_dev->dev);
 }
 
-static ssize_t class_rbd_add(struct class *c,
-			     struct class_attribute *attr,
-			     const char *buf, size_t count)
+static ssize_t rbd_add(struct bus_type *bus, const char *buf, size_t count)
 {
 	struct ceph_osd_client *osdc;
 	struct rbd_device *rbd_dev;
@@ -1419,6 +1784,7 @@ static ssize_t class_rbd_add(struct class *c,
 	/* static rbd_device initialization */
 	spin_lock_init(&rbd_dev->lock);
 	INIT_LIST_HEAD(&rbd_dev->node);
+	INIT_LIST_HEAD(&rbd_dev->snaps);
 
 	/* generate unique id: find highest unique id, add one */
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
@@ -1478,6 +1844,9 @@ static ssize_t class_rbd_add(struct class *c,
 	}
 	rbd_dev->major = irc;
 
+	rc = rbd_bus_add_dev(rbd_dev);
+	if (rc)
+		goto err_out_disk;
 	/* set up and announce blkdev mapping */
 	rc = rbd_init_disk(rbd_dev);
 	if (rc)
@@ -1487,6 +1856,8 @@ static ssize_t class_rbd_add(struct class *c,
 
 err_out_blkdev:
 	unregister_blkdev(rbd_dev->major, rbd_dev->name);
+err_out_disk:
+	rbd_free_disk(rbd_dev);
 err_out_client:
 	rbd_put_client(rbd_dev);
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
@@ -1518,35 +1889,10 @@ static struct rbd_device *__rbd_get_dev(unsigned long id)
 	return NULL;
 }
 
-static ssize_t class_rbd_remove(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
+static void rbd_dev_release(struct device *dev)
 {
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, rc;
-	unsigned long ul;
-
-	rc = strict_strtoul(buf, 10, &ul);
-	if (rc)
-		return rc;
-
-	/* convert to int; abort if we lost anything in the conversion */
-	target_id = (int) ul;
-	if (target_id != ul)
-		return -EINVAL;
-
-	/* remove object from list immediately */
-	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-
-	rbd_dev = __rbd_get_dev(target_id);
-	if (rbd_dev)
-		list_del_init(&rbd_dev->node);
-
-	mutex_unlock(&ctl_mutex);
-
-	if (!rbd_dev)
-		return -ENOENT;
+	struct rbd_device *rbd_dev =
+			container_of(dev, struct rbd_device, dev);
 
 	rbd_put_client(rbd_dev);
 
@@ -1557,67 +1903,11 @@ static ssize_t class_rbd_remove(struct class *c,
 
 	/* release module ref */
 	module_put(THIS_MODULE);
-
-	return count;
-}
-
-static ssize_t class_rbd_snaps_list(struct class *c,
-			      struct class_attribute *attr,
-			      char *data)
-{
-	struct rbd_device *rbd_dev = NULL;
-	struct list_head *tmp;
-	struct rbd_image_header *header;
-	int i, n = 0, max = PAGE_SIZE;
-	int ret;
-
-	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-
-	n += snprintf(data, max, "#id\tsnap\tKB\n");
-
-	list_for_each(tmp, &rbd_dev_list) {
-		char *names, *p;
-		struct ceph_snap_context *snapc;
-
-		rbd_dev = list_entry(tmp, struct rbd_device, node);
-		header = &rbd_dev->header;
-
-		down_read(&header->snap_rwsem);
-
-		names = header->snap_names;
-		snapc = header->snapc;
-
-		n += snprintf(data + n, max - n, "%d\t%s\t%lld%s\n",
-			      rbd_dev->id, RBD_SNAP_HEAD_NAME,
-			      header->image_size >> 10,
-			      (!rbd_dev->cur_snap ? " (*)" : ""));
-		if (n == max)
-			break;
-
-		p = names;
-		for (i = 0; i < header->total_snaps; i++, p += strlen(p) + 1) {
-			n += snprintf(data + n, max - n, "%d\t%s\t%lld%s\n",
-			      rbd_dev->id, p, header->snap_sizes[i] >> 10,
-			      (rbd_dev->cur_snap &&
-			       (snap_index(header, i) == rbd_dev->cur_snap) ?
-			       " (*)" : ""));
-			if (n == max)
-				break;
-		}
-
-		up_read(&header->snap_rwsem);
-	}
-
-
-	ret = n;
-	mutex_unlock(&ctl_mutex);
-	return ret;
 }
 
-static ssize_t class_rbd_snaps_refresh(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
+static ssize_t rbd_remove(struct bus_type *bus,
+			  const char *buf,
+			  size_t count)
 {
 	struct rbd_device *rbd_dev = NULL;
 	int target_id, rc;
@@ -1641,95 +1931,70 @@ static ssize_t class_rbd_snaps_refresh(struct class *c,
 		goto done;
 	}
 
-	rc = rbd_update_snaps(rbd_dev);
-	if (rc < 0)
-		ret = rc;
+	list_del_init(&rbd_dev->node);
+
+	__rbd_remove_snaps_kobj(rbd_dev);
+	rbd_bus_del_dev(rbd_dev);
 
 done:
 	mutex_unlock(&ctl_mutex);
 	return ret;
 }
 
-static ssize_t class_rbd_snap_create(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
+static ssize_t rbd_snap_add(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf,
+			    size_t count)
 {
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, ret;
-	char *name;
-
-	name = kmalloc(RBD_MAX_SNAP_NAME_LEN + 1, GFP_KERNEL);
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+	int ret;
+	char *name = kmalloc(count + 1, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
-	/* parse snaps add command */
-	if (sscanf(buf, "%d "
-		   "%" __stringify(RBD_MAX_SNAP_NAME_LEN) "s",
-		   &target_id,
-		   name) != 2) {
-		ret = -EINVAL;
-		goto done;
-	}
+	snprintf(name, count, "%s", buf);
 
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done_unlock;
-	}
-
 	ret = rbd_header_add_snap(rbd_dev,
 				  name, GFP_KERNEL);
 	if (ret < 0)
 		goto done_unlock;
 
-	ret = rbd_update_snaps(rbd_dev);
+	ret = __rbd_update_snaps(rbd_dev);
 	if (ret < 0)
 		goto done_unlock;
 
 	ret = count;
 done_unlock:
 	mutex_unlock(&ctl_mutex);
-done:
 	kfree(name);
 	return ret;
 }
 
-static ssize_t class_rbd_rollback(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
+static ssize_t rbd_snap_rollback(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t count)
 {
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, ret;
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+	int ret;
 	u64 snapid;
-	char snap_name[RBD_MAX_SNAP_NAME_LEN];
 	u64 cur_ofs;
-	char *seg_name;
+	char *seg_name = NULL;
+	char *snap_name = kmalloc(count + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!snap_name)
+		return ret;
 
 	/* parse snaps add command */
-	if (sscanf(buf, "%d "
-		   "%" __stringify(RBD_MAX_SNAP_NAME_LEN) "s",
-		   &target_id,
-		   snap_name) != 2) {
-		return -EINVAL;
-	}
-
-	ret = -ENOMEM;
+	snprintf(snap_name, count, "%s", buf);
 	seg_name = kmalloc(RBD_MAX_SEG_NAME_LEN + 1, GFP_NOIO);
 	if (!seg_name)
-		return ret;
+		goto done;
 
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done_unlock;
-	}
-
 	ret = snap_by_name(&rbd_dev->header, snap_name, &snapid, NULL);
 	if (ret < 0)
 		goto done_unlock;
@@ -1750,7 +2015,7 @@ static ssize_t class_rbd_rollback(struct class *c,
 				   seg_name, ret);
 	}
 
-	ret = rbd_update_snaps(rbd_dev);
+	ret = __rbd_update_snaps(rbd_dev);
 	if (ret < 0)
 		goto done_unlock;
 
@@ -1758,57 +2023,42 @@ static ssize_t class_rbd_rollback(struct class *c,
 
 done_unlock:
 	mutex_unlock(&ctl_mutex);
+done:
 	kfree(seg_name);
+	kfree(snap_name);
 
 	return ret;
 }
 
-static struct class_attribute class_rbd_attrs[] = {
-	__ATTR(add,		0200, NULL, class_rbd_add),
-	__ATTR(remove,		0200, NULL, class_rbd_remove),
-	__ATTR(list,		0444, class_rbd_list, NULL),
-	__ATTR(snaps_refresh,	0200, NULL, class_rbd_snaps_refresh),
-	__ATTR(snap_create,	0200, NULL, class_rbd_snap_create),
-	__ATTR(snaps_list,	0444, class_rbd_snaps_list, NULL),
-	__ATTR(snap_rollback,	0200, NULL, class_rbd_rollback),
+static struct bus_attribute rbd_bus_attrs[] = {
+	__ATTR(add, S_IWUSR, NULL, rbd_add),
+	__ATTR(remove, S_IWUSR, NULL, rbd_remove),
 	__ATTR_NULL
 };
 
 /*
  * create control files in sysfs
- * /sys/class/rbd/...
+ * /sys/bus/rbd/...
  */
 static int rbd_sysfs_init(void)
 {
-	int ret = -ENOMEM;
+	int ret;
 
-	class_rbd = kzalloc(sizeof(*class_rbd), GFP_KERNEL);
-	if (!class_rbd)
-		goto out;
+	rbd_bus_type.bus_attrs = rbd_bus_attrs;
 
-	class_rbd->name = DRV_NAME;
-	class_rbd->owner = THIS_MODULE;
-	class_rbd->class_release = class_rbd_release;
-	class_rbd->class_attrs = class_rbd_attrs;
+	ret = bus_register(&rbd_bus_type);
+	 if (ret < 0)
+		return ret;
 
-	ret = class_register(class_rbd);
-	if (ret)
-		goto out_class;
-	return 0;
+	ret = device_register(&rbd_root_dev);
 
-out_class:
-	kfree(class_rbd);
-	class_rbd = NULL;
-	pr_err(DRV_NAME ": failed to create class rbd\n");
-out:
 	return ret;
 }
 
 static void rbd_sysfs_cleanup(void)
 {
-	if (class_rbd)
-		class_destroy(class_rbd);
-	class_rbd = NULL;
+	device_unregister(&rbd_root_dev);
+	bus_unregister(&rbd_bus_type);
 }
 
 int __init rbd_init(void)
-- 
1.5.6.5



