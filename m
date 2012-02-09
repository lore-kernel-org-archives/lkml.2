Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2BIWj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:39:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab2BIWjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:39:25 -0500
Date: Thu, 9 Feb 2012 14:39:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: daniel.santos@pobox.com
Cc: Daniel Santos <danielfsantos@att.net>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mm/slab.c: remove effectively dead code from kmem_cache_create
Message-Id: <20120209143924.886e0ff6.akpm@linux-foundation.org>
In-Reply-To: <4F334897.5010405@att.net>
References: <4F334897.5010405@att.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Feb 2012 22:16:23 -0600
Daniel Santos <danielfsantos@att.net> wrote:

> I was examining slab.c when I noticed that there is code that will never
> be executed, but that the compiler probably wouldn't determine as such. 

Please cc the maintainer (Pekka) on slab patches.

Please include a Signed-off-by: on patches, as discussed in
Documentation/SubmittingPatches.

--- a/mm/slab.c~mm-slabc-remove-effectively-dead-code-from-kmem_cache_create
+++ a/mm/slab.c
@@ -2326,6 +2326,7 @@ kmem_cache_create (const char *name, siz
 		ralign = BYTES_PER_WORD;
 	}
 
+#if DEBUG
 	/*
 	 * Redzoning and user store require word alignment or possibly larger.
 	 * Note this will be overridden by architecture or caller mandated
@@ -2341,6 +2342,7 @@ kmem_cache_create (const char *name, siz
 		size += REDZONE_ALIGN - 1;
 		size &= ~(REDZONE_ALIGN - 1);
 	}
+#endif
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2350,9 +2352,13 @@ kmem_cache_create (const char *name, siz
 	if (ralign < align) {
 		ralign = align;
 	}
+
+#if DEBUG
 	/* disable debug if necessary */
 	if (ralign > __alignof__(unsigned long long))
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
+#endif
+
 	/*
 	 * 4) Store it.
 	 */
@@ -2442,7 +2448,7 @@ kmem_cache_create (const char *name, siz
 		slab_size =
 		    cachep->num * sizeof(kmem_bufctl_t) + sizeof(struct slab);
 
-#ifdef CONFIG_PAGE_POISONING
+#if DEBUG && defined(CONFIG_PAGE_POISONING)
 		/* If we're going to use the generic kernel_map_pages()
 		 * poisoning, then it's going to smash the contents of
 		 * the redzone and userword anyhow, so switch them off.
_


kmem_cache_create() is called extremely rarely, so the performance
benefit here is negligible.

We could presumably avoid two of those ifdefs by defining SLAB_RED_ZONE
and SLAB_STORE_USER to be zero if !defined(DEBUG).  Personally I think
that's a bit too subtle and would prefer the explicit ifdefs.

In my x86_64 allnoconfig build the patch reduces slab.o's text size
from 12859 bytes to 12812.  I'll let Pekka decide if that's worth it ;)
