Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2BJWnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab2BJWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:25 -0500
MIME-Version: 1.0
Message-Id: <20120210222952.352208385@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch 82/86] zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Magenheimer <dan.magenheimer@oracle.com>

commit e8b4553457e78bcff90f70a31212a40a8fd4f0db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


