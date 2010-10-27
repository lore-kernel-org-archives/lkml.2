Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0J0CC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 22:02:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51379 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab0J0CCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 22:02:54 -0400
Date: Wed, 27 Oct 2010 13:02:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xen tree
Message-Id: <20101027130249.5b4bc6ff.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the xen tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/xen/setup.c: In function 'xen_add_extra_mem':
arch/x86/xen/setup.c:65: error: implicit declaration of function 'reserve_early'

Caused by commit 42ee1471e9b879479a15debac752314a596c738e ("xen:
implement "extra" memory to reserve space for pages not present at boot")
interacting with commit a9ce6bc15100023b411f8117e53a016d61889800 ("x86,
memblock: Replace e820_/_early string with memblock_").  This latter
commit was in the xen tree yesterday (via a merge of tip/core/memblock)
but has been removed today (but it is in Linus' tree).

Linus will need this fixup patch when he merges the xen tree.  I have
applied it to linux-next today and can carry it as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Oct 2010 12:57:06 +1100
Subject: [PATCH] xen: merge fixup for reserve_early name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 1163bc5..105db25 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -62,7 +62,7 @@ static __init void xen_add_extra_mem(unsigned long pages)
 	e820_add_region(extra_start, size, E820_RAM);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
-	reserve_early(extra_start, extra_start + size, "XEN EXTRA");
+	memblock_x86_reserve_range(extra_start, extra_start + size, "XEN EXTRA");
 
 	xen_extra_mem_size += size;
 
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
