Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2GaGgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:36:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44784 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2GaGgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:36:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [PATCH 0/2][RFC] Better handling of insane CMOS values
Date: Tue, 31 Jul 2012 02:35:46 -0400
Message-Id: <1343716548-38742-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073106-2356-0000-0000-000000D9F34F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So CAI Qian noticed recent boot trouble on a machine that had its CMOS
clock configured for the year 8200. 
See: http://lkml.org/lkml/2012/7/29/188

While running with a crazy CMOS clock isn't advised, and a simple
"don't do that" might be reasonable, the behavior has in effect
regressed recently due to changes in the hrtimer/timekeeping
interactions.

This patchset tries to resolve this issue in two ways:
1) Change ktime_get_update_offsets to match ktime_get and avoid
possible precision loss with extremely large timespecs.

2) Catch any stop attempt to set the time to a value (circa the
year 2264) large enough to overflow ktime_t.

The end fix here might be an either/or/both combination of these
two changes, so I wanted to send them out for comment. I'm also
looking at further ways to test and improve robustness around
these more extreme time values.

I've also only been able to lightly test. If you want to try this out
you can add the following to timekeeping_init after the
read_persistent_clock() call:

	now.tv_sec = 196469280000LL;

thanks
-john


Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>


John Stultz (2):
  [RFC] time: Fix problem with large timespecs &
    ktime_get_update_offsets
  [RFC] time: Limit time values that would overflow ktime_t

 kernel/time/timekeeping.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

-- 
1.7.9.5

