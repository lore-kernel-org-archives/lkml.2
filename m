Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab2D0INA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:13:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55930 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2D0IM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:12:57 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 0/5] Rationalize time keeping
Date: Fri, 27 Apr 2012 10:12:39 +0200
Message-Id: <cover.1335510125.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in time for this year's leap second, this patch series presents a
solution for the UTC leap second mess.

Of course, the POSIX UTC system is broken by design, and the Linux
kernel cannot fix that. However, what we can do is correctly execute
leap seconds and always report the time variables (UTC time, TAI
offset, and leap second status) with consistency.

The basic idea is to keep the internal time using a continuous
timescale and to convert to UTC by testing the time value against the
current threshold and adding the appropriate offset. Since the UTC
time and the leap second status is provided on demand, this eliminates
the need to set a timer or to constantly monitor for leap seconds, as
was done up until now.

Patches 2 and 3 are just trivial stuff I saw along the way.

* Benefits
  - Fixes the buggy, inconsistent time reporting surrounding a leap
    second event.
  - Opens the possibility of offering a rational time source to user
    space. [ Trivial to offer clock_gettime(CLOCK_TAI) for example. ]

* Performance Impacts
** con
   - Small extra cost when reading the time (one integer addition plus
     one integer test).
** pro
   - Removes repetitive, periodic division (secs % 86400 == 0) the whole
     day long preceding a leap second.
   - Cost of maintaining leap second status goes to the user of the
     NTP adjtimex() interface, if any.

* Todo
  - The function __current_kernel_time accesses the time variables
    without taking the lock. I can't figure that out.


Richard Cochran (5):
  Add functions to convert continuous timescales to UTC.
  ntp: Fix a stale comment and a few stray newlines.
  timekeeping: Fix a few minor newline issues.
  timekeeping: Offer an interface to manipulate leap seconds.
  timekeeping: Use a continuous timescale to tell time.

 include/linux/timex.h      |    2 +-
 kernel/time/Kconfig        |   12 ++
 kernel/time/leap-seconds.h |   23 ++++
 kernel/time/ntp.c          |   87 ++++------------
 kernel/time/timekeeping.c  |  252 +++++++++++++++++++++++++++++++++++++++++---
 kernel/time/utc-tai.h      |   99 +++++++++++++++++
 6 files changed, 391 insertions(+), 84 deletions(-)
 create mode 100644 kernel/time/leap-seconds.h
 create mode 100644 kernel/time/utc-tai.h

-- 
1.7.2.5

