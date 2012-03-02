Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2CBBPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:15:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52324 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab2CBBPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:15:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.236.72.230 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        linux@arm.linux.org.uk, sam@ravnborg.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] compiler.h: Include <linux/bug.h> to avoid build breakage with ARRAY_SIZE()
Date: Thu,  1 Mar 2012 22:15:22 -0300
Message-Id: <1330650922-24143-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building imx_v6_v7_defconfig generated the following build error:

arch/arm/mach-imx/cpu_op-mx51.c: In function 'mx51_get_cpu_op':
arch/arm/mach-imx/cpu_op-mx51.c:27: error: implicit declaration of function 'BUILD_BUG_ON_ZERO'

commit 6f863554 (kernel.h: doesn't explicitly use bug.h, so don't include it.)
has removed asm/debug.h from linux/kernel.h.

Quoting Russell King (http://www.spinics.net/lists/arm-kernel/msg161916.html)

"linux/kernel.h _does_ use bug stuff - in ARRAY_SIZE().

ARRAY_SIZE() uses __must_be_array(), which is defined in linux/compiler-gcc.h,
which is obtained via linux/compiler.h and linux/linkage.h.

linux/compiler-gcc.h defines __must_be_array() to be:
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))

and BUILD_BUG_ON_ZERO used to be in linux/kernel.h but got moved to
linux/bug.h.

Hence why people are seeing build breakage with ARRAY_SIZE()."

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Move linux/bug.h to linux/compiler.h

 include/linux/compiler.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4a24354..0300fb7 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -46,6 +46,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 
 #ifdef __GNUC__
 #include <linux/compiler-gcc.h>
+#include <linux/bug.h>
 #endif
 
 #define notrace __attribute__((no_instrument_function))
-- 
1.7.1

