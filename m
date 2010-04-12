Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0DLWgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:36:37 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35028 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0DLWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:36:36 -0400
Message-ID: <4BC39FAF.4030808@oracle.com>
Date: Mon, 12 Apr 2010 15:33:19 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
CC: Andy Isaacson <adi@hexapodia.org>, Yinghai <yinghai.lu@oracle.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH -v2 2/2] x86,pci, acpi: Inherent BUSY flag when setup_resource
 for root bus
References: <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org> <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org> <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>
In-Reply-To: <20100412200224.GO11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BC3A036.008C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So make pci root resource from _CRS honor the range We reserve in e820 below 1M
then  will not assign them to unsigned pci BAR

-v2: let pci_bus_alloc_resource() honor IORESOURCE_BUSY
     driver can not use those range, so skip it

Tested-by: Andy Isaacson <adi@hexapodia.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |    4 ++++
 drivers/pci/bus.c   |    4 ++++
 2 files changed, 8 insertions(+)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -175,6 +175,10 @@ setup_resource(struct acpi_resource *acp
 			"conflicts with %s %pR\n",
 			res, conflict->name, conflict);
 	} else {
+		/* In case it falls in big reserved region */
+		if (res->parent->flags & IORESOURCE_BUSY)
+			res->flags |= IORESOURCE_BUSY;
+
 		pci_bus_add_resource(info->bus, res, 0);
 		info->res_num++;
 		if (addr.translation_offset)
Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -103,6 +103,10 @@ pci_bus_alloc_resource(struct pci_bus *b
 		if (!r)
 			continue;
 
+		/* Driver can not reserve it later, so don't use it */
+		if (r->flags & IORESOURCE_BUSY)
+			continue;
+
 		/* type_mask must match */
 		if ((res->flags ^ r->flags) & type_mask)
 			continue;
