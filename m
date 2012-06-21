Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2FUK4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:56:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43353 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab2FUKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:55:37 -0400
Date: Thu, 21 Jun 2012 12:55:29 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [RFC 2/2] usb: gadget: Add USB Functions Gadget
In-reply-to: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1340276129-20023-3-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Demonstrate a USB gadget configured entirely through configfs.
This is a work in progress.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/Kconfig          |   11 +
 drivers/usb/gadget/Makefile         |    2 +
 drivers/usb/gadget/composite.c      |   27 +-
 drivers/usb/gadget/f_mass_storage.c |  675 +++++++++++++++++---------------
 drivers/usb/gadget/storage_common.c |  376 +++++++++++-------
 drivers/usb/gadget/usb_functions.c  |  731 +++++++++++++++++++++++++++++++++++
 6 files changed, 1349 insertions(+), 473 deletions(-)
 create mode 100644 drivers/usb/gadget/usb_functions.c

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index a167f37..40d21ba 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -556,6 +556,17 @@ choice
 
 # this first set of drivers all depend on bulk-capable hardware.
 
+config USB_FG
+	tristate "USB Functions Gadget (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && CONFIGFS_FS
+	help
+	  USB Functions Gadget is a device which aggregates a number of
+	  USB functions. The gadget is composed by userspace through a
+	  configfs interface, which enables specifying what USB
+	  configurations the gadget is composed of, what USB functions
+	  a USB configuration is composed of and enabling/disabling
+	  the gadget.
+
 config USB_ZERO
 	tristate "Gadget Zero (DEVELOPMENT)"
 	help
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 3bd3bd6..ff5ee74 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_USB_FUSB300)	+= fusb300_udc.o
 #
 # USB gadget drivers
 #
+g_usb_functions-y		:= usb_functions.o
 g_zero-y			:= zero.o
 g_audio-y			:= audio.o
 g_ether-y			:= ether.o
@@ -53,6 +54,7 @@ g_ncm-y				:= ncm.o
 g_acm_ms-y			:= acm_ms.o
 g_tcm_usb_gadget-y		:= tcm_usb_gadget.o
 
+obj-$(CONFIG_USB_FG)		+= g_usb_functions.o
 obj-$(CONFIG_USB_ZERO)		+= g_zero.o
 obj-$(CONFIG_USB_AUDIO)		+= g_audio.o
 obj-$(CONFIG_USB_ETH)		+= g_ether.o
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 390749b..ddf6390 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -40,29 +40,14 @@ static int (*composite_gadget_bind)(struct usb_composite_dev *cdev);
  */
 
 static ushort idVendor;
-module_param(idVendor, ushort, 0644);
-MODULE_PARM_DESC(idVendor, "USB Vendor ID");
-
 static ushort idProduct;
-module_param(idProduct, ushort, 0644);
-MODULE_PARM_DESC(idProduct, "USB Product ID");
-
 static ushort bcdDevice;
-module_param(bcdDevice, ushort, 0644);
-MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");
-
-static char *iManufacturer;
-module_param(iManufacturer, charp, 0644);
-MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");
-
-static char *iProduct;
-module_param(iProduct, charp, 0644);
-MODULE_PARM_DESC(iProduct, "USB Product string");
-
-static char *iSerialNumber;
-module_param(iSerialNumber, charp, 0644);
-MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
-
+static char i_manufacturer[256];
+static char *iManufacturer = i_manufacturer;
+static char i_product[256];
+static char *iProduct = i_product;
+static char i_serial[256];
+static char *iSerialNumber = i_serial;
 static char composite_manufacturer[50];
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f67b453..8c90d37 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -55,11 +55,6 @@
  *
  *	nluns		Number of LUNs function have (anywhere from 1
  *				to FSG_MAX_LUNS which is 8).
- *	luns		An array of LUN configuration values.  This
- *				should be filled for each LUN that
- *				function will include (ie. for "nluns"
- *				LUNs).  Each element of the array has
- *				the following fields:
  *	->filename	The path to the backing file for the LUN.
  *				Required if LUN is not marked as
  *				removable.
@@ -368,7 +363,6 @@ struct fsg_common {
 
 	unsigned int		nluns;
 	unsigned int		lun;
-	struct fsg_lun		*luns;
 	struct fsg_lun		*curlun;
 
 	unsigned int		bulk_out_maxpacket;
@@ -383,7 +377,6 @@ struct fsg_common {
 	u32			usb_amount_left;
 
 	unsigned int		can_stall:1;
-	unsigned int		free_storage_on_release:1;
 	unsigned int		phase_error:1;
 	unsigned int		short_packet_received:1;
 	unsigned int		bad_lun_okay:1;
@@ -405,6 +398,10 @@ struct fsg_common {
 	char inquiry_string[8 + 16 + 4 + 1];
 
 	struct kref		ref;
+
+	const char		*lun_name_format;
+
+	struct config_group	group;
 };
 
 struct fsg_config {
@@ -430,6 +427,10 @@ struct fsg_config {
 	u16 release;
 
 	char			can_stall;
+	struct usb_configuration *usb_config;
+
+	/* configfs-related */
+	struct config_group	group;
 };
 
 struct fsg_dev {
@@ -1460,8 +1461,7 @@ static int do_start_stop(struct fsg_common *common)
 
 	/* Simulate an unload/eject */
 	if (common->ops && common->ops->pre_eject) {
-		int r = common->ops->pre_eject(common, curlun,
-					       curlun - common->luns);
+		int r = common->ops->pre_eject(common, curlun, curlun->n_lun);
 		if (unlikely(r < 0))
 			return r;
 		else if (r)
@@ -1475,8 +1475,7 @@ static int do_start_stop(struct fsg_common *common)
 	down_read(&common->filesem);
 
 	return common->ops && common->ops->post_eject
-		? min(0, common->ops->post_eject(common, curlun,
-						 curlun - common->luns))
+		? min(0, common->ops->post_eject(common, curlun, curlun->n_lun))
 		: 0;
 }
 
@@ -2255,8 +2254,7 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	if (cbw->Lun >= FSG_MAX_LUNS || cbw->Flags & ~US_BULK_FLAG_IN ||
 			cbw->Length <= 0 || cbw->Length > MAX_COMMAND_SIZE) {
 		DBG(fsg, "non-meaningful CBW: lun = %u, flags = 0x%x, "
-				"cmdlen %u\n",
-				cbw->Lun, cbw->Flags, cbw->Length);
+		    "cmdlen %u\n", cbw->Lun, cbw->Flags, cbw->Length);
 
 		/*
 		 * We can do anything we want here, so let's stall the
@@ -2280,9 +2278,22 @@ static int received_cbw(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	if (common->data_size == 0)
 		common->data_dir = DATA_DIR_NONE;
 	common->lun = cbw->Lun;
-	if (common->lun >= 0 && common->lun < common->nluns)
-		common->curlun = &common->luns[common->lun];
-	else
+	if (common->lun >= 0 && common->lun < common->nluns) {
+		struct config_item *it;
+
+		mutex_lock(&common->group.cg_subsys->su_mutex);
+		list_for_each_entry(it, &common->group.cg_children, ci_entry) {
+			struct fsg_lun *lun;
+
+			lun = to_fsg_lun(it);
+			if (lun->n_lun == common->lun) {
+				common->curlun = lun;
+
+				break;
+			}
+		}
+		mutex_unlock(&common->group.cg_subsys->su_mutex);
+	} else
 		common->curlun = NULL;
 	common->tag = cbw->Tag;
 	return 0;
@@ -2342,6 +2353,7 @@ static int alloc_request(struct fsg_common *common, struct usb_ep *ep,
 /* Reset interface setting and re-init endpoint state (toggle etc). */
 static int do_set_interface(struct fsg_common *common, struct fsg_dev *new_fsg)
 {
+	struct config_item *item;
 	struct fsg_dev *fsg;
 	int i, rc = 0;
 
@@ -2426,8 +2438,14 @@ reset:
 	}
 
 	common->running = 1;
-	for (i = 0; i < common->nluns; ++i)
-		common->luns[i].unit_attention_data = SS_RESET_OCCURRED;
+	mutex_lock(&common->group.cg_subsys->su_mutex);
+	list_for_each_entry(item, &common->group.cg_children, ci_entry) {
+		struct fsg_lun *lun;
+
+		lun = to_fsg_lun(item);
+		lun->unit_attention_data = SS_RESET_OCCURRED;
+	}
+	mutex_unlock(&common->group.cg_subsys->su_mutex);
 	return rc;
 }
 
@@ -2458,7 +2476,6 @@ static void handle_exception(struct fsg_common *common)
 	int			i;
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
-	struct fsg_lun		*curlun;
 	unsigned int		exception_req_tag;
 
 	/*
@@ -2526,14 +2543,20 @@ static void handle_exception(struct fsg_common *common)
 	if (old_state == FSG_STATE_ABORT_BULK_OUT)
 		common->state = FSG_STATE_STATUS_PHASE;
 	else {
-		for (i = 0; i < common->nluns; ++i) {
-			curlun = &common->luns[i];
+		struct config_item *it;
+
+		mutex_lock(&common->group.cg_subsys->su_mutex);
+		list_for_each_entry(it, &common->group.cg_children, ci_entry) {
+			struct fsg_lun *curlun;
+
+			curlun = to_fsg_lun(it);
 			curlun->prevent_medium_removal = 0;
 			curlun->sense_data = SS_NO_SENSE;
 			curlun->unit_attention_data = SS_NO_SENSE;
 			curlun->sense_data_info = 0;
 			curlun->info_valid = 0;
 		}
+		mutex_unlock(&common->group.cg_subsys->su_mutex);
 		common->state = FSG_STATE_IDLE;
 	}
 	spin_unlock_irq(&common->lock);
@@ -2666,17 +2689,25 @@ static int fsg_main_thread(void *common_)
 
 	if (!common->ops || !common->ops->thread_exits
 	 || common->ops->thread_exits(common) < 0) {
-		struct fsg_lun *curlun = common->luns;
-		unsigned i = common->nluns;
+		struct list_head *cursor;
 
 		down_write(&common->filesem);
-		for (; i--; ++curlun) {
+
+		mutex_lock(&common->group.cg_subsys->su_mutex);
+		list_for_each_prev(cursor, &common->group.cg_children) {
+			struct config_item *item;
+			struct fsg_lun *curlun;
+
+			item = list_entry(cursor, struct config_item, ci_entry);
+
+			curlun = to_fsg_lun(item);
 			if (!fsg_lun_is_open(curlun))
 				continue;
 
 			fsg_lun_close(curlun);
 			curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
 		}
+		mutex_unlock(&common->group.cg_subsys->su_mutex);
 		up_write(&common->filesem);
 	}
 
@@ -2684,24 +2715,10 @@ static int fsg_main_thread(void *common_)
 	complete_and_exit(&common->thread_notifier, 0);
 }
 
-
-/*************************** DEVICE ATTRIBUTES ***************************/
-
-/* Write permission is checked per LUN in store_*() functions. */
-static DEVICE_ATTR(ro, 0644, fsg_show_ro, fsg_store_ro);
-static DEVICE_ATTR(nofua, 0644, fsg_show_nofua, fsg_store_nofua);
-static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
-
-
 /****************************** FSG COMMON ******************************/
 
 static void fsg_common_release(struct kref *ref);
 
-static void fsg_lun_release(struct device *dev)
-{
-	/* Nothing needs to be done */
-}
-
 static inline void fsg_common_get(struct fsg_common *common)
 {
 	kref_get(&common->ref);
@@ -2712,49 +2729,192 @@ static inline void fsg_common_put(struct fsg_common *common)
 	kref_put(&common->ref, fsg_common_release);
 }
 
-static struct fsg_common *fsg_common_init(struct fsg_common *common,
-					  struct usb_composite_dev *cdev,
-					  struct fsg_config *cfg)
+#define DIGITS		"0123456789"
+static struct config_item *alloc_fsg_lun(struct config_group *group,
+					 const char *name)
+{
+	struct fsg_common *common;
+	struct fsg_lun *lun;
+	struct config_item *item;
+	const char *p, *r, *s;
+	int n;
+	char buf[256];
+	unsigned long tmp;
+
+	common = group ? container_of(group, struct fsg_common, group) : NULL;
+	if (!common)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * TODO: some of the checks should be done when
+	 *common->lun_name_format is assigned
+	 */
+	/* check if first part of the name format is good */
+	p = strchr(common->lun_name_format, '%');
+	if (!p)
+		return ERR_PTR(-EINVAL);
+	if (*(p + 1) != 'd')
+		return ERR_PTR(-EINVAL);
+	n = p - common->lun_name_format;
+	/* check if the first part of the name matches the format */
+	if (strncmp(name, common->lun_name_format, n))
+		return ERR_PTR(-EINVAL);
+	/* interpret the %d part */
+	/*
+	 * TODO: improve. Now e.g. 01 and 1 are considered equal,
+	 * which means lun1 cannot be created after lun01 is created.
+	 * Probably lun01 (number parts with leading zeros) should be
+	 * disallowed.
+	 */
+	r = name + n;
+	s = strpbrk(r, DIGITS);
+	if (s != r)
+		return ERR_PTR(-EINVAL);
+	n = strspn(s, DIGITS);
+	while (n--) {
+		buf[s - r] = *s;
+		s++;
+	}
+	buf[s - r] = '\0';
+	tmp = simple_strtoul(buf, NULL, 10);
+	if (tmp >= common->nluns)
+		return ERR_PTR(-EINVAL);
+	/* check if the second part of the name meatches the format */
+	if (strcmp(p + 2, s))
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(item, &common->group.cg_children, ci_entry) {
+		lun = to_fsg_lun(item);
+		if (tmp == lun->n_lun)
+			return ERR_PTR(-EBUSY);
+	}
+
+	lun = kzalloc(sizeof *lun, GFP_KERNEL);
+	if (!lun)
+		return ERR_PTR(-ENOMEM);
+
+	lun->filesem = &common->filesem;
+	lun->n_lun = tmp;
+
+	config_item_init_type_name(&lun->item, name, &fsg_lun_item_type);
+
+	LINFO(lun, "LUN: %s%s%sfile: %s\n",
+	      lun->removable ? "removable " : "",
+	      lun->ro ? "read only " : "",
+	      lun->cdrom ? "CD-ROM " : "",
+	      "(no medium)");
+
+	return &lun->item;
+}
+
+static ssize_t fsg_common_show_luns(struct fsg_common *common, char *buf)
+{
+	return sprintf(buf, "%d\n", common->nluns);
+}
+
+static ssize_t fsg_common_store_luns(struct fsg_common *common, const char *buf,
+				     size_t count)
+{
+	struct config_item *function, *config, *gadget;
+	unsigned long tmp;
+	int ret;
+	char *p = (char *)buf;
+
+	function = common->group.cg_item.ci_parent;
+	if (!function)
+		return -EBUSY;
+
+	config = function->ci_parent;
+	if (!config)
+		return -EBUSY;
+
+	gadget = config->ci_parent;
+	if (!gadget)
+		return -EBUSY;
+
+	ret = gadget_verify_connected(gadget);
+	if (ret)
+		return ret;
+
+	tmp = simple_strtoul(p, &p, 10);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (tmp > 16383)
+		return -ERANGE;
+
+	common->nluns = tmp;
+
+	return count;
+}
+
+static ssize_t fsg_common_show_stall(struct fsg_common *common, char *buf)
+{
+	return sprintf(buf, "%d\n", common->can_stall);
+}
+
+static ssize_t fsg_common_store_stall(struct fsg_common *common,
+				      const char *buf, size_t count)
+{
+	if (buf[0] != '0' && buf[0] != '1')
+		return -EINVAL;
+
+	common->can_stall = buf[0] == '1';
+
+	return count;
+}
+
+CONFIGFS_ATTR_STRUCT(fsg_common);
+
+#define FSG_CONFIG_ATTR_RW(_name)					\
+static struct fsg_common_attribute fsg_common_##_name =			\
+	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, fsg_common_show_##_name,\
+			fsg_common_store_##_name)
+
+FSG_CONFIG_ATTR_RW(luns);
+FSG_CONFIG_ATTR_RW(stall);
+
+static struct configfs_attribute *fsg_common_attrs[] = {
+	&fsg_common_luns.attr,
+	&fsg_common_stall.attr,
+	NULL,
+};
+
+static struct fsg_common *to_fsg_common(struct config_item *item)
+{
+	return item ? container_of(to_config_group(item),
+				   struct fsg_common, group) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(fsg_common);
+
+static void fsg_common_release_item(struct config_item *item)
+{
+	kfree(to_fsg_common(item));
+}
+
+static struct configfs_item_operations fsg_common_item_ops = {
+	.show_attribute		= fsg_common_attr_show,
+	.store_attribute	= fsg_common_attr_store,
+	.release		= fsg_common_release_item,
+};
+
+static struct configfs_group_operations fsg_common_group_ops = {
+	.make_item	= alloc_fsg_lun,
+};
+
+static struct config_item_type fsg_common_item_type = {
+	.ct_attrs	= fsg_common_attrs,
+	.ct_item_ops	= &fsg_common_item_ops,
+	.ct_group_ops	= &fsg_common_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct fsg_common *fsg_common_init_cdev(struct fsg_common *common,
+					       struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
-	struct fsg_buffhd *bh;
-	struct fsg_lun *curlun;
-	struct fsg_lun_config *lcfg;
-	int nluns, i, rc;
-	char *pathbuf;
-
-	rc = fsg_num_buffers_validate();
-	if (rc != 0)
-		return ERR_PTR(rc);
-
-	/* Find out how many LUNs there should be */
-	nluns = cfg->nluns;
-	if (nluns < 1 || nluns > FSG_MAX_LUNS) {
-		dev_err(&gadget->dev, "invalid number of LUNs: %u\n", nluns);
-		return ERR_PTR(-EINVAL);
-	}
-
-	/* Allocate? */
-	if (!common) {
-		common = kzalloc(sizeof *common, GFP_KERNEL);
-		if (!common)
-			return ERR_PTR(-ENOMEM);
-		common->free_storage_on_release = 1;
-	} else {
-		memset(common, 0, sizeof *common);
-		common->free_storage_on_release = 0;
-	}
-
-	common->buffhds = kcalloc(fsg_num_buffers,
-				  sizeof *(common->buffhds), GFP_KERNEL);
-	if (!common->buffhds) {
-		if (common->free_storage_on_release)
-			kfree(common);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	common->ops = cfg->ops;
-	common->private_data = cfg->private_data;
+	int rc, i;
 
 	common->gadget = gadget;
 	common->ep0 = gadget->ep0;
@@ -2770,84 +2930,10 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		fsg_intf_desc.iInterface = rc;
 	}
 
-	/*
-	 * Create the LUNs, open their backing files, and register the
-	 * LUN devices in sysfs.
-	 */
-	curlun = kcalloc(nluns, sizeof(*curlun), GFP_KERNEL);
-	if (unlikely(!curlun)) {
-		rc = -ENOMEM;
-		goto error_release;
-	}
-	common->luns = curlun;
-
-	init_rwsem(&common->filesem);
-
-	for (i = 0, lcfg = cfg->luns; i < nluns; ++i, ++curlun, ++lcfg) {
-		curlun->cdrom = !!lcfg->cdrom;
-		curlun->ro = lcfg->cdrom || lcfg->ro;
-		curlun->initially_ro = curlun->ro;
-		curlun->removable = lcfg->removable;
-		curlun->dev.release = fsg_lun_release;
-		curlun->dev.parent = &gadget->dev;
-		/* curlun->dev.driver = &fsg_driver.driver; XXX */
-		dev_set_drvdata(&curlun->dev, &common->filesem);
-		dev_set_name(&curlun->dev,
-			     cfg->lun_name_format
-			   ? cfg->lun_name_format
-			   : "lun%d",
-			     i);
-
-		rc = device_register(&curlun->dev);
-		if (rc) {
-			INFO(common, "failed to register LUN%d: %d\n", i, rc);
-			common->nluns = i;
-			put_device(&curlun->dev);
-			goto error_release;
-		}
-
-		rc = device_create_file(&curlun->dev, &dev_attr_ro);
-		if (rc)
-			goto error_luns;
-		rc = device_create_file(&curlun->dev, &dev_attr_file);
-		if (rc)
-			goto error_luns;
-		rc = device_create_file(&curlun->dev, &dev_attr_nofua);
-		if (rc)
-			goto error_luns;
-
-		if (lcfg->filename) {
-			rc = fsg_lun_open(curlun, lcfg->filename);
-			if (rc)
-				goto error_luns;
-		} else if (!curlun->removable) {
-			ERROR(common, "no file given for LUN%d\n", i);
-			rc = -EINVAL;
-			goto error_luns;
-		}
-	}
-	common->nluns = nluns;
-
-	/* Data buffers cyclic list */
-	bh = common->buffhds;
-	i = fsg_num_buffers;
-	goto buffhds_first_it;
-	do {
-		bh->next = bh + 1;
-		++bh;
-buffhds_first_it:
-		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
-		if (unlikely(!bh->buf)) {
-			rc = -ENOMEM;
-			goto error_release;
-		}
-	} while (--i);
-	bh->next = common->buffhds;
-
 	/* Prepare inquiryString */
-	if (cfg->release != 0xffff) {
+	/*if (cfg->release != 0xffff) {
 		i = cfg->release;
-	} else {
+	} else */{
 		i = usb_gadget_controller_number(gadget);
 		if (i >= 0) {
 			i = 0x0300 + i;
@@ -2858,28 +2944,78 @@ buffhds_first_it:
 		}
 	}
 	snprintf(common->inquiry_string, sizeof common->inquiry_string,
-		 "%-8s%-16s%04x", cfg->vendor_name ?: "Linux",
+		 "%-8s%-16s%04x", "Linux",
 		 /* Assume product name dependent on the first LUN */
-		 cfg->product_name ?: (common->luns->cdrom
-				     ? "File-Stor Gadget"
-				     : "File-CD Gadget"),
-		 i);
+		 /* TODO: actually check first child's "cdrom" flag */
+			"USB mass storage", i);
 
 	/*
 	 * Some peripheral controllers are known not to be able to
 	 * halt bulk endpoints correctly.  If one of them is present,
 	 * disable stalls.
 	 */
-	common->can_stall = cfg->can_stall &&
+	common->can_stall = common->can_stall &&
 		!(gadget_is_at91(common->gadget));
 
+	return common;
+
+error_release:
+	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
+	/* Call fsg_common_release() directly, ref might be not initialised. */
+	fsg_common_release(&common->ref);
+	return ERR_PTR(rc);
+}
+
+static struct fsg_common *fsg_common_init(struct fsg_common *common)
+{
+	struct fsg_buffhd *bh;
+	int i, rc;
+
+	rc = fsg_num_buffers_validate();
+	if (rc != 0)
+		return ERR_PTR(rc);
+
+	/* TODO: move it somewhere else */
+	/*if (common->nluns < 1 || common->nluns > FSG_MAX_LUNS) {
+		printk("invalid number of LUNs: %u\n", nluns);
+		return ERR_PTR(-EINVAL);
+	}*/
+
+	common->buffhds = kcalloc(fsg_num_buffers,
+				  sizeof *(common->buffhds), GFP_KERNEL);
+	if (!common->buffhds)
+		return ERR_PTR(-ENOMEM);
+
+	common->ops = NULL;
+	common->private_data = NULL;
+
+	init_rwsem(&common->filesem);
+
+	common->lun_name_format = common->lun_name_format ?
+			common->lun_name_format : "lun%d";
+
+	/* Data buffers cyclic list */
+	bh = common->buffhds;
+	i = fsg_num_buffers;
+	goto buffhds_first_it;
+	do {
+		bh->next = bh + 1;
+		++bh;
+buffhds_first_it:
+		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
+		if (unlikely(!bh->buf)) {
+			rc = -ENOMEM;
+			goto error_release;
+		}
+	} while (--i);
+	bh->next = common->buffhds;
+
 	spin_lock_init(&common->lock);
 	kref_init(&common->ref);
 
 	/* Tell the thread to start working */
 	common->thread_task =
-		kthread_create(fsg_main_thread, common,
-			       cfg->thread_name ?: "file-storage");
+		kthread_create(fsg_main_thread, common, "file-storage");
 	if (IS_ERR(common->thread_task)) {
 		rc = PTR_ERR(common->thread_task);
 		goto error_release;
@@ -2888,39 +3024,15 @@ buffhds_first_it:
 	init_waitqueue_head(&common->fsg_wait);
 
 	/* Information */
-	INFO(common, FSG_DRIVER_DESC ", version: " FSG_DRIVER_VERSION "\n");
-	INFO(common, "Number of LUNs=%d\n", common->nluns);
+	pr_info(FSG_DRIVER_DESC ", version: " FSG_DRIVER_VERSION "\n");
+	pr_info("Number of LUNs=%d\n", common->nluns);
 
-	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
-	for (i = 0, nluns = common->nluns, curlun = common->luns;
-	     i < nluns;
-	     ++curlun, ++i) {
-		char *p = "(no medium)";
-		if (fsg_lun_is_open(curlun)) {
-			p = "(error)";
-			if (pathbuf) {
-				p = d_path(&curlun->filp->f_path,
-					   pathbuf, PATH_MAX);
-				if (IS_ERR(p))
-					p = "(error)";
-			}
-		}
-		LINFO(curlun, "LUN: %s%s%sfile: %s\n",
-		      curlun->removable ? "removable " : "",
-		      curlun->ro ? "read only " : "",
-		      curlun->cdrom ? "CD-ROM " : "",
-		      p);
-	}
-	kfree(pathbuf);
-
-	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
+	pr_info("I/O thread pid: %d\n", task_pid_nr(common->thread_task));
 
 	wake_up_process(common->thread_task);
 
 	return common;
 
-error_luns:
-	common->nluns = i + 1;
 error_release:
 	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
 	/* Call fsg_common_release() directly, ref might be not initialised. */
@@ -2928,9 +3040,38 @@ error_release:
 	return ERR_PTR(rc);
 }
 
+static struct config_group *alloc_fsg_common(struct config_group *group,
+					     const char *n)
+{
+	struct config_item *item;
+	struct fsg_common *common, *ret;
+
+	if (strcmp(name, "f_mass_storage"))
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(item, &group->cg_children, ci_entry)
+		if (!strcmp(name, item->ci_name))
+			return ERR_PTR(-EBUSY);
+
+	common = kzalloc(sizeof *common, GFP_KERNEL);
+	if (!common)
+		return ERR_PTR(-ENOMEM);
+
+	ret = fsg_common_init(common);
+	if (IS_ERR(ret)) {
+		kfree(common);
+		return (struct config_group *)ret;
+	}
+
+	config_group_init_type_name(&common->group, n, &fsg_common_item_type);
+
+	return &common->group;
+}
+
 static void fsg_common_release(struct kref *ref)
 {
 	struct fsg_common *common = container_of(ref, struct fsg_common, ref);
+	struct config_item *item;
 
 	/* If the thread isn't already dead, tell it to exit now */
 	if (common->state != FSG_STATE_TERMINATED) {
@@ -2938,20 +3079,9 @@ static void fsg_common_release(struct kref *ref)
 		wait_for_completion(&common->thread_notifier);
 	}
 
-	if (likely(common->luns)) {
-		struct fsg_lun *lun = common->luns;
-		unsigned i = common->nluns;
-
-		/* In error recovery common->nluns may be zero. */
-		for (; i; --i, ++lun) {
-			device_remove_file(&lun->dev, &dev_attr_nofua);
-			device_remove_file(&lun->dev, &dev_attr_ro);
-			device_remove_file(&lun->dev, &dev_attr_file);
-			fsg_lun_close(lun);
-			device_unregister(&lun->dev);
-		}
-
-		kfree(common->luns);
+	list_for_each_entry(item, &common->group.cg_children, ci_entry) {
+		struct fsg_lun *lun = to_fsg_lun(item);
+		fsg_lun_close(lun);
 	}
 
 	{
@@ -2963,11 +3093,8 @@ static void fsg_common_release(struct kref *ref)
 	}
 
 	kfree(common->buffhds);
-	if (common->free_storage_on_release)
-		kfree(common);
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
@@ -2983,6 +3110,8 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 		wait_event(common->fsg_wait, common->fsg != fsg);
 	}
 
+	common->curlun = NULL;
+	common->lun = 0;
 	fsg_common_put(common);
 	usb_free_descriptors(fsg->function.descriptors);
 	usb_free_descriptors(fsg->function.hs_descriptors);
@@ -3074,26 +3203,41 @@ static struct usb_gadget_strings *fsg_strings_array[] = {
 	NULL,
 };
 
-static int fsg_bind_config(struct usb_composite_dev *cdev,
-			   struct usb_configuration *c,
-			   struct fsg_common *common)
+static int fsg_bind_function(struct usb_configuration *c,
+			     struct config_item *item, void *data)
 {
 	struct fsg_dev *fsg;
+	struct usb_composite_dev *cdev;
+	struct fsg_common *common;
+	struct list_head *cursor;
+	int luns;
 	int rc;
 
+	common = to_fsg_common(item);
+
+	/* refuse bind if some luns are not yet created */
+	luns = 0;
+	list_for_each(cursor, &common->group.cg_children)
+		luns++;
+	if (luns != common->nluns)
+		return -EAGAIN;
+
 	fsg = kzalloc(sizeof *fsg, GFP_KERNEL);
 	if (unlikely(!fsg))
 		return -ENOMEM;
 
-	fsg->function.name        = FSG_DRIVER_DESC;
-	fsg->function.strings     = fsg_strings_array;
-	fsg->function.bind        = fsg_bind;
-	fsg->function.unbind      = fsg_unbind;
-	fsg->function.setup       = fsg_setup;
-	fsg->function.set_alt     = fsg_set_alt;
-	fsg->function.disable     = fsg_disable;
+	fsg->function.name	= FSG_DRIVER_DESC;
+	fsg->function.strings	= fsg_strings_array;
+	fsg->function.bind	= fsg_bind;
+	fsg->function.unbind	= fsg_unbind;
+	fsg->function.setup	= fsg_setup;
+	fsg->function.set_alt	= fsg_set_alt;
+	fsg->function.disable	= fsg_disable;
+	fsg->common		= common;
+
+	cdev = data;
+	fsg_common_init_cdev(fsg->common, cdev);
 
-	fsg->common               = common;
 	/*
 	 * Our caller holds a reference to common structure so we
 	 * don't have to be worry about it being freed until we return
@@ -3109,98 +3253,3 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 		fsg_common_get(fsg->common);
 	return rc;
 }
-
-
-/************************* Module parameters *************************/
-
-struct fsg_module_parameters {
-	char		*file[FSG_MAX_LUNS];
-	bool		ro[FSG_MAX_LUNS];
-	bool		removable[FSG_MAX_LUNS];
-	bool		cdrom[FSG_MAX_LUNS];
-	bool		nofua[FSG_MAX_LUNS];
-
-	unsigned int	file_count, ro_count, removable_count, cdrom_count;
-	unsigned int	nofua_count;
-	unsigned int	luns;	/* nluns */
-	bool		stall;	/* can_stall */
-};
-
-#define _FSG_MODULE_PARAM_ARRAY(prefix, params, name, type, desc)	\
-	module_param_array_named(prefix ## name, params.name, type,	\
-				 &prefix ## params.name ## _count,	\
-				 S_IRUGO);				\
-	MODULE_PARM_DESC(prefix ## name, desc)
-
-#define _FSG_MODULE_PARAM(prefix, params, name, type, desc)		\
-	module_param_named(prefix ## name, params.name, type,		\
-			   S_IRUGO);					\
-	MODULE_PARM_DESC(prefix ## name, desc)
-
-#define FSG_MODULE_PARAMETERS(prefix, params)				\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, file, charp,		\
-				"names of backing files or devices");	\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, ro, bool,		\
-				"true to force read-only");		\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, removable, bool,	\
-				"true to simulate removable media");	\
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, cdrom, bool,		\
-				"true to simulate CD-ROM instead of disk"); \
-	_FSG_MODULE_PARAM_ARRAY(prefix, params, nofua, bool,		\
-				"true to ignore SCSI WRITE(10,12) FUA bit"); \
-	_FSG_MODULE_PARAM(prefix, params, luns, uint,			\
-			  "number of LUNs");				\
-	_FSG_MODULE_PARAM(prefix, params, stall, bool,			\
-			  "false to prevent bulk stalls")
-
-static void
-fsg_config_from_params(struct fsg_config *cfg,
-		       const struct fsg_module_parameters *params)
-{
-	struct fsg_lun_config *lun;
-	unsigned i;
-
-	/* Configure LUNs */
-	cfg->nluns =
-		min(params->luns ?: (params->file_count ?: 1u),
-		    (unsigned)FSG_MAX_LUNS);
-	for (i = 0, lun = cfg->luns; i < cfg->nluns; ++i, ++lun) {
-		lun->ro = !!params->ro[i];
-		lun->cdrom = !!params->cdrom[i];
-		lun->removable = /* Removable by default */
-			params->removable_count <= i || params->removable[i];
-		lun->filename =
-			params->file_count > i && params->file[i][0]
-			? params->file[i]
-			: 0;
-	}
-
-	/* Let MSF use defaults */
-	cfg->lun_name_format = 0;
-	cfg->thread_name = 0;
-	cfg->vendor_name = 0;
-	cfg->product_name = 0;
-	cfg->release = 0xffff;
-
-	cfg->ops = NULL;
-	cfg->private_data = NULL;
-
-	/* Finalise */
-	cfg->can_stall = params->stall;
-}
-
-static inline struct fsg_common *
-fsg_common_from_params(struct fsg_common *common,
-		       struct usb_composite_dev *cdev,
-		       const struct fsg_module_parameters *params)
-	__attribute__((unused));
-static inline struct fsg_common *
-fsg_common_from_params(struct fsg_common *common,
-		       struct usb_composite_dev *cdev,
-		       const struct fsg_module_parameters *params)
-{
-	struct fsg_config cfg;
-	fsg_config_from_params(&cfg, params);
-	return fsg_common_init(common, cdev, &cfg);
-}
-
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 8081ca3..8ec7155 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -51,6 +51,7 @@
 
 
 #include <linux/usb/storage.h>
+#include <linux/configfs.h>
 #include <scsi/scsi.h>
 #include <asm/unaligned.h>
 
@@ -79,10 +80,9 @@
 #define VLDBG(lun, fmt, args...) do { } while (0)
 #endif /* VERBOSE_DEBUG */
 
-#define LDBG(lun, fmt, args...)   dev_dbg (&(lun)->dev, fmt, ## args)
-#define LERROR(lun, fmt, args...) dev_err (&(lun)->dev, fmt, ## args)
-#define LWARN(lun, fmt, args...)  dev_warn(&(lun)->dev, fmt, ## args)
-#define LINFO(lun, fmt, args...)  dev_info(&(lun)->dev, fmt, ## args)
+#define LERROR(lun, fmt, args...)  pr_err(fmt, ## args)
+#define LDBG(lun, fmt, args...)   pr_debug(fmt, ## args)
+#define LINFO(lun, fmt, args...)  pr_info(fmt, ## args)
 
 /*
  * Keep those macros in sync with those in
@@ -185,7 +185,6 @@ struct interrupt_data {
 
 /*-------------------------------------------------------------------------*/
 
-
 struct fsg_lun {
 	struct file	*filp;
 	loff_t		file_length;
@@ -206,16 +205,245 @@ struct fsg_lun {
 
 	unsigned int	blkbits;	/* Bits of logical block size of bound block device */
 	unsigned int	blksize;	/* logical block size of bound block device */
-	struct device	dev;
+
+	/* configfs-related section */
+	struct config_item	item;
+	struct rw_semaphore	*filesem;
+	unsigned int		n_lun;
 };
 
 #define fsg_lun_is_open(curlun)	((curlun)->filp != NULL)
 
-static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
+static ssize_t fsg_lun_show_ro(struct fsg_lun *curlun, char *buf)
 {
-	return container_of(dev, struct fsg_lun, dev);
+	return sprintf(buf, "%d\n", fsg_lun_is_open(curlun)
+				  ? curlun->ro
+				  : curlun->initially_ro);
 }
 
+static ssize_t fsg_lun_show_nofua(struct fsg_lun *curlun, char *buf)
+{
+	return sprintf(buf, "%u\n", curlun->nofua);
+}
+
+static ssize_t fsg_lun_show_file(struct fsg_lun *curlun, char *buf)
+{
+	struct rw_semaphore	*filesem = curlun->filesem;
+	char		*p;
+	ssize_t		rc;
+
+	down_read(filesem);
+	if (fsg_lun_is_open(curlun)) {	/* Get the complete pathname */
+		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
+		if (IS_ERR(p))
+			rc = PTR_ERR(p);
+		else {
+			rc = strlen(p);
+			memmove(buf, p, rc);
+			buf[rc] = '\n';		/* Add a newline */
+			buf[++rc] = 0;
+		}
+	} else {				/* No file, return 0 bytes */
+		*buf = 0;
+		rc = 0;
+	}
+	up_read(filesem);
+	return rc;
+}
+
+
+static ssize_t fsg_lun_store_ro(struct fsg_lun *curlun, const char *buf,
+				size_t count)
+{
+	ssize_t		rc;
+	struct rw_semaphore	*filesem = curlun->filesem;
+	unsigned	ro;
+
+	rc = kstrtouint(buf, 2, &ro);
+	if (rc)
+		return rc;
+
+	/*
+	 * Allow the write-enable status to change only while the
+	 * backing file is closed.
+	 */
+	down_read(filesem);
+	if (fsg_lun_is_open(curlun)) {
+		LDBG(curlun, "read-only status change prevented\n");
+		rc = -EBUSY;
+	} else {
+		curlun->ro = ro;
+		curlun->initially_ro = ro;
+		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
+		rc = count;
+	}
+	up_read(filesem);
+	return rc;
+}
+
+static int fsg_lun_fsync_sub(struct fsg_lun *curlun);
+
+static ssize_t fsg_lun_store_nofua(struct fsg_lun *curlun, const char *buf,
+				   size_t count)
+{
+	unsigned	nofua;
+	int		ret;
+
+	ret = kstrtouint(buf, 2, &nofua);
+	if (ret)
+		return ret;
+
+	/* Sync data when switching from async mode to sync */
+	if (!nofua && curlun->nofua)
+		fsg_lun_fsync_sub(curlun);
+
+	curlun->nofua = nofua;
+
+	return count;
+}
+
+static int fsg_lun_open(struct fsg_lun *curlun, const char *filename);
+static void fsg_lun_close(struct fsg_lun *curlun);
+
+static ssize_t fsg_lun_store_file(struct fsg_lun *curlun, const char *buf,
+				  size_t count)
+{
+	struct rw_semaphore	*filesem = curlun->filesem;
+	int		rc = 0;
+
+	if (curlun->prevent_medium_removal && fsg_lun_is_open(curlun)) {
+		LDBG(curlun, "eject attempt prevented\n");
+		return -EBUSY;				/* "Door is locked" */
+	}
+
+	/* Remove a trailing newline */
+	if (count > 0 && buf[count-1] == '\n')
+		((char *) buf)[count-1] = 0;		/* Ugh! */
+
+	/* Eject current medium */
+	down_write(filesem);
+	if (fsg_lun_is_open(curlun)) {
+		fsg_lun_close(curlun);
+		curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
+	}
+
+	/* Load new medium */
+	if (count > 0 && buf[0]) {
+		rc = fsg_lun_open(curlun, buf);
+		if (rc == 0)
+			curlun->unit_attention_data =
+					SS_NOT_READY_TO_READY_TRANSITION;
+	}
+	up_write(filesem);
+	return (rc < 0 ? rc : count);
+}
+
+static ssize_t fsg_lun_show_removable(struct fsg_lun *curlun, char *buf)
+{
+	return sprintf(buf, "%d\n", curlun->removable);
+}
+
+static ssize_t fsg_lun_store_removable(struct fsg_lun *curlun, const char *buf,
+				       size_t count)
+{
+	if (fsg_lun_is_open(curlun)) {
+		LDBG(curlun, "media type change prevented\n");
+		return -EBUSY;
+	}
+
+	if (buf[0] != '0' && buf[0] != '1')
+		return -EINVAL;
+
+	curlun->removable = buf[0] == '1';
+
+	return count;
+}
+
+CONFIGFS_ATTR_STRUCT(fsg_lun);
+
+#define FSG_LUN_ATTR_RW(_name)						\
+static struct fsg_lun_attribute fsg_lun_##_name =			\
+	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR, fsg_lun_show_##_name,	\
+			fsg_lun_store_##_name)
+
+FSG_LUN_ATTR_RW(ro);
+FSG_LUN_ATTR_RW(nofua);
+FSG_LUN_ATTR_RW(file);
+FSG_LUN_ATTR_RW(removable);
+
+static struct configfs_attribute *fsg_lun_attrs[] = {
+	&fsg_lun_ro.attr,
+	&fsg_lun_nofua.attr,
+	&fsg_lun_file.attr,
+	&fsg_lun_removable.attr,
+	NULL,
+};
+
+static struct fsg_lun *to_fsg_lun(struct config_item *item)
+{
+	return item ? container_of(item, struct fsg_lun, item) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(fsg_lun);
+
+static int (*gadget_verify_connected)(struct config_item *item);
+
+void fsg_set_gadget_verify_connected(int (*f)(struct config_item *item))
+{
+	gadget_verify_connected = f;
+}
+
+static int fsg_lun_check_rmdir(struct config_group *parent,
+			       struct config_item *item)
+{
+	/*
+	 * a lun item is a child of a f_mass_storage group, which is a child
+	 * of a function group, which is a child of a configuration group,
+	 * which is a child of a gadget group
+	 */
+	struct fsg_lun *lun;
+	struct config_item *function, *config, *gadget;
+
+	lun = to_fsg_lun(item);
+
+	if (fsg_lun_is_open(lun))
+		return -EBUSY;
+
+	if (!gadget_verify_connected || !parent)
+		return 0;
+
+	function = parent->cg_item.ci_parent;
+	if (!function)
+		return 0;
+
+	config = function->ci_parent;
+	if (!config)
+		return 0;
+
+	gadget = config->ci_parent;
+	if (!gadget)
+		return 0;
+
+	return gadget_verify_connected(gadget);
+}
+
+static void fsg_lun_item_release(struct config_item *item)
+{
+	kfree(to_fsg_lun(item));
+}
+
+static struct configfs_item_operations fsg_lun_ops = {
+	.show_attribute		= fsg_lun_attr_show,
+	.store_attribute	= fsg_lun_attr_store,
+	.check_rmdir		= fsg_lun_check_rmdir,
+	.release		= fsg_lun_item_release,
+};
+
+static struct config_item_type fsg_lun_item_type = {
+	.ct_attrs	= fsg_lun_attrs,
+	.ct_item_ops	= &fsg_lun_ops,
+	.ct_owner	= THIS_MODULE,
+};
 
 /* Big enough to hold our biggest descriptor */
 #define EP0_BUFSIZE	256
@@ -243,7 +471,7 @@ static inline int fsg_num_buffers_validate(void)
 	if (fsg_num_buffers >= 2 && fsg_num_buffers <= 4)
 		return 0;
 	pr_err("fsg_num_buffers %u is out of range (%d to %d)\n",
-	       fsg_num_buffers, 2 ,4);
+	       fsg_num_buffers, 2, 4);
 	return -EINVAL;
 }
 
@@ -768,133 +996,3 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
 /*-------------------------------------------------------------------------*/
 
 
-static ssize_t fsg_show_ro(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-
-	return sprintf(buf, "%d\n", fsg_lun_is_open(curlun)
-				  ? curlun->ro
-				  : curlun->initially_ro);
-}
-
-static ssize_t fsg_show_nofua(struct device *dev, struct device_attribute *attr,
-			      char *buf)
-{
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-
-	return sprintf(buf, "%u\n", curlun->nofua);
-}
-
-static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
-			     char *buf)
-{
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	char		*p;
-	ssize_t		rc;
-
-	down_read(filesem);
-	if (fsg_lun_is_open(curlun)) {	/* Get the complete pathname */
-		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
-		if (IS_ERR(p))
-			rc = PTR_ERR(p);
-		else {
-			rc = strlen(p);
-			memmove(buf, p, rc);
-			buf[rc] = '\n';		/* Add a newline */
-			buf[++rc] = 0;
-		}
-	} else {				/* No file, return 0 bytes */
-		*buf = 0;
-		rc = 0;
-	}
-	up_read(filesem);
-	return rc;
-}
-
-
-static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	ssize_t		rc;
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	unsigned	ro;
-
-	rc = kstrtouint(buf, 2, &ro);
-	if (rc)
-		return rc;
-
-	/*
-	 * Allow the write-enable status to change only while the
-	 * backing file is closed.
-	 */
-	down_read(filesem);
-	if (fsg_lun_is_open(curlun)) {
-		LDBG(curlun, "read-only status change prevented\n");
-		rc = -EBUSY;
-	} else {
-		curlun->ro = ro;
-		curlun->initially_ro = ro;
-		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
-		rc = count;
-	}
-	up_read(filesem);
-	return rc;
-}
-
-static ssize_t fsg_store_nofua(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	unsigned	nofua;
-	int		ret;
-
-	ret = kstrtouint(buf, 2, &nofua);
-	if (ret)
-		return ret;
-
-	/* Sync data when switching from async mode to sync */
-	if (!nofua && curlun->nofua)
-		fsg_lun_fsync_sub(curlun);
-
-	curlun->nofua = nofua;
-
-	return count;
-}
-
-static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	int		rc = 0;
-
-	if (curlun->prevent_medium_removal && fsg_lun_is_open(curlun)) {
-		LDBG(curlun, "eject attempt prevented\n");
-		return -EBUSY;				/* "Door is locked" */
-	}
-
-	/* Remove a trailing newline */
-	if (count > 0 && buf[count-1] == '\n')
-		((char *) buf)[count-1] = 0;		/* Ugh! */
-
-	/* Eject current medium */
-	down_write(filesem);
-	if (fsg_lun_is_open(curlun)) {
-		fsg_lun_close(curlun);
-		curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
-	}
-
-	/* Load new medium */
-	if (count > 0 && buf[0]) {
-		rc = fsg_lun_open(curlun, buf);
-		if (rc == 0)
-			curlun->unit_attention_data =
-					SS_NOT_READY_TO_READY_TRANSITION;
-	}
-	up_write(filesem);
-	return (rc < 0 ? rc : count);
-}
diff --git a/drivers/usb/gadget/usb_functions.c b/drivers/usb/gadget/usb_functions.c
new file mode 100644
index 0000000..8d4b9ae
--- /dev/null
+++ b/drivers/usb/gadget/usb_functions.c
@@ -0,0 +1,731 @@
+/*
+ * USB Functions Gadget
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/configfs.h>
+
+/*
+ * Directly including C files for experimental version
+ *
+ */
+#include "composite.c"
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+
+/*
+ * Supported functions
+ */
+#include "f_mass_storage.c"
+
+/*-------------------------------------------------------------------------*/
+
+#define DRIVER_DESC		"USB Functions Gadget"
+#define DRIVER_VERSION		"Pawelek"
+
+#define VENDOR_ID		0x1d6b /* Linux Foundation */
+#define PRODUCT_ID		0x0108
+#define BCD_DEVICE		0xffff
+
+/*-----------  helper functions and macros for configfs support  ----------*/
+
+#define UFG_STR_LEN		256
+
+#define UFG_SHOW_USHORT_ATTR(_name, _type, _member)			\
+static ssize_t _type##_show_##_name(struct _type *grp, char *buf)	\
+{									\
+	return sprintf(buf, "%d\n", grp->_member);			\
+}
+
+#define UFG_STORE_USHORT_ATTR(_name, _type, _member)			\
+static ssize_t _type##_store_##_name(struct _type *grp,			\
+				     const char *buf, size_t count)	\
+{									\
+	grp->_member = (ushort)ufg_read_twobyte(buf);			\
+	grp->_member##_set = true;					\
+									\
+	return count;							\
+}
+
+#define UFG_SHOW_STR_ATTR(_name, _type, _member)			\
+static ssize_t _type##_show_##_name(struct _type *grp, char *buf)	\
+{									\
+	return strlcpy(buf, grp->_member, UFG_STR_LEN);			\
+}
+
+#define UFG_STORE_STR_ATTR(_name, _type, _member)			\
+static ssize_t _type##_store_##_name(struct _type *grp,			\
+				      const char *buf, size_t count)	\
+{									\
+	strlcpy(grp->_member, buf, UFG_STR_LEN);			\
+	grp->_member##_set = true;					\
+									\
+	return count;							\
+}
+
+#define UFG_ATTR_RW(_name, _attr, _type)				\
+static struct _type##_attribute _type##_##_name =			\
+	__CONFIGFS_ATTR(_attr, S_IRUGO | S_IWUSR, _type##_show_##_name,	\
+			_type##_store_##_name)
+
+#define UFG_ATTR_RO(_name, _attr, _type)				\
+static struct _type##_attribute _type##_##_name =			\
+	__CONFIGFS_ATTR(_attr, S_IRUGO | S_IWUSR, _type##_show_##_name, NULL)
+
+typedef struct config_group *(*make_group_fn)(struct config_group *group,
+					      const char *name);
+typedef int (*bind_function_fn)(struct usb_configuration *c,
+				struct config_item *item, void *data);
+
+static ssize_t ufg_read_twobyte(const char *buf)
+{
+	unsigned long tmp;
+	char *p = (char *)buf;
+
+	tmp = simple_strtoul(p, &p, 10);
+	if (!p || (*p && (*p != '\n')))
+		return -EINVAL;
+
+	if (tmp > 16383)
+		return -ERANGE;
+
+	return tmp;
+}
+
+/*--------------------  handling of dynamic make_group --------------------*/
+
+struct ufg_fn {
+	const char		*name;
+	struct config_group	*group;
+	make_group_fn		make_group;
+	bind_function_fn	bind;
+};
+
+static struct ufg_fn f_mass_storage = {
+	.name		= "f_mass_storage",
+	.make_group	= alloc_fsg_common,
+	.bind		= fsg_bind_function,
+};
+
+static struct ufg_fn *available_functions[] = {
+	&f_mass_storage,
+	NULL,
+};
+
+struct ufg_fn *ufg_fn_by_name(const char *name)
+{
+	struct ufg_fn **f;
+
+	f = available_functions;
+
+	while (*f) {
+		if (sysfs_streq((*f)->name, name))
+			return *f;
+		f++;
+	}
+
+	return NULL;
+}
+
+struct ufg_fn *ufg_fn_by_group(struct config_group *group)
+{
+	struct ufg_fn **f;
+
+	f = available_functions;
+
+	while (*f) {
+		if ((*f)->group == group)
+			return *f;
+		f++;
+	}
+
+	return NULL;
+}
+
+static struct config_group *ufg_make_function_subgroup(
+	struct config_group *group, const char *name)
+{
+	struct ufg_fn *fn;
+
+	fn = ufg_fn_by_name(name);
+	if (!fn || !fn->make_group)
+		return ERR_PTR(-EINVAL);
+
+	if (fn->group)
+		return ERR_PTR(-EBUSY);
+
+	fn->group = group;
+
+	return fn->make_group(group, name);
+}
+
+/*------------------  USB function-level configfs group  ------------------*/
+
+#define UFG_FUNC_NAME_LEN	UFG_STR_LEN
+
+struct ufg_function_grp {
+	/* This group needs children */
+	struct config_group group;
+
+	/* attributes' values */
+	char name[UFG_FUNC_NAME_LEN];
+};
+
+UFG_SHOW_STR_ATTR(name, ufg_function_grp, name);
+
+static ssize_t ufg_function_grp_store_name(struct ufg_function_grp *grp,
+					   const char *buf, size_t count)
+{
+	struct ufg_fn *fn;
+
+	fn = ufg_fn_by_name(buf);
+	if (!fn)
+		return -EINVAL;
+
+	strlcpy(grp->name, buf, UFG_FUNC_NAME_LEN);
+
+	return count;
+}
+
+CONFIGFS_ATTR_STRUCT(ufg_function_grp);
+
+UFG_ATTR_RW(name, name, ufg_function_grp);
+
+static struct configfs_attribute *ufg_function_grp_attrs[] = {
+	&ufg_function_grp_name.attr,
+	NULL,
+};
+
+static struct ufg_function_grp *to_ufg_function_grp(struct config_item *item)
+{
+	return item ? container_of(to_config_group(item),
+				   struct ufg_function_grp, group) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(ufg_function_grp);
+
+static void ufg_function_grp_release(struct config_item *item)
+{
+	kfree(to_ufg_function_grp(item));
+}
+
+
+static struct configfs_item_operations ufg_function_grp_item_ops = {
+	.show_attribute		= ufg_function_grp_attr_show,
+	.store_attribute	= ufg_function_grp_attr_store,
+	.release		= ufg_function_grp_release,
+};
+
+static struct configfs_group_operations ufg_function_grp_group_ops = {
+	.make_group	= ufg_make_function_subgroup,
+};
+
+static struct config_item_type ufg_function_grp_type = {
+	.ct_attrs	= ufg_function_grp_attrs,
+	.ct_item_ops	= &ufg_function_grp_item_ops,
+	.ct_group_ops	= &ufg_function_grp_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct config_group *make_ufg_function(struct config_group *group,
+					      const char *name)
+{
+	struct ufg_function_grp *function;
+
+	function = kzalloc(sizeof *function, GFP_KERNEL);
+	if (!function)
+		return ERR_PTR(-ENOMEM);
+
+	config_group_init_type_name(&function->group, name,
+				    &ufg_function_grp_type);
+
+	return &function->group;
+}
+
+/*---------------  USB configuration-level configfs group  ----------------*/
+
+struct ufg_config_grp {
+	/* This group needs children */
+	struct config_group group;
+
+	bool	added;
+
+	/* attributes' values */
+	ushort	max_power;
+	bool	max_power_set;
+	ushort	num_interfaces;
+	ushort	conf_number;
+};
+
+UFG_SHOW_USHORT_ATTR(max_power, ufg_config_grp, max_power);
+UFG_STORE_USHORT_ATTR(max_power, ufg_config_grp, max_power);
+
+UFG_SHOW_USHORT_ATTR(num_interfaces, ufg_config_grp, num_interfaces);
+
+UFG_SHOW_USHORT_ATTR(conf_number, ufg_config_grp, conf_number);
+
+CONFIGFS_ATTR_STRUCT(ufg_config_grp);
+
+UFG_ATTR_RW(max_power, maximum_power, ufg_config_grp);
+
+UFG_ATTR_RO(num_interfaces, number_of_interfaces, ufg_config_grp);
+
+UFG_ATTR_RO(conf_number, configuration_number, ufg_config_grp);
+
+static struct configfs_attribute *ufg_config_grp_attrs[] = {
+	&ufg_config_grp_max_power.attr,
+	&ufg_config_grp_num_interfaces.attr,
+	&ufg_config_grp_conf_number.attr,
+	NULL,
+};
+
+static struct ufg_config_grp *to_ufg_config_grp(struct config_item *item)
+{
+	return item ? container_of(to_config_group(item), struct ufg_config_grp,
+				   group) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(ufg_config_grp);
+
+static void ufg_config_grp_release(struct config_item *item)
+{
+	kfree(to_ufg_config_grp(item));
+}
+
+static struct configfs_item_operations ufg_config_grp_item_ops = {
+	.show_attribute		= ufg_config_grp_attr_show,
+	.store_attribute	= ufg_config_grp_attr_store,
+	.release		= ufg_config_grp_release,
+};
+
+static struct configfs_group_operations ufg_config_grp_group_ops = {
+	.make_group	= make_ufg_function,
+};
+
+static struct config_item_type ufg_config_grp_type = {
+	.ct_attrs	= ufg_config_grp_attrs,
+	.ct_item_ops	= &ufg_config_grp_item_ops,
+	.ct_group_ops	= &ufg_config_grp_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct config_group *make_ufg_config(struct config_group *group,
+					   const char *name)
+{
+	struct ufg_config_grp *config;
+
+	config = kzalloc(sizeof *config, GFP_KERNEL);
+	if (!config)
+		return ERR_PTR(-ENOMEM);
+
+	config_group_init_type_name(&config->group, name, &ufg_config_grp_type);
+
+	return &config->group;
+}
+
+/*------------------  USB gadget-level configfs group  --------------------*/
+
+#define UFG_NAME_LEN		UFG_STR_LEN
+
+struct ufg_gadget_grp {
+	/* This group needs children */
+	struct config_group group;
+
+	/* attributes' values */
+	ushort	idVendor;
+	bool	idVendor_set;
+	ushort	idProduct;
+	bool	idProduct_set;
+	ushort	bcdDevice;
+	bool	bcdDevice_set;
+	char	iManufacturer[UFG_NAME_LEN];
+	bool	iManufacturer_set;
+	char	iProduct[UFG_NAME_LEN];
+	bool	iProduct_set;
+	char	iSerialNumber[UFG_NAME_LEN];
+	bool	iSerialNumber_set;
+	bool	connect;
+};
+
+static int ufg_gadget_bind(struct ufg_gadget_grp *group);
+
+UFG_SHOW_USHORT_ATTR(id_vendor, ufg_gadget_grp, idVendor);
+UFG_STORE_USHORT_ATTR(id_vendor, ufg_gadget_grp, idVendor);
+
+UFG_SHOW_USHORT_ATTR(id_product, ufg_gadget_grp, idProduct);
+UFG_STORE_USHORT_ATTR(id_product, ufg_gadget_grp, idProduct);
+
+UFG_SHOW_USHORT_ATTR(bcd_device, ufg_gadget_grp, bcdDevice);
+UFG_STORE_USHORT_ATTR(bcd_device, ufg_gadget_grp, bcdDevice);
+
+UFG_SHOW_STR_ATTR(i_manufacturer, ufg_gadget_grp, iManufacturer);
+UFG_STORE_STR_ATTR(i_manufacturer, ufg_gadget_grp, iManufacturer);
+
+UFG_SHOW_STR_ATTR(i_product, ufg_gadget_grp, iProduct);
+UFG_STORE_STR_ATTR(i_product, ufg_gadget_grp, iProduct);
+
+UFG_SHOW_STR_ATTR(i_serial_number, ufg_gadget_grp, iSerialNumber);
+UFG_STORE_STR_ATTR(i_serial_number, ufg_gadget_grp, iSerialNumber);
+
+UFG_SHOW_USHORT_ATTR(connect, ufg_gadget_grp, connect);
+static ssize_t ufg_gadget_grp_store_connect(struct ufg_gadget_grp *grp,
+					    const char *buf, size_t count)
+{
+	bool connect;
+	int ret;
+
+	if (buf[0] != '0' && buf[0] != '1')
+		return -EINVAL;
+
+	connect = grp->connect;
+	grp->connect = buf[0] == '1';
+
+	if (connect && grp->connect)
+		return -EBUSY;
+
+	ret = ufg_gadget_bind(grp);
+	if (ret) {
+		grp->connect = connect;
+		return ret;
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR_STRUCT(ufg_gadget_grp);
+
+UFG_ATTR_RW(id_vendor, idVendor, ufg_gadget_grp);
+UFG_ATTR_RW(id_product, idProduct, ufg_gadget_grp);
+UFG_ATTR_RW(bcd_device, bcdDevice, ufg_gadget_grp);
+UFG_ATTR_RW(i_manufacturer, iManufacturer, ufg_gadget_grp);
+UFG_ATTR_RW(i_product, iProduct, ufg_gadget_grp);
+UFG_ATTR_RW(i_serial_number, iSerialNumber, ufg_gadget_grp);
+UFG_ATTR_RW(connect, connect, ufg_gadget_grp);
+
+static struct configfs_attribute *ufg_gadget_grp_attrs[] = {
+	&ufg_gadget_grp_id_vendor.attr,
+	&ufg_gadget_grp_id_product.attr,
+	&ufg_gadget_grp_bcd_device.attr,
+	&ufg_gadget_grp_i_manufacturer.attr,
+	&ufg_gadget_grp_i_product.attr,
+	&ufg_gadget_grp_i_serial_number.attr,
+	&ufg_gadget_grp_connect.attr,
+	NULL,
+};
+
+static struct ufg_gadget_grp *to_ufg_gadget_grp(struct config_item *item)
+{
+	return item ? container_of(to_config_group(item), struct ufg_gadget_grp,
+				   group) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(ufg_gadget_grp);
+
+static void ufg_gadget_grp_release(struct config_item *item)
+{
+	kfree(to_ufg_gadget_grp(item));
+}
+
+static struct configfs_item_operations ufg_gadget_grp_item_ops = {
+	.show_attribute		= ufg_gadget_grp_attr_show,
+	.store_attribute	= ufg_gadget_grp_attr_store,
+	.release		= ufg_gadget_grp_release,
+};
+
+static struct configfs_group_operations ufg_gadget_grp_group_ops = {
+	.make_group	= make_ufg_config,
+};
+
+static struct config_item_type ufg_gadget_grp_type = {
+	.ct_attrs	= ufg_gadget_grp_attrs,
+	.ct_item_ops	= &ufg_gadget_grp_item_ops,
+	.ct_group_ops	= &ufg_gadget_grp_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct config_group *make_ufg_gadget(struct config_group *group,
+					   const char *name)
+{
+	struct ufg_gadget_grp *gadget;
+
+	gadget = kzalloc(sizeof *gadget, GFP_KERNEL);
+	if (!gadget)
+		return ERR_PTR(-ENOMEM);
+
+	config_group_init_type_name(&gadget->group, name, &ufg_gadget_grp_type);
+
+	return &gadget->group;
+}
+
+static int ufg_gadget_grp_check_connected(struct config_item *item)
+{
+	struct ufg_gadget_grp *gadget;
+
+	gadget = to_ufg_gadget_grp(item);
+
+	if (gadget)
+		return gadget->connect ? -EBUSY : 0;
+
+	return 0;
+}
+
+/*-------------------  configfs subsystem for ufg  ------------------------*/
+
+#define UFG_FUNC_NAMES_BUF_LEN	UFG_STR_LEN
+
+struct ufg_subsys {
+	/* This is the root of the subsystem */
+	struct configfs_subsystem subsys;
+
+	/* attributes' values */
+	char	avail_func[UFG_FUNC_NAMES_BUF_LEN];
+};
+
+static ssize_t ufg_subsys_show_avail_func(struct ufg_subsys *grp, char *buf)
+{
+	return sprintf(buf, "%s\n", grp->avail_func);
+}
+
+CONFIGFS_ATTR_STRUCT(ufg_subsys);
+
+UFG_ATTR_RO(avail_func, available_functions, ufg_subsys);
+
+static struct configfs_attribute *ufg_subsys_attrs[] = {
+	&ufg_subsys_avail_func.attr,
+	NULL,
+};
+
+static struct ufg_subsys *to_ufg_subsys(struct config_item *item)
+{
+	return item ? container_of(to_configfs_subsystem(to_config_group(item)),
+				   struct ufg_subsys, subsys) : NULL;
+}
+
+CONFIGFS_ATTR_OPS(ufg_subsys);
+
+static struct configfs_item_operations ufg_subsys_item_ops = {
+	.show_attribute = ufg_subsys_attr_show,
+};
+
+static struct configfs_group_operations ufg_subsys_group_ops = {
+	.make_group	= make_ufg_gadget,
+};
+
+static struct config_item_type ufg_subsys_type = {
+	.ct_attrs	= ufg_subsys_attrs,
+	.ct_item_ops	= &ufg_subsys_item_ops,
+	.ct_group_ops	= &ufg_subsys_group_ops,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct ufg_subsys ufg_subsystem = {
+	.subsys = {
+		.su_group = {
+			.cg_item = {
+				.ci_namebuf	= "usb-function-gadget",
+				.ci_type	= &ufg_subsys_type,
+			},
+		},
+	},
+};
+
+/*-------------------  USB composite handling code  -----------------------*/
+
+static struct usb_device_descriptor ufg_device_desc = {
+	.bLength              = sizeof(ufg_device_desc),
+	.bDescriptorType      = USB_DT_DEVICE,
+	.bcdUSB               = __constant_cpu_to_le16(0x0200),
+	.bDeviceClass         = USB_CLASS_PER_INTERFACE,
+	.idVendor             = __constant_cpu_to_le16(VENDOR_ID),
+	.idProduct            = __constant_cpu_to_le16(PRODUCT_ID),
+	.bcdDevice            = __constant_cpu_to_le16(BCD_DEVICE),
+	.bNumConfigurations   = 1,
+};
+
+static struct usb_composite_driver ufg_driver = {
+	.name		= "usb_function_gadget",
+	.dev		= &ufg_device_desc,
+	.iProduct	= DRIVER_DESC,
+	.needs_serial	= 1,
+};
+
+static void ufg_unbind_config(struct usb_configuration *c);
+
+static struct usb_configuration ufg_config_driver = {
+	.label		= "ufg",
+	.unbind		= ufg_unbind_config,
+	.bConfigurationValue = 1,
+	.bmAttributes	= USB_CONFIG_ATT_ONE | USB_CONFIG_ATT_SELFPOWER,
+	.bMaxPower	= 0xFA, /* 500ma */
+};
+
+static struct usb_composite_dev *_cdev;
+
+static int ufg_bind(struct usb_composite_dev *cdev)
+{
+	struct usb_gadget	*gadget = cdev->gadget;
+	int			gcnum;
+
+	_cdev = cdev;
+	/*
+	 * Start disconnected. Userspace will connect the gadget once
+	 * it is done configuring the functions.
+	 */
+	usb_gadget_disconnect(gadget);
+
+	gcnum = usb_gadget_controller_number(gadget);
+	if (gcnum >= 0)
+		ufg_device_desc.bcdDevice = cpu_to_le16(0x0200 + gcnum);
+	else {
+		pr_warn("%s: controller '%s' not recognized\n",
+			DRIVER_DESC, gadget->name);
+		ufg_device_desc.bcdDevice = __constant_cpu_to_le16(0x9999);
+	}
+
+	usb_gadget_set_selfpowered(gadget);
+
+	pr_info("%s: version: %s\n", DRIVER_DESC, DRIVER_VERSION);
+
+	return 0;
+}
+
+static struct usb_configuration *_config;
+
+static int ufg_bind_config(struct usb_configuration *c)
+{
+	_config = c;
+
+	return 0;
+}
+
+static void ufg_unbind_config(struct usb_configuration *c)
+{
+}
+
+static void update_ufg_driver(struct ufg_gadget_grp *ufg_gadget)
+{
+	if (ufg_gadget->idVendor_set)
+		idVendor = __constant_cpu_to_le16(ufg_gadget->idVendor);
+	if (ufg_gadget->idProduct_set)
+		idProduct = __constant_cpu_to_le16(ufg_gadget->idProduct);
+	if (ufg_gadget->bcdDevice_set)
+		bcdDevice = __constant_cpu_to_le16(ufg_gadget->bcdDevice);
+	if (ufg_gadget->iManufacturer_set)
+		strlcpy(iManufacturer, ufg_gadget->iManufacturer, UFG_NAME_LEN);
+	if (ufg_gadget->iProduct_set)
+		strlcpy(iProduct, ufg_gadget->iProduct, UFG_NAME_LEN);
+	if (ufg_gadget->iSerialNumber_set)
+		strlcpy(iSerialNumber, ufg_gadget->iSerialNumber, UFG_NAME_LEN);
+}
+
+static int ufg_gadget_bind(struct ufg_gadget_grp *ufg_gadget)
+{
+	struct config_item *ci;
+	int r;
+
+	if (!ufg_gadget->connect) {
+		usb_composite_unregister(&ufg_driver);
+		return 0;
+	}
+
+	update_ufg_driver(ufg_gadget);
+	r = usb_composite_probe(&ufg_driver, ufg_bind);
+
+	if (r)
+		return r;
+
+	list_for_each_entry(ci, &ufg_gadget->group.cg_children, ci_entry) {
+		struct ufg_config_grp *config;
+		struct config_item *f;
+
+		config = to_ufg_config_grp(ci);
+
+		ufg_config_driver.bMaxPower = config->max_power;
+		r = usb_add_config(_cdev, &ufg_config_driver, ufg_bind_config);
+		if (r)
+			goto unbind;
+		config->added = true;
+
+		list_for_each_entry(f, &config->group.cg_children, ci_entry) {
+			struct ufg_fn *ufg_fn;
+
+			ufg_fn = ufg_fn_by_group(to_config_group(f));
+
+			if (ufg_fn && ufg_fn->bind) {
+				struct config_item *subgroup;
+				struct config_group *group;
+
+				group = to_config_group(f);
+				subgroup = container_of(group->cg_children.next,
+						struct config_item, ci_entry);
+				r = ufg_fn->bind(_config, subgroup, _cdev);
+				if (r)
+					goto unbind;
+			}
+		}
+
+	}
+
+	return 0;
+
+unbind:
+	list_for_each_entry(ci, &ufg_gadget->group.cg_children, ci_entry) {
+		struct ufg_config_grp *config;
+
+		config = to_ufg_config_grp(ci);
+		if (!config->added)
+			continue;
+
+		usb_remove_config(_cdev, &ufg_config_driver);
+		config->added = false;
+	}
+	usb_composite_unregister(&ufg_driver);
+	return r;
+}
+
+
+/*----------------------  general module stuff  ---------------------------*/
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Andrzej Pietrasiewicz");
+MODULE_LICENSE("GPL");
+
+static int __init ufg_init(void)
+{
+	int ret;
+
+	fsg_set_gadget_verify_connected(ufg_gadget_grp_check_connected);
+
+	config_group_init(&ufg_subsystem.subsys.su_group);
+	mutex_init(&ufg_subsystem.subsys.su_mutex);
+	ret = configfs_register_subsystem(&ufg_subsystem.subsys);
+	if (ret)
+		goto unregister;
+
+	return 0;
+
+unregister:
+	configfs_unregister_subsystem(&ufg_subsystem.subsys);
+
+	return ret;
+}
+module_init(ufg_init);
+
+static void ufg_cleanup(void)
+{
+	configfs_unregister_subsystem(&ufg_subsystem.subsys);
+}
+module_exit(ufg_cleanup);
-- 
1.7.0.4

