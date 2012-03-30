Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab2C3MWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:22:52 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48615 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab2C3MSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:23 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 67/76] PNPACPI: Fix device ref leaking in acpi_pnp_match
Date: Fri, 30 Mar 2012 06:14:10 -0400
Message-id: <89e96ada572fb216e582dbe3f64e1a6939a37f74.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

During testing pci root bus removal, found some root bus bridge is not freed.
If booting with pnpacpi=off, those hostbridge could be freed without problem.
It turns out that some devices reference are not released during acpi_pnp_match.
that match should not hold one device ref during every calling.
Add pu_device calling before returning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/pnp/pnpacpi/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index b00c176..d21e8f5 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -321,9 +321,14 @@ static int __init acpi_pnp_match(struct device *dev, void *_pnp)
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
 
-- 
1.7.10.rc2.19.gfae9d

