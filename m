Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2JITuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:50:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2JITuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:50:11 -0400
Date: Tue, 9 Oct 2012 12:49:50 -0700
From: "tip-bot for Hildner, Christian" <christian.hildner@siemens.com>
Message-ID: <tip-26cff4e2aa4d666dc6a120ea34336b5057e3e187@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        christian.hildner@siemens.com, jan.kiszka@siemens.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        christian.hildner@siemens.com, tglx@linutronix.de,
        jan.kiszka@siemens.com
In-Reply-To: <98673C87CB31274881CFFE0B65ECC87B0F5FC1963E@DEFTHW99EA4MSX.ww902.siemens.net>
References: <98673C87CB31274881CFFE0B65ECC87B0F5FC1963E@DEFTHW99EA4MSX.ww902.siemens.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Fix endless looping between cascade()
  and internal_add_timer()
Git-Commit-ID: 26cff4e2aa4d666dc6a120ea34336b5057e3e187
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 12:49:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26cff4e2aa4d666dc6a120ea34336b5057e3e187
Gitweb:     http://git.kernel.org/tip/26cff4e2aa4d666dc6a120ea34336b5057e3e187
Author:     Hildner, Christian <christian.hildner@siemens.com>
AuthorDate: Mon, 8 Oct 2012 15:49:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 9 Oct 2012 21:27:14 +0200

timers: Fix endless looping between cascade() and internal_add_timer()

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
Cc: stable@vger.kernel.org
---
 kernel/timer.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

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
