Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab0FQSnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:43:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51374 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab0FQSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:43:44 -0400
Message-ID: <4C1A6C27.5090106@kernel.org>
Date: Thu, 17 Jun 2010 11:40:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug 16228] BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
References: <bug-16228-13546@https.bugzilla.kernel.org/> <201006171637.o5HGbgnO009943@demeter.kernel.org>
In-Reply-To: <201006171637.o5HGbgnO009943@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4C1A6C9D.0116,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 09:37 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=16228
> 
> 
> Bjorn Helgaas <bjorn.helgaas@hp.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |yinghai@kernel.org
> 
> 
> 
> 
> --- Comment #8 from Bjorn Helgaas <bjorn.helgaas@hp.com>  2010-06-17 16:37:42 ---
> That's perfect, thanks!
> 
> The E820 memory map from BIOS reports a range that overlaps the first
> megabyte (0xbff00000-0xbfffffff) of that host bridge window:
> 
>   BIOS-e820: 0000000000100000 - 00000000bfdf9c00 (usable)
>   BIOS-e820: 00000000bfdf9c00 - 00000000bfe4bc00 (ACPI NVS)
>   BIOS-e820: 00000000bfe4bc00 - 00000000bfe4dc00 (ACPI data)
>   BIOS-e820: 00000000bfe4dc00 - 00000000c0000000 (reserved)
>   pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
> 
> The 0x100000-0xbfdf9c00 range is system RAM, and I would expect that
> the ACPI NVS and data area is also RAM, and the last reserved piece is
> probably RAM, too, because RAM tends to end at nicely aligned boundaries.
> 
> Table 14-1 in the ACPI 4.0 spec says "reserved" ranges from the E820
> table are "unsuitable for a standard device to use as a device memory
> space."
> 
> I think maybe Linux should regard those reserved ranges as unavailable
> for allocation to PCI devices, even if they happen to be included in a
> host bridge window.  What do you think, Yinghai?

for above 1M area, 
current kernel will honor setting from HW register and later will use insert_resource_expand_to_fit()
with e820 reserved entries.
so in this case will have one big 0xbfe4dc00 - 0xe000000 reserved entry in /proc/iomem as parent of
0xbff00000 - 0xe0000000

Sane BIOS should not put allocated range to PCI bridge/device into e820 table as reserved entries.

But there IS some BIOS doing that.
So Linus decided to trust setting from PCI bar at first.

later for pci_assign_unsigned, We should avoid those range.

one solution is expanding my one of old version for below 1M handling to:
use reserve_region_with_split instead.
will get /proc/iomem
bfe4dc00 - bfefffff reserved
bff00000 - dfffffff PCI BUS #00
  bff00000 - bfffffff reserved
  ...

so will use bff0000 - bfffffff reserved as holder to prevent those range to be allocated to unassigned devices.
reserve_region_with_split need to need be updated a little bit to make sure it will not put holder on range with children already.

something like this

Subject: [PATCH] x86, resource: Add reserve_region_with_split_check_child()

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

-v2: Add function pointer to put string comparing with caller
-v3: expand to use it above 1M resources.

Tested-by: Guenter Roeck <guenter.roeck@ericsson.com>
Tested-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   15 ++++++++++++---
 include/linux/ioport.h |    3 +++
 kernel/resource.c      |   29 ++++++++++++++++++++++++-----
 3 files changed, 39 insertions(+), 8 deletions(-)

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
@@ -1135,8 +1143,9 @@ void __init e820_reserve_resources_late(
 
 	res = e820_res;
 	for (i = 0; i < e820.nr_map; i++) {
-		if (!res->parent && res->end)
-			insert_resource_expand_to_fit(&iomem_resource, res);
+		if (!res->parent && res->end) {
+			reserve_region_with_split_check_child(&iomem_resource, res->start, res->end, res->name, check_func);
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
 
