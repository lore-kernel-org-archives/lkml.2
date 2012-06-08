Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2FHFQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:16:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761330Ab2FHFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:26 -0400
Message-Id: <20120608041845.680203839@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joonsoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [ 36/82] slub: fix a memory leak in get_partial_node()
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <js1304@gmail.com>

commit 02d7633fa567be7bf55a993b79d2a31b95ce2227 upstream.

In the case which is below,

1. acquire slab for cpu partial list
2. free object to it by remote cpu
3. page->freelist = t

then memory leak is occurred.

Change acquire_slab() not to zap freelist when it works for cpu partial list.
I think it is a sufficient solution for fixing a memory leak.

Below is output of 'slabinfo -r kmalloc-256'
when './perf stat -r 30 hackbench 50 process 4000 > /dev/null' is done.

***Vanilla***
Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     256  Total  :     468   Sanity Checks : Off  Total: 3833856
SlabObj:     256  Full   :     111   Redzoning     : Off  Used : 2004992
SlabSiz:    8192  Partial:     302   Poisoning     : Off  Loss : 1828864
Loss   :       0  CpuSlab:      55   Tracking      : Off  Lalig:       0
Align  :       8  Objects:      32   Tracing       : Off  Lpadd:       0

***Patched***
Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     256  Total  :     300   Sanity Checks : Off  Total: 2457600
SlabObj:     256  Full   :     204   Redzoning     : Off  Used : 2348800
SlabSiz:    8192  Partial:      33   Poisoning     : Off  Loss :  108800
Loss   :       0  CpuSlab:      63   Tracking      : Off  Lalig:       0
Align  :       8  Objects:      32   Tracing       : Off  Lpadd:       0

Total and loss number is the impact of this patch.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1506,15 +1506,19 @@
 		freelist = page->freelist;
 		counters = page->counters;
 		new.counters = counters;
-		if (mode)
+		if (mode) {
 			new.inuse = page->objects;
+			new.freelist = NULL;
+		} else {
+			new.freelist = freelist;
+		}
 
 		VM_BUG_ON(new.frozen);
 		new.frozen = 1;
 
 	} while (!__cmpxchg_double_slab(s, page,
 			freelist, counters,
-			NULL, new.counters,
+			new.freelist, new.counters,
 			"lock and freeze"));
 
 	remove_partial(n, page);
@@ -1556,7 +1560,6 @@
 			object = t;
 			available =  page->objects - page->inuse;
 		} else {
-			page->freelist = t;
 			available = put_cpu_partial(s, page, 0);
 		}
 		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)


