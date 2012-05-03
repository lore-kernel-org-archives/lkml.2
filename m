Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2ECSVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:21:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55123 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2ECSVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:21:44 -0400
Date: Thu, 3 May 2012 20:21:30 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120503182128.GB2254@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B228F.90903@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 03:49:51PM -0700, John Stultz wrote:
> On 04/27/2012 01:12 AM, Richard Cochran wrote:
> >* Performance Impacts
> >** con
> >    - Small extra cost when reading the time (one integer addition plus
> >      one integer test).
> This may not be so small when it comes to folks who are very
> concerned about the clock_gettime hotpath.
> Further, the correction will be needed to be made in the vsyscall
> paths, which isn't done with your current patchset (causing userland
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> to see different time values then what kernel space calculates).

John, now that you clarified the vDSO thing, I am very confused about
this statement of yours. It appears that the vDSO data are updated
when timekeeping_update() in timekeeper.c calls update_vsyscall().

I think the hunk from patch #5, below, does in fact adjust the time
value correctly before it gets handed off to the arch-specific
update_vsyscall() to be copied into the vDSO page. So I'll make the
claim that:

1. We don't have to touch the vsyscall paths for this.
2. This change does not affect vDSO performance at all.

Would you mind taking another look at the patch?

Thanks,
Richard

---
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7941258..6cedf46 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -212,11 +212,14 @@ static inline s64 timekeeping_get_ns_raw(void)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
+	struct timespec ts;
 	if (clearntp) {
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+	ts.tv_sec = timekeeper_utc_sec();
+	ts.tv_nsec = timekeeper.xtime.tv_nsec;
+	update_vsyscall(&ts, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
