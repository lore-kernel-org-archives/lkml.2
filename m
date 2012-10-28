Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2J1X3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:29:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42246 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab2J1X2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:32 -0400
Message-Id: <20121028231546.516941371@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Hildner, Christian" <christian.hildner@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 031/105] timers: Fix endless looping between cascade() and
 internal_add_timer()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Hildner, Christian" <christian.hildner@siemens.com>

commit 26cff4e2aa4d666dc6a120ea34336b5057e3e187 upstream.

Adding two (or more) timers with large values for "expires" (they have
to reside within tv5 in the same list) leads to endless looping
between cascade() and internal_add_timer() in case CONFIG_BASE_SMALL
is one and jiffies are crossing the value 1 << 18. The bug was
introduced between 2.6.11 and 2.6.12 (and survived for quite some
time).

This patch ensures that when cascade() is called timers within tv5 are
not added endlessly to their own list again, instead they are added to
the next lower tv level tv4 (as expected).

Signed-off-by: Christian Hildner <christian.hildner@siemens.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Link: http://lkml.kernel.org/r/98673C87CB31274881CFFE0B65ECC87B0F5FC1963E@DEFTHW99EA4MSX.ww902.siemens.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/timer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index d5de1b2..367d008 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -63,6 +63,7 @@ EXPORT_SYMBOL(jiffies_64);
 #define TVR_SIZE (1 << TVR_BITS)
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
+#define MAX_TVAL ((unsigned long)((1ULL << (TVR_BITS + 4*TVN_BITS)) - 1))
 
 struct tvec {
 	struct list_head vec[TVN_SIZE];
@@ -359,11 +360,12 @@ __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 		vec = base->tv1.vec + (base->timer_jiffies & TVR_MASK);
 	} else {
 		int i;
-		/* If the timeout is larger than 0xffffffff on 64-bit
-		 * architectures then we use the maximum timeout:
+		/* If the timeout is larger than MAX_TVAL (on 64-bit
+		 * architectures or with CONFIG_BASE_SMALL=1) then we
+		 * use the maximum timeout.
 		 */
-		if (idx > 0xffffffffUL) {
-			idx = 0xffffffffUL;
+		if (idx > MAX_TVAL) {
+			idx = MAX_TVAL;
 			expires = idx + base->timer_jiffies;
 		}
 		i = (expires >> (TVR_BITS + 3 * TVN_BITS)) & TVN_MASK;


