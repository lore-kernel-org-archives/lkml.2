Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0CaRLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0CaRLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:11:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1268151081-28307-1-git-send-email-vapier@gentoo.org>
References: <1268151081-28307-1-git-send-email-vapier@gentoo.org> <1261413866-30634-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH v2] NOMMU: implement vmap/vunmap with kmalloc
Date: Wed, 31 Mar 2010 18:11:24 +0100
Message-ID: <14998.1270055484@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about the attached patch instead?  I'd rather not make vmap() generally
available in NOMMU mode since it can't be implemented in NOMMU mode.  Yes,
vmap() can take a copy of the pages it is given, but you can't guarantee
that's the right thing to do.  It's like a shared-writable mmap.

Instead, why not just override vmap() in firmware_class.c for the one instance
where we know we're happy with this behaviour?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Work around the lack of vmap()/vunmap() in firmware_loading_store()

Work around the lack of vmap()/vunmap() in firmware_loading_store() when
operating in NOMMU mode.  vmap() cannot be implemented as there's no virtual
mapping available.

Instead, in NOMMU mode, coalesce the data into one big buffer and store as the
address vmap() would've returned.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/base/firmware_class.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)


diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 18518ba..e33c2cb 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -59,6 +59,33 @@ static struct builtin_fw *__start_builtin_fw;
 static struct builtin_fw *__end_builtin_fw;
 #endif
 
+/*
+ * NOMMU mode can't provide vmap() as there's no MMU to do the virtual mapping.
+ * Coalesce the data into a big buffer instead.
+ */
+#ifndef CONFIG_MMU
+static void *__pretend_vmap(struct page **pages, unsigned int count,
+			    unsigned long flags, pgprot_t prot)
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
+
+#define vmap(pg, c, f, pr)	__pretend_vmap(pg, c, f, pr)
+#endif /* !CONFIG_MMU */
+
 static void
 fw_load_abort(struct firmware_priv *fw_priv)
 {
