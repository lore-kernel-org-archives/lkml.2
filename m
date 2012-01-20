Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2ATPPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:15:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2ATPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:15:29 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
Date: Sat, 21 Jan 2012 00:15:26 +0900
Message-Id: <1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_set and bitmap_clear rather than modifying individual bits
in a memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
---
 drivers/block/xen-blkfront.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2f22874..619868d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -43,6 +43,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
+#include <linux/bitmap.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -177,8 +178,7 @@ static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
 
 	spin_lock(&minor_lock);
 	if (find_next_bit(minors, end, minor) >= end) {
-		for (; minor < end; ++minor)
-			__set_bit(minor, minors);
+		bitmap_set(minors, minor, nr);
 		rc = 0;
 	} else
 		rc = -EBUSY;
@@ -193,8 +193,7 @@ static void xlbd_release_minors(unsigned int minor, unsigned int nr)
 
 	BUG_ON(end > nr_minors);
 	spin_lock(&minor_lock);
-	for (; minor < end; ++minor)
-		__clear_bit(minor, minors);
+	bitmap_clear(minors,  minor, nr);
 	spin_unlock(&minor_lock);
 }
 
-- 
1.7.4.4

