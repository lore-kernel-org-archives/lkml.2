Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2KLXXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:23:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2KLXXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:23:44 -0500
Date: Mon, 12 Nov 2012 15:23:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] bootmem: fix wrong call parameter for
 free_bootmem()
Message-Id: <20121112152342.ce90052a.akpm@linux-foundation.org>
In-Reply-To: <1352737915-30906-4-git-send-email-js1304@gmail.com>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
	<1352737915-30906-4-git-send-email-js1304@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 01:31:55 +0900
Joonsoo Kim <js1304@gmail.com> wrote:

> It is somehow strange that alloc_bootmem return virtual address
> and free_bootmem require physical address.
> Anyway, free_bootmem()'s first parameter should be physical address.
> 
> There are some call sites for free_bootmem() with virtual address.
> So fix them.

Well gee, I wonder how that happened :(


How does this look?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootmem-fix-wrong-call-parameter-for-free_bootmem-fix

improve free_bootmem() and free_bootmem_pate() documentation

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++--
 mm/bootmem.c            |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/mm/bootmem.c~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
+++ a/mm/bootmem.c
@@ -147,21 +147,21 @@ unsigned long __init init_bootmem(unsign
 
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
- * @addr: starting address of the range
+ * @addr: starting physical address of the range
  * @size: size of the range in bytes
  *
  * This is only useful when the bootmem allocator has already been torn
  * down, but we are still initializing the system.  Pages are given directly
  * to the page allocator, no bootmem metadata is updated because it is gone.
  */
-void __init free_bootmem_late(unsigned long addr, unsigned long size)
+void __init free_bootmem_late(unsigned long physaddr, unsigned long size)
 {
 	unsigned long cursor, end;
 
-	kmemleak_free_part(__va(addr), size);
+	kmemleak_free_part(__va(physaddr), size);
 
-	cursor = PFN_UP(addr);
-	end = PFN_DOWN(addr + size);
+	cursor = PFN_UP(physaddr);
+	end = PFN_DOWN(physaddr + size);
 
 	for (; cursor < end; cursor++) {
 		__free_pages_bootmem(pfn_to_page(cursor), 0);
@@ -385,21 +385,21 @@ void __init free_bootmem_node(pg_data_t 
 
 /**
  * free_bootmem - mark a page range as usable
- * @addr: starting address of the range
+ * @addr: starting physical address of the range
  * @size: size of the range in bytes
  *
  * Partial pages will be considered reserved and left as they are.
  *
  * The range must be contiguous but may span node boundaries.
  */
-void __init free_bootmem(unsigned long addr, unsigned long size)
+void __init free_bootmem(unsigned long physaddr, unsigned long size)
 {
 	unsigned long start, end;
 
-	kmemleak_free_part(__va(addr), size);
+	kmemleak_free_part(__va(physaddr), size);
 
-	start = PFN_UP(addr);
-	end = PFN_DOWN(addr + size);
+	start = PFN_UP(physaddr);
+	end = PFN_DOWN(physaddr + size);
 
 	mark_bootmem(start, end, 0, 0);
 }
--- a/include/linux/bootmem.h~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
+++ a/include/linux/bootmem.h
@@ -51,8 +51,8 @@ extern unsigned long free_all_bootmem(vo
 extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
-extern void free_bootmem(unsigned long addr, unsigned long size);
-extern void free_bootmem_late(unsigned long addr, unsigned long size);
+extern void free_bootmem(unsigned long physaddr, unsigned long size);
+extern void free_bootmem_late(unsigned long physaddr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
_

