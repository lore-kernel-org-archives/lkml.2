Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2GFH54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:57:56 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36489 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2GFH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:57:54 -0400
Message-ID: <1341561460.24895.12.camel@ThinkPad-T420>
Subject: [PATCH powerpc 2/2 v3] kfree the cache name of pgtable cache
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Fri, 06 Jul 2012 15:57:40 +0800
In-Reply-To: <1341561286.24895.9.camel@ThinkPad-T420>
References: <1341561286.24895.9.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070521-5490-0000-0000-000001BC56C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to kfree the cache name of pgtables cache. It depends
on patch 1/2 -- ([PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's
saved_alias list, SLAB, and SLOB) in this mail thread. 

For SLUB, as the pgtables cache might be mergeable to other caches.
During early boot, the name string is saved in the save_alias list. In
this case, the name could be safely kfreed after calling
kmem_cache_create() with patch 1.

For SLAB/SLOB, we need the changes in patch 1, which duplicates the name
strings in cache create.

v3: with patch 1/2 updated to make slab/slob consistent, #ifdef
CONFIG_SLUB is no longer needed. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/mm/init_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 620b7ac..bc7f462 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -130,6 +130,7 @@ void pgtable_cache_add(unsigned shift, void
(*ctor)(void *))
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
 	new = kmem_cache_create(name, table_size, align, 0, ctor);
+	kfree(name);
 	PGT_CACHE(shift) = new;
 
 	pr_debug("Allocated pgtable cache for order %d\n", shift);
-- 
1.7.1



