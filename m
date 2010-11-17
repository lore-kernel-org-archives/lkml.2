Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0KQAfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:35:16 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:36188 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab0KQAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id; q=dns; s=drama; b=LjOYiZKquX1ItPI6W
	kIWOlxWSPl3718Dk/NhWr7xFeMHrN/KqSl6rMCTbPPYlw6uRn/DrLLYebYJqyY2t
	fq5Isleg+zjzv0krbqY3963i2Bae6JwSsvKATdyxh6EDQEtDVmx5qhtlSYeEzxdg
	GUb85wXm+H9NDeJXRj1Ln6Yurc=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: greg@kroah.com
Cc: sage@newdream.net, yehudasa@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH] rbd: replace the rbd sysfs interface
Date: Tue, 16 Nov 2010 16:32:09 -0800
Message-Id: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Following is the new rbd sysfs interface. It lists devices in their own
subdirectories, as well as their underlying snapshots. Please let us
know if there's any issue you think we missed or did wrong.

Thanks,
Yehuda

---

The new interface creates directories per mapped image
and under each it creates a subdir per available snapshot.
This allows keeping a cleaner interface within the sysfs
guidelines. The ABI documentation was updated too.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 Documentation/ABI/testing/sysfs-class-rbd |   83 +++
 drivers/block/rbd.c                       |  775 +++++++++++++++++------------
 2 files changed, 547 insertions(+), 311 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-rbd b/Documentation/ABI/testing/sysfs-class-rbd
new file mode 100644
index 0000000..4d96618
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-rbd
@@ -0,0 +1,83 @@
+What:		/sys/class/rbd/
+Date:		November 2010
+Contact:	Yehuda Sadeh <yehuda@hq.newdream.net>, Sage Weil <sage@newdream.net>
+Description:
+
+Being used for adding and removing rbd block devices.
+
+Usage: <mon ip addr> <options> <pool name> <rbd image name> [snap name]
+
+ $ echo "192.168.0.1 name=admin rbd foo" > /sys/class/rbd/add
+
+The snapshot name can be "-" or omitted to map the image read/write. A <dev-id>
+will be assigned for any registered block device. If snapshot is used, it will
+be mapped read-only.
+
+Removal of a device:
+
+  $ echo <dev-id> > /sys/class/rbd/remove
+
+Entries under /sys/class/rbd/<dev-id>/
+---------------------------------------
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
+	 $ echo <snap-name> > /sys/class/rbd/<dev-id>/snap_create
+
+snap_rollback
+
+	Rolls back data to the specified snapshot. This goes over the entire
+	list of rados blocks and sends a rollback command to each.
+
+	 $ echo <snap-name> > /sys/class/rbd/<dev-id>/snap_rollback
+
+snaps/
+
+	The snaps directory will hold a directory per snapshot that exists
+        for this rbd image.
+
+
+Entries under /sys/class/rbd/<dev-id>/snaps/<snap-name>
+--------------------------------------------------------
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
index 6ec9d53..7b857f9 100644
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
+                 Documentation/ABI/testing/sysfs-class-rbd
 
  */
 
@@ -163,6 +92,14 @@ struct rbd_request {
 	u64			len;
 };
 
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
@@ -193,6 +130,11 @@ struct rbd_device {
 	int read_only;
 
 	struct list_head	node;
+
+	struct device		dev;
+	struct kobject		snaps_kobj;
+	struct list_head	snaps;
+	int			kobj_ready;
 };
 
 static spinlock_t node_lock;      /* protects client get/put */
@@ -202,6 +144,12 @@ static DEFINE_MUTEX(ctl_mutex);	  /* Serialize open/close/setup/teardown */
 static LIST_HEAD(rbd_dev_list);    /* devices */
 static LIST_HEAD(rbd_client_list);      /* clients */
 
+static int __rbd_init_snaps_header(struct rbd_device *rbd_dev);
+
+static struct rbd_device *dev_to_rbd(struct device *dev)
+{
+	return container_of(dev, struct rbd_device, dev);
+}
 
 static int rbd_open(struct block_device *bdev, fmode_t mode)
 {
@@ -361,7 +309,6 @@ static int rbd_header_from_disk(struct rbd_image_header *header,
 	int ret = -ENOMEM;
 
 	init_rwsem(&header->snap_rwsem);
-
 	header->snap_names_len = le64_to_cpu(ondisk->snap_names_len);
 	header->snapc = kmalloc(sizeof(struct ceph_snap_context) +
 				snap_count *
@@ -1256,10 +1203,22 @@ bad:
 	return -ERANGE;
 }
 
+static void __rbd_remove_snaps_kobj(struct rbd_device *rbd_dev)
+{
+	struct rbd_snap *snap;
+
+	while (!list_empty(&rbd_dev->snaps)) {
+		snap = list_first_entry(&rbd_dev->snaps, struct rbd_snap, node);
+		list_del_init(&snap->node);
+		kobject_del(&snap->kobj);
+		kfree(snap);
+	}
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
@@ -1280,12 +1239,15 @@ static int rbd_update_snaps(struct rbd_device *rbd_dev)
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
@@ -1300,6 +1262,11 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
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
@@ -1343,49 +1310,430 @@ out:
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
 
 static void class_rbd_release(struct class *cls)
 {
 	kfree(cls);
 }
 
-static ssize_t class_rbd_list(struct class *c,
-			      struct class_attribute *attr,
-			      char *data)
+static ssize_t rbd_size_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
-	int n = 0;
-	struct list_head *tmp;
-	int max = PAGE_SIZE;
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
+
+static ssize_t rbd_client_id_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+
+	return sprintf(buf, "client%lld\n", ceph_client_id(rbd_dev->client));
+}
+
+static ssize_t rbd_pool_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
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
+			     struct device_attribute *attr, char *buf)
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
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	rc = __rbd_update_snaps(rbd_dev);
+	if (rc < 0)
+		ret = rc;
+
+	mutex_unlock(&ctl_mutex);
+	return ret;
+}
+
+static ssize_t rbd_snap_add(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf,
+			    size_t size)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+	int ret;
+	char *name = kmalloc(size + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	snprintf(name, size, "%s", buf);
 
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
-	n += snprintf(data, max,
-		      "#id\tmajor\tclient_name\tpool\tname\tsnap\tKB\n");
+	ret = rbd_header_add_snap(rbd_dev,
+				  name, GFP_KERNEL);
+	if (ret < 0)
+		goto done_unlock;
 
-	list_for_each(tmp, &rbd_dev_list) {
-		struct rbd_device *rbd_dev;
+	ret = __rbd_update_snaps(rbd_dev);
+	if (ret < 0)
+		goto done_unlock;
 
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
-			break;
+	ret = size;
+done_unlock:
+	mutex_unlock(&ctl_mutex);
+	kfree(name);
+	return ret;
+}
+
+static ssize_t rbd_snap_rollback(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf,
+				 size_t size)
+{
+	struct rbd_device *rbd_dev = dev_to_rbd(dev);
+	int ret;
+	u64 snapid;
+	u64 cur_ofs;
+	char *seg_name = NULL;
+	char *snap_name = kmalloc(size + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!snap_name)
+		return ret;
+
+	/* parse snaps add command */
+	snprintf(snap_name, size, "%s", buf);
+	seg_name = kmalloc(RBD_MAX_SEG_NAME_LEN + 1, GFP_NOIO);
+	if (!seg_name)
+		goto done;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+
+	ret = snap_by_name(&rbd_dev->header, snap_name, &snapid, NULL);
+	if (ret < 0)
+		goto done_unlock;
+
+	dout("snapid=%lld\n", snapid);
+
+	cur_ofs = 0;
+	while (cur_ofs < rbd_dev->header.image_size) {
+		cur_ofs += rbd_get_segment(&rbd_dev->header,
+					   rbd_dev->obj,
+					   cur_ofs, (u64)-1,
+					   seg_name, NULL);
+		dout("seg_name=%s\n", seg_name);
+
+		ret = rbd_req_sync_rollback_obj(rbd_dev, snapid, seg_name);
+		if (ret < 0)
+			pr_warning("could not roll back obj %s err=%d\n",
+				   seg_name, ret);
 	}
 
+	ret = __rbd_update_snaps(rbd_dev);
+	if (ret < 0)
+		goto done_unlock;
+
+	ret = size;
+
+done_unlock:
 	mutex_unlock(&ctl_mutex);
-	return n;
+done:
+	kfree(seg_name);
+	kfree(snap_name);
+
+	return ret;
+}
+
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
+static void rbd_dev_release(struct device *dev)
+{
+}
+
+static struct device_type rbd_type = {
+	.name		= "rbd",
+	.groups		= rbd_attr_groups,
+	.release	= rbd_dev_release,
+};
+
+
+/*
+  sysfs - snapshots
+*/
+
+static struct kobj_type rbd_snap_root_ktype = {
+};
+
+static ssize_t rbd_snap_size(struct rbd_snap *snap,
+			     char *buf)
+{
+	return sprintf(buf, "%lld\n", (long long)snap->size);
+}
+
+static ssize_t rbd_snap_id(struct rbd_snap *snap,
+			     char *buf)
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
+static struct kobj_type rbd_snap_ktype = {
+	.default_attrs = rbd_snap_attrs,
+	.sysfs_ops     = &rbd_snap_attr_ops,
+};
+
+static void __rbd_remove_snap_kobj(struct rbd_device *rbd_dev,
+				   struct rbd_snap *snap)
+{
+	list_del(&snap->node);
+	kobject_del(&snap->kobj);
+	kfree(snap->name);
+	kfree(snap);
+}
+
+static int __rbd_add_snap_kobj(struct rbd_device *rbd_dev,
+			       int i, const char *name,
+			       struct rbd_snap **snapp)
+{
+	int ret;
+	struct rbd_snap *snap = kzalloc(sizeof(*snap), GFP_KERNEL);
+	if (!snap)
+		return -ENOMEM;
+	snap->name = kstrdup(name, GFP_KERNEL);
+	snap->size = rbd_dev->header.snap_sizes[i];
+	snap->id = rbd_dev->header.snapc->snaps[i];
+	if (rbd_dev->kobj_ready) {
+		ret = kobject_init_and_add(&snap->kobj,
+					   &rbd_snap_ktype,
+					   &rbd_dev->snaps_kobj,
+					   "%s", snap->name);
+		if (ret < 0) {
+			kfree(snap);
+			return ret;
+		}
+	}
+	*snapp = snap;
+	return 0;
+}
+
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
+			__rbd_remove_snap_kobj(rbd_dev, old_snap);
+			continue;
+		}
+		if (old_snap->id == cur_id) {
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
+			if (cur_id >= old_snap->id)
+				break;
+			ret = __rbd_add_snap_kobj(rbd_dev, i - 1, name, &snap);
+			if (ret < 0)
+				return ret;
+
+			/* note that we add it backward, hence using n and not p */
+			list_add(&snap->node, n);
+			p = &snap->node;
+		}
+	}
+	for (; i > 0; i--) {
+		name = rbd_prev_snap_name(name, first_name);
+		if (!name) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+		ret = __rbd_add_snap_kobj(rbd_dev, i - 1, name, &snap);
+		if (ret < 0)
+			return ret;
+		list_add(&snap->node, &rbd_dev->snaps);
+	}
+
+	return 0;
+}
+
+static int class_rbd_add_dev(struct rbd_device *rbd_dev)
+{
+	int ret;
+	struct device *dev;
+	struct rbd_snap *snap;
+
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+	dev = &rbd_dev->dev;
+
+	dev->class = class_rbd;
+	dev->type = &rbd_type;
+	dev_set_name(dev, "%d", rbd_dev->id);
+	ret = device_register(dev);
+	if (ret < 0)
+		goto done;
+
+	ret = kobject_init_and_add(&rbd_dev->snaps_kobj, &rbd_snap_root_ktype,
+				   &dev->kobj, "snaps");
+	rbd_dev->kobj_ready = 1;
+	list_for_each_entry(snap, &rbd_dev->snaps, node) {
+		ret = kobject_init_and_add(&snap->kobj, &rbd_snap_ktype,
+					   &rbd_dev->snaps_kobj,
+					   "%s", snap->name);
+		if (ret < 0)
+			break;
+	}
+done:
+	mutex_unlock(&ctl_mutex);
+	return ret;
+}
+
+static void class_rbd_del_dev(struct rbd_device *rbd_dev)
+{
+	device_unregister(&rbd_dev->dev);
 }
 
 static ssize_t class_rbd_add(struct class *c,
@@ -1419,6 +1767,8 @@ static ssize_t class_rbd_add(struct class *c,
 	/* static rbd_device initialization */
 	spin_lock_init(&rbd_dev->lock);
 	INIT_LIST_HEAD(&rbd_dev->node);
+	INIT_LIST_HEAD(&rbd_dev->snaps);
+	rbd_dev->kobj_ready = 0;
 
 	/* generate unique id: find highest unique id, add one */
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
@@ -1483,8 +1833,14 @@ static ssize_t class_rbd_add(struct class *c,
 	if (rc)
 		goto err_out_blkdev;
 
+	rc = class_rbd_add_dev(rbd_dev);
+	if (rc)
+		goto err_out_disk;
+
 	return count;
 
+err_out_disk:
+	rbd_free_disk(rbd_dev);
 err_out_blkdev:
 	unregister_blkdev(rbd_dev->major, rbd_dev->name);
 err_out_client:
@@ -1543,11 +1899,15 @@ static ssize_t class_rbd_remove(struct class *c,
 	if (rbd_dev)
 		list_del_init(&rbd_dev->node);
 
+	__rbd_remove_snaps_kobj(rbd_dev);
+
 	mutex_unlock(&ctl_mutex);
 
 	if (!rbd_dev)
 		return -ENOENT;
 
+	class_rbd_del_dev(rbd_dev);
+
 	rbd_put_client(rbd_dev);
 
 	/* clean up and free blkdev */
@@ -1561,216 +1921,9 @@ static ssize_t class_rbd_remove(struct class *c,
 	return count;
 }
 
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
-}
-
-static ssize_t class_rbd_snaps_refresh(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
-{
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, rc;
-	unsigned long ul;
-	int ret = count;
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
-	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done;
-	}
-
-	rc = rbd_update_snaps(rbd_dev);
-	if (rc < 0)
-		ret = rc;
-
-done:
-	mutex_unlock(&ctl_mutex);
-	return ret;
-}
-
-static ssize_t class_rbd_snap_create(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
-{
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, ret;
-	char *name;
-
-	name = kmalloc(RBD_MAX_SNAP_NAME_LEN + 1, GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	/* parse snaps add command */
-	if (sscanf(buf, "%d "
-		   "%" __stringify(RBD_MAX_SNAP_NAME_LEN) "s",
-		   &target_id,
-		   name) != 2) {
-		ret = -EINVAL;
-		goto done;
-	}
-
-	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done_unlock;
-	}
-
-	ret = rbd_header_add_snap(rbd_dev,
-				  name, GFP_KERNEL);
-	if (ret < 0)
-		goto done_unlock;
-
-	ret = rbd_update_snaps(rbd_dev);
-	if (ret < 0)
-		goto done_unlock;
-
-	ret = count;
-done_unlock:
-	mutex_unlock(&ctl_mutex);
-done:
-	kfree(name);
-	return ret;
-}
-
-static ssize_t class_rbd_rollback(struct class *c,
-				struct class_attribute *attr,
-				const char *buf,
-				size_t count)
-{
-	struct rbd_device *rbd_dev = NULL;
-	int target_id, ret;
-	u64 snapid;
-	char snap_name[RBD_MAX_SNAP_NAME_LEN];
-	u64 cur_ofs;
-	char *seg_name;
-
-	/* parse snaps add command */
-	if (sscanf(buf, "%d "
-		   "%" __stringify(RBD_MAX_SNAP_NAME_LEN) "s",
-		   &target_id,
-		   snap_name) != 2) {
-		return -EINVAL;
-	}
-
-	ret = -ENOMEM;
-	seg_name = kmalloc(RBD_MAX_SEG_NAME_LEN + 1, GFP_NOIO);
-	if (!seg_name)
-		return ret;
-
-	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
-
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done_unlock;
-	}
-
-	ret = snap_by_name(&rbd_dev->header, snap_name, &snapid, NULL);
-	if (ret < 0)
-		goto done_unlock;
-
-	dout("snapid=%lld\n", snapid);
-
-	cur_ofs = 0;
-	while (cur_ofs < rbd_dev->header.image_size) {
-		cur_ofs += rbd_get_segment(&rbd_dev->header,
-					   rbd_dev->obj,
-					   cur_ofs, (u64)-1,
-					   seg_name, NULL);
-		dout("seg_name=%s\n", seg_name);
-
-		ret = rbd_req_sync_rollback_obj(rbd_dev, snapid, seg_name);
-		if (ret < 0)
-			pr_warning("could not roll back obj %s err=%d\n",
-				   seg_name, ret);
-	}
-
-	ret = rbd_update_snaps(rbd_dev);
-	if (ret < 0)
-		goto done_unlock;
-
-	ret = count;
-
-done_unlock:
-	mutex_unlock(&ctl_mutex);
-	kfree(seg_name);
-
-	return ret;
-}
-
 static struct class_attribute class_rbd_attrs[] = {
 	__ATTR(add,		0200, NULL, class_rbd_add),
 	__ATTR(remove,		0200, NULL, class_rbd_remove),
-	__ATTR(list,		0444, class_rbd_list, NULL),
-	__ATTR(snaps_refresh,	0200, NULL, class_rbd_snaps_refresh),
-	__ATTR(snap_create,	0200, NULL, class_rbd_snap_create),
-	__ATTR(snaps_list,	0444, class_rbd_snaps_list, NULL),
-	__ATTR(snap_rollback,	0200, NULL, class_rbd_rollback),
 	__ATTR_NULL
 };
 
-- 
1.5.6.5

