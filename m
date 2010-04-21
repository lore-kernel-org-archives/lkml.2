Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0DUFje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:39:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58690 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0DUFjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:39:32 -0400
Message-ID: <4BCE8EBF.5050207@oracle.com>
Date: Tue, 20 Apr 2010 22:35:59 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC4F03C.1020707@oracle.com> <4BC4F320.8020902@zytor.com> <4BC4F703.5030700@oracle.com> <4BC4F80C.2020209@zytor.com> <4BC4F851.7040500@oracle.com> <4BC4F948.8050500@zytor.com> <4BC4F9C2.20503@oracle.com> <4BCE8E3E.4030809@oracle.com>
In-Reply-To: <4BCE8E3E.4030809@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BCE8F34.0019:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Don't clear root bus resource too early, until We can make sure _CRS works

also restore it, if all _CRS get rejected because of conflicts

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -196,9 +196,6 @@ get_current_resources(struct acpi_device
 	struct pci_root_info info;
 	size_t size;
 
-	if (pci_use_crs)
-		pci_bus_remove_resources(bus);
-
 	info.bridge = device;
 	info.bus = bus;
 	info.res_num = 0;
@@ -217,10 +214,20 @@ get_current_resources(struct acpi_device
 		goto name_alloc_fail;
 	sprintf(info.name, "PCI Bus %04x:%02x", domain, busnum);
 
+	/* Only clear that when _CRS works for sure*/
+	if (pci_use_crs)
+		pci_bus_remove_resources(bus);
+
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				&info);
 
+	if (pci_use_crs && !info.res_num) {
+		/* Restore default one */
+		bus->resource[0] = &ioport_resource;
+		bus->resource[1] = &iomem_resource;
+	}
+
 	return;
 
 name_alloc_fail:
