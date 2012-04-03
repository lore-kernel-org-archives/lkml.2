Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2DCXO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:14:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:63275 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab2DCXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:14:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH v2] avr32: fix nop compile fails from system.h split up
Date: Tue,  3 Apr 2012 19:14:04 -0400
Message-Id: <1333494844-3802-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

  In file included from kernel/exit.c:61:
  arch/avr32/include/asm/mmu_context.h: In function 'enable_mmu':
  arch/avr32/include/asm/mmu_context.h:135: error: implicit
  declaration of function 'nop'

It needs an include of the new file created in:

commit ae473946586680b01c13975a3b674de23ad7c93e

    "Disintegrate asm/system.h for AVR32"

But since that file only contains "nop", and since other
arch already have precedent of putting nop in asm/barrier.h
we should just delete the new file and put nop in barrier.h

Suggested-by: David Howells <dhowells@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: adopt dh's suggestion and assume new special_insns.h needs rm'ing]

diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
index 808001c..0961275 100644
--- a/arch/avr32/include/asm/barrier.h
+++ b/arch/avr32/include/asm/barrier.h
@@ -8,6 +8,8 @@
 #ifndef __ASM_AVR32_BARRIER_H
 #define __ASM_AVR32_BARRIER_H
 
+#define nop()			asm volatile("nop")
+
 #define mb()			asm volatile("" : : : "memory")
 #define rmb()			mb()
 #define wmb()			asm volatile("sync 0" : : : "memory")
diff --git a/arch/avr32/include/asm/special_insns.h b/arch/avr32/include/asm/special_insns.h
deleted file mode 100644
index f922218..0000000
--- a/arch/avr32/include/asm/special_insns.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_AVR32_SPECIAL_INSNS_H
-#define __ASM_AVR32_SPECIAL_INSNS_H
-
-#define nop() asm volatile("nop")
-
-#endif /* __ASM_AVR32_SPECIAL_INSNS_H */
-- 
1.7.9.1

