Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab0LNNGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:06:37 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46584 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759259Ab0LNNGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:06:36 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <Hiroshi.DOYU@nokia.com>, <linux@arm.linux.org.uk>, <h-kanigeri2@ti.com>
Cc: <felipe.contreras@nokia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, "Guzman Lugo, Fernando" <x0095840@ti.com>
Subject: [PATCHv6 1/4] omap: iovmm - no gap checking for fixed address
Date: Tue, 14 Dec 2010 07:07:24 -0600
Message-Id: <1292332047-8206-2-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <x0095840@ti.com>

If some fixed da address is wanted to be mapped and the page
is freed but it is used as gap, the mapping will fail.
This patch is fixing that and olny keeps the gap for
not fixed address.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/plat-omap/iovmm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 8ce0de2..34f0012 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -289,10 +289,10 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 	prev_end = 0;
 	list_for_each_entry(tmp, &obj->mmap, list) {
 
-		if (prev_end >= start)
+		if (prev_end > start)
 			break;
 
-		if (start + bytes < tmp->da_start)
+		if (start + bytes <= tmp->da_start)
 			goto found;
 
 		if (flags & IOVMF_DA_ANON)
@@ -301,7 +301,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 		prev_end = tmp->da_end;
 	}
 
-	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
+	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
 		goto found;
 
 	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
-- 
1.7.3.2

