Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2GQReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:34:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54535 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2GQRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:34:34 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock & hrtimer/futex issue
Date: Tue, 17 Jul 2012 13:33:47 -0400
Message-Id: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071717-7606-0000-0000-00000213278D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is backport of the leapsecond fixes to 3.0-stable. These are less
straight forward, and should get closer review.

This patch set addresses two issues:

1) Deadlock leapsecond issue that a few reports described.

I spent some time over the weekend trying to find a way to reproduce
the hard-hang issue some folks were reporting after the leapsecond.
Initially I didn't think the 6b43ae8a619d17 leap-second hrimter livelock
patch needed to be backported since, I assumed it required the ntp_lock
split for it to be triggered, but looking again I found that the same
issue could occur prior to splitting out the ntp_lock. So I've backported
that fix (and its follow-on fixups) as well as created a test case
to reproduce the hard-hang deadlock.


2) Early hrtimer/futex expiration issue that was more widely observed

This is the load-spike issue that a number of folks saw that did not
hard hang most boxes (although some reports did show nmi-watchdogs
triggering due to sudden spinning in tight loops).

I've booted and tested this entire patchset on two boxes and run through a
number of leapsecond related stress tests. However, additional testing and
review would be appreciated.

The original commits backported in this set are:

Deadlock issue fixes:
---------------------
6b43ae8a619d17c4935c3320d2ef9e92bdeed05d    ntp: Fix leap-second hrtimer livelock
dd48d708ff3e917f6d6b6c2b696c3f18c019feed    ntp: Correct TAI offset during leap second
fad0c66c4bb836d57a5f125ecd38bed653ca863a    timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond

Helper change: (allows the following fixes to backport more easily):
--------------------------------------------------------------------
cc06268c6a87db156af2daed6e96a936b955cc82    time: Move common updates to a function

Hrtimer early-expiration issue fixes:
-------------------------------
f55a6faa384304c89cfef162768e88374d3312cb    hrtimer: Provide clock_was_set_delayed()
4873fa070ae84a4115f0b3c9dfabc224f1bc7c51    timekeeping: Fix leapsecond triggered load spike issue
5b9fe759a678e05be4937ddf03d50e950207c1c0    timekeeping: Maintain ktime_t based offsets for hrtimers
196951e91262fccda81147d2bcf7fdab08668b40    hrtimers: Move lock held region in hrtimer_interrupt()
f6c06abfb3972ad4914cef57d8348fcb2932bc3b    timekeeping: Provide hrtimer update function
5baefd6d84163443215f4a99f6a20f054ef11236    hrtimer: Update hrtimer base offsets each hrtimer_interrupt
3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0    timekeeping: Add missing update call in timekeeping_resume()


I've already done backports to all the stable kernels to 2.6.32, and
will send out the rest soon.

Please let me know if you have any comments or feedback. 

thanks
-john


Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

John Stultz (5):
  3.0.x: ntp: Fix leap-second hrtimer livelock
  3.0.x: timekeeping: Fix CLOCK_MONOTONIC inconsistency during
    leapsecond
  3.0.x: hrtimer: Provide clock_was_set_delayed()
  3.0.x: timekeeping: Fix leapsecond triggered load spike issue
  3.0.x: hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Richard Cochran (1):
  3.0.x: ntp: Correct TAI offset during leap second

Thomas Gleixner (5):
  3.0.x: time: Move common updates to a function
  3.0.x: timekeeping: Maintain ktime_t based offsets for hrtimers
  3.0.x: hrtimers: Move lock held region in hrtimer_interrupt()
  3.0.x: timekeeping: Provide hrtimer update function
  3.0.x: timekeeping: Add missing update call in timekeeping_resume()

 include/linux/hrtimer.h   |   10 +++-
 include/linux/timex.h     |    2 +-
 kernel/hrtimer.c          |   53 +++++++++++++------
 kernel/time/ntp.c         |  124 +++++++++++++++------------------------------
 kernel/time/timekeeping.c |  115 +++++++++++++++++++++++++++++++----------
 5 files changed, 175 insertions(+), 129 deletions(-)

-- 
1.7.9.5

