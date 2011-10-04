Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1JDNVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:21:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51889 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab1JDNVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:21:53 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: gregkh@suse.de, cascardo@holoscopio.com, dan.magenheimer@oracle.com,
        rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com, Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH] staging: zcache: reduce tmem bucket lock contention
Date: Tue,  4 Oct 2011 08:21:32 -0500
Message-Id: <1317734492-22165-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20111003230632.GA12719@kroah.com>
References: <20111003230632.GA12719@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmem uses hash buckets each with their own rbtree and lock to
quickly lookup tmem objects.  tmem has TMEM_HASH_BUCKETS (256)
buckets per pool.  However, because of the way the tmem_oid is
generated for frontswap pages, only 16 unique tmem_oids are being
generated, resulting in only 16 of the 256 buckets being used.
This cause high lock contention for the per bucket locks.

This patch changes SWIZ_BITS to include more bits of the offset.
The result is that all 256 hash buckets are potentially used resulting in a
95% drop in hash bucket lock contention.

Based on v3.1-rc7

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 462fbc2..b4b692f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1798,8 +1798,10 @@ static int zcache_frontswap_poolid = -1;
 /*
  * Swizzling increases objects per swaptype, increasing tmem concurrency
  * for heavy swaploads.  Later, larger nr_cpus -> larger SWIZ_BITS
+ * Setting SWIZ_BITS to 27 basically reconstructs the swap entry from
+ * frontswap_get_page()
  */
-#define SWIZ_BITS		4
+#define SWIZ_BITS		27
 #define SWIZ_MASK		((1 << SWIZ_BITS) - 1)
 #define _oswiz(_type, _ind)	((_type << SWIZ_BITS) | (_ind & SWIZ_MASK))
 #define iswiz(_ind)		(_ind >> SWIZ_BITS)
-- 
1.7.4.1

