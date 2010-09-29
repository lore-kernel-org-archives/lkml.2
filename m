Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0I2OaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:30:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51984 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0I2OaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H11hgeS8+rei6SKs8qLCCCw/vf8/rrPRro8cQhm+DZTKiCYlUAEIPoP3VHUxJzWAwJ
         jVm68msAYoiM2TgBJ3BW6uoDptd1D5Dg9bYc9IY1HpT808nUhQW1HdrYYNVOjJdV0Ov+
         wbBTRiuxq35yXdVmVavtZrjYtZV1qNs2pk1Cw=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix __PHYSICAL_MASK calculation
Date: Wed, 29 Sep 2010 23:29:48 +0900
Message-Id: <1285770588-14065-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit non-PAE system, cast to 'phys_addr_t' truncates value
before subtraction. Subtracting before cast produce same result
but remove following warnings from sparse:

 arch/x86/include/asm/pgtable_types.h:255:38: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable_types.h:270:38: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:127:32: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:132:32: warning: cast truncates bits from constant value (100000000 becomes 0)
 arch/x86/include/asm/pgtable.h:344:31: warning: cast truncates bits from constant value (100000000 becomes 0)

64-bit or PAE machines will not be affected by this change.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/include/asm/page_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index a667f24..1df6621 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -8,7 +8,7 @@
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
-#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((phys_addr_t)((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 /* Cast PAGE_MASK to a signed type so that it is sign-extended if
-- 
1.7.2.2

