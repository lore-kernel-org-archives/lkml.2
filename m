Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2AKHvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:51:48 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:48929
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab2AKHvq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:51:46 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz542M4015Lzz1202hzz8275bhz2dhc1ahc1bh2a8h668h839h8e2h8e3h945hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Shi Xuelin-B29237 <B29237@freescale.com>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH] 	dmaengine: async_xor, fix zero address issue when xor
 highmem page
Thread-Topic: [PATCH] 	dmaengine: async_xor, fix zero address issue when xor
 highmem page
Thread-Index: AQHMxGfd4QsjeoknPke1bvzC+IXi1pYG4khg
Date: Wed, 11 Jan 2012 07:51:41 +0000
Message-ID: <DBB740589CE8814680DECFE34BE197AB166593@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1324967446-28939-1-git-send-email-b29237@freescale.com>
In-Reply-To: <1324967446-28939-1-git-send-email-b29237@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.103]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan Williams,

Do you have any comment about this patch?

Thanks,
Forrest

-----Original Message-----
From: Shi Xuelin-B29237 
Sent: 2011年12月27日 14:31
To: vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Li Yang-R58472
Cc: Shi Xuelin-B29237
Subject: [PATCH] dmaengine: async_xor, fix zero address issue when xor highmem page

From: Forrest shi <b29237@freescale.com>

	we may do_sync_xor high mem pages, in this case, page_address will
        return zero address which cause a failure.

	this patch uses kmap_atomic before xor the pages and kunmap_atomic
        after it.

	Signed-off-by: b29237@freescale.com <xuelin.shi@freescale.com>
---
 crypto/async_tx/async_xor.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c index bc28337..5b416d1 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/dma-mapping.h>
 #include <linux/raid/xor.h>
 #include <linux/async_tx.h>
@@ -126,7 +127,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	    int src_cnt, size_t len, struct async_submit_ctl *submit)  {
 	int i;
-	int xor_src_cnt = 0;
+	int xor_src_cnt = 0, kmap_cnt=0;
 	int src_off = 0;
 	void *dest_buf;
 	void **srcs;
@@ -138,11 +139,13 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 
 	/* convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
-		if (src_list[i])
-			srcs[xor_src_cnt++] = page_address(src_list[i]) + offset;
+		if (src_list[i]) {
+			srcs[xor_src_cnt++] = kmap_atomic(src_list[i], KM_USER1) + offset;
+		}
+	kmap_cnt = xor_src_cnt;
 	src_cnt = xor_src_cnt;
 	/* set destination address */
-	dest_buf = page_address(dest) + offset;
+	dest_buf = kmap_atomic(dest, KM_USER0) + offset;
 
 	if (submit->flags & ASYNC_TX_XOR_ZERO_DST)
 		memset(dest_buf, 0, len);
@@ -157,6 +160,11 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		src_off += xor_src_cnt;
 	}
 
+	kunmap_atomic(dest_buf, KM_USER0);
+	for (i = 0; i < kmap_cnt; i++) 
+		if (src_list[i])
+			kunmap_atomic(srcs[i], KM_USER1);
+
 	async_tx_sync_epilog(submit);
 }
 
--
1.7.0.4


