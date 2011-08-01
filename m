Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1HAXZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab1HAXZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.189269480@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Liu <lliubbo@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [06/70] mm/nommu.c: fix remap_pfn_range()
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Liu <lliubbo@gmail.com>

commit 8f3b1327aa454bc8283e96bca7669c3c88b83f79 upstream.

remap_pfn_range() means map physical address pfn<<PAGE_SHIFT to user addr.

For nommu arch it's implemented by vma->vm_start = pfn << PAGE_SHIFT which
is wrong acroding the original meaning of this function.  And some driver
developer using remap_pfn_range() with correct parameter will get
unexpected result because vm_start is changed.  It should be implementd
like addr = pfn << PAGE_SHIFT but which is meanless on nommu arch, this
patch just make it simply return.

Parameter name and setting of vma->vm_flags also be fixed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/nommu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1819,10 +1819,13 @@ struct page *follow_page(struct vm_area_
 	return NULL;
 }
 
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long from,
-		unsigned long to, unsigned long size, pgprot_t prot)
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	vma->vm_start = vma->vm_pgoff << PAGE_SHIFT;
+	if (addr != (pfn << PAGE_SHIFT))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 	return 0;
 }
 EXPORT_SYMBOL(remap_pfn_range);


