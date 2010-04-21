Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0DUFiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:38:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64260 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0DUFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:38:08 -0400
Message-ID: <4BCE8E76.9000704@oracle.com>
Date: Tue, 20 Apr 2010 22:34:46 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/3] x86, resource: Add reserve_region_with_split_check_child()
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC4F03C.1020707@oracle.com> <4BC4F320.8020902@zytor.com> <4BC4F703.5030700@oracle.com> <4BC4F80C.2020209@zytor.com> <4BC4F851.7040500@oracle.com> <4BC4F948.8050500@zytor.com> <4BC4F9C2.20503@oracle.com> <4BCE8E3E.4030809@oracle.com>
In-Reply-To: <4BCE8E3E.4030809@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BCE8EF2.0080:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



It will cover the whole region to BUSY, except that some regions that have
children under them.

those children normally is PCI bar but it is falling into E820_RESERVED.
We can not put BUSY on them, otherwise driver can not use pci_request_region()
later

/proc/iomem will have
00010000-00094fff : System RAM
00095000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : reserved
000c0000-000cffff : reserved
000d0000-000dffff : PCI Bus 0000:00
  000d0000-000dffff : reserved
000e0000-000fffff : reserved

Tested-by: Guenter Roeck <guenter.roeck@ericsson.com>
Tested-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   10 +++++++---
 include/linux/ioport.h |    3 +++
 kernel/resource.c      |   24 +++++++++++++++++++-----
 3 files changed, 29 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1094,7 +1094,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (e820.map[i].type != E820_RESERVED) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
@@ -1135,8 +1135,12 @@ void __init e820_reserve_resources_late(
 
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
-		if (!res->parent && res->end)
-			insert_resource_expand_to_fit(&iomem_resource, res);
+		if (!res->parent && res->end) {
+			if (res->start < (1ULL<<20))
+				reserve_region_with_split_check_child(&iomem_resource, res->start, res->end, res->name);
+			else
+				insert_resource_expand_to_fit(&iomem_resource, res);
+		}
 		res++;
 	}
 
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -120,6 +120,9 @@ void release_child_resources(struct reso
 extern void reserve_region_with_split(struct resource *root,
 			     resource_size_t start, resource_size_t end,
 			     const char *name);
+void reserve_region_with_split_check_child(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     const char *name);
 extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -609,7 +609,7 @@ int adjust_resource(struct resource *res
 
 static void __init __reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
-		const char *name)
+		const char *name, bool check_child)
 {
 	struct resource *parent = root;
 	struct resource *conflict;
@@ -631,13 +631,18 @@ static void __init __reserve_region_with
 	kfree(res);
 
 	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
+	if (conflict->start <= start && conflict->end >= end) {
+		if (check_child && !conflict->child && strstr(conflict->name, "PCI Bus"))
+			__reserve_region_with_split(conflict, start, end, name, false);
 		return;
+	}
 
 	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
+		__reserve_region_with_split(root, start, conflict->start-1, name, check_child);
 	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
+		__reserve_region_with_split(root, conflict->end+1, end, name, check_child);
+	if (check_child && !conflict->child && strstr(conflict->name, "PCI Bus"))
+		__reserve_region_with_split(conflict, conflict->start, conflict->end, name, false);
 }
 
 void __init reserve_region_with_split(struct resource *root,
@@ -645,7 +650,16 @@ void __init reserve_region_with_split(st
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	__reserve_region_with_split(root, start, end, name, false);
+	write_unlock(&resource_lock);
+}
+
+void __init reserve_region_with_split_check_child(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name, true);
 	write_unlock(&resource_lock);
 }
 
