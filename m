Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2CEReN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:34:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42465 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab2CEReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:34:10 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/5] staging: zsmalloc: calculate MAX_PHYSMEM_BITS if not defined
Date: Mon,  5 Mar 2012 11:33:22 -0600
Message-Id: <1330968804-8098-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030517-2398-0000-0000-000004CAFEE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a way to determine or "set a
reasonable value for" MAX_PHYSMEM_BITS in the case that
it is not defined (i.e. !SPARSEMEM)

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc_int.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc_int.h b/drivers/staging/zsmalloc/zsmalloc_int.h
index 4d66d2d..ffb272f 100644
--- a/drivers/staging/zsmalloc/zsmalloc_int.h
+++ b/drivers/staging/zsmalloc/zsmalloc_int.h
@@ -39,7 +39,21 @@
  * Note that object index <obj_idx> is relative to system
  * page <PFN> it is stored in, so for each sub-page belonging
  * to a zspage, obj_idx starts with 0.
+ *
+ * This is made more complicated by various memory models and PAE.
+ */
+
+#ifndef MAX_PHYSMEM_BITS
+#ifdef CONFIG_HIGHMEM64G
+#define MAX_PHYSMEM_BITS 36
+#else /* !CONFIG_HIGHMEM64G */
+/*
+ * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
+ * be PAGE_SHIFT
  */
+#define MAX_PHYSMEM_BITS BITS_PER_LONG
+#endif
+#endif
 #define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
 #define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
-- 
1.7.5.4

