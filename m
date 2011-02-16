Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1BPOru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:47:50 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61712 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1BPOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=un/8MZtwyTZm12Zv4ELKkI/m5ACkGlhTrZL62VIY1RFeiG7RP6ctLHIvrua0w1eNRX
         fmQxZVwxFOHyEpBKmOjMUQVIvzaLCQ+YTsyigzAEndtwuHm2NAc6IZ88fxxV0cBjFKvp
         LssWJJXU5dHwaz6Hta2ugn2CJWQeXZ66lSyeg=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: use bitmap library functions
Date: Wed, 16 Feb 2011 23:48:35 +0900
Message-Id: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_set()/bitmap_clear() to fill/zero a region of a bitmap
instead of doing set_bit()/clear_bit() each bit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/ioport.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8eec0ec..8c96897 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -14,22 +14,9 @@
 #include <linux/slab.h>
 #include <linux/thread_info.h>
 #include <linux/syscalls.h>
+#include <linux/bitmap.h>
 #include <asm/syscalls.h>
 
-/* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
-static void set_bitmap(unsigned long *bitmap, unsigned int base,
-		       unsigned int extent, int new_value)
-{
-	unsigned int i;
-
-	for (i = base; i < base + extent; i++) {
-		if (new_value)
-			__set_bit(i, bitmap);
-		else
-			__clear_bit(i, bitmap);
-	}
-}
-
 /*
  * this changes the io permissions bitmap in the current task.
  */
@@ -69,7 +56,10 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 	 */
 	tss = &per_cpu(init_tss, get_cpu());
 
-	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
+	if (turn_on)
+		bitmap_clear(t->io_bitmap_ptr, from, num);
+	else
+		bitmap_set(t->io_bitmap_ptr, from, num);
 
 	/*
 	 * Search for a (possibly new) maximum. This is simple and stupid,
-- 
1.7.4

