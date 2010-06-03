Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0FCUok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:44:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44368 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab0FCUoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:44:38 -0400
Message-ID: <4C0813D7.7080900@oracle.com>
Date: Thu, 03 Jun 2010 13:43:03 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
References: <bug-16009-13546@https.bugzilla.kernel.org/> <201005191637.13177.bjorn.helgaas@hp.com> <201005202236.20444.bjorn.helgaas@hp.com> <201006021536.43333.bjorn.helgaas@hp.com> <4C070ECA.2020309@oracle.com>
In-Reply-To: <4C070ECA.2020309@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C081432.01C8:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure We can reject wrong size from BIOS.

https://bugzilla.kernel.org/show_bug.cgi?id=16009
Yannick found that video does not work with 2.6.34

the root cause:
BIOS assigned wrong range to pci bridge.  and before 2.6.34 kernel will
just get range that is needed.
for 2.6.34.
|	d65245c PCI: don't shrink bridge resources
will try to range size is bigger than old one.
(used by boot stage multi-try to get big BAR size for pci bridge,
 and pcie hotplug to get big range)

So try to 0 for old size for pci bridge in this boot stage case.

Reported-by: Yannick <yannick.roehlly@free.fr>
Analyzed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/microblaze/pci/pci-common.c        |    1 +
 arch/mn10300/unit-asb2305/pci-asb2305.c |    1 +
 arch/powerpc/kernel/pci-common.c        |    1 +
 arch/x86/pci/i386.c                     |    1 +
 4 files changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -136,6 +136,7 @@ static void __init pcibios_allocate_bus_
 					 * child resource allocations in this
 					 * range.
 					 */
+					r->start = r->end = 0;
 					r->flags = 0;
 				}
 			}
Index: linux-2.6/arch/microblaze/pci/pci-common.c
===================================================================
--- linux-2.6.orig/arch/microblaze/pci/pci-common.c
+++ linux-2.6/arch/microblaze/pci/pci-common.c
@@ -1277,6 +1277,7 @@ void pcibios_allocate_bus_resources(stru
 		printk(KERN_WARNING "PCI: Cannot allocate resource region "
 		       "%d of PCI bridge %d, will remap\n", i, bus->number);
 clear_resource:
+		res->start = res->end = 0;
 		res->flags = 0;
 	}
 
Index: linux-2.6/arch/mn10300/unit-asb2305/pci-asb2305.c
===================================================================
--- linux-2.6.orig/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ linux-2.6/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -117,6 +117,7 @@ static void __init pcibios_allocate_bus_
 					 * Invalidate the resource to prevent
 					 * child resource allocations in this
 					 * range. */
+					r->start = r->end = 0;
 					r->flags = 0;
 				}
 			}
Index: linux-2.6/arch/powerpc/kernel/pci-common.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/pci-common.c
+++ linux-2.6/arch/powerpc/kernel/pci-common.c
@@ -1309,6 +1309,7 @@ void pcibios_allocate_bus_resources(stru
 		printk(KERN_WARNING "PCI: Cannot allocate resource region "
 		       "%d of PCI bridge %d, will remap\n", i, bus->number);
 clear_resource:
+		res->start = res->end = 0;
 		res->flags = 0;
 	}
 
