Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2KZSKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:10:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2KZRDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Hildner <christian.hildner@siemens.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 060/270] timers: Fix endless looping between cascade() and internal_add_timer()
Date: Mon, 26 Nov 2012 14:55:50 -0200
Message-Id: <1353949160-26803-61-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/timer.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6ec7e7e..ad4ced1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -63,6 +63,7 @@ EXPORT_SYMBOL(jiffies_64);
 #define TVR_SIZE (1 << TVR_BITS)
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
+#define MAX_TVAL ((unsigned long)((1ULL << (TVR_BITS + 4*TVN_BITS)) - 1))
 
 struct tvec {
 	struct list_head vec[TVN_SIZE];
@@ -356,11 +357,12 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
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
-- 
1.7.9.5

