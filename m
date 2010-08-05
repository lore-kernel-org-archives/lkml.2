Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0HERd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:33:27 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:32332 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752388Ab0HERdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:33:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Q8NhY5YVM1kDPZEhSAWXZd0SBwyR4r5pzcp5mdmXtLBnnF2
 gr825UP40AcyswkNpGChxmNrK7lN6N8ojTxjFrerolefBv5R_Dh7KOmqAmxe
 wzTFw9_W8I0DiIvFmH.oC6UCYtvIzqXStEro2_iR1QNL4d28VjGJ8l0AUQ99
 30Goqepq5uftqnjLyiXcx8q9v.hQhgCNbMrP3SQ2hafqrzQCBEibbPDIosaM
 V8KEe0HqPk.Dmc4lXh3pBo4ZbZSi6VbY1rQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 5 Aug 2010 12:33:22 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008051231400.6787@router.home>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, David Rientjes wrote:

> I bisected this to patch 8 but still don't have a bootlog.  I'm assuming
> in the meantime that something is kmallocing DMA memory on this machine
> prior to kmem_cache_init_late() and get_slab() is returning a NULL
> pointer.

There is a kernel option "earlyprintk=..." that allows you to see early
boot messages.

If this indeed is a problem with the DMA caches then try the following
patch:



Subject: slub: Move dma cache initialization up

Do dma kmalloc initialization in kmem_cache_init and not in kmem_cache_init_late()

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-08-05 12:24:21.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-08-05 12:28:58.000000000 -0500
@@ -3866,13 +3866,8 @@ void __init kmem_cache_init(void)
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
 #endif
-}

-void __init kmem_cache_init_late(void)
-{
 #ifdef CONFIG_ZONE_DMA
-	int i;
-
 	/* Create the dma kmalloc array and make it operational */
 	for (i = 0; i < SLUB_PAGE_SHIFT; i++) {
 		struct kmem_cache *s = kmalloc_caches[i];
@@ -3891,6 +3886,10 @@ void __init kmem_cache_init_late(void)
 #endif
 }

+void __init kmem_cache_init_late(void)
+{
+}
+
 /*
  * Find a mergeable slab cache
  */
