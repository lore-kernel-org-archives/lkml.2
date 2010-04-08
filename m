Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0DHNvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0DHNvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:51:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Work around the lack of vmap()/vunmap() in
	firmware_loading_store() [ver #2]
To: vapier@gentoo.org
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Date: Thu, 08 Apr 2010 14:51:07 +0100
Message-ID: <20100408135107.19547.5352.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work around the lack of vmap()/vunmap() in firmware_loading_store() when
operating in NOMMU mode.  vmap() cannot be implemented as there's no virtual
mapping available.

Instead, in NOMMU mode, make available a function (vcoalesce()) that can
coalesce the supplied data into one big buffer and store as the address vmap()
would've returned.

This can be #defined to vmap() in NOMMU mode by interested parties.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/base/firmware_class.c |    8 ++++++++
 include/linux/vmalloc.h       |    1 +
 mm/nommu.c                    |   24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 985da11..be71e54 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -60,6 +60,14 @@ static struct builtin_fw *__start_builtin_fw;
 static struct builtin_fw *__end_builtin_fw;
 #endif
 
+/*
+ * NOMMU mode can't provide vmap() as there's no MMU to do the virtual mapping.
+ * Coalesce the data into a big buffer instead.
+ */
+#ifndef CONFIG_MMU
+#define vmap(pg, c, f, pr)	vcoalesce(pg, c, f, pr)
+#endif
+
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..f36a4b2 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -48,6 +48,7 @@ extern void __init vmalloc_init(void);
 static inline void vmalloc_init(void)
 {
 }
+extern void *vcoalesce(struct page **, unsigned int, unsigned long, pgprot_t);
 #endif
 
 extern void *vmalloc(unsigned long size);
diff --git a/mm/nommu.c b/mm/nommu.c
index 63fa17d..05a5c63 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -405,6 +405,30 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 EXPORT_SYMBOL(vm_insert_page);
 
 /*
+ * NOMMU mode can't provide vmap() as there's no MMU to do the virtual mapping.
+ * Provide a facility to coalesce the data into a big buffer instead.
+ */
+void *vcoalesce(struct page **pages, unsigned int count,
+		unsigned long flags, pgprot_t prot)
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
+/*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
  *  like trying to un-brk an area that has already been mapped

