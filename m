Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2BUBYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:24:10 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:46853 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BUBYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:24:07 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: fix memleak when ACPI _CRS is not used.
Date: Mon, 20 Feb 2012 17:23:47 -0800
Message-Id: <1329787427-17890-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F42F235.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

got warning:
unreferenced object 0xffff8801f6914200 (size 512):
  comm "swapper/0", pid 1, jiffies 4294893643 (age 2664.644s)
  hex dump (first 32 bytes):
    00 00 c0 fe 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    60 58 2f f6 03 88 ff ff 00 02 00 00 00 00 00 00  `X/.............
  backtrace:
    [<ffffffff81c2408c>] kmemleak_alloc+0x26/0x43
    [<ffffffff8113764f>] __kmalloc+0x121/0x183
    [<ffffffff81ca8d93>] get_current_resources+0x5a/0xc6
    [<ffffffff81c5bedd>] pci_acpi_scan_root+0x13c/0x21c
    [<ffffffff81c2a745>] acpi_pci_root_add+0x1e1/0x421
    [<ffffffff81408f50>] acpi_device_probe+0x50/0x190
    [<ffffffff8149edc7>] really_probe+0x99/0x126
    [<ffffffff8149ef83>] driver_probe_device+0x3b/0x56
    [<ffffffff8149effd>] __driver_attach+0x5f/0x82
    [<ffffffff8149d860>] bus_for_each_dev+0x5c/0x88
    [<ffffffff8149eb87>] driver_attach+0x1e/0x20
    [<ffffffff8149e7cc>] bus_add_driver+0xca/0x21d
    [<ffffffff8149f47b>] driver_register+0x91/0xfe
    [<ffffffff81409d09>] acpi_bus_register_driver+0x43/0x45
    [<ffffffff8278bdc9>] acpi_pci_root_init+0x20/0x28
    [<ffffffff810001e7>] do_one_initcall+0x57/0x134

The system have _CRS for root buses, but they are not used because is old...

Try free those not used resource array and name.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -282,9 +282,6 @@ static void add_resources(struct pci_roo
 	int i;
 	struct resource *res, *root, *conflict;
 
-	if (!pci_use_crs)
-		return;
-
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);
 
@@ -336,8 +333,13 @@ get_current_resources(struct acpi_device
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				&info);
 
-	add_resources(&info);
-	return;
+	if (pci_use_crs) {
+		add_resources(&info);
+
+		return;
+	}
+
+	kfree(info.name);
 
 name_alloc_fail:
 	kfree(info.res);
