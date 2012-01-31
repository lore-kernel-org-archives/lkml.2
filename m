Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2AaJht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:37:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51705 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2AaJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:37:47 -0500
From: Chinmay V S <chinmay.v.s@pathpartnertech.com>
To: linux-kernel@vger.kernel.org
Cc: cvs268@gmail.com, tglx@linutronix.de, sebastian@breakpoint.cc,
        arjan@linux.intel.com, jeff.chua.linux@gmail.com,
        Chinmay V S <chinmay.v.s@pathpartnertech.com>
Subject: [RFC] [PATCH] [timer] Optimise apply_slack() for size and speed.
Date: Tue, 31 Jan 2012 15:07:32 +0530
Message-Id: <1328002652-7700-1-git-send-email-chinmay.v.s@pathpartnertech.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To apply proper slack, the original algorithm used to prepare a mask and
then apply the mask to obtain the appropriately rounded-off absolute
time the timer expires.

This patch modifies the masking logic to a bit-shift logic, therby
reducing the complexity and number of operations. Thus obtaining a minor
speed-up.

Signed-off-by: Chinmay V S <chinmay.v.s@pathpartnertech.com>
---
 kernel/timer.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..0379658 100644
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
@@ -811,9 +809,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	bit = find_last_bit(&mask, BITS_PER_LONG);
 
-	mask = (1 << bit) - 1;
-
-	expires_limit = expires_limit & ~(mask);
+	expires_limit = (expires_limit >> bit) << bit;
 
 	return expires_limit;
 }
-- 
1.7.5.4

