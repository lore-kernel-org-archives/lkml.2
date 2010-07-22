Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0GVD6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:58:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57619 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab0GVD6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:58:19 -0400
Date: Thu, 22 Jul 2010 13:58:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Dave Airlie <airlied@redhat.com>,
        Geert Stappers <stappers@stappers.nl>
Subject: linux-next: build failure after merge of the final tree (Linus'
 tree related)
Message-Id: <20100722135815.de838491.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_a
rray_wb':
drivers/gpu/drm/ttm/ttm_page_alloc.c:227: error: implicit declaration of function 'unmap_page_from_agp'
drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wc':
drivers/gpu/drm/ttm/ttm_page_alloc.c:238: error: implicit declaration of function 'map_page_into_agp'

Presumably caused by commit 1e8655f87333def92bb8215b423adc65403b08a5
("drm/ttm: Fix build on architectures without AGP") as unmap_page_from_agp()
is declared in asm/agp.h.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Jul 2010 13:53:55 +1000
Subject: [PATCH] drm/ttm: really fix build on architectures without AGP

After commit 1e8655f87333def92bb8215b423adc65403b08a5
("drm/ttm: Fix build on architectures without AGP") was merged, linux-next
got this build failure for a powerpc allyesconfig build:

drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_a
rray_wb':
drivers/gpu/drm/ttm/ttm_page_alloc.c:227: error: implicit declaration of function 'unmap_page_from_agp'
drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wc':
drivers/gpu/drm/ttm/ttm_page_alloc.c:238: error: implicit declaration of function 'map_page_into_agp'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d233c65..590f0c2 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -40,12 +40,12 @@
 #include <linux/slab.h>
 
 #include <asm/atomic.h>
-#ifdef TTM_HAS_AGP
-#include <asm/agp.h>
-#endif
 
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"
+#ifdef TTM_HAS_AGP
+#include <asm/agp.h>
+#endif
 
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
