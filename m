Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2BCQB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:01:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2BCQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:01:24 -0500
From: Chinmay V S <chinmay.v.s@pathpartnertech.com>
To: linux-kernel@vger.kernel.org
Cc: cvs268@gmail.com, tglx@linutronix.de, sebastian@breakpoint.cc,
        arjan@linux.intel.com, jeff.chua.linux@gmail.com,
        Chinmay V S <chinmay.v.s@pathpartnertech.com>
Subject: [PATCH] [timer] Optimise apply_slack() for size and speed.
Date: Fri,  3 Feb 2012 21:30:50 +0530
Message-Id: <1328284850-27743-1-git-send-email-chinmay.v.s@pathpartnertech.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <arjan@linux.intel.com>
References: <arjan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the patch for improved readability.
How about the following patch?


To apply proper slack, the original algorithm used to prepare a mask and
then apply the mask to obtain the appropriately rounded-off absolute
time the timer expires.

This patch modifies the masking logic to a bit-shift logic, therby
reducing the complexity and number of operations. Thus obtaining a minor
speed-up.

Signed-off-by: Chinmay V S <chinmay.v.s@pathpartnertech.com>
---
 kernel/timer.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..eb4b708 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -785,9 +785,7 @@ EXPORT_SYMBOL(mod_timer_pending);
  * Algorithm:
  *   1) calculate the maximum (absolute) time
  *   2) calculate the highest bit where the expires and new max are different
- *   3) use this bit to make a mask
- *   4) use the bitmask to round down the maximum time, so that all last
- *      bits are zeros
+ *   3) round down the maximum time, so that all the lower bits are zeros
  */
 static inline
 unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
@@ -811,9 +809,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
-
-	expires_limit = expires_limit & ~(mask);
+	/* Round down by zero-ing the lower bits */
+	expires_limit = (expires_limit >> bit) << bit;
 
 	return expires_limit;
 }
-- 
1.7.5.4

