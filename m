Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161967Ab1FALsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:48:41 -0400
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:57719 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161733Ab1FALs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:48:28 -0400
X-AuditID: c1b4fb39-b7bfdae000005125-15-4de6270ad0bd
From: Nils Carlson <nils.carlson@ericsson.com>
To: <clemens@ladisch.de>, <linux-kernel@vger.kernel.org>
CC: Nils Carlson <nils.carlson@ericsson.com>
Subject: [PATCH] Fix periodic-emulation in HPET for delayed interrupts
Date: Wed, 1 Jun 2011 13:58:50 +0200
Message-ID: <1306929530-23771-1-git-send-email-nils.carlson@ericsson.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When interrupts are delayed due to interrupt masking or due
to other interrupts being serviced the HPET periodic-emuation
would fail. This happened because given an interval t and
a time for the current interrupt m we would compute the next
time as t + m. This works until we are delayed for > t, in
which case we would be writing a new value which is in fact
in the past.

This can be solved by computing the next time instead as
(k * t) + m where k is large enough to be in the future.
The exact computation of k is described in a comment to
the code.

Signed-off-by: Nils Carlson <nils.carlson@ericsson.com>
---
 drivers/char/hpet.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 051474c..34d6a1c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -163,11 +163,32 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 	 * This has the effect of treating non-periodic like periodic.
 	 */
 	if ((devp->hd_flags & (HPET_IE | HPET_PERIODIC)) == HPET_IE) {
-		unsigned long m, t;
+		unsigned long m, t, mc, base, k;
+		struct hpet __iomem *hpet = devp->hd_hpet;
+		struct hpets *hpetp = devp->hd_hpets;
 
 		t = devp->hd_ireqfreq;
 		m = read_counter(&devp->hd_timer->hpet_compare);
-		write_counter(t + m, &devp->hd_timer->hpet_compare);
+		mc = read_counter(&hpet->hpet_mc);
+		/* The time for the next interrupt would logically be t + m,
+		 * however, if we are very unlucky and the interrupt is delayed
+		 * for longer than t then we will completely miss the next
+		 * interrupt if we set t + m and an application will hang.
+		 * Therefore we need to make a more complex computation assuming
+		 * that there exists a k for which the following is true:
+		 * k * t + base < mc + delta
+		 * (k + 1) * t + base > mc + delta
+		 * where t is the interval in hpet ticks for the given freq,
+		 * base is the theoretical start value 0 < base < t,
+		 * mc is the main counter value at the time of the interrupt,
+		 * delta is the time it takes to write the a value to the
+		 * comparator.
+		 * k may then be computed as (mc - base + delta) / t .
+		 */
+		base = mc % t;
+		k = (mc - base + hpetp->hp_delta) / t;
+		write_counter(t * (k + 1) + base,
+			      &devp->hd_timer->hpet_compare);
 	}
 
 	if (devp->hd_flags & HPET_SHARED_IRQ)
-- 
1.7.2.5

