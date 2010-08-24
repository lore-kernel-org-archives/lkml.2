Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736Ab0HXXPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:15:37 -0400
Received: from kroah.org ([198.145.64.141]:41127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486Ab0HXXCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:33 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:06 2010
Message-Id: <20100824224506.126043612@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Lameter <cl@linux.com>, Carsten Otte <cotte@de.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [056/114] slab: fix object alignment
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <cotte@de.ibm.com>

commit 1ab335d8f85792e3b107ff8237d53cf64db714df upstream.

This patch fixes alignment of slab objects in case CONFIG_DEBUG_PAGEALLOC is
active.
Before this spot in kmem_cache_create, we have this situation:
- align contains the required alignment of the object
- cachep->obj_offset is 0 or equals align in case of CONFIG_DEBUG_SLAB
- size equals the size of the object, or object plus trailing redzone in case
  of CONFIG_DEBUG_SLAB

This spot tries to fill one page per object if the object is in certain size
limits, however setting obj_offset to PAGE_SIZE - size does break the object
alignment since size may not be aligned with the required alignment.
This patch simply adds an ALIGN(size, align) to the equation and fixes the
object size detection accordingly.

This code in drivers/s390/cio/qdio_setup_init has lead to incorrectly aligned
slab objects (sizeof(struct qdio_q) equals 1792):
	qdio_q_cache = kmem_cache_create("qdio_q", sizeof(struct qdio_q),
					 256, 0, NULL);

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2331,8 +2331,8 @@ kmem_cache_create (const char *name, siz
 	}
 #if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
 	if (size >= malloc_sizes[INDEX_L3 + 1].cs_size
-	    && cachep->obj_size > cache_line_size() && size < PAGE_SIZE) {
-		cachep->obj_offset += PAGE_SIZE - size;
+	    && cachep->obj_size > cache_line_size() && ALIGN(size, align) < PAGE_SIZE) {
+		cachep->obj_offset += PAGE_SIZE - ALIGN(size, align);
 		size = PAGE_SIZE;
 	}
 #endif


