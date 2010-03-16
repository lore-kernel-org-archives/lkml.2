Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0CPULk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:11:40 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33194 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0CPULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:11:37 -0400
Subject: [PATCH] x86/PCI: ignore Consumer/Producer bit and parse additional
	_CRS resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Mar 2010 14:11:34 -0600
Message-ID: <20100316201134.24527.87006.stgit@bob.kio>
In-Reply-To: <20100316201046.24527.79634.stgit@bob.kio>
References: <20100316201046.24527.79634.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We previously used only resources marked "Producer," i.e., those the bridge
forwards downstream.  But BIOSes haven't used that bit consistently, so it's
useless.  For bridge devices, we have to assume *all* ACPI resources are
forwarded downstream.  Non-Producer bridge resources typically appear in
PCI config space and are not described in ACPI.

In addition to ACPI_RESOURCE_TYPE_ADDRESS{16,32,64}, parse these types:

    ACPI_RESOURCE_TYPE_IO
    ACPI_RESOURCE_TYPE_FIXED_IO
    ACPI_RESOURCE_TYPE_MEMORY24
    ACPI_RESOURCE_TYPE_MEMORY32
    ACPI_RESOURCE_TYPE_FIXED_MEMORY32
    ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64

This basically reimplements what drivers/pnp/pnpacpi/rsparser.c already
does, and I plan to take advantage of that, but we're not quite ready to
do it yet because it will require converting pci_root.c from an ACPI
driver to a PNP driver.

This is a possible fix for http://bugzilla.kernel.org/show_bug.cgi?id=15533
reported by Pete Zaitcev <zaitcev@redhat.com>.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/acpi.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 71 insertions(+), 6 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index d255ce8..e0f45c2 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -65,14 +65,79 @@ resource_to_addr(struct acpi_resource *resource,
 			struct acpi_resource_address64 *addr)
 {
 	acpi_status status;
+	struct acpi_resource_io *io;
+	struct acpi_resource_fixed_io *fixed_io;
+	struct acpi_resource_memory24 *memory24;
+	struct acpi_resource_memory32 *memory32;
+	struct acpi_resource_fixed_memory32 *fixed_memory32;
+	struct acpi_resource_extended_address64 *ext_addr64;
+
+	memset(addr, 0, sizeof(*addr));
+
+	switch (resource->type) {
+	case ACPI_RESOURCE_TYPE_IO:
+		io = &resource->data.io;
+		addr->resource_type = ACPI_IO_RANGE;
+		addr->minimum = io->minimum;
+		addr->address_length = io->address_length;
+		return AE_OK;
+
+	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		fixed_io = &resource->data.fixed_io;
+		addr->resource_type = ACPI_IO_RANGE;
+		addr->minimum = fixed_io->address;
+		addr->address_length = fixed_io->address_length;
+		return AE_OK;
+
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+		memory24 = &resource->data.memory24;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory24->minimum;
+		addr->address_length = memory24->address_length;
+		return AE_OK;
+
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+		memory32 = &resource->data.memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = memory32->minimum;
+		addr->address_length = memory32->address_length;
+		return AE_OK;
 
-	status = acpi_resource_to_address64(resource, addr);
-	if (ACPI_SUCCESS(status) &&
-	    (addr->resource_type == ACPI_MEMORY_RANGE ||
-	    addr->resource_type == ACPI_IO_RANGE) &&
-	    addr->address_length > 0 &&
-	    addr->producer_consumer == ACPI_PRODUCER) {
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		fixed_memory32 = &resource->data.fixed_memory32;
+		addr->resource_type = ACPI_MEMORY_RANGE;
+		addr->minimum = fixed_memory32->address;
+		addr->address_length = fixed_memory32->address_length;
 		return AE_OK;
+
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+		status = acpi_resource_to_address64(resource, addr);
+		if (ACPI_SUCCESS(status) &&
+		    (addr->resource_type == ACPI_MEMORY_RANGE ||
+		     addr->resource_type == ACPI_IO_RANGE) &&
+		    addr->address_length > 0) {
+			return AE_OK;
+		}
+		break;
+
+	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
+		ext_addr64 = &resource->data.ext_address64;
+		if ((ext_addr64->resource_type == ACPI_MEMORY_RANGE ||
+		     ext_addr64->resource_type == ACPI_IO_RANGE) &&
+		    ext_addr64->address_length > 0) {
+			addr->resource_type = ext_addr64->resource_type;
+			addr->minimum = ext_addr64->minimum;
+			addr->address_length = ext_addr64->address_length;
+			addr->translation_offset =
+					ext_addr64->translation_offset;
+			if (ext_addr64->resource_type == ACPI_MEMORY_RANGE)
+				addr->info.mem.caching =
+						ext_addr64->info.mem.caching;
+			return AE_OK;
+		}
+		break;
 	}
 	return AE_ERROR;
 }

