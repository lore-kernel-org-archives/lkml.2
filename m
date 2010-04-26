Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0DZWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:06:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63805 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab0DZWGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:06:54 -0400
Message-ID: <4BD60E0A.204@oracle.com>
Date: Mon, 26 Apr 2010 15:04:58 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: [PATCH -v5 3/3] x86, resource: Add reserve_region_with_split_check_child()
References: <4BC4E55B.7000103@oracle.com>	<20100426183436.GV11130@hexapodia.org>	<20100426123135.5d095d2f@virtuousgeek.org>	<201004261427.57229.bjorn.helgaas@hp.com>	<20100426133757.3e1d0a75@virtuousgeek.org>	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com> <20100426142546.2e77b1ba@virtuousgeek.org> <4BD60CD5.4060601@oracle.com> <4BD60CD4.9020708@oracle.com>
In-Reply-To: <4BD60CD4.9020708@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BD60E5A.0145:SCFMA922111,ss=1,fgs=0
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

v5: Add function pointer to put string comparing with caller

Tested-by: Guenter Roeck <guenter.roeck@ericsson.com>
Tested-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   18 +++++++++++++++---
 include/linux/ioport.h |    3 +++
 kernel/resource.c      |   29 ++++++++++++++++++++++++-----
 3 files changed, 42 insertions(+), 8 deletions(-)

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
@@ -1128,6 +1128,14 @@ static unsigned long ram_alignment(resou
 
 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)
 
+static int __init check_func(struct resource *cf)
+{
+	if (strstr(cf->name, "PCI Bus"))
+		return 1;
+
+        return 0;
+}
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1135,8 +1143,12 @@ void __init e820_reserve_resources_late(
 
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
-		if (!res->parent && res->end)
-			insert_resource_expand_to_fit(&iomem_resource, res);
+		if (!res->parent && res->end) {
+			if (res->start < (1ULL<<20))
+				reserve_region_with_split_check_child(&iomem_resource, res->start, res->end, res->name, check_func);
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
+			     const char *name, int (*check_func)(struct resource *cf));
 extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -607,9 +607,14 @@ int adjust_resource(struct resource *res
 	return result;
 }
 
+static int __init check_func_nop(struct resource *cf)
+{
+	return 1;
+}
+
 static void __init __reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
-		const char *name)
+		const char *name, bool check_child, int (*check_func)(struct resource *cf))
 {
 	struct resource *parent = root;
 	struct resource *conflict;
@@ -631,13 +636,18 @@ static void __init __reserve_region_with
 	kfree(res);
 
 	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
+	if (conflict->start <= start && conflict->end >= end) {
+		if (check_child && !conflict->child && check_func(conflict))
+			__reserve_region_with_split(conflict, start, end, name, false, check_func_nop);
 		return;
+	}
 
 	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
+		__reserve_region_with_split(root, start, conflict->start-1, name, check_child, check_func);
 	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
+		__reserve_region_with_split(root, conflict->end+1, end, name, check_child, check_func);
+	if (check_child && !conflict->child && check_func(conflict))
+		__reserve_region_with_split(conflict, conflict->start, conflict->end, name, false, check_func_nop);
 }
 
 void __init reserve_region_with_split(struct resource *root,
@@ -645,7 +655,16 @@ void __init reserve_region_with_split(st
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	__reserve_region_with_split(root, start, end, name, false, check_func_nop);
+	write_unlock(&resource_lock);
+}
+
+void __init reserve_region_with_split_check_child(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name, int (*check_func)(struct resource *cf))
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name, true, check_func);
 	write_unlock(&resource_lock);
 }
 
