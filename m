Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0CVHqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:46:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:58955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0CVHqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:46:30 -0400
Date: Mon, 22 Mar 2010 07:45:51 GMT
From: tip-bot for Colin Ian King <colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       colin.king@canonical.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
       colin.king@canonical.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268994482.1798.6.camel@lenovo>
References: <1268994482.1798.6.camel@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] softlockup: Stop spurious softlockup messages due to overflow
Message-ID: <tip-8c2eb4805d422bdbf60ba00ff233c794d23c3c00@git.kernel.org>
Git-Commit-ID: 8c2eb4805d422bdbf60ba00ff233c794d23c3c00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Mar 2010 07:45:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c2eb4805d422bdbf60ba00ff233c794d23c3c00
Gitweb:     http://git.kernel.org/tip/8c2eb4805d422bdbf60ba00ff233c794d23c3c00
Author:     Colin Ian King <colin.king@canonical.com>
AuthorDate: Fri, 19 Mar 2010 10:28:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 21 Mar 2010 19:30:13 +0100

softlockup: Stop spurious softlockup messages due to overflow

Ensure additions on touch_ts do not overflow.  This can occur
when the top 32 bits of the TSC reach 0xffffffff causing
additions to touch_ts to overflow and this in turn generates
spurious softlockup warnings.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <1268994482.1798.6.camel@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..4b493f6 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -155,11 +155,11 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_ts + softlockup_thresh/2)
+	if (time_after(now - softlockup_thresh/2, touch_ts))
 		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_ts + softlockup_thresh))
+	if (time_before_eq(now - softlockup_thresh, touch_ts))
 		return;
 
 	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
