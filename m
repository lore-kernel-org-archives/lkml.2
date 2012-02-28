Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793Ab2B1WDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:03:30 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55905 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833Ab2B1WD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:03:29 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: zcache: fix length type mismatch
Date: Tue, 28 Feb 2012 16:01:37 -0600
Message-Id: <1330466497-24361-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022822-6148-0000-0000-000003D61A77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a type mismatch in the compression code where
a size_t pointer was cast to a unsigned int pointer.  On
little endian archs, there is no issue.  However on big
endian archs, the value is incorrect, taking the high
order bits and truncating the lower order bits.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 238d820..46c7c04 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1170,14 +1170,14 @@ static atomic_t zcache_curr_pers_pampd_count = ATOMIC_INIT(0);
 static unsigned long zcache_curr_pers_pampd_count_max;
 
 /* forward reference */
-static int zcache_compress(struct page *from, void **out_va, size_t *out_len);
+static int zcache_compress(struct page *from, void **out_va, unsigned *out_len);
 
 static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
 				struct tmem_pool *pool, struct tmem_oid *oid,
 				 uint32_t index)
 {
 	void *pampd = NULL, *cdata;
-	size_t clen;
+	unsigned clen;
 	int ret;
 	unsigned long count;
 	struct page *page = (struct page *)(data);
@@ -1326,7 +1326,7 @@ static struct tmem_pamops zcache_pamops = {
 static DEFINE_PER_CPU(unsigned char *, zcache_dstmem);
 #define ZCACHE_DSTMEM_ORDER 1
 
-static int zcache_compress(struct page *from, void **out_va, size_t *out_len)
+static int zcache_compress(struct page *from, void **out_va, unsigned *out_len)
 {
 	int ret = 0;
 	unsigned char *dmem = __get_cpu_var(zcache_dstmem);
@@ -1339,7 +1339,7 @@ static int zcache_compress(struct page *from, void **out_va, size_t *out_len)
 	from_va = kmap_atomic(from, KM_USER0);
 	mb();
 	ret = zcache_comp_op(ZCACHE_COMPOP_COMPRESS, from_va, PAGE_SIZE, dmem,
-				(unsigned int *)out_len);
+				out_len);
 	BUG_ON(ret);
 	*out_va = dmem;
 	kunmap_atomic(from_va, KM_USER0);
-- 
1.7.5.4

