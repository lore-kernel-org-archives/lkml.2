Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2DAUkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:40:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:54193 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2DAUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 04/11] avr32: fix build failures from mis-naming of atmel_nand.h
Date: Sun,  1 Apr 2012 16:38:40 -0400
Message-Id: <1333312727-11428-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bf4289cba02b8cf770ecd7959ca70839f0dd9d3c

    "ATMEL: fix nand ecc support"

indicated that it wanted to "Move platform data to a common
header include/linux/platform_data/atmel_nand.h" and the new
header even had re-include protectors with:

    #ifndef __ATMEL_NAND_H__

However, the file that was added was simply called atmel.h
and this caused avr32 defconfig to fail with:

  In file included from arch/avr32/boards/atstk1000/setup.c:22:
  arch/avr32/mach-at32ap/include/mach/board.h:10:44: error: linux/platform_data/atmel_nand.h: No such file or directory
  In file included from arch/avr32/boards/atstk1000/setup.c:22:
  arch/avr32/mach-at32ap/include/mach/board.h:121: warning: 'struct atmel_nand_data' declared inside parameter list
  arch/avr32/mach-at32ap/include/mach/board.h:121: warning: its scope is only this definition or declaration, which is probably not what you want
  make[2]: *** [arch/avr32/boards/atstk1000/setup.o] Error 1

It seems the scope of the file contents will expand beyond
just nand, so ignore the original intention, and fix up the
users who reference the bad name with the _nand suffix.

CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: David Woodhouse <dwmw2@infradead.org>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/avr32/mach-at32ap/include/mach/board.h |    2 +-
 include/linux/platform_data/atmel.h         |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/mach-at32ap/include/mach/board.h b/arch/avr32/mach-at32ap/include/mach/board.h
index 7173386..70742ec 100644
--- a/arch/avr32/mach-at32ap/include/mach/board.h
+++ b/arch/avr32/mach-at32ap/include/mach/board.h
@@ -7,7 +7,7 @@
 #include <linux/types.h>
 #include <linux/serial.h>
 #include <linux/platform_data/macb.h>
-#include <linux/platform_data/atmel_nand.h>
+#include <linux/platform_data/atmel.h>
 
 #define GPIO_PIN_NONE	(-1)
 
diff --git a/include/linux/platform_data/atmel.h b/include/linux/platform_data/atmel.h
index d056263..b0f2c56 100644
--- a/include/linux/platform_data/atmel.h
+++ b/include/linux/platform_data/atmel.h
@@ -4,8 +4,8 @@
  * GPL v2 Only
  */
 
-#ifndef __ATMEL_NAND_H__
-#define __ATMEL_NAND_H__
+#ifndef __ATMEL_H__
+#define __ATMEL_H__
 
 #include <linux/mtd/nand.h>
 
@@ -24,4 +24,4 @@ struct atmel_nand_data {
 	unsigned int	num_parts;
 };
 
-#endif /* __ATMEL_NAND_H__ */
+#endif /* __ATMEL_H__ */
-- 
1.7.9.1

