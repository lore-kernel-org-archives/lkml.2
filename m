Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2FYJzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:55:16 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36012 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2FYJzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:55:14 -0400
Message-ID: <1340618099.13778.39.camel@ThinkPad-T420>
Subject: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if SLUB
 is used
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 25 Jun 2012 17:54:59 +0800
In-Reply-To: <1340617984.13778.37.camel@ThinkPad-T420>
References: <1340617984.13778.37.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062509-2674-0000-0000-00000503929E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to kfree the cache name of pgtables cache if SLUB is
used, as SLUB duplicates the cache name, and the original one is leaked.

This patch depends on patch 1 -- (duplicate the cache name in
saved_alias list) in this mail thread. As the pgtables cache might be
merged to other caches. In this case, the name could be safely kfreed
after calling kmem_cache_create() with patch 1.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/mm/init_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 620b7ac..c9d2a7f 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -130,6 +130,9 @@ void pgtable_cache_add(unsigned shift, void
(*ctor)(void *))
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
 	new = kmem_cache_create(name, table_size, align, 0, ctor);
+#ifdef CONFIG_SLUB
+	kfree(name); /* SLUB duplicates the cache name */
+#endif
 	PGT_CACHE(shift) = new;
 
 	pr_debug("Allocated pgtable cache for order %d\n", shift);
-- 
1.7.1

