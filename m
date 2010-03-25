Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0CYP22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:28:28 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35279 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0CYP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:28:25 -0400
Subject: [PATCH 1/2] x86/PCI: for host bridge address space collisions,
	show conflicting resource
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 25 Mar 2010 09:28:24 -0600
Message-ID: <20100325152824.10117.37931.stgit@bob.kio>
In-Reply-To: <20100325152750.10117.81615.stgit@bob.kio>
References: <20100325152750.10117.81615.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With insert_resource_conflict(), we can learn what the actual conflict is,
so print that info for debugging purposes.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/acpi.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 6e22454..75ac3f8 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -122,7 +122,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 	unsigned long flags;
-	struct resource *root;
+	struct resource *root, *conflict;
 	u64 start, end;
 
 	status = resource_to_addr(acpi_res, &addr);
@@ -157,9 +157,12 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 		return AE_OK;
 	}
 
-	if (insert_resource(root, res)) {
+	conflict = insert_resource_conflict(root, res);
+	if (conflict) {
 		dev_err(&info->bridge->dev,
-			"can't allocate host bridge window %pR\n", res);
+			"address space collision: host bridge window %pR "
+			"conflicts with %s %pR\n",
+			res, conflict->name, conflict);
 	} else {
 		pci_bus_add_resource(info->bus, res, 0);
 		info->res_num++;

