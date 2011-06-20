Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1FTSVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:21:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1FTSVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ojFsk09PIDtiPRZbeKNITXAGUHhjYnz8TYhUriqEGm5284G4NJYSawPrANBDOvbEv4
         Mund1sUW4MeBOFSG9b1gglGnKb1M7YM0fs5kWwIYa5+swUEBwgAi2In/+WpKqOOXhgh4
         /z9Lz9mhbLgI9o7o0fAT7d3R4mbovDYPNp/tw=
Date: Mon, 20 Jun 2011 14:20:59 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
To: airlied@linux.ie, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-alpha <linux-alpha@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc: Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Jay Estabrook <jay.estabrook@gmail.com>
Subject: [PATCH 3/3 REPOST] alpha, drm: Add Alpha support to Radeon DRM code
Message-ID: <20110620142059.04c3b912.jay.estabrook_gmail.com@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; alpha-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alpha needs to have available the system bus address for the Radeon's
local memory, so that it can be used in ttm_bo_vm_fault(), when building
the PTEs for accessing that VRAM.  So, we make bus.addr hold the ioremap()
return, and then we can modify bus.base appropriately for use during page
fault processing.

Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -Naurp a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
--- a/drivers/gpu/drm/radeon/radeon_ttm.c	2011-04-26 23:48:50.000000000 -0400
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c	2011-05-03 18:24:27.000000000 -0400
@@ -450,6 +450,29 @@ static int radeon_ttm_io_mem_reserve(str
 			return -EINVAL;
 		mem->bus.base = rdev->mc.aper_base;
 		mem->bus.is_iomem = true;
+#ifdef __alpha__
+		/*
+		 * Alpha: use bus.addr to hold the ioremap() return,
+		 * so we can modify bus.base below.
+		 */
+		if (mem->placement & TTM_PL_FLAG_WC)
+			mem->bus.addr =
+				ioremap_wc(mem->bus.base + mem->bus.offset,
+					   mem->bus.size);
+		else
+			mem->bus.addr =
+				ioremap_nocache(mem->bus.base + mem->bus.offset,
+						mem->bus.size);
+
+		/*
+		 * Alpha: Take just the bus offset and
+		 * add the hose/domain memory base.
+		 * Then, bus.base can be returned
+		 * for use in an mmap() call.
+		 */
+		mem->bus.base = (mem->bus.base & 0x0ffffffffUL) +
+			rdev->ddev->hose->dense_mem_base;
+#endif
 		break;
 	default:
 		return -EINVAL;
