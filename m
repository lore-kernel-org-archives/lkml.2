Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0JNCOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:14:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53226 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0JNCOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:14:22 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 1/4] iovmm: no gap checking for fixed address
Date: Wed, 13 Oct 2010 21:27:34 -0500
Message-Id: <1287023257-30951-2-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287023257-30951-1-git-send-email-x0095840@ti.com>
References: <1287023257-30951-1-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If some fixed da address is wanted to be mapped and the page
is freed but it is used as gap, the mapping will fail.
This patch is fixing that and olny keeps the gap for
not fixed address.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/iovmm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 24ca9c4..34f0012 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -289,7 +289,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 	prev_end = 0;
 	list_for_each_entry(tmp, &obj->mmap, list) {
 
-		if (prev_end >= start)
+		if (prev_end > start)
 			break;
 
 		if (start + bytes <= tmp->da_start)
@@ -301,7 +301,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		prev_end = tmp->da_end;
 	}
 
-	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
+	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.6.3.3

