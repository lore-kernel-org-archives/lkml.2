Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab2CMILL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:11:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44639 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2CMILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120313.001842.1454669292182923878.davem@davemloft.net>
References: <CAHqTa-3DiZhd_yoRTzp2Np0Rp=_zrfL7CbN_twu+ZZeu7f4ENg@mail.gmail.com>
 <20120312.235002.344576347742686103.davem@davemloft.net> <CAHqTa-3sMRJ0p7driNF+d=f_NZNCF-+TWnCSNO2efEdfv0ayVQ@mail.gmail.com>
 <20120313.001842.1454669292182923878.davem@davemloft.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 04:10:42 -0400
Message-ID: <CAHqTa-2c7pOTicWO8stNJfVfep4gSPHwKdr3kv_Jk-oi=dU5bw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fdinitto@redhat.com, hannes@cmpxchg.org, olaf@aepfle.de,
        paul.gortmaker@windriver.com, tj@kernel.org, hpa@linux.intel.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 3:18 AM, David Miller <davem@davemloft.net> wrote:
> I'm only saying that you should design your stuff such that an
> architecture with such features could easily hook into it using this
> kind facility.

How about this?


diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index a6bb102..7335cf7 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -59,6 +59,8 @@ int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+phys_addr_t memblock_reserve_by_name(const char *name,
+	phys_addr_t size, phys_addr_t align);

 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
@@ -246,6 +248,11 @@ static inline phys_addr_t
memblock_alloc(phys_addr_t size, phys_addr_t align)
 	return 0;
 }

+phys_addr_t memblock_reserve_by_name(const char *name,
+	phys_addr_t size, phys_addr_t align)
+{
+	return 0;
+}
 #endif /* CONFIG_HAVE_MEMBLOCK */

 #endif /* __KERNEL__ */
diff --git a/mm/memblock.c b/mm/memblock.c
index 99f2855..2ab4559 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -519,6 +519,38 @@ int __init_memblock memblock_reserve(phys_addr_t
base, phys_addr_t size)
 	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
 }

+#define RESERVE_SEARCH_END 0xfe000000
+#define RESERVE_SEARCH_JUMP (16*1024*1024)
+
+/**
+ * Find a well-defined location for the given memory area and reserve it.
+ * The generic version just scans through memory looking for an available
+ * area, and ignores the name.  An arch-specific version could request a
+ * named area from the bootloader (eg.  prom_retain()) in the hopes of
+ * getting a region guaranteed not to be messed up by the bootloader.
+ */
+phys_addr_t __init_memblock memblock_reserve_by_name(const char *name,
+	phys_addr_t size, phys_addr_t align)
+{
+	unsigned long where;
+
+	for (where = RESERVE_SEARCH_END - align;
+			where >= RESERVE_SEARCH_JUMP;
+			where -= RESERVE_SEARCH_JUMP) {
+		where &= ~(roundup_pow_of_two(align) - 1);
+		if (memblock_find_in_range(where, where + size,
+					size, align) != 0) {
+			memblock_reserve(where, size);
+			printk(KERN_INFO "memblock(%s): "
+				"reserved %lu @ 0x%08lx\n",
+				name, (unsigned long)size,
+				(unsigned long)where);
+			return where;
+		}
+	}
+	return 0;
+}
+
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
-- 
1.7.7.3
