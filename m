Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0HQE4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:56:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0HQE4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:56:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jbk6o/cV1FC2hIsR7gZ9zO60DyQwXiWrTU//iMMHwb6THuqOAyjjBL7+vzOrDJz+a
	rNUdCM83yp7GsXyJCmxnQ==
Date: Mon, 16 Aug 2010 21:56:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008051231400.6787@router.home>
Message-ID: <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008051231400.6787@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Christoph Lameter wrote:

> > I bisected this to patch 8 but still don't have a bootlog.  I'm assuming
> > in the meantime that something is kmallocing DMA memory on this machine
> > prior to kmem_cache_init_late() and get_slab() is returning a NULL
> > pointer.
> 
> There is a kernel option "earlyprintk=..." that allows you to see early
> boot messages.
> 

Ok, so this is panicking because of the error handling when trying to 
create sysfs directories with the same name (in this case, :dt-0000064).  
I'll look into while this isn't failing gracefully later, but I isolated 
this to the new code that statically allocates the DMA caches in 
kmem_cache_init_late().

The iteration runs from 0 to SLUB_PAGE_SHIFT; that's actually incorrect 
since the kmem_cache_node cache occupies the first spot in the 
kmalloc_caches array and has a size, 64 bytes, equal to a power of two 
that is duplicated later.  So this patch tries creating two DMA kmalloc 
caches with 64 byte object size which triggers a BUG_ON() during 
kmem_cache_release() in the error handling later.

The fix is to start the iteration at 1 instead of 0 so that all other 
caches have their equivalent DMA caches created and the special-case 
kmem_cache_node cache is excluded (see below).

I'm really curious why nobody else ran into this problem before, 
especially if they have CONFIG_SLUB_DEBUG enabled so 
struct kmem_cache_node has the same size.  Perhaps my early bug report 
caused people not to test the series...

I'm adding Tejun Heo to the cc because of another thing that may be 
problematic: alloc_percpu() allocates GFP_KERNEL memory, so when we try to 
allocate kmem_cache_cpu for a DMA cache we may be returning memory from a 
node that doesn't include lowmem so there will be no affinity between the 
struct and the slab.  I'm wondering if it would be better for the percpu 
allocator to be extended for kzalloc_node(), or vmalloc_node(), when 
allocating memory after the slab layer is up.

There're a couple more issues with the patch as well:

 - the entire iteration in kmem_cache_init_late() needs to be protected by 
   slub_lock.  The comment in create_kmalloc_cache() should be revised 
   since you're no longer calling it only with irqs disabled.  
   kmem_cache_init_late() has irqs enabled and, thus, slab_caches must be 
   protected.

 - a BUG_ON(!name) needs to be added in kmem_cache_init_late() when 
   kasprintf() returns NULL.  This isn't checked in kmem_cache_open() so 
   it'll only encounter a problem in the sysfs layer.  Adding a BUG_ON() 
   will help track those down.

Otherwise, I didn't find any problem with removing the dynamic DMA cache 
allocation on my machines.

Please fold this into patch 8.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2552,13 +2552,12 @@ static int __init setup_slub_nomerge(char *str)
 
 __setup("slub_nomerge", setup_slub_nomerge);
 
+/*
+ * Requires slub_lock if called when irqs are enabled after early boot.
+ */
 static void create_kmalloc_cache(struct kmem_cache *s,
 		const char *name, int size, unsigned int flags)
 {
-	/*
-	 * This function is called with IRQs disabled during early-boot on
-	 * single CPU so there's no need to take slub_lock here.
-	 */
 	if (!kmem_cache_open(s, name, size, ARCH_KMALLOC_MINALIGN,
 								flags, NULL))
 		goto panic;
@@ -3063,17 +3062,20 @@ void __init kmem_cache_init_late(void)
 #ifdef CONFIG_ZONE_DMA
 	int i;
 
-	for (i = 0; i < SLUB_PAGE_SHIFT; i++) {
+	down_write(&slub_lock);
+	for (i = 1; i < SLUB_PAGE_SHIFT; i++) {
 		struct kmem_cache *s = &kmalloc_caches[i];
 
-		if (s && s->size) {
+		if (s->size) {
 			char *name = kasprintf(GFP_KERNEL,
 				 "dma-kmalloc-%d", s->objsize);
 
+			BUG_ON(!name);
 			create_kmalloc_cache(&kmalloc_dma_caches[i],
 				name, s->objsize, SLAB_CACHE_DMA);
 		}
 	}
+	up_write(&slub_lock);
 #endif
 }
 
