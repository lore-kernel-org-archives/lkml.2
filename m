Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2CCV35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 16:29:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:27867 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2CCV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 16:29:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, stable@kerne.org
Subject: [PATCH] PNPACPI: Fix device ref leaking in acpi_pnp_match
Date: Sat,  3 Mar 2012 13:29:20 -0800
Message-Id: <1330810160-20306-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F528D4A.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing pci root bus removal, found some root bus bridge is not freed.

If booting with pnpacpi=off, those hostbridge could be freed without problem.

It turns out that some devices reference are not released during acpi_pnp_match.

that match should not hold one device ref during every calling.

Add pu_device calling before returning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kerne.org
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@mit.edu>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org

---
 drivers/pnp/pnpacpi/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6/drivers/pnp/pnpacpi/core.c
@@ -321,9 +321,14 @@ static int __init acpi_pnp_match(struct
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
 	struct pnp_dev *pnp = _pnp;
+	struct device *physical_device;
+
+	physical_device = acpi_get_physical_device(acpi->handle);
+	if (physical_device)
+		put_device(physical_device);
 
 	/* true means it matched */
-	return !acpi_get_physical_device(acpi->handle)
+	return !physical_device
 	    && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
 }
 
