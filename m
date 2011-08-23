Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1HWAfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:35:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:1043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1HWAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,266,1312182000"; 
   d="scan'208";a="41286712"
Subject: [patch 1/2]slub: add slab with one free object to partial list tail
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        cl@linux.com, penberg@kernel.org, "Shi, Alex" <alex.shi@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 08:36:59 +0800
Message-ID: <1314059819.29510.18.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slab has just one free object, adding it to partial list head doesn't make
sense. And it can cause lock contentation. For example,
1. CPU takes the slab from partial list
2. fetch an object
3. switch to another slab
4. free an object, then the slab is added to partial list again
In this way n->list_lock will be heavily contended.
In fact, Alex had a hackbench regression. 3.1-rc1 performance drops about 70%
against 3.0. This patch fixes it.

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2011-08-15 09:55:21.000000000 +0800
+++ linux/mm/slub.c	2011-08-23 08:13:54.000000000 +0800
@@ -2377,7 +2377,7 @@ static void __slab_free(struct kmem_cach
 		 */
 		if (unlikely(!prior)) {
 			remove_full(s, page);
-			add_partial(n, page, 0);
+			add_partial(n, page, 1);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}


