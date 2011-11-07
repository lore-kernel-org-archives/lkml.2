Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1KGXX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:23:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab1KGXX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:23:56 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 4/4] ACPI: Remove ./drivers/acpi/atomicio.[ch]
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 16:23:47 -0700
Message-ID: <20111107232347.13472.17553.stgit@amt.stowe>
In-Reply-To: <20111107232321.13472.52069.stgit@amt.stowe>
References: <20111107232321.13472.52069.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

With the conversion of atomicio routines in place, atomicio.[ch] can be
removed, replacing the APEI specific pre-mapping capabilities with the
more generalized versions that commits 620242ae8c3 and 29718521237
provide.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/Makefile   |    1 
 drivers/acpi/atomicio.c |  365 -----------------------------------------------
 include/acpi/atomicio.h |   10 -
 3 files changed, 0 insertions(+), 376 deletions(-)
 delete mode 100644 drivers/acpi/atomicio.c
 delete mode 100644 include/acpi/atomicio.h

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ecb26b4..e7c1d0f 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -19,7 +19,6 @@ obj-y				+= acpi.o \
 
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
-acpi-y				+= atomicio.o
 
 # sleep related files
 acpi-y				+= wakeup.o
diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
deleted file mode 100644
index 7489b89..0000000
--- a/drivers/acpi/atomicio.c
+++ /dev/null
@@ -1,365 +0,0 @@
-/*
- * atomicio.c - ACPI IO memory pre-mapping/post-unmapping, then
- * accessing in atomic context.
- *
- * This is used for NMI handler to access IO memory area, because
- * ioremap/iounmap can not be used in NMI handler. The IO memory area
- * is pre-mapped in process context and accessed in NMI handler.
- *
- * Copyright (C) 2009-2010, Intel Corp.
- *	Author: Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/acpi.h>
-#include <linux/io.h>
-#include <linux/kref.h>
-#include <linux/rculist.h>
-#include <linux/interrupt.h>
-#include <linux/slab.h>
-#include <acpi/atomicio.h>
-
-#define ACPI_PFX "ACPI: "
-
-static LIST_HEAD(acpi_iomaps);
-/*
- * Used for mutual exclusion between writers of acpi_iomaps list, for
- * synchronization between readers and writer, RCU is used.
- */
-static DEFINE_SPINLOCK(acpi_iomaps_lock);
-
-struct acpi_iomap {
-	struct list_head list;
-	void __iomem *vaddr;
-	unsigned long size;
-	phys_addr_t paddr;
-	struct kref ref;
-};
-
-/* acpi_iomaps_lock or RCU read lock must be held before calling */
-static struct acpi_iomap *__acpi_find_iomap(phys_addr_t paddr,
-					    unsigned long size)
-{
-	struct acpi_iomap *map;
-
-	list_for_each_entry_rcu(map, &acpi_iomaps, list) {
-		if (map->paddr + map->size >= paddr + size &&
-		    map->paddr <= paddr)
-			return map;
-	}
-	return NULL;
-}
-
-/*
- * Atomic "ioremap" used by NMI handler, if the specified IO memory
- * area is not pre-mapped, NULL will be returned.
- *
- * acpi_iomaps_lock or RCU read lock must be held before calling
- */
-static void __iomem *__acpi_ioremap_fast(phys_addr_t paddr,
-					 unsigned long size)
-{
-	struct acpi_iomap *map;
-
-	map = __acpi_find_iomap(paddr, size);
-	if (map)
-		return map->vaddr + (paddr - map->paddr);
-	else
-		return NULL;
-}
-
-/* acpi_iomaps_lock must be held before calling */
-static void __iomem *__acpi_try_ioremap(phys_addr_t paddr,
-					unsigned long size)
-{
-	struct acpi_iomap *map;
-
-	map = __acpi_find_iomap(paddr, size);
-	if (map) {
-		kref_get(&map->ref);
-		return map->vaddr + (paddr - map->paddr);
-	} else
-		return NULL;
-}
-
-/*
- * Used to pre-map the specified IO memory area. First try to find
- * whether the area is already pre-mapped, if it is, increase the
- * reference count (in __acpi_try_ioremap) and return; otherwise, do
- * the real ioremap, and add the mapping into acpi_iomaps list.
- */
-static void __iomem *acpi_pre_map(phys_addr_t paddr,
-				  unsigned long size)
-{
-	void __iomem *vaddr;
-	struct acpi_iomap *map;
-	unsigned long pg_sz, flags;
-	phys_addr_t pg_off;
-
-	spin_lock_irqsave(&acpi_iomaps_lock, flags);
-	vaddr = __acpi_try_ioremap(paddr, size);
-	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-	if (vaddr)
-		return vaddr;
-
-	pg_off = paddr & PAGE_MASK;
-	pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
-	vaddr = ioremap(pg_off, pg_sz);
-	if (!vaddr)
-		return NULL;
-	map = kmalloc(sizeof(*map), GFP_KERNEL);
-	if (!map)
-		goto err_unmap;
-	INIT_LIST_HEAD(&map->list);
-	map->paddr = pg_off;
-	map->size = pg_sz;
-	map->vaddr = vaddr;
-	kref_init(&map->ref);
-
-	spin_lock_irqsave(&acpi_iomaps_lock, flags);
-	vaddr = __acpi_try_ioremap(paddr, size);
-	if (vaddr) {
-		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-		iounmap(map->vaddr);
-		kfree(map);
-		return vaddr;
-	}
-	list_add_tail_rcu(&map->list, &acpi_iomaps);
-	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-
-	return map->vaddr + (paddr - map->paddr);
-err_unmap:
-	iounmap(vaddr);
-	return NULL;
-}
-
-/* acpi_iomaps_lock must be held before calling */
-static void __acpi_kref_del_iomap(struct kref *ref)
-{
-	struct acpi_iomap *map;
-
-	map = container_of(ref, struct acpi_iomap, ref);
-	list_del_rcu(&map->list);
-}
-
-/*
- * Used to post-unmap the specified IO memory area. The iounmap is
- * done only if the reference count goes zero.
- */
-static void acpi_post_unmap(phys_addr_t paddr, unsigned long size)
-{
-	struct acpi_iomap *map;
-	unsigned long flags;
-	int del;
-
-	spin_lock_irqsave(&acpi_iomaps_lock, flags);
-	map = __acpi_find_iomap(paddr, size);
-	BUG_ON(!map);
-	del = kref_put(&map->ref, __acpi_kref_del_iomap);
-	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-
-	if (!del)
-		return;
-
-	synchronize_rcu();
-	iounmap(map->vaddr);
-	kfree(map);
-}
-
-/* In NMI handler, should set silent = 1 */
-static int acpi_check_gar(struct acpi_generic_address *reg,
-			  u64 *paddr, int silent)
-{
-	u32 width, space_id;
-
-	width = reg->bit_width;
-	space_id = reg->space_id;
-	/* Handle possible alignment issues */
-	memcpy(paddr, &reg->address, sizeof(*paddr));
-	if (!*paddr) {
-		if (!silent)
-			pr_warning(FW_BUG ACPI_PFX
-			"Invalid physical address in GAR [0x%llx/%u/%u]\n",
-				   *paddr, width, space_id);
-		return -EINVAL;
-	}
-
-	if ((width != 8) && (width != 16) && (width != 32) && (width != 64)) {
-		if (!silent)
-			pr_warning(FW_BUG ACPI_PFX
-				   "Invalid bit width in GAR [0x%llx/%u/%u]\n",
-				   *paddr, width, space_id);
-		return -EINVAL;
-	}
-
-	if (space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
-	    space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
-		if (!silent)
-			pr_warning(FW_BUG ACPI_PFX
-			"Invalid address space type in GAR [0x%llx/%u/%u]\n",
-				   *paddr, width, space_id);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* Pre-map, working on GAR */
-int acpi_pre_map_gar(struct acpi_generic_address *reg)
-{
-	u64 paddr;
-	void __iomem *vaddr;
-	int rc;
-
-	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		return 0;
-
-	rc = acpi_check_gar(reg, &paddr, 0);
-	if (rc)
-		return rc;
-
-	vaddr = acpi_pre_map(paddr, reg->bit_width / 8);
-	if (!vaddr)
-		return -EIO;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(acpi_pre_map_gar);
-
-/* Post-unmap, working on GAR */
-int acpi_post_unmap_gar(struct acpi_generic_address *reg)
-{
-	u64 paddr;
-	int rc;
-
-	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		return 0;
-
-	rc = acpi_check_gar(reg, &paddr, 0);
-	if (rc)
-		return rc;
-
-	acpi_post_unmap(paddr, reg->bit_width / 8);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(acpi_post_unmap_gar);
-
-/*
- * Can be used in atomic (including NMI) or process context. RCU read
- * lock can only be released after the IO memory area accessing.
- */
-static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
-{
-	void __iomem *addr;
-
-	rcu_read_lock();
-	addr = __acpi_ioremap_fast(paddr, width);
-	switch (width) {
-	case 8:
-		*val = readb(addr);
-		break;
-	case 16:
-		*val = readw(addr);
-		break;
-	case 32:
-		*val = readl(addr);
-		break;
-#ifdef readq
-	case 64:
-		*val = readq(addr);
-		break;
-#endif
-	default:
-		return -EINVAL;
-	}
-	rcu_read_unlock();
-
-	return 0;
-}
-
-static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
-{
-	void __iomem *addr;
-
-	rcu_read_lock();
-	addr = __acpi_ioremap_fast(paddr, width);
-	switch (width) {
-	case 8:
-		writeb(val, addr);
-		break;
-	case 16:
-		writew(val, addr);
-		break;
-	case 32:
-		writel(val, addr);
-		break;
-#ifdef writeq
-	case 64:
-		writeq(val, addr);
-		break;
-#endif
-	default:
-		return -EINVAL;
-	}
-	rcu_read_unlock();
-
-	return 0;
-}
-
-/* GAR accessing in atomic (including NMI) or process context */
-int acpi_atomic_read(u64 *val, struct acpi_generic_address *reg)
-{
-	u64 paddr;
-	int rc;
-
-	rc = acpi_check_gar(reg, &paddr, 1);
-	if (rc)
-		return rc;
-
-	*val = 0;
-	switch (reg->space_id) {
-	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		return acpi_atomic_read_mem(paddr, val, reg->bit_width);
-	case ACPI_ADR_SPACE_SYSTEM_IO:
-		return acpi_os_read_port(paddr, (u32 *)val, reg->bit_width);
-	default:
-		return -EINVAL;
-	}
-}
-EXPORT_SYMBOL_GPL(acpi_atomic_read);
-
-int acpi_atomic_write(u64 val, struct acpi_generic_address *reg)
-{
-	u64 paddr;
-	int rc;
-
-	rc = acpi_check_gar(reg, &paddr, 1);
-	if (rc)
-		return rc;
-
-	switch (reg->space_id) {
-	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		return acpi_atomic_write_mem(paddr, val, reg->bit_width);
-	case ACPI_ADR_SPACE_SYSTEM_IO:
-		return acpi_os_write_port(paddr, val, reg->bit_width);
-	default:
-		return -EINVAL;
-	}
-}
-EXPORT_SYMBOL_GPL(acpi_atomic_write);
diff --git a/include/acpi/atomicio.h b/include/acpi/atomicio.h
deleted file mode 100644
index 8b9fb4b..0000000
--- a/include/acpi/atomicio.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef ACPI_ATOMIC_IO_H
-#define ACPI_ATOMIC_IO_H
-
-int acpi_pre_map_gar(struct acpi_generic_address *reg);
-int acpi_post_unmap_gar(struct acpi_generic_address *reg);
-
-int acpi_atomic_read(u64 *val, struct acpi_generic_address *reg);
-int acpi_atomic_write(u64 val, struct acpi_generic_address *reg);
-
-#endif

