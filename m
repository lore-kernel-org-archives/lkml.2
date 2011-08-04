Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HDWBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:01:01 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:52147 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1HDWAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:00:52 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-next@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] zcache: Use div_u64 for 64-bit division
Date: Thu,  4 Aug 2011 19:00:33 -0300
Message-Id: <1312495234-20961-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110804145145.4af47989.rdunlap@xenotime.net>
References: <20110804145145.4af47989.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xv_get_total_size_bytes returns a u64 value and it's used in a division.
This causes build failures in 32-bit architectures, as reported by Randy
Dunlap.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>
Cc: driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
---
 drivers/staging/zcache/zcache-main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 66469ac..2c41c44 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
+#include <linux/math64.h>
 #include "tmem.h"
 
 #include "../zram/xvmalloc.h" /* if built in drivers/staging */
@@ -1162,6 +1163,7 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
 	uint16_t client_id = get_client_id_from_client(cli);
 	unsigned long zv_mean_zsize;
 	unsigned long curr_pers_pampd_count;
+	u64 total_zsize;
 
 	if (eph) {
 		ret = zcache_compress(page, &cdata, &clen);
@@ -1194,8 +1196,9 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
 		}
 		/* reject if mean compression is too poor */
 		if ((clen > zv_max_mean_zsize) && (curr_pers_pampd_count > 0)) {
-			zv_mean_zsize = xv_get_total_size_bytes(cli->xvpool) /
-						curr_pers_pampd_count;
+			total_zsize = xv_get_total_size_bytes(cli->xvpool);
+			zv_mean_zsize = div_u64(total_zsize,
+						curr_pers_pampd_count);
 			if (zv_mean_zsize > zv_max_mean_zsize) {
 				zcache_mean_compress_poor++;
 				goto out;
-- 
1.7.5.4

