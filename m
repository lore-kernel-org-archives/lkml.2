Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0HYXcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:32:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6852 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0HYXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:32:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BIkm6b5cLp4if+xda/AvOxklhliySVAyJqfEnDlZigBYmX2ZDO6KNfjpTNnEG+o4Q
	bqfhoVeiBBrFdciOFQtow==
Date: Wed, 25 Aug 2010 16:32:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
In-Reply-To: <alpine.DEB.2.00.1008251447410.22117@router.home>
Message-ID: <alpine.DEB.2.00.1008251622500.31521@chino.kir.corp.google.com>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au> <20100825094559.bc652afe.randy.dunlap@oracle.com> <alpine.DEB.2.00.1008251409260.22117@router.home> <20100825122134.2ac33360.randy.dunlap@oracle.com>
 <alpine.DEB.2.00.1008251447410.22117@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Christoph Lameter wrote:

> > Certainly.  config file is attached.
> 
> Ah. Memory hotplug....
> 
> 
> 
> Subject: Slub: Fix up missing kmalloc_cache -> kmem_cache_node case for memoryhotplug
> 
> Memory hotplug allocates and frees per node structures. Use the correct name.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>

But we also need to fixup SLUB_RESILIENCY_TEST.


slub: fix SLUB_RESILIENCY_TEST for dynamic kmalloc caches

Now that the kmalloc_caches array is dynamically allocated at boot, 
SLUB_RESILIENCY_TEST needs to be fixed to pass the correct type.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3486,6 +3486,8 @@ static void resiliency_test(void)
 {
 	u8 *p;
 
+	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 16 || SLUB_PAGE_SHIFT < 10);
+
 	printk(KERN_ERR "SLUB resiliency testing\n");
 	printk(KERN_ERR "-----------------------\n");
 	printk(KERN_ERR "A. Corruption after allocation\n");
@@ -3495,7 +3497,7 @@ static void resiliency_test(void)
 	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
 			" 0x12->0x%p\n\n", p + 16);
 
-	validate_slab_cache(kmalloc_caches + 4);
+	validate_slab_cache(kmalloc_caches[4]);
 
 	/* Hmmm... The next two are dangerous */
 	p = kzalloc(32, GFP_KERNEL);
@@ -3505,7 +3507,7 @@ static void resiliency_test(void)
 	printk(KERN_ERR
 		"If allocated object is overwritten then not detectable\n\n");
 
-	validate_slab_cache(kmalloc_caches + 5);
+	validate_slab_cache(kmalloc_caches[5]);
 	p = kzalloc(64, GFP_KERNEL);
 	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
 	*p = 0x56;
@@ -3513,27 +3515,27 @@ static void resiliency_test(void)
 									p);
 	printk(KERN_ERR
 		"If allocated object is overwritten then not detectable\n\n");
-	validate_slab_cache(kmalloc_caches + 6);
+	validate_slab_cache(kmalloc_caches[6]);
 
 	printk(KERN_ERR "\nB. Corruption after free\n");
 	p = kzalloc(128, GFP_KERNEL);
 	kfree(p);
 	*p = 0x78;
 	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches + 7);
+	validate_slab_cache(kmalloc_caches[7]);
 
 	p = kzalloc(256, GFP_KERNEL);
 	kfree(p);
 	p[50] = 0x9a;
 	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n",
 			p);
-	validate_slab_cache(kmalloc_caches + 8);
+	validate_slab_cache(kmalloc_caches[8]);
 
 	p = kzalloc(512, GFP_KERNEL);
 	kfree(p);
 	p[512] = 0xab;
 	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
-	validate_slab_cache(kmalloc_caches + 9);
+	validate_slab_cache(kmalloc_caches[9]);
 }
 #else
 static void resiliency_test(void) {};
