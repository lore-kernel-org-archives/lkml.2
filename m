Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2CEReV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:34:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42558 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2CEReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:34:17 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/5] staging: zsmalloc: add ZS_MAX_PAGES_PER_ZSPAGE
Date: Mon,  5 Mar 2012 11:33:21 -0600
Message-Id: <1330968804-8098-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1330968804-8098-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030517-2398-0000-0000-000004CAFEED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves where max_zspage_order is declared and
changes its meaning.  "Order" typically implies 2^order
of something; however, it is currently being used as the
"maximum number of single pages in a zspage".  To add clarity,
ZS_MAX_ZSPAGE_ORDER is now used to calculate ZS_MAX_PAGES_PER_ZSPAGE,
which is 2^ZS_MAX_ZSPAGE_ORDER and is the upper bound on the number
of pages in a zspage.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
 drivers/staging/zsmalloc/zsmalloc_int.h  |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 240bcbf..09caa4f 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -186,7 +186,7 @@ static int get_zspage_order(int class_size)
 	/* zspage order which gives maximum used size per KB */
 	int max_usedpc_order = 1;
 
-	for (i = 1; i <= max_zspage_order; i++) {
+	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
 		int zspage_size;
 		int waste, usedpc;
 
diff --git a/drivers/staging/zsmalloc/zsmalloc_int.h b/drivers/staging/zsmalloc/zsmalloc_int.h
index e06e142..4d66d2d 100644
--- a/drivers/staging/zsmalloc/zsmalloc_int.h
+++ b/drivers/staging/zsmalloc/zsmalloc_int.h
@@ -26,6 +26,13 @@
 #define ZS_ALIGN		8
 
 /*
+ * A single 'zspage' is composed of up to 2^N discontiguous 0-order (single)
+ * pages. ZS_MAX_ZSPAGE_ORDER defines upper limit on N.
+ */
+#define ZS_MAX_ZSPAGE_ORDER 2
+#define ZS_MAX_PAGES_PER_ZSPAGE (_AC(1, UL) << ZS_MAX_ZSPAGE_ORDER)
+
+/*
  * Object location (<PFN>, <obj_idx>) is encoded as
  * as single (void *) handle value.
  *
@@ -59,12 +66,6 @@
 					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
- * A single 'zspage' is composed of N discontiguous 0-order (single) pages.
- * This defines upper limit on N.
- */
-static const int max_zspage_order = 4;
-
-/*
  * We do not maintain any list for completely empty or full pages
  */
 enum fullness_group {
-- 
1.7.5.4

