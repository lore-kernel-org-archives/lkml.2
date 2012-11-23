Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab2KWCuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:50:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60838 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2KWCuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:50:09 -0500
Message-ID: <50AEE45C.80603@ozlabs.ru>
Date: Fri, 23 Nov 2012 13:50:04 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] powerpc/pseries: Fix kernel crash caused by NULL PE
Content-Type: multipart/mixed;
 boundary="------------010108090804080207040608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010108090804080207040608
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

While hooking MSI interrupts, the corresponding device tree node
of the PE that the PCI device has been put into should be checked.
However, those PCI devices (e.g. VirtIO based PCI devices) that
don't have EEH capability shouldn't have the associated PE. So we
shouldn't try to get the PE's device tree node. Otherwise, it
would cause kernel crash.

Actually, it was introduced by commit 66523d9f ("powerpc/eeh: Trace
error based on PE from beginning").

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
  arch/powerpc/platforms/pseries/msi.c |   11 +++++++++--
  1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c 
b/arch/powerpc/platforms/pseries/msi.c
index d19f497..9284e42 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -218,9 +218,16 @@ static struct device_node *find_pe_dn(struct pci_dev 
*dev, int *total)
  	if (!dn)
  		return NULL;
  -	/* Get the top level device in the PE */
+	/*
+	 * Get the top level device in the PE, but some PCI devices
+	 * without EEH capability (e.g. VirtIO based PCI devices)
+	 * don't have the associated PE. So we should not get the
+	 * top level device from PE for those PCI devices.
+	 */
  	edev = of_node_to_eeh_dev(dn);
-	edev = list_first_entry(&edev->pe->edevs, struct eeh_dev, list);
+	if (edev->pe)
+		edev = list_first_entry(&edev->pe->edevs,
+				struct eeh_dev, list);
  	dn = eeh_dev_to_of_node(edev);
  	if (!dn)
  		return NULL;
-- 
1.7.5.4


--------------010108090804080207040608
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010108090804080207040608--
