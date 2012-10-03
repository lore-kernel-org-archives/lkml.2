Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2JCXA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:00:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31193 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:00:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/4] ACPI: add drivers_autoprobe in struct acpi_device
Date: Wed,  3 Oct 2012 16:00:11 -0700
Message-Id: <1349305214-3241-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349305214-3241-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use to control the delay attach driver for acpi_device.

Will use bus notifier to toggle this bits when needed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/scan.c     |    8 +++++++-
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..cbb3ed1 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -333,7 +333,12 @@ static void acpi_device_release(struct device *dev)
 static int acpi_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
-	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
+	struct acpi_driver *acpi_drv;
+
+	if (!acpi_dev->drivers_autoprobe)
+		return 0;
+
+	acpi_drv = to_acpi_driver(drv);
 
 	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
@@ -1268,6 +1273,7 @@ static int acpi_add_single_object(struct acpi_device **child,
 	device->parent = acpi_bus_get_parent(handle);
 	device->bus_ops = *ops; /* workround for not call .start */
 	STRUCT_TO_INT(device->status) = sta;
+	device->drivers_autoprobe = true;
 
 	acpi_device_get_busid(device);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..969544e 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -304,6 +304,7 @@ struct acpi_device {
 	struct device dev;
 	struct acpi_bus_ops bus_ops;	/* workaround for different code path for hotplug */
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
+	bool drivers_autoprobe;
 };
 
 static inline void *acpi_driver_data(struct acpi_device *d)
-- 
1.7.7

