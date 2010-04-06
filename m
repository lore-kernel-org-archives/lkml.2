Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0DFTYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:24:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:27204 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0DFTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:24:10 -0400
Subject: [PATCH] x86/PCI: ignore Consumer/Producer bit in ACPI window
	descriptions
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Date: Tue, 06 Apr 2010 13:24:08 -0600
Message-ID: <20100406192408.14676.17106.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACPI Address Space Descriptors (used in _CRS) have a Consumer/Producer
bit that is supposed to distinguish regions that are consumed directly
by a device from those that are forwarded ("produced") by a bridge.
But BIOSes have apparently not used this consistently, and Windows
seems to ignore it, so I think Linux should ignore it as well.

I can't point to any of these supposed broken BIOSes, but since we
now rely on _CRS by default, I think it's safer to ignore this bit
from the start.

Here are details of my experiments with how Windows handles it:
    https://bugzilla.kernel.org/show_bug.cgi?id=15701

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/acpi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c7b1ebf..334153c 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -71,8 +71,7 @@ resource_to_addr(struct acpi_resource *resource,
 	if (ACPI_SUCCESS(status) &&
 	    (addr->resource_type == ACPI_MEMORY_RANGE ||
 	    addr->resource_type == ACPI_IO_RANGE) &&
-	    addr->address_length > 0 &&
-	    addr->producer_consumer == ACPI_PRODUCER) {
+	    addr->address_length > 0) {
 		return AE_OK;
 	}
 	return AE_ERROR;

