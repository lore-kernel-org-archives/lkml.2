Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1CPVYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:24:51 -0400
Received: from kroah.org ([198.145.64.141]:42723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab1CPVMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/50] firmware: Break out system_event_log in dmi-sysfs
Date: Wed, 16 Mar 2011 14:11:13 -0700
Message-Id: <1300309888-5028-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

The optional type 15 entry of the DMI table describes a non-volatile
storage-backed system event log.

In preparation for the next commit which exposes the raw bits of the
event log to userland, create a new sub-directory within the dmi entry
called "system_event_log" and expose attribute files that describe the
event log itself.

Currently, only a single child object is permitted within a
dmi_sysfs_entry.  We simply point at this child from the dmi_sysfs_entry
if it exists.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-sysfs.c |  159 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 2d8a04a..d209610 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -35,6 +35,7 @@ struct dmi_sysfs_entry {
 	int instance;
 	int position;
 	struct list_head list;
+	struct kobject *child;
 };
 
 /*
@@ -77,6 +78,10 @@ struct dmi_sysfs_mapped_attribute dmi_sysfs_attr_##_entry##_##_name = { \
 /*************************************************
  * Generic DMI entry support.
  *************************************************/
+static void dmi_entry_free(struct kobject *kobj)
+{
+	kfree(kobj);
+}
 
 static struct dmi_sysfs_entry *to_entry(struct kobject *kobj)
 {
@@ -186,6 +191,146 @@ static size_t dmi_entry_length(const struct dmi_header *dh)
 }
 
 /*************************************************
+ * Support bits for specialized DMI entry support
+ *************************************************/
+struct dmi_entry_attr_show_data {
+	struct attribute *attr;
+	char *buf;
+};
+
+static ssize_t dmi_entry_attr_show_helper(struct dmi_sysfs_entry *entry,
+					  const struct dmi_header *dh,
+					  void *_data)
+{
+	struct dmi_entry_attr_show_data *data = _data;
+	struct dmi_sysfs_mapped_attribute *attr;
+
+	attr = container_of(data->attr,
+			    struct dmi_sysfs_mapped_attribute, attr);
+	return attr->show(entry, dh, data->buf);
+}
+
+static ssize_t dmi_entry_attr_show(struct kobject *kobj,
+				   struct attribute *attr,
+				   char *buf)
+{
+	struct dmi_entry_attr_show_data data = {
+		.attr = attr,
+		.buf  = buf,
+	};
+	/* Find the entry according to our parent and call the
+	 * normalized show method hanging off of the attribute */
+	return find_dmi_entry(to_entry(kobj->parent),
+			      dmi_entry_attr_show_helper, &data);
+}
+
+static const struct sysfs_ops dmi_sysfs_specialize_attr_ops = {
+	.show = dmi_entry_attr_show,
+};
+
+/*************************************************
+ * Specialized DMI entry support.
+ *************************************************/
+
+/*** Type 15 - System Event Table ***/
+
+#define DMI_SEL_ACCESS_METHOD_IO8	0x00
+#define DMI_SEL_ACCESS_METHOD_IO2x8	0x01
+#define DMI_SEL_ACCESS_METHOD_IO16	0x02
+#define DMI_SEL_ACCESS_METHOD_PHYS32	0x03
+#define DMI_SEL_ACCESS_METHOD_GPNV	0x04
+
+struct dmi_system_event_log {
+	struct dmi_header header;
+	u16	area_length;
+	u16	header_start_offset;
+	u16	data_start_offset;
+	u8	access_method;
+	u8	status;
+	u32	change_token;
+	union {
+		struct {
+			u16 index_addr;
+			u16 data_addr;
+		} io;
+		u32	phys_addr32;
+		u16	gpnv_handle;
+		u32	access_method_address;
+	};
+	u8	header_format;
+	u8	type_descriptors_supported_count;
+	u8	per_log_type_descriptor_length;
+	u8	supported_log_type_descriptos[0];
+} __packed;
+
+static const struct dmi_system_event_log *to_sel(const struct dmi_header *dh)
+{
+	return (const struct dmi_system_event_log *)dh;
+}
+
+#define DMI_SYSFS_SEL_FIELD(_field) \
+static ssize_t dmi_sysfs_sel_##_field(struct dmi_sysfs_entry *entry, \
+				      const struct dmi_header *dh, \
+				      char *buf) \
+{ \
+	const struct dmi_system_event_log *sel = to_sel(dh); \
+	if (sizeof(*sel) > dmi_entry_length(dh)) \
+		return -EIO; \
+	return sprintf(buf, "%u\n", sel->_field); \
+} \
+static DMI_SYSFS_MAPPED_ATTR(sel, _field)
+
+DMI_SYSFS_SEL_FIELD(area_length);
+DMI_SYSFS_SEL_FIELD(header_start_offset);
+DMI_SYSFS_SEL_FIELD(data_start_offset);
+DMI_SYSFS_SEL_FIELD(access_method);
+DMI_SYSFS_SEL_FIELD(status);
+DMI_SYSFS_SEL_FIELD(change_token);
+DMI_SYSFS_SEL_FIELD(access_method_address);
+DMI_SYSFS_SEL_FIELD(header_format);
+DMI_SYSFS_SEL_FIELD(type_descriptors_supported_count);
+DMI_SYSFS_SEL_FIELD(per_log_type_descriptor_length);
+
+static struct attribute *dmi_sysfs_sel_attrs[] = {
+	&dmi_sysfs_attr_sel_area_length.attr,
+	&dmi_sysfs_attr_sel_header_start_offset.attr,
+	&dmi_sysfs_attr_sel_data_start_offset.attr,
+	&dmi_sysfs_attr_sel_access_method.attr,
+	&dmi_sysfs_attr_sel_status.attr,
+	&dmi_sysfs_attr_sel_change_token.attr,
+	&dmi_sysfs_attr_sel_access_method_address.attr,
+	&dmi_sysfs_attr_sel_header_format.attr,
+	&dmi_sysfs_attr_sel_type_descriptors_supported_count.attr,
+	&dmi_sysfs_attr_sel_per_log_type_descriptor_length.attr,
+	NULL,
+};
+
+
+static struct kobj_type dmi_system_event_log_ktype = {
+	.release = dmi_entry_free,
+	.sysfs_ops = &dmi_sysfs_specialize_attr_ops,
+	.default_attrs = dmi_sysfs_sel_attrs,
+};
+
+static int dmi_system_event_log(struct dmi_sysfs_entry *entry)
+{
+	int ret;
+
+	entry->child = kzalloc(sizeof(*entry->child), GFP_KERNEL);
+	if (!entry->child)
+		return -ENOMEM;
+	ret = kobject_init_and_add(entry->child,
+				   &dmi_system_event_log_ktype,
+				   &entry->kobj,
+				   "system_event_log");
+	if (ret)
+		goto out_free;
+out_free:
+	kfree(entry->child);
+	return ret;
+}
+
+/*************************************************
  * Generic DMI entry support.
  *************************************************/
 
@@ -325,6 +470,18 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 	list_add_tail(&entry->list, &entry_list);
 	spin_unlock(&entry_list_lock);
 
+	/* Handle specializations by type */
+	switch (dh->type) {
+	case DMI_ENTRY_SYSTEM_EVENT_LOG:
+		*ret = dmi_system_event_log(entry);
+		break;
+	default:
+		/* No specialization */
+		break;
+	}
+	if (*ret)
+		goto out_err;
+
 	/* Create the raw binary file to access the entry */
 	*ret = sysfs_create_bin_file(&entry->kobj, &dmi_entry_raw_attr);
 	if (*ret)
@@ -332,6 +489,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 
 	return;
 out_err:
+	kobject_put(entry->child);
 	kobject_put(&entry->kobj);
 	return;
 }
@@ -342,6 +500,7 @@ static void cleanup_entry_list(void)
 
 	/* No locks, we are on our way out */
 	list_for_each_entry_safe(entry, next, &entry_list, list) {
+		kobject_put(entry->child);
 		kobject_put(&entry->kobj);
 	}
 }
-- 
1.7.4.1

