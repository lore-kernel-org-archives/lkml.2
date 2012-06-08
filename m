Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2FHF2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:28:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43159 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760068Ab2FHFHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:14 -0400
Message-Id: <20120608041845.147912759@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, KyongHo <pullip.cho@samsung.com>,
        "Olav Haugan" <ohaugan@codeaurora.org>
Subject: [ 32/82] mm: fix faulty initialization in vmalloc_init()
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KyongHo <pullip.cho@samsung.com>

commit dbda591d920b4c7692725b13e3f68ecb251e9080 upstream.

The transfer of ->flags causes some of the static mapping virtual
addresses to be prematurely freed (before the mapping is removed) because
VM_LAZY_FREE gets "set" if tmp->flags has VM_IOREMAP set.  This might
cause subsequent vmalloc/ioremap calls to fail because it might allocate
one of the freed virtual address ranges that aren't unmapped.

va->flags has different types of flags from tmp->flags.  If a region with
VM_IOREMAP set is registered with vm_area_add_early(), it will be removed
by __purge_vmap_area_lazy().

Fix vmalloc_init() to correctly initialize vmap_area for the given
vm_struct.

Also initialise va->vm.  If it is not set, find_vm_area() for the early
vm regions will always fail.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Cc: "Olav Haugan" <ohaugan@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c28b0b9..2aad499 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1185,9 +1185,10 @@ void __init vmalloc_init(void)
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
-		va->flags = tmp->flags | VM_VM_AREA;
+		va->flags = VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
+		va->vm = tmp;
 		__insert_vmap_area(va);
 	}
 


