Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2LTB5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:57:39 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38313 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2LTBzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 13/16] ACPI: Add .setup() and .cleanup() callbacks to struct acpi_bus_type
Date: Thu, 20 Dec 2012 02:57:35 +0100
Message-ID: <2494783.CtaoJvSv38@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add two new callbacks,.setup() and .cleanup(), struct acpi_bus_type
and modify acpi_platform_notify() to call .setup() after executing
acpi_bind_one() successfully and acpi_platform_notify_remove() to
call .cleanup() before running acpi_unbind_one().  This will allow
the users of struct acpi_bus_type, PCI in particular, to specify
operations to be executed right after the given device has been
associated with a companion struct acpi_device and right before
it's going to be detached from that companion, respectively.

The main motivation is to be able to get rid of acpi_pci_bind()
and acpi_pci_unbind(), which are horrible horrible stuff.  [In short,
there are three problems with them: The way they populate the .bind()
and .unbind() callbacks of ACPI devices is rather less than
straightforward, they require special hotplug-specific paths to be
present in the ACPI namespace scanning code and by the time
acpi_pci_unbind() is called the PCI device object in question may
not exist any more.]

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |   52 +++++++++++++++++++++++++++++++++---------------
 include/acpi/acpi_bus.h |    2 +
 2 files changed, 38 insertions(+), 16 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -423,6 +423,8 @@ struct acpi_bus_type {
 	int (*find_device) (struct device *, acpi_handle *);
 	/* For bridges, such as PCI root bridge, IDE controller */
 	int (*find_bridge) (struct device *, acpi_handle *);
+	void (*setup)(struct device *);
+	void (*cleanup)(struct device *);
 };
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -63,6 +63,9 @@ static struct acpi_bus_type *acpi_get_bu
 {
 	struct acpi_bus_type *tmp, *ret = NULL;
 
+	if (!type)
+		return NULL;
+
 	down_read(&bus_type_sem);
 	list_for_each_entry(tmp, &bus_type_list, list) {
 		if (tmp->bus == type) {
@@ -264,28 +267,39 @@ static int acpi_platform_notify(struct d
 {
 	struct acpi_bus_type *type;
 	acpi_handle handle;
-	int ret = -EINVAL;
+	int ret;
 
 	ret = acpi_bind_one(dev, NULL);
-	if (!ret)
-		goto out;
-
-	if (!dev->bus || !dev->parent) {
+	if (ret && (!dev->bus || !dev->parent)) {
 		/* bridge devices genernally haven't bus or parent */
 		ret = acpi_find_bridge_device(dev, &handle);
-		goto end;
+		if (!ret) {
+			ret = acpi_bind_one(dev, handle);
+			if (ret)
+				goto out;
+		}
 	}
+
 	type = acpi_get_bus_type(dev->bus);
-	if (!type) {
-		DBG("No ACPI bus support for %s\n", dev_name(dev));
-		ret = -EINVAL;
-		goto end;
-	}
-	if ((ret = type->find_device(dev, &handle)) != 0)
-		DBG("Can't get handler for %s\n", dev_name(dev));
- end:
-	if (!ret)
-		acpi_bind_one(dev, handle);
+	if (ret) {
+		if (!type || !type->find_device) {
+			DBG("No ACPI bus support for %s\n", dev_name(dev));
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = type->find_device(dev, &handle);
+		if (ret) {
+			DBG("Unable to get handle for %s\n", dev_name(dev));
+			goto out;
+		}
+		ret = acpi_bind_one(dev, handle);
+		if (ret)
+			goto out;
+	}
+
+	if (type && type->setup)
+		type->setup(dev);
 
  out:
 #if ACPI_GLUE_DEBUG
@@ -304,6 +318,12 @@ static int acpi_platform_notify(struct d
 
 static int acpi_platform_notify_remove(struct device *dev)
 {
+	struct acpi_bus_type *type;
+
+	type = acpi_get_bus_type(dev->bus);
+	if (type && type->cleanup)
+		type->cleanup(dev);
+
 	acpi_unbind_one(dev);
 	return 0;
 }

