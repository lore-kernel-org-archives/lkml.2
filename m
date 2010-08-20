Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0HTIsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab0HTIrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:47:01 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 16/19] Add helpers for zero-copy userspace access
Date: Fri, 20 Aug 2010 10:46:00 +0200
Message-Id: <1282293963-27807-18-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 crypto/userspace/cryptodev_main.c |   87 +++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/crypto/userspace/cryptodev_main.c b/crypto/userspace/cryptodev_main.c
index c6419f4..a6712db 100644
--- a/crypto/userspace/cryptodev_main.c
+++ b/crypto/userspace/cryptodev_main.c
@@ -1,3 +1,46 @@
+/*
+ * Driver for /dev/crypto device (aka CryptoDev)
+ *
+ * Copyright (c) 2004 Michal Ludvig <mludvig@logix.net.nz>, SuSE Labs
+ * Copyright (c) 2009,2010 Nikos Mavrogiannopoulos <nmav@gnutls.org>
+ *
+ * This file is part of linux cryptodev.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+/*
+ * Device /dev/crypto provides an interface for 
+ * accessing kernel CryptoAPI algorithms (ciphers,
+ * hashes) from userspace programs.
+ *
+ * /dev/crypto interface was originally introduced in
+ * OpenBSD and this module attempts to keep the API.
+ *
+ */
+
+#include <linux/audit.h>
+#include <linux/crypto.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/ioctl.h>
+#include <linux/random.h>
+#include <linux/syscalls.h>
+#include <linux/pagemap.h>
+#include <linux/uaccess.h>
+#include <linux/scatterlist.h>
 #include "cryptodev_int.h"
 #include "ncr-int.h"
 #include <linux/version.h>
@@ -11,3 +54,47 @@ MODULE_LICENSE("GPL");
 int cryptodev_verbosity = 0;
 module_param(cryptodev_verbosity, int, 0644);
 MODULE_PARM_DESC(cryptodev_verbosity, "0: normal, 1: verbose, 2: debug");
+
+/* ====== CryptoAPI ====== */
+
+void release_user_pages(struct page **pg, int pagecount)
+{
+	while (pagecount--) {
+		if (!PageReserved(pg[pagecount]))
+			SetPageDirty(pg[pagecount]);
+		page_cache_release(pg[pagecount]);
+	}
+}
+
+/* offset of buf in it's first page */
+#define PAGEOFFSET(buf) ((unsigned long)buf & ~PAGE_MASK)
+
+/* fetch the pages addr resides in into pg and initialise sg with them */
+int __get_userbuf(uint8_t __user *addr, uint32_t len, int write,
+		int pgcount, struct page **pg, struct scatterlist *sg)
+{
+	int ret, pglen, i = 0;
+	struct scatterlist *sgp;
+
+	down_write(&current->mm->mmap_sem);
+	ret = get_user_pages(current, current->mm,
+			(unsigned long)addr, pgcount, write, 0, pg, NULL);
+	up_write(&current->mm->mmap_sem);
+	if (ret != pgcount)
+		return -EINVAL;
+
+	sg_init_table(sg, pgcount);
+
+	pglen = min((ptrdiff_t)(PAGE_SIZE - PAGEOFFSET(addr)), (ptrdiff_t)len);
+	sg_set_page(sg, pg[i++], pglen, PAGEOFFSET(addr));
+
+	len -= pglen;
+	for (sgp = sg_next(sg); len; sgp = sg_next(sgp)) {
+		pglen = min((uint32_t)PAGE_SIZE, len);
+		sg_set_page(sgp, pg[i++], pglen, 0);
+		len -= pglen;
+	}
+	sg_mark_end(sg_last(sg, pgcount));
+	return 0;
+}
+
-- 
1.7.2.1

