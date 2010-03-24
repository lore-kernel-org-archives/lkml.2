Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0CXISp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:18:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:42034 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0CXISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:18:43 -0400
Subject: [PATCH 1/2] mm/vmalloc: Export purge_vmap_area_lazy()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Nathan Fontenot <nfont@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 18:56:31 +1100
Message-ID: <1269417391.8599.188.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc code needs to ensure that all previous iounmap/vunmap has
really been flushed out of the MMU hash table. Without that, various
hotplug operations may fail when trying to return those pieces to
the hypervisor due to existing active mappings.

This exports purge_vmap_area_lazy() to allow the powerpc code to perform
that purge when unplugging devices.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

Nick, care to give me an Ack so I can get that upstream along with
the next patch ASAP (and back into distros) ?

Thanks !
Ben.

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..0d0ae4e 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -99,6 +99,7 @@ extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
 				    pgprot_t prot, struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+extern void purge_vmap_area_lazy(void);
 
 /* Allocate/destroy a 'vmalloc' VM area. */
 extern struct vm_struct *alloc_vm_area(size_t size);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..d25c741 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -317,8 +317,6 @@ static void __insert_vmap_area(struct vmap_area *va)
 		list_add_rcu(&va->list, &vmap_area_list);
 }
 
-static void purge_vmap_area_lazy(void);
-
 /*
  * Allocate a region of KVA of the specified size and alignment, within the
  * vstart and vend.
@@ -590,12 +588,13 @@ static void try_purge_vmap_area_lazy(void)
 /*
  * Kick off a purge of the outstanding lazy areas.
  */
-static void purge_vmap_area_lazy(void)
+void purge_vmap_area_lazy(void)
 {
 	unsigned long start = ULONG_MAX, end = 0;
 
 	__purge_vmap_area_lazy(&start, &end, 1, 0);
 }
+EXPORT_SYMBOL_GPL(purge_vmap_area_lazy);
 
 /*
  * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been


