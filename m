Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2AUCOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:14:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab2AUCNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:13:44 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/3] ACPI: Remove ./drivers/acpi/atomicio.[ch]
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Fri, 20 Jan 2012 19:13:37 -0700
Message-ID: <20120121021337.14723.38449.stgit@amt.stowe>
In-Reply-To: <20120121021318.14723.45698.stgit@amt.stowe>
References: <20120121021318.14723.45698.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

With the conversion of atomicio's routines in place (see commits
6f68c91c55e and 700130b41f4), atomicio.[ch] can be removed, replacing
the APEI specific pre-mapping capabilities with the more generalized
versions that drivers/acpi/osl.c provides.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/Makefile   |    1 
 drivers/acpi/atomicio.c |  422 -----------------------------------------------
 include/acpi/atomicio.h |   10 -
 3 files changed, 0 insertions(+), 433 deletions(-)
 delete mode 100644 drivers/acpi/atomicio.c
 delete mode 100644 include/acpi/atomicio.h

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index c07f44f..1567028 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -19,7 +19,6 @@ obj-y				+= acpi.o \
 
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
-acpi-y				+= atomicio.o
 acpi-y				+= nvs.o
 
 # sleep related files
diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
deleted file mode 100644
index d4a5b3d..0000000
--- a/drivers/acpi/atomicio.c
+++ /dev/null
@@ -1,422 +0,0 @@
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
-#include <linux/export.h>
-#include <linux/init.h>
-#include <linux/acpi.h>
-#include <linux/io.h>
-#include <linux/kref.h>
-#include <linux/rculist.h>
-#include <linux/interrupt.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
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
-	map = __acpi_find_iomap(paddr, size/8);
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
-#ifndef CONFIG_IA64
-#define should_use_kmap(pfn)	page_is_ram(pfn)
-#else
-/* ioremap will take care of cache attributes */
-#define should_use_kmap(pfn)	0
-#endif
-
-static void __iomem *acpi_map(phys_addr_t pg_off, unsigned long pg_sz)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (should_use_kmap(pfn)) {
-		if (pg_sz > PAGE_SIZE)
-			return NULL;
-		return (void __iomem __force *)kmap(pfn_to_page(pfn));
-	} else
-		return ioremap(pg_off, pg_sz);
-}
-
-static void acpi_unmap(phys_addr_t pg_off, void __iomem *vaddr)
-{
-	unsigned long pfn;
-
-	pfn = pg_off >> PAGE_SHIFT;
-	if (page_is_ram(pfn))
-		kunmap(pfn_to_page(pfn));
-	else
-		iounmap(vaddr);
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
-	vaddr = acpi_map(pg_off, pg_sz);
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
-		acpi_unmap(pg_off, map->vaddr);
-		kfree(map);
-		return vaddr;
-	}
-	list_add_tail_rcu(&map->list, &acpi_iomaps);
-	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
-
-	return map->vaddr + (paddr - map->paddr);
-err_unmap:
-	acpi_unmap(pg_off, vaddr);
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
-	acpi_unmap(map->paddr, map->vaddr);
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
-#ifdef readq
-static inline u64 read64(const volatile void __iomem *addr)
-{
-	return readq(addr);
-}
-#else
-static inline u64 read64(const volatile void __iomem *addr)
-{
-	u64 l, h;
-	l = readl(addr);
-	h = readl(addr+4);
-	return l | (h << 32);
-}
-#endif
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
-	case 64:
-		*val = read64(addr);
-		break;
-	default:
-		return -EINVAL;
-	}
-	rcu_read_unlock();
-
-	return 0;
-}
-
-#ifdef writeq
-static inline void write64(u64 val, volatile void __iomem *addr)
-{
-	writeq(val, addr);
-}
-#else
-static inline void write64(u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val>>32, addr+4);
-}
-#endif
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
-	case 64:
-		write64(val, addr);
-		break;
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

