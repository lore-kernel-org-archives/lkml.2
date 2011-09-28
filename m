Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1I1J4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:56:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54131 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1I1J4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:56:06 -0400
Date: Wed, 28 Sep 2011 19:56:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Huang Ying <ying.huang@intel.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110928195601.9d0da0ea27186c4ce9349d94@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

In file included from include/linux/irq_work.h:4:0,
                 from include/linux/perf_event.h:510,
                 from arch/sparc/mm/fault_32.c:21:
include/linux/llist.h: In function 'llist_add':
include/linux/llist.h:158:2: error: implicit declaration of function 'in_nmi'
In file included from include/linux/irq_work.h:4:0,
                 from include/linux/perf_event.h:510,
                 from arch/sparc/kernel/unaligned_32.c:18:
include/linux/llist.h: In function 'llist_add':
include/linux/llist.h:158:2: error: implicit declaration of function 'in_nmi'
In file included from include/linux/irq_work.h:4:0,
                 from include/linux/perf_event.h:510,
                 from kernel/sys.c:16:
include/linux/llist.h: In function 'llist_add':
include/linux/llist.h:158:2: error: implicit declaration of function 'in_nmi'

Caused by commit 510d7dc70eab ("llist: make all llist functions inline")
from the akpm tree.

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 19:51:38 +1000
Subject: [PATCH] llist: using in_nmi requires including hardirq.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/llist.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 5d23564..fb81b7b 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -73,6 +73,7 @@ struct llist_node {
 #ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 #define CHECK_NMI_SAFE_CMPXCHG()
 #else
+#include <linux/hardirq.h>
 #define CHECK_NMI_SAFE_CMPXCHG()	BUG_ON(in_nmi())
 #endif
 
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
