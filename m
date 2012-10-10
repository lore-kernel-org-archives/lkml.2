Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2JJWx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55421 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757477Ab2JJWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:22 -0400
X-Sasl-enc: RXJPzZ/4gOLxfsWK75H9potS7Y3jnHLYKeKKN6Ub0o/S 1349909601
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 012/133] PCI: acpiphp: check whether _ADR evaluation succeeded
Date: Thu, 11 Oct 2012 07:50:38 +0900
Message-Id: <20121010224856.675586895@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -132,6 +132,15 @@ register_slot(acpi_handle handle, u32 lv
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
@@ -144,10 +153,6 @@ register_slot(acpi_handle handle, u32 lv
 		}
 	}
 
-	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
-	device = (adr >> 16) & 0xffff;
-	function = adr & 0xffff;
-
 	newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
 	if (!newfunc)
 		return AE_NO_MEMORY;


