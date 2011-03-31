Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab1CaOx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:53:26 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57454 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab1CaOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 21/21] staging:iio: rip out scan_el attributes.  Now handled as iio_dev_attrs like everything else.
Date: Thu, 31 Mar 2011 15:54:15 +0100
Message-Id: <1301583255-28468-22-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers have no need to use this functionality any more and we save a lot of
code by getting rid of it.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/industrialio-ring.c |  101 ++++++++-----------------------
 drivers/staging/iio/ring_generic.h      |   24 -------
 2 files changed, 26 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 07d64bc..815be33 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -193,53 +193,6 @@ static ssize_t iio_show_fixed_type(struct device *dev,
 		       this_attr->c->scan_type.shift);
 }
 
-static int __iio_add_chan_scan_elattr(const char *postfix,
-				      const char *group,
-				      struct iio_chan_spec *chan,
-				      struct device *dev,
-				      struct list_head *attr_list)
-{
-	int ret;
-	struct iio_scan_el *scan_el;
-
-	scan_el = kzalloc(sizeof *scan_el, GFP_KERNEL);
-	if (scan_el == NULL) {
-		ret = -ENOMEM;
-		goto error_ret;
-	}
-	if (chan->type != IIO_TIMESTAMP)
-		ret = __iio_device_attr_init(&scan_el->dev_attr, postfix, chan,
-					     iio_scan_el_show,
-					     iio_scan_el_store, 0);
-	else /*
-	      * Timestamp handled separately because it simplifies a lot of
-	      * drivers by ensuring they don't have to know its magic index
-	      */
-		ret = __iio_device_attr_init(&scan_el->dev_attr, postfix, chan,
-					     iio_scan_el_ts_show,
-					     iio_scan_el_ts_store, 0);
-	if (ret)
-		goto error_free_scan_el;
-
-	scan_el->number = chan->scan_index;
-
-	ret = sysfs_add_file_to_group(&dev->kobj,
-				      &scan_el->dev_attr.attr,
-				      group);
-	if (ret < 0)
-		goto error_device_attr_deinit;
-
-	list_add(&scan_el->l, attr_list);
-
-	return 0;
-error_device_attr_deinit:
-	__iio_device_attr_deinit(&scan_el->dev_attr);
-error_free_scan_el:
-	kfree(scan_el);
-error_ret:
-	return ret;
-}
-
 static int iio_ring_add_channel_sysfs(struct iio_ring_buffer *ring,
 				      struct iio_chan_spec *chan)
 {
@@ -268,23 +221,28 @@ static int iio_ring_add_channel_sysfs(struct iio_ring_buffer *ring,
 	if (ret)
 		goto error_ret;
 
-	ret = __iio_add_chan_scan_elattr("en", "scan_elements",
-					 chan, &ring->dev,
-					 &ring->scan_el_en_attr_list);
-
+	if (chan->type != IIO_TIMESTAMP)
+		ret = __iio_add_chan_devattr("en", "scan_elements",
+					     chan,
+					     &iio_scan_el_show,
+					     &iio_scan_el_store,
+					     chan->scan_index,
+					     0,
+					     &ring->dev,
+					     &ring->scan_el_dev_attr_list);
+	else
+		ret = __iio_add_chan_devattr("en", "scan_elements",
+					     chan,
+					     &iio_scan_el_ts_show,
+					     &iio_scan_el_ts_store,
+					     chan->scan_index,
+					     0,
+					     &ring->dev,
+					     &ring->scan_el_dev_attr_list);
 error_ret:
 	return ret;
 }
 
-static void iio_ring_remove_and_free_scan_el_attr(struct iio_ring_buffer *ring,
-						  struct iio_scan_el *p)
-{
-	sysfs_remove_file_from_group(&ring->dev.kobj,
-				     &p->dev_attr.attr, "scan_elements");
-	kfree(p->dev_attr.attr.name);
-	kfree(p);
-}
-
 static void iio_ring_remove_and_free_scan_dev_attr(struct iio_ring_buffer *ring,
 						   struct iio_dev_attr *p)
 {
@@ -306,15 +264,10 @@ static struct attribute_group iio_scan_el_dummy_group = {
 static void __iio_ring_attr_cleanup(struct iio_ring_buffer *ring)
 {
 	struct iio_dev_attr *p, *n;
-	struct iio_scan_el *q, *m;
-	int anydynamic = !(list_empty(&ring->scan_el_dev_attr_list) &&
-			   list_empty(&ring->scan_el_en_attr_list));
+	int anydynamic = !list_empty(&ring->scan_el_dev_attr_list);
 	list_for_each_entry_safe(p, n,
 				 &ring->scan_el_dev_attr_list, l)
 		iio_ring_remove_and_free_scan_dev_attr(ring, p);
-	list_for_each_entry_safe(q, m,
-				 &ring->scan_el_en_attr_list, l)
-		iio_ring_remove_and_free_scan_el_attr(ring, q);
 
 	if (ring->scan_el_attrs)
 		sysfs_remove_group(&ring->dev.kobj,
@@ -352,7 +305,6 @@ int iio_ring_buffer_register_ex(struct iio_ring_buffer *ring, int id,
 	}
 
 	INIT_LIST_HEAD(&ring->scan_el_dev_attr_list);
-	INIT_LIST_HEAD(&ring->scan_el_en_attr_list);
 	if (channels) {
 		/* new magic */
 		for (i = 0; i < num_channels; i++) {
@@ -554,9 +506,9 @@ ssize_t iio_scan_el_show(struct device *dev,
 {
 	int ret;
 	struct iio_ring_buffer *ring = dev_get_drvdata(dev);
-	struct iio_scan_el *this_el = to_iio_scan_el(attr);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
 
-	ret = iio_scan_mask_query(ring, this_el->number);
+	ret = iio_scan_mask_query(ring, this_attr->address);
 	if (ret < 0)
 		return ret;
 	return sprintf(buf, "%d\n", ret);
@@ -572,7 +524,7 @@ ssize_t iio_scan_el_store(struct device *dev,
 	bool state;
 	struct iio_ring_buffer *ring = dev_get_drvdata(dev);
 	struct iio_dev *indio_dev = ring->indio_dev;
-	struct iio_scan_el *this_el = to_iio_scan_el(attr);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
 
 	state = !(buf[0] == '0');
 	mutex_lock(&indio_dev->mlock);
@@ -580,20 +532,19 @@ ssize_t iio_scan_el_store(struct device *dev,
 		ret = -EBUSY;
 		goto error_ret;
 	}
-	ret = iio_scan_mask_query(ring, this_el->number);
+	ret = iio_scan_mask_query(ring, this_attr->address);
 	if (ret < 0)
 		goto error_ret;
 	if (!state && ret) {
-		ret = iio_scan_mask_clear(ring, this_el->number);
+		ret = iio_scan_mask_clear(ring, this_attr->address);
 		if (ret)
 			goto error_ret;
 	} else if (state && !ret) {
-		ret = iio_scan_mask_set(ring, this_el->number);
+		ret = iio_scan_mask_set(ring, this_attr->address);
 		if (ret)
 			goto error_ret;
 	}
-	if (this_el->set_state)
-		ret = this_el->set_state(this_el, indio_dev, state);
+
 error_ret:
 	mutex_unlock(&indio_dev->mlock);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index ba441d9..801ec34 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -109,7 +109,6 @@ struct iio_ring_buffer {
 	int				(*postdisable)(struct iio_dev *);
 
 	struct list_head scan_el_dev_attr_list;
-	struct list_head scan_el_en_attr_list;
 
 	wait_queue_head_t pollq;
 	bool stufftoread;
@@ -138,29 +137,6 @@ static inline void __iio_update_ring_buffer(struct iio_ring_buffer *ring,
 }
 
 /**
- * struct iio_scan_el - an individual element of a scan
- * @dev_attr:		control attribute (if directly controllable)
- * @number:		unique identifier of element (used for bit mask)
- * @label:		useful data for the scan el (often reg address)
- * @set_state:		for some devices datardy signals are generated
- *			for any enabled lines.  This allows unwanted lines
- *			to be disabled and hence not get in the way.
- **/
-struct iio_scan_el {
-	struct device_attribute		dev_attr;
-	unsigned int			number;
-	unsigned int			label;
-	struct list_head l;
-
-	int (*set_state)(struct iio_scan_el *scanel,
-			 struct iio_dev *dev_info,
-			 bool state);
-};
-
-#define to_iio_scan_el(_dev_attr)				\
-	container_of(_dev_attr, struct iio_scan_el, dev_attr);
-
-/**
  * iio_scan_el_store() - sysfs scan element selection interface
  * @dev: the target device
  * @attr: the device attribute that is being processed
-- 
1.7.3.4

