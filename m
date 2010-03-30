Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab0CaABh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:01:37 -0400
Received: from kroah.org ([198.145.64.141]:45426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab0C3XSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:00 2010
Message-Id: <20100330225659.323479291@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Colin Ian King <colin.king@canonical.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [091/116] softlockup: Stop spurious softlockup messages due to overflow
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 8c2eb4805d422bdbf60ba00ff233c794d23c3c00 upstream.

Ensure additions on touch_ts do not overflow.  This can occur
when the top 32 bits of the TSC reach 0xffffffff causing
additions to touch_ts to overflow and this in turn generates
spurious softlockup warnings.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <1268994482.1798.6.camel@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/softlockup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -140,11 +140,11 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_timestamp + softlockup_thresh/2)
+	if (time_after(now - softlockup_thresh/2, touch_timestamp))
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_timestamp + softlockup_thresh))
+	if (time_before_eq(now - softlockup_thresh, touch_timestamp))
 		return;
 
 	per_cpu(print_timestamp, this_cpu) = touch_timestamp;


