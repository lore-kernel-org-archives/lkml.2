Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2JGXiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:38:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38375 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab2JGXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:35 -0400
Message-Id: <20121007225844.663121700@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 072/108] PCI: acpiphp: check whether _ADR evaluation succeeded
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit dfb117b3e50c52c7b3416db4a4569224b8db80bb upstream.

Check whether we evaluated _ADR successfully.  Previously we ignored
failure, so we would have used garbage data from the stack as the device
and function number.

We return AE_OK so that we ignore only this slot and continue looking
for other slots.

Found by Coverity (CID 113981).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/acpiphp_glue.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 806c44f..09bf377 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -132,6 +132,15 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
 		return AE_OK;
 
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status)) {
+		warn("can't evaluate _ADR (%#x)\n", status);
+		return AE_OK;
+	}
+
+	device = (adr >> 16) & 0xffff;
+	function = adr & 0xffff;
+
 	pdev = pbus->self;
 	if (pdev && pci_is_pcie(pdev)) {
 		tmp = acpi_find_root_bridge_handle(pdev);
@@ -144,10 +153,6 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		}
 	}
 
-	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
-	device = (adr >> 16) & 0xffff;
-	function = adr & 0xffff;
-
 	newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
 	if (!newfunc)
 		return AE_NO_MEMORY;


