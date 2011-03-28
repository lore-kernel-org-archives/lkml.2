Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab1C1HDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:03:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51085 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1C1HDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:03:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 v2] NOMMU: new vcoalesce helper function
Date: Mon, 28 Mar 2011 02:04:44 -0400
Message-Id: <1301292284-8523-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't support vmap on NOMMU systems, so add a new vcoalesce function
which combines maps via kmalloc.  A bit more overhead, but at least it
works.  For MMU systems, vcoalesce simply redirects to vmap.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- fix MMU version of vcoalesce

 include/linux/vmalloc.h |    3 +++
 mm/nommu.c              |   22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4ed6fcd..6b3480c 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -44,10 +44,13 @@ extern void vm_unmap_aliases(void);
 
 #ifdef CONFIG_MMU
 extern void __init vmalloc_init(void);
+#define vcoalesce(...) vmap(__VA_ARGS__)
 #else
 static inline void vmalloc_init(void)
 {
 }
+extern void *vcoalesce(struct page **pages, unsigned int count,
+			unsigned long flags, pgprot_t prot);
 #endif
 
 extern void *vmalloc(unsigned long size);
diff --git a/mm/nommu.c b/mm/nommu.c
index cb86e7d..7812938 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -404,6 +404,26 @@ void *vmalloc_32_user(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc_32_user);
 
+void *vcoalesce(struct page **pages, unsigned int count,
+	unsigned long flags, pgprot_t prot)
+{
+	unsigned int i;
+	void *new_map, *page_data;
+
+	new_map = kmalloc(count << PAGE_SHIFT, GFP_KERNEL);
+	if (!new_map)
+		return NULL;
+
+	for (i = 0; i < count; ++i) {
+		page_data = kmap(pages[i]);
+		memcpy(new_map + (i << PAGE_SHIFT), page_data, PAGE_SIZE);
+		kunmap(page_data);
+	}
+
+	return new_map;
+}
+EXPORT_SYMBOL(vcoalesce);
+
 void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
 {
 	BUG();
@@ -413,7 +433,7 @@ EXPORT_SYMBOL(vmap);
 
 void vunmap(const void *addr)
 {
-	BUG();
+	kfree(addr);
 }
 EXPORT_SYMBOL(vunmap);
 
-- 
1.7.4.1

