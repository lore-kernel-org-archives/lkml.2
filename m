Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282Ab2CQVbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 17:31:41 -0400
Received: from nbd.name ([46.4.11.11]:55470 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab2CQVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 17:31:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [PATCH] timer: optimize apply_slack()
Date: Sat, 17 Mar 2012 22:31:35 +0100
Message-Id: <1332019895-59698-1-git-send-email-nbd@openwrt.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fls(mask) is equivalent to find_last_bit(&mask, BITS_PER_LONG), but cheaper.
find_last_bit was showing up high on the list when I was profiling for stalls
on icache misses on a system with very small cache size (MIPS).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..659371e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -809,7 +809,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 	if (mask == 0)
 		return expires;
 
-	bit = find_last_bit(&mask, BITS_PER_LONG);
+	bit = __fls(mask);
 
 	mask = (1 << bit) - 1;
 
-- 
1.7.3.2

