Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0KCSbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:31:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45910 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0KCSbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:31:36 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 0/7] Posix interface for RTC (v2)
Date: Wed,  3 Nov 2010 11:31:12 -0700
Message-Id: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

So I think this patch set is starting to shape up, and 
it has been functioning pretty well in my testing, so 
I wanted to send it out again for review.

The first two patches lay groundwork, pulling the timerlist
infrastructure out of hrtimers and into common code.

The next two patches rework the RTC code, so the interface is
a little more abstracted away from the hardware, allowing
us to multiplex timers from different applications ontop of
a single RTC device, and cleaning up the now redundant older
emulation layer.

This is where the patchset diverges into two paths:

The next two patches provide a posix interface layer ontop of
the RTC device. One of the patches, provided by Richard Cochran,
allows for dynamic posix clock registration and is likely to be
reworked here shortly. The other implements the posix interface.
This interface exposes the actual RTC time and allows timers
to be set against that time domain, which may not stay in sync
with the kernel's system time. It also allows wakeup timers to be
triggered in the future when the machine may be suspended.


The last patch takes a different approach. It too provides a
posix interface that can be used to trigger wakeup alarms
when the machine is suspended, but it uses a bit of a hybrid
method, basing timers off the system time clock ids (ie: 
CLOCK_REALTIME/MONOTONIC) while the system is running, and 
then setting the RTC to fire only when we go to suspend.
This hybrid approach was inspired by the Android Alarm driver,
which uses this same method, but exposes the interface to
userland via ioctl device instead of the posix interface.

I wanted to send out both of these methods to get some
feedback on which direction (or possibly both) people
would prefer to see.

Any other feedback or comments would also be appreciated!

thanks
-john


CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Arve Hjønnevåg <arve@android.com>



John Stultz (6):
  [RFC] Introduce timerlist infrastructure.
  [RFC] hrtimers: Convert hrtimers to use timerlist infrastructure
  [RFC] RTC: Rework RTC code to use timerlist for events
  [RFC] RTC: Remove UIE emulation
  [RFC] RTC: Add posix clock/timer interface
  [RFC] Introduce Alarm (hybrid) timers

Richard Cochran (1):
  [RFC] posix clocks: dynamic clock ids.

 drivers/rtc/Makefile         |    2 +-
 drivers/rtc/class.c          |   15 +
 drivers/rtc/interface.c      |  579 ++++++++++++++++++++++++++----------------
 drivers/rtc/posix.c          |  258 +++++++++++++++++++
 drivers/rtc/rtc-dev.c        |  104 --------
 drivers/rtc/rtc-lib.c        |   26 ++
 drivers/rtc/rtc-sysfs.c      |   10 +
 include/linux/alarmtimer.h   |   29 ++
 include/linux/hrtimer.h      |   32 +--
 include/linux/posix-timers.h |   11 +-
 include/linux/rtc.h          |   52 +++-
 include/linux/time.h         |    4 +
 include/linux/timerlist.h    |   37 +++
 kernel/hrtimer.c             |   86 +++----
 kernel/posix-timers.c        |   41 +++-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  522 +++++++++++++++++++++++++++++++++++++
 kernel/time/timer_list.c     |    8 +-
 lib/Makefile                 |    2 +-
 lib/timerlist.c              |  115 +++++++++
 20 files changed, 1503 insertions(+), 432 deletions(-)
 create mode 100644 drivers/rtc/posix.c
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 include/linux/timerlist.h
 create mode 100644 kernel/time/alarmtimer.c
 create mode 100644 lib/timerlist.c

-- 
1.7.3.2.146.gca209

