Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1BQPFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:05:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:60703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab1BQPFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:05:42 -0500
Date: Thu, 17 Feb 2011 15:05:18 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
References: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use bitmap library functions
Message-ID: <tip-da1016df85ed67b6f7dbb765532c54bc35ba08d7@git.kernel.org>
Git-Commit-ID: da1016df85ed67b6f7dbb765532c54bc35ba08d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 15:05:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da1016df85ed67b6f7dbb765532c54bc35ba08d7
Gitweb:     http://git.kernel.org/tip/da1016df85ed67b6f7dbb765532c54bc35ba08d7
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Wed, 16 Feb 2011 23:48:35 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Feb 2011 14:59:22 +0100

x86: Use bitmap library functions

Use bitmap_set()/bitmap_clear() to fill/zero a region of a
bitmap instead of doing set_bit()/clear_bit() each bit.

This change has been tested with ioperm() and there's no
change in behavior.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
