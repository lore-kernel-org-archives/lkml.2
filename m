Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1HDWoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:44:08 -0400
Received: from [66.192.166.38] ([66.192.166.38]:43469 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754816Ab1HDWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:44:03 -0400
X-Greylist: delayed 1954 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 18:44:03 EDT
Date: Thu, 04 Aug 2011 18:11:27 -0400
From: paul.clements@steeleye.com
To: greg@kroah.com
Subject: [PATCH v2] nbd: nbd sysfs framework
Message-ID: <4e3b190f.NjLPBhXLsVSgFxi+%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: This patch adds a small framework that will simplify adding
sysfs entries for nbd (coming later). All the locking and structure walking
are in the main nbd_attr_ handlers and the individual entries' show and store
handlers will be much simpler. The patch moves the one existing sysfs entry
(pid) to use the framework. ABI docs included.

Thanks,
Paul

From: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 Documentation/ABI/testing/sysfs-block-nbd |    8 ++
 drivers/block/nbd.c                       |   98 ++++++++++++++++++++++--------
 2 files changed, 80 insertions(+), 26 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-nbd b/Documentation/ABI/testing/sysfs-block-nbd
new file mode 100644
index 0000000..3728d9f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-block-nbd
@@ -0,0 +1,8 @@
+What:		/sys/block/nbd<id>/nbd/pid
+Date:		August 2011
+Contact:	Paul Clements <paul.clements@steeleye.com>
+Description:
+		The pid file is read-only and specifies the pid of the
+		caller of NBD_DO_IT ioctl (normally this is the nbd-client).
+		The pid will be zero if the nbd connection is not
+		currently established.
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index e6fc716..1dbca97 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -383,39 +383,17 @@ harderror:
 	return NULL;
 }
 
-static ssize_t pid_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-
-	return sprintf(buf, "%ld\n",
-		(long) ((struct nbd_device *)disk->private_data)->pid);
-}
-
-static struct device_attribute pid_attr = {
-	.attr = { .name = "pid", .mode = S_IRUGO},
-	.show = pid_show,
-};
-
 static int nbd_do_it(struct nbd_device *lo)
 {
 	struct request *req;
-	int ret;
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
-	if (ret) {
-		printk(KERN_ERR "nbd: sysfs_create_file failed!");
-		lo->pid = 0;
-		return ret;
-	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	lo->pid = 0;
 	return 0;
 }
@@ -730,10 +708,73 @@ static const struct block_device_operations nbd_fops =
 	.ioctl =	nbd_ioctl,
 };
 
-/*
- * And here should be modules and kernel interface 
- *  (Just smiley confuses emacs :-)
- */
+// this structure holds the "real" show and store handlers so that the
+// main nbd attr handlers can find them
+struct nbd_sysfs_entry {
+	struct device_attribute dev_attr;
+	ssize_t (*show)(struct nbd_device *, char *);
+	ssize_t (*store)(struct nbd_device *, const char *, size_t);
+};
+
+#define NBD_ATTR(_name, _perm, _show, _store) \
+	static struct nbd_sysfs_entry nbd_sysfs_##_name = { \
+	.dev_attr = __ATTR(_name, _perm, nbd_attr_show, nbd_attr_store), \
+	.show = _show, \
+	.store = _store \
+}
+
+static ssize_t
+nbd_attr_show(struct device *dev, struct device_attribute *attr, char *page)
+{
+	struct nbd_sysfs_entry *entry = container_of(attr,
+			struct nbd_sysfs_entry, dev_attr);
+	struct nbd_device *lo = (struct nbd_device *)
+				dev_to_disk(dev)->private_data;
+	ssize_t rv;
+
+	if (!entry->show || !lo)
+		return -EIO;
+	rv = entry->show(lo, page);
+	return rv;
+}
+
+static ssize_t
+nbd_attr_store(struct device *dev, struct device_attribute *attr,
+	      const char *page, size_t length)
+{
+	struct nbd_sysfs_entry *entry = container_of(attr,
+			struct nbd_sysfs_entry, dev_attr);
+	struct nbd_device *lo = (struct nbd_device *)
+				dev_to_disk(dev)->private_data;
+	ssize_t rv;
+
+	if (!entry->store || !lo)
+		return -EIO;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	mutex_lock(&lo->tx_lock);
+	rv = entry->store(lo, page, length);
+	mutex_unlock(&lo->tx_lock);
+
+	return rv;
+}
+
+static ssize_t pid_show(struct nbd_device *lo, char *page)
+{
+	return sprintf(page, "%ld\n", (long)lo->pid);
+}
+
+NBD_ATTR(pid, S_IRUGO, pid_show, NULL);
+
+static struct attribute *nbd_attrs[] = {
+	&nbd_sysfs_pid.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group nbd_attr_group = {
+	.name = "nbd",
+	.attrs = nbd_attrs,
+};
 
 static int __init nbd_init(void)
 {
@@ -786,6 +827,7 @@ static int __init nbd_init(void)
 	dprintk(DBG_INIT, "nbd: debugflags=0x%x\n", debugflags);
 
 	for (i = 0; i < nbds_max; i++) {
+		int error;
 		struct gendisk *disk = nbd_dev[i].disk;
 		nbd_dev[i].file = NULL;
 		nbd_dev[i].magic = LO_MAGIC;
@@ -805,6 +847,8 @@ static int __init nbd_init(void)
 		sprintf(disk->disk_name, "nbd%d", i);
 		set_capacity(disk, 0);
 		add_disk(disk);
+		error = sysfs_create_group(&disk_to_dev(disk)->kobj,
+				&nbd_attr_group);
 	}
 
 	return 0;
@@ -824,6 +868,8 @@ static void __exit nbd_cleanup(void)
 		struct gendisk *disk = nbd_dev[i].disk;
 		nbd_dev[i].magic = 0;
 		if (disk) {
+			sysfs_remove_group(&disk_to_dev(disk)->kobj,
+					&nbd_attr_group);
 			del_gendisk(disk);
 			blk_cleanup_queue(disk->queue);
 			put_disk(disk);
