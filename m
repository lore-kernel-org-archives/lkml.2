Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1BEOXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1BEOXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kw/LlPTqd5VPe88iWiCLN5rGzA1/cocG9qZpp2Qi08HOVWeL/t3IuQypeM8dfvRWa7
         8YK7hWNBd/2686vSovmzwn5EtWnHqNevX5vbTqEUPbBGgqKiLgNHhGspK9k246yDmI6z
         YoOoSCFsbEY1hzTd1FBzZqiPKjyi01EjVOwvs=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 49/52] kstrtox: convert s390
Date: Sat,  5 Feb 2011 16:20:52 +0200
Message-Id: <1296915654-7458-49-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/s390/kernel/ptrace.c        |    8 +++--
 arch/s390/kernel/vdso.c          |    5 ++-
 drivers/s390/block/dasd_devmap.c |   20 +++++------
 drivers/s390/char/sclp_async.c   |    8 +++--
 drivers/s390/cio/ccwgroup.c      |    4 +-
 drivers/s390/cio/cmf.c           |    9 +++--
 drivers/s390/cio/css.c           |    4 +-
 drivers/s390/cio/device.c        |    6 ++--
 drivers/s390/cio/qdio_debug.c    |    6 ++-
 drivers/s390/net/qeth_l3_sys.c   |   10 ++---
 drivers/s390/scsi/zfcp_aux.c     |    4 +-
 drivers/s390/scsi/zfcp_sysfs.c   |   66 +++++++++++++++++++++++---------------
 drivers/tty/hvc/hvc_iucv.c       |    6 ++--
 13 files changed, 88 insertions(+), 68 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index ef86ad2..8d63a16 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -1143,12 +1143,14 @@ unsigned long regs_get_register(struct pt_regs *regs, unsigned int offset)
 
 int regs_query_register_offset(const char *name)
 {
-	unsigned long offset;
+	unsigned int offset;
+	int rv;
 
 	if (!name || *name != 'r')
 		return -EINVAL;
-	if (strict_strtoul(name + 1, 10, &offset))
-		return -EINVAL;
+	rv = kstrtouint(name + 1, 10, &offset);
+	if (rv < 0)
+		return rv;
 	if (offset >= NUM_GPRS)
 		return -EINVAL;
 	return offset;
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index f438d74..b1f5e5a 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -54,7 +54,6 @@ unsigned int __read_mostly vdso_enabled = 1;
 
 static int __init vdso_setup(char *s)
 {
-	unsigned long val;
 	int rc;
 
 	rc = 0;
@@ -63,7 +62,9 @@ static int __init vdso_setup(char *s)
 	else if (strncmp(s, "off", 4) == 0)
 		vdso_enabled = 0;
 	else {
-		rc = strict_strtoul(s, 0, &val);
+		unsigned long val;
+
+		rc = kstrtoul(s, 0, &val);
 		vdso_enabled = rc ? 0 : !!val;
 	}
 	return !rc;
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index cb6a67b..5a3c4b9 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -902,7 +902,7 @@ dasd_use_raw_store(struct device *dev, struct device_attribute *attr,
 	if (IS_ERR(devmap))
 		return PTR_ERR(devmap);
 
-	if ((strict_strtoul(buf, 10, &val) != 0) || val > 1)
+	if (kstrtoul(buf, 10, &val) != 0 || val > 1)
 		return -EINVAL;
 
 	spin_lock(&dasd_devmap_lock);
@@ -1159,20 +1159,18 @@ dasd_expires_store(struct device *dev, struct device_attribute *attr,
 {
 	struct dasd_device *device;
 	unsigned long val;
+	int rv;
+
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val == 0 || val > DASD_EXPIRES_MAX)
+		return -EINVAL;
 
 	device = dasd_device_from_cdev(to_ccwdev(dev));
 	if (IS_ERR(device))
 		return -ENODEV;
-
-	if ((strict_strtoul(buf, 10, &val) != 0) ||
-	    (val > DASD_EXPIRES_MAX) || val == 0) {
-		dasd_put_device(device);
-		return -EINVAL;
-	}
-
-	if (val)
-		device->default_expires = val;
-
+	device->default_expires = val;
 	dasd_put_device(device);
 	return count;
 }
diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index 7ad30e7..75a58dc 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -67,7 +67,6 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 				 void __user *buffer, size_t *count,
 				 loff_t *ppos)
 {
-	unsigned long val;
 	int len, rc;
 	char buf[3];
 
@@ -81,13 +80,16 @@ static int proc_handler_callhome(struct ctl_table *ctl, int write,
 		if (rc != 0)
 			return -EFAULT;
 	} else {
+		int val;
+
 		len = *count;
 		rc = copy_from_user(buf, buffer, sizeof(buf));
 		if (rc != 0)
 			return -EFAULT;
 		buf[sizeof(buf) - 1] = '\0';
-		if (strict_strtoul(buf, 0, &val) != 0)
-			return -EINVAL;
+		rc = kstrtoint(buf, 0, &val);
+		if (rc < 0)
+			return rc;
 		if (val != 0 && val != 1)
 			return -EINVAL;
 		callhome_enabled = val;
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 2864581..6f17efe 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -419,7 +419,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 {
 	struct ccwgroup_device *gdev;
 	struct ccwgroup_driver *gdrv;
-	unsigned long value;
+	int value;
 	int ret;
 
 	if (!dev->driver)
@@ -431,7 +431,7 @@ ccwgroup_online_store (struct device *dev, struct device_attribute *attr, const
 	if (!try_module_get(gdrv->owner))
 		return -EINVAL;
 
-	ret = strict_strtoul(buf, 0, &value);
+	ret = kstrtoint(buf, 0, &value);
 	if (ret)
 		goto out;
 
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 2985eb4..df48ea3 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -1181,10 +1181,10 @@ static ssize_t cmb_enable_store(struct device *dev,
 				size_t c)
 {
 	struct ccw_device *cdev;
+	int val;
 	int ret;
-	unsigned long val;
 
-	ret = strict_strtoul(buf, 16, &val);
+	ret = kstrtoint(buf, 16, &val);
 	if (ret)
 		return ret;
 
@@ -1197,8 +1197,11 @@ static ssize_t cmb_enable_store(struct device *dev,
 	case 1:
 		ret = enable_cmf(cdev);
 		break;
+	default:
+		ret = -EINVAL;
 	}
-
+	if (ret < 0)
+		return ret;
 	return c;
 }
 
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 24d8e97..fe92213 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -710,10 +710,10 @@ css_cm_enable_store(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
 	struct channel_subsystem *css = to_css(dev);
+	int val;
 	int ret;
-	unsigned long val;
 
-	ret = strict_strtoul(buf, 16, &val);
+	ret = kstrtoint(buf, 16, &val);
 	if (ret)
 		return ret;
 	mutex_lock(&css->mutex);
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index b7eaff9..f2edaa8 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -536,8 +536,8 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
-	int force, ret;
-	unsigned long i;
+	int force, i;
+	int ret;
 
 	if (!dev_fsm_final_state(cdev) &&
 	    cdev->private->state != DEV_STATE_DISCONNECTED)
@@ -555,7 +555,7 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 		ret = 0;
 	} else {
 		force = 0;
-		ret = strict_strtoul(buf, 16, &i);
+		ret = kstrtoint(buf, 16, &i);
 	}
 	if (ret)
 		goto out;
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index f8b03a6..ff6ca17 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -187,7 +187,7 @@ static ssize_t qperf_seq_write(struct file *file, const char __user *ubuf,
 	struct seq_file *seq = file->private_data;
 	struct qdio_irq *irq_ptr = seq->private;
 	struct qdio_q *q;
-	unsigned long val;
+	int val;
 	char buf[8];
 	int ret, i;
 
@@ -199,7 +199,7 @@ static ssize_t qperf_seq_write(struct file *file, const char __user *ubuf,
 		return -EFAULT;
 	buf[count] = 0;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoint(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -215,6 +215,8 @@ static ssize_t qperf_seq_write(struct file *file, const char __user *ubuf,
 	case 1:
 		irq_ptr->perf_stat_enabled = 1;
 		break;
+	default:
+		return -EINVAL;
 	}
 	return count;
 }
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 67cfa68..4e9cb7c 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -355,8 +355,8 @@ static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	int rc = 0;
-	unsigned long i;
+	int i;
+	int rc;
 
 	if (!card)
 		return -EINVAL;
@@ -371,11 +371,9 @@ static ssize_t qeth_l3_dev_sniffer_store(struct device *dev,
 		goto out;
 	}
 
-	rc = strict_strtoul(buf, 16, &i);
-	if (rc) {
-		rc = -EINVAL;
+	rc = kstrtoint(buf, 16, &i);
+	if (rc)
 		goto out;
-	}
 	switch (i) {
 	case 0:
 		card->options.sniffer = i;
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 51c666f..78a652a 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -102,11 +102,11 @@ static void __init zfcp_init_device_setup(char *devstr)
 	strncpy(busid, token, ZFCP_BUS_ID_SIZE);
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, (unsigned long long *) &wwpn))
+	if (!token || kstrtou64(token, 0, &wwpn))
 		goto err_out;
 
 	token = strsep(&str, ",");
-	if (!token || strict_strtoull(token, 0, (unsigned long long *) &lun))
+	if (!token || kstrtou64(token, 0, &lun))
 		goto err_out;
 
 	kfree(str_saved);
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index cdc4ff7..9de9b62 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -99,9 +99,13 @@ static ssize_t zfcp_sysfs_port_failed_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
-	unsigned long val;
+	int val;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &val) || val != 0)
+	rv = kstrtoint(buf, 0, &val);
+	if (rv < 0)
+		return rv;
+	if (val != 0)
 		return -EINVAL;
 
 	zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_RUNNING);
@@ -137,10 +141,14 @@ static ssize_t zfcp_sysfs_unit_failed_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
-	unsigned long val;
 	struct scsi_device *sdev;
+	int val;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &val) || val != 0)
+	rv = kstrtoint(buf, 0, &val);
+	if (rv < 0)
+		return rv;
+	if (val != 0)
 		return -EINVAL;
 
 	sdev = zfcp_unit_sdev(unit);
@@ -183,23 +191,23 @@ static ssize_t zfcp_sysfs_adapter_failed_store(struct device *dev,
 					       const char *buf, size_t count)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
-	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
-	unsigned long val;
-	int retval = 0;
+	struct zfcp_adapter *adapter;
+	int val;
+	int retval;
 
+	retval = kstrtoint(buf, 0, &val);
+	if (retval < 0)
+		return retval;
+	if (val != 0)
+		return -EINVAL;
+
+	adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	if (!adapter)
 		return -ENODEV;
-
-	if (strict_strtoul(buf, 0, &val) || val != 0) {
-		retval = -EINVAL;
-		goto out;
-	}
-
 	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"syafai2");
 	zfcp_erp_wait(adapter);
-out:
 	zfcp_ccw_adapter_put(adapter);
 	return retval ? retval : (ssize_t) count;
 }
@@ -232,22 +240,24 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
-	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
 	u64 wwpn;
-	int retval = -EINVAL;
+	int retval;
+
+	retval = kstrtou64(buf, 0, &wwpn);
+	if (retval < 0)
+		return retval;
 
+	adapter = zfcp_ccw_adapter_by_cdev(cdev);
 	if (!adapter)
 		return -ENODEV;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &wwpn))
-		goto out;
-
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
-	if (!port)
+	if (!port) {
+		retval = -EINVAL;
 		goto out;
-	else
-		retval = 0;
+	}
 
 	write_lock_irq(&adapter->port_list_lock);
 	list_del(&port->list);
@@ -289,9 +299,11 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	u64 fcp_lun;
+	int rv;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
-		return -EINVAL;
+	rv = kstrtou64(buf, 0, &fcp_lun);
+	if (rv < 0)
+		return rv;
 
 	if (zfcp_unit_add(port, fcp_lun))
 		return -EINVAL;
@@ -306,9 +318,11 @@ static ssize_t zfcp_sysfs_unit_remove_store(struct device *dev,
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	u64 fcp_lun;
+	int rv;
 
-	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
-		return -EINVAL;
+	rv =  kstrtou64(buf, 0, &fcp_lun);
+	if (rv < 0)
+		return rv;
 
 	if (zfcp_unit_remove(port, fcp_lun))
 		return -EINVAL;
diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index c3425bb..ade3355 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -94,7 +94,7 @@ static void hvc_iucv_msg_complete(struct iucv_path *, struct iucv_message *);
 
 
 /* Kernel module parameter: use one terminal device as default */
-static unsigned long hvc_iucv_devices = 1;
+static unsigned int hvc_iucv_devices = 1;
 
 /* Array of allocated hvc iucv tty lines... */
 static struct hvc_iucv_private *hvc_iucv_table[MAX_HVC_IUCV_LINES];
@@ -1227,7 +1227,7 @@ static int __init hvc_iucv_init(void)
 	}
 
 	if (hvc_iucv_devices > MAX_HVC_IUCV_LINES) {
-		pr_err("%lu is not a valid value for the hvc_iucv= "
+		pr_err("%u is not a valid value for the hvc_iucv= "
 			"kernel parameter\n", hvc_iucv_devices);
 		rc = -EINVAL;
 		goto out_error;
@@ -1328,7 +1328,7 @@ out_error:
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return strict_strtoul(val, 10, &hvc_iucv_devices);
+	 return kstrtouint(val, 10, &hvc_iucv_devices);
 }
 
 
-- 
1.7.3.4

