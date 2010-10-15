Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0JOPUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:20:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53997 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0JOPUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=H67UC6inEDewS91j1fO14e3kBYh8V0NGqD6d7Al9UbV4saW0c32gTVKrpWWfqVMLLf
         ao3jZnvud247k2MXm7bcnExQq6lhgIuqVmx55Wwbk3//icYDy7tEu5QO4f1iAr4uy/tI
         D/6A38f3e/Jo18GVUDOstq0c5g4Ys8mTQ9XCg=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing ioremap() on RAM
Date: Fri, 15 Oct 2010 17:15:20 +0300
Message-Id: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

Drivers have been relying on this behavior, but done so wrongly.
However, rather than breaking drivers from .35 to .36, we should warn on
.36 and only break on .37. This way we give a chance for contributors to
fix the issues.

According to ARM, the behavior of having multiple mappings is
unspecified from ARMv6+. This causes real issues specially on modern
hardware, and specially with speculative prefetching. So drivers need to
be fixed.

Also, since current hardware has palliative meassures to deal with
multiple mappings with the same memory type but diferent cacheability
attributes, ensure that such restriction is taking place.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Woodruff <r-woodruff2@ti.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mm/ioremap.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index ab50627..7dfd6dd 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -202,10 +202,14 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 		return NULL;
 
 	/*
-	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
+	 * This causes problems with ARMv6+. Will be disallowed soon.
+	 * Also avoid a second mapping with different shareability, which is
+	 * not supposed to work anyway.
 	 */
 	if (WARN_ON(pfn_valid(pfn)))
-		return NULL;
+		if (__LINUX_ARM_ARCH__ >= 6 &&
+		    (mtype != MT_DEVICE_CACHED && mtype != MT_DEVICE_WC))
+			mtype = MT_DEVICE_WC;
 
 	type = get_mem_type(mtype);
 	if (!type)
-- 
1.7.3.1.2.g7fe2b

