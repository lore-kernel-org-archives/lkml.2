Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0KMO63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:58:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0KMO60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=W1hdVXFvPBq/Y98QjwSlNcgIWxgJ0q4Q6U5f9JOu3nE1f6m0KLErGlFPQ1yRlqaekz
         XWyI7lddw9F0gxSOV6AMtaWbQOUBi0Bd+CZ2yys0sR2PtCyJHBgapoPapKlftXVIHSpf
         X3gDgMZfFfGmSwjIrATAK91wxwUErKRp26rJk=
Message-ID: <4CDEA6D0.8040303@gmail.com>
Date: Sat, 13 Nov 2010 15:55:12 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/16 v3] pramfs: memory protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Memory write protection.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/fs/pramfs/wprotect.c linux-2.6.36/fs/pramfs/wprotect.c
--- linux-2.6.36-orig/fs/pramfs/wprotect.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/fs/pramfs/wprotect.c	2010-10-30 11:59:54.000000000 +0200
@@ -0,0 +1,41 @@
+/*
+ * FILE NAME fs/pramfs/wprotect.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Write protection for the filesystem pages.
+ *
+ * Copyright 2009-2010 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include "pram.h"
+
+void pram_writeable(void *vaddr, unsigned long size, int rw)
+{
+	int ret = 0;
+	unsigned long nrpages = size >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)vaddr;
+
+	/* Page aligned */
+	addr &= PAGE_MASK;
+
+	if (size & (PAGE_SIZE - 1))
+		nrpages++;
+
+	if (rw)
+		ret = set_memory_rw(addr, nrpages);
+	else
+		ret = set_memory_ro(addr, nrpages);
+
+	BUG_ON(ret);
+}
