Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2KTA5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:57:23 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:54095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2KTA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:56:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [Update][PATCH 1/3] ACPI: Allow ACPI handles of devices to be initialized in advance
Date: Tue, 20 Nov 2012 01:57:13 +0100
Message-ID: <3954977.fT8lC34ML2@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <4036218.zBRlg5OZsZ@vostro.rjw.lan>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1758879.PKgPhTGcB7@vostro.rjw.lan> <4036218.zBRlg5OZsZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, the ACPI handles of devices are initialized from within
device_add(), by acpi_bind_one() called from acpi_platform_notify()
which first uses the .find_device() routine provided by the device's
bus type to find the matching device node in the ACPI namespace.
This is a source of some computational overhead and, moreover, the
correctness of the result depends on the implementation of
.find_device() which is known to fail occasionally for some bus types
(e.g. PCI).  In some cases, however, the corresponding ACPI device
node is known already before calling device_add() for the given
struct device object and the whole .find_device() dance in
acpi_platform_notify() is then simply unnecessary.

For this reason, make it possible to initialize the ACPI handles of
devices before calling device_add() for them.  Modify
acpi_platform_notify() to call acpi_bind_one() in advance to check
the device's existing ACPI handle and skip the .find_device()
search if that is successful.  Change acpi_bind_one() accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/glue.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -130,46 +130,59 @@ static int acpi_bind_one(struct device *
 {
 	struct acpi_device *acpi_dev;
 	acpi_status status;
-	struct acpi_device_physical_node *physical_node;
+	struct acpi_device_physical_node *physical_node, *pn;
 	char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
 	int retval = -EINVAL;
 
 	if (dev->acpi_handle) {
-		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
-		return -EINVAL;
+		if (handle) {
+			dev_warn(dev, "ACPI handle is already set\n");
+			return -EINVAL;
+		} else {
+			handle = dev->acpi_handle;
+		}
 	}
+	if (!handle)
+		return -EINVAL;
 
 	get_device(dev);
 	status = acpi_bus_get_device(handle, &acpi_dev);
 	if (ACPI_FAILURE(status))
 		goto err;
 
-	physical_node = kzalloc(sizeof(struct acpi_device_physical_node),
-		GFP_KERNEL);
+	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
 	if (!physical_node) {
 		retval = -ENOMEM;
 		goto err;
 	}
 
 	mutex_lock(&acpi_dev->physical_node_lock);
+
+	/* Sanity check. */
+	list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
+		if (pn->dev == dev) {
+			dev_warn(dev, "Already associated with ACPI node\n");
+			goto err_free;
+		}
+
 	/* allocate physical node id according to physical_node_id_bitmap */
 	physical_node->node_id =
 		find_first_zero_bit(acpi_dev->physical_node_id_bitmap,
 		ACPI_MAX_PHYSICAL_NODE);
 	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
 		retval = -ENOSPC;
-		mutex_unlock(&acpi_dev->physical_node_lock);
-		kfree(physical_node);
-		goto err;
+		goto err_free;
 	}
 
 	set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
 	physical_node->dev = dev;
 	list_add_tail(&physical_node->node, &acpi_dev->physical_node_list);
 	acpi_dev->physical_node_count++;
+
 	mutex_unlock(&acpi_dev->physical_node_lock);
 
-	dev->acpi_handle = handle;
+	if (!dev->acpi_handle)
+		dev->acpi_handle = handle;
 
 	if (!physical_node->node_id)
 		strcpy(physical_node_name, PHYSICAL_NODE_STRING);
@@ -187,8 +200,14 @@ static int acpi_bind_one(struct device *
 	return 0;
 
  err:
+	dev->acpi_handle = NULL;
 	put_device(dev);
 	return retval;
+
+ err_free:
+	mutex_unlock(&acpi_dev->physical_node_lock);
+	kfree(physical_node);
+	goto err;
 }
 
 static int acpi_unbind_one(struct device *dev)
@@ -247,6 +266,10 @@ static int acpi_platform_notify(struct d
 	acpi_handle handle;
 	int ret = -EINVAL;
 
+	ret = acpi_bind_one(dev, NULL);
+	if (!ret)
+		goto out;
+
 	if (!dev->bus || !dev->parent) {
 		/* bridge devices genernally haven't bus or parent */
 		ret = acpi_find_bridge_device(dev, &handle);
@@ -260,10 +283,11 @@ static int acpi_platform_notify(struct d
 	}
 	if ((ret = type->find_device(dev, &handle)) != 0)
 		DBG("Can't get handler for %s\n", dev_name(dev));
-      end:
+ end:
 	if (!ret)
 		acpi_bind_one(dev, handle);
 
+ out:
 #if ACPI_GLUE_DEBUG
 	if (!ret) {
 		struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };

