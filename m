Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0K2UcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:32:16 -0500
Received: from claw.goop.org ([74.207.240.146]:41892 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0K2UcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:32:15 -0500
Message-ID: <4CF40DCB.5010007@goop.org>
Date: Mon, 29 Nov 2010 12:32:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC] vmalloc: eagerly clear ptes on vunmap
References: <4CEF6B8B.8080206@goop.org> <20101127103656.GA6884@amd>
In-Reply-To: <20101127103656.GA6884@amd>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unmapping a region in the vmalloc space, clear the ptes immediately.
There's no point in deferring this because there's no amortization
benefit.

The TLBs are left dirty, and they are flushed lazily to amortize the
cost of the IPIs.

This specific motivation for this patch is a regression since 2.6.36 when
using NFS under Xen, triggered by the NFS client's use of vm_map_ram()
introduced in 56e4ebf877b6043c289bda32a5a7385b80c17dee.  XFS also uses
vm_map_ram() and could cause similar problems.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a3d66b3..9960644 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -566,7 +566,6 @@ static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
 			if (va->va_end > *end)
 				*end = va->va_end;
 			nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
-			unmap_vmap_area(va);
 			list_add_tail(&va->purge_list, &valist);
 			va->flags |= VM_LAZY_FREEING;
 			va->flags &= ~VM_LAZY_FREE;
@@ -616,6 +615,8 @@ static void purge_vmap_area_lazy(void)
  */
 static void free_unmap_vmap_area_noflush(struct vmap_area *va)
 {
+	unmap_vmap_area(va);
+
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
 	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
@@ -944,8 +945,10 @@ static void vb_free(const void *addr, unsigned long size)
 		BUG_ON(vb->free);
 		spin_unlock(&vb->lock);
 		free_vmap_block(vb);
-	} else
+	} else {
 		spin_unlock(&vb->lock);
+		vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
+	}
 }
 
 /**
@@ -988,7 +991,6 @@ void vm_unmap_aliases(void)
 
 				s = vb->va->va_start + (i << PAGE_SHIFT);
 				e = vb->va->va_start + (j << PAGE_SHIFT);
-				vunmap_page_range(s, e);
 				flush = 1;
 
 				if (s < start)


