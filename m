Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2AWVyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:54:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:52228 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2AWVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:54:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: dave@linux.vnet.ibm.com, cascardo@holoscopio.com,
        sjenning@linux.vnet.ibm.com,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.
Date: Mon, 23 Jan 2012 16:52:20 -0500
Message-Id: <1327355540-30681-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
References: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F1DD726.00F6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

SWIZ_BITS > 8 results in a much larger number of "tmem_obj"
allocations, likely one per page-placed-in-frontswap.  The
tmem_obj is not huge (roughly 100 bytes), but it is large
enough to add a not-insignificant memory overhead to zcache.

The SWIZ_BITS=8  will get roughly the same lock contention
without the space wastage.

The effect of SWIZ_BITS can be thought of as "2^SWIZ_BITS is
the number of unique oids that be generated" (This concept is
limited to frontswap's use of tmem).

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 642840c..9c011b7 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1782,9 +1782,9 @@ static int zcache_frontswap_poolid = -1;
  * Swizzling increases objects per swaptype, increasing tmem concurrency
  * for heavy swaploads.  Later, larger nr_cpus -> larger SWIZ_BITS
  * Setting SWIZ_BITS to 27 basically reconstructs the swap entry from
- * frontswap_get_page()
+ * frontswap_get_page(), but has side-effects. Hence using 8.
  */
-#define SWIZ_BITS		27
+#define SWIZ_BITS		8
 #define SWIZ_MASK		((1 << SWIZ_BITS) - 1)
 #define _oswiz(_type, _ind)	((_type << SWIZ_BITS) | (_ind & SWIZ_MASK))
 #define iswiz(_ind)		(_ind >> SWIZ_BITS)
-- 
1.7.7.5

