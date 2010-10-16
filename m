Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0JPAjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:39:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49320 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab0JPAjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:39:01 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 0/6] [RFC] A posix clock/timer interface to the RTC
Date: Fri, 15 Oct 2010 17:38:49 -0700
Message-Id: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>


This patchset allows the RTC to be managed via the posix_clocks/timers
interface. This allows applications to program timer events that will 
wake the system from suspend state. If the system is not suspended, the
timers fire like normal posix timers.

Currently, if an application wants to trigger a RTC alarm to wake up
from suspend, they must use the sysfs wakealarm interface or the rtc
chardev RTC_WKALM_SET ioctl. The limitation with this interface is
that it is fairly hardware oriented, so multiple applications cannot
set an RTC alarm without overwriting any previous alarms set by other
applications.

The in-kernel posix interface allows for the kernel to manage a list
of timers that control when the alarm is fired, so applications
do not need to coordinate access to the alarm hardware.

My earlier proof-of-concept hack/patch for this work (see
http://lwn.net/Articles/405986/ ) did not get much review from the 
RTC folks, so I've carried on reworking a number of layers of code
in order to make this functionality something that could possibly be
upstreamed in the future.

The patches are still fairly rough, but together they do function, so
while there is still work to be done, I wanted to send this out again
so folks had an idea of the scope of the work and could make
suggestions as to where I've gone wrong. :)

So please let me know what you think.

thanks
-john


CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>


John Stultz (5):
  [RFC] Introduce timerlist infrastructure.
  [RFC] hrtimers: Convert hrtimers to use timerlist infrastructure
  [RFC] RTC: Rework RTC code to use timerlist for events
  [RFC] RTC: Remove UIE emulation
  [RFC] RTC: Add posix clock/timer interface

Richard Cochran (1):
  [RFC] posix clocks: dynamic clock ids.

 drivers/rtc/Makefile         |    2 +-
 drivers/rtc/class.c          |   23 ++
 drivers/rtc/interface.c      |  453 +++++++++++++++++++++---------------------
 drivers/rtc/posix.c          |  274 +++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c        |  104 ----------
 drivers/rtc/rtc-lib.c        |   26 +++
 drivers/rtc/rtc-sysfs.c      |   10 +
 include/linux/hrtimer.h      |   32 ++--
 include/linux/posix-timers.h |    9 +-
 include/linux/rtc.h          |   49 +++--
 include/linux/time.h         |    2 +
 include/linux/timerlist.h    |   37 ++++
 kernel/hrtimer.c             |   86 +++-----
 kernel/posix-timers.c        |   41 +++-
 kernel/time/timer_list.c     |    8 +-
 lib/Makefile                 |    2 +-
 lib/timerlist.c              |  115 +++++++++++
 17 files changed, 843 insertions(+), 430 deletions(-)
 create mode 100644 drivers/rtc/posix.c
 create mode 100644 include/linux/timerlist.h
 create mode 100644 lib/timerlist.c
