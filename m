Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1JSFJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:09:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1JSFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:09:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=sFbm24qrBVaF2hQCF4YtWdqKQr8NYDqR4TTsCMbnA/O0i6J/RQMJkkSGL7Ng5hntY
	W2tGy1JVBluchn4yoiCNA==
Date: Tue, 18 Oct 2011 22:09:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 2/2] slab: introduce slab_max_order kernel parameter
In-Reply-To: <alpine.DEB.2.00.1110182207500.5907@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1110182208260.5907@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110182207500.5907@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new slab_max_order kernel parameter which is the equivalent of
slub_max_order.

For immediate purposes, allows users to override the heuristic that sets
the max order to 1 by default if they have more than 32MB of RAM.  This
may result in page allocation failures if there is substantial
fragmentation.

Another usecase would be to increase the max order for better
performance.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 mm/slab.c                           |   20 +++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2318,6 +2318,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	slram=		[HW,MTD]
 
+	slab_max_order=	[MM, SLAB]
+			Determines the maximum allowed order for slabs.
+			A high setting may cause OOMs due to memory
+			fragmentation.  Defaults to 1 for systems with
+			more than 32MB of RAM, 0 otherwise.
+
 	slub_debug[=options[,slabs]]	[MM, SLUB]
 			Enabling slub_debug allows one to determine the
 			culprit if slab objects become corrupted. Enabling
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -479,11 +479,13 @@ EXPORT_SYMBOL(slab_buffer_size);
 #endif
 
 /*
- * Do not go above this order unless 0 objects fit into the slab.
+ * Do not go above this order unless 0 objects fit into the slab or
+ * overridden on the command line.
  */
 #define	SLAB_MAX_ORDER_HI	1
 #define	SLAB_MAX_ORDER_LO	0
 static int slab_max_order = SLAB_MAX_ORDER_LO;
+static bool slab_max_order_set __initdata;
 
 /*
  * Functions for storing/retrieving the cachep and or slab from the page
@@ -851,6 +853,17 @@ static int __init noaliencache_setup(char *s)
 }
 __setup("noaliencache", noaliencache_setup);
 
+static int __init slab_max_order_setup(char *str)
+{
+	get_option(&str, &slab_max_order);
+	slab_max_order = slab_max_order < 0 ? 0 :
+				min(slab_max_order, MAX_ORDER - 1);
+	slab_max_order_set = true;
+
+	return 1;
+}
+__setup("slab_max_order=", slab_max_order_setup);
+
 #ifdef CONFIG_NUMA
 /*
  * Special reaping functions for NUMA systems called from cache_reap().
@@ -1499,9 +1512,10 @@ void __init kmem_cache_init(void)
 
 	/*
 	 * Fragmentation resistance on low memory - only use bigger
-	 * page orders on machines with more than 32MB of memory.
+	 * page orders on machines with more than 32MB of memory if
+	 * not overridden on the command line.
 	 */
-	if (totalram_pages > (32 << 20) >> PAGE_SHIFT)
+	if (!slab_max_order_set && totalram_pages > (32 << 20) >> PAGE_SHIFT)
 		slab_max_order = SLAB_MAX_ORDER_HI;
 
 	/* Bootstrap is tricky, because several objects are allocated
