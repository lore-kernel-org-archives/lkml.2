Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0DTTwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:52:45 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17454 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0DTTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:52:43 -0400
Subject: [PATCH] x86/PCI: parse additional host bridge window resource types
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Date: Tue, 20 Apr 2010 13:52:41 -0600
Message-ID: <20100420195241.13265.93577.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds support for Memory24, Memory32, and Memory32Fixed descriptors in
PCI host bridge _CRS.

I experimentally determined that Windows (2008 R2) accepts these descriptors
and treats them as windows that are forwarded to the PCI bus, e.g., if
it finds any PCI devices with BARs outside the windows, it moves them into
the windows.

I don't know whether any machines actually use these descriptors in PCI
host bridge _CRS methods, but if any exist and they're new enough that we
automatically turn on "pci=use_crs", they will work with Windows but not
with Linux.

Here are the details: https://bugzilla.kernel.org/show_bug.cgi?id=15817

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/acpi.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 37 insertions(+), 6 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 334153c..44f83ce 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -66,13 +66,44 @@ resource_to_addr(struct acpi_resource *resource,
 			struct acpi_resource_address64 *addr)
 {
 	acpi_status status;
-
-	status = acpi_resource_to_address64(resource, addr);
-	if (ACPI_SUCCESS(status) &&
-	    (addr->resource_type == ACPI_MEMORY_RANGE ||
-	    addr->resource_type == ACPI_IO_RANGE) &&
-	    addr->address_length > 0) {
+	struct acpi_resource_memory24 *memory24;
+	struct acpi_resource_memory32 *memory32;
+	struct acpi_resource_fixed_memory32 *fixed_memory32;
+
+	memset(addr, 0, sizeof(*addr));
+	switch (resource->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+		memory24 = &resource->data.memory24;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory24->minimum;
+		addr->address_length = memory24->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
+		return AE_OK;
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+		memory32 = &resource->data.memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory32->minimum;
+		addr->address_length = memory32->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
 		return AE_OK;
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		fixed_memory32 = &resource->data.fixed_memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = fixed_memory32->address;
+		addr->address_length = fixed_memory32->address_length;
+		addr->maximum = addr->minimum + addr->address_length - 1;
+		return AE_OK;
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		status = acpi_resource_to_address64(resource, addr);
+		if (ACPI_SUCCESS(status) &&
+		    (addr->resource_type == ACPI_MEMORY_RANGE ||
+		    addr->resource_type == ACPI_IO_RANGE) &&
+		    addr->address_length > 0) {
+			return AE_OK;
+		}
+		break;
 	}
 	return AE_ERROR;
 }

