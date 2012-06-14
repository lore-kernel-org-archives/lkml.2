Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2FNX6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2FNX6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:43 -0400
Message-Id: <20120614235645.932553729@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, KyongHo Cho <pullip.cho@samsung.com>,
        "Olav Haugan" <ohaugan@codeaurora.org>
Subject: [ 19/20] mm: fix faulty initialization in vmalloc_init()
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1174,9 +1174,10 @@ void __init vmalloc_init(void)
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
 


