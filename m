Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1EKQQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:16:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1EKQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:57 -0400
Date: Wed, 11 May 2011 11:35:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS deadlock fixed?
Message-ID: <20110511153546.GA11224@infradead.org>
References: <4DC8B397.20207@taghos.com.br>
 <20110511153501.GA8457@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511153501.GA8457@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here's the actual patch, sorry:


Index: linux-2.6/fs/xfs/linux-2.6/kmem.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/kmem.c	2011-05-11 17:29:51.729191621 +0200
+++ linux-2.6/fs/xfs/linux-2.6/kmem.c	2011-05-11 17:30:22.915689382 +0200
@@ -56,10 +56,12 @@ kmem_alloc(size_t size, unsigned int __n
 		ptr = kmalloc(size, lflags);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
-		if (!(++retries % 100))
+		if (!(++retries % 100)) {
 			xfs_err(NULL,
 		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, lflags);
+			dump_stack();
+		}
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
@@ -112,10 +114,12 @@ kmem_zone_alloc(kmem_zone_t *zone, unsig
 		ptr = kmem_cache_alloc(zone, lflags);
 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
 			return ptr;
-		if (!(++retries % 100))
+		if (!(++retries % 100)) {
 			xfs_err(NULL,
 		"possible memory allocation deadlock in %s (mode:0x%x)",
 					__func__, lflags);
+			dump_stack();
+		}
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
