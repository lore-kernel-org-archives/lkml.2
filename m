Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1AXXdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:33:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1AXXdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:33:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 7/8] ACPI: Introduce acpi_os_get_iomem()
Date: Tue, 25 Jan 2011 00:30:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl> <201101250025.10817.rjw@sisk.pl>
In-Reply-To: <201101250025.10817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250030.53131.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce function acpi_os_get_iomem() that may be used by its callers
to get a reference to an ACPI iomap.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/osl.c      |   16 ++++++++++++++++
 include/linux/acpi_io.h |    2 ++
 2 files changed, 18 insertions(+)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -285,6 +285,22 @@ acpi_map_vaddr_lookup(acpi_physical_addr
 	return NULL;
 }
 
+void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
+{
+	struct acpi_ioremap *map;
+	void __iomem *virt = NULL;
+
+	mutex_lock(&acpi_ioremap_lock);
+	map = acpi_map_lookup(phys, size);
+	if (map) {
+		virt = map->virt + (phys - map->phys);
+		map->refcount++;
+	}
+	mutex_unlock(&acpi_ioremap_lock);
+	return virt;
+}
+EXPORT_SYMBOL_GPL(acpi_os_get_iomem);
+
 /* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
 static struct acpi_ioremap *
 acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
Index: linux-2.6/include/linux/acpi_io.h
===================================================================
--- linux-2.6.orig/include/linux/acpi_io.h
+++ linux-2.6/include/linux/acpi_io.h
@@ -10,4 +10,6 @@ static inline void __iomem *acpi_os_iore
        return ioremap_cache(phys, size);
 }
 
+void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size);
+
 #endif

