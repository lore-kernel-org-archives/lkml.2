Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0JACz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:55:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38623 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0JACz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:55:27 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 2/4] iovmm: fix roundup for next area and end check for the last area
Date: Thu, 30 Sep 2010 22:08:53 -0500
Message-Id: <1285902536-7043-3-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285902536-7043-2-git-send-email-x0095840@ti.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
 <1285902536-7043-2-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As da_end does not belongs to the area the roundup should
be done to da_end and not to da_end + 1.
Also the end check for the last area should be
ULONG_MAX - start + 1 >= bytes.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/iovmm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 24ca9c4..fc6b109 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -289,19 +289,19 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 	prev_end = 0;
 	list_for_each_entry(tmp, &obj->mmap, list) {
 
-		if (prev_end >= start)
+		if (prev_end > start)
 			break;
 
 		if (start + bytes <= tmp->da_start)
 			goto found;
 
 		if (flags & IOVMF_DA_ANON)
-			start = roundup(tmp->da_end + 1, alignement);
+			start = roundup(tmp->da_end, alignement);
 
 		prev_end = tmp->da_end;
 	}
 
-	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
+	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.6.3.3

