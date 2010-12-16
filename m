Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0LPAl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:41:27 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36837 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0LPAlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:41:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>
Subject: =?UTF-8?q?=5BPATCH=200/2=5D=20=5BRFC=5D=20Introduce=20CLOCK=5FBOOTTIME?=
Date: Wed, 15 Dec 2010 16:40:46 -0800
Message-Id: <1292460048-28035-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some discussions with Jamie Lokier about some of the 
drawbacks of CLOCK_MONOTONIC not incrementing during suspend
(see http://www.spinics.net/lists/linux-fsdevel/msg40272.html),
I wanted to see if we couldn't provide a new clockid that would 
allow applications that wanted to be aware of time passing during
suspend without having to deal with the inconsistencies of 
CLOCK_REALTIME caused by calls to settimeofday.

So this patchset introduces CLOCK_BOOTTIME, which is identical
to CLOCK_MONOTONIC, but includes any time spent in suspend.

This is just my initial stab at this, so I'd appreciate any comments
or thougths on these patches.

Jamie: On platforms that don't implement read_persistent_clock,
your issue would still be present, but fixing that is on my list.
Other then that issue, does this seem to address your concern?

Thomas: Let me know if the hrtimer_base indirection is too 
gross. It just seemed silly to create 5 empty bases so we could
have an exact match between the clockids and the bases.

Arve: I believe CLOCK_BOOTTIME would be sufficient for what
Android is using as elapsedRealtime() or 
ANDROID_ALARM_ELAPSED_REALTIME. If not please let me know why.

thanks
-john


CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve Hjønnevåg <arve@android.com>


John Stultz (2):
  hrtimers: extend hrtimer base code to handle more then 2 clockids
  hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase and posix interface

 include/linux/hrtimer.h   |   22 ++++++++++++-
 include/linux/time.h      |    4 ++
 kernel/hrtimer.c          |   44 ++++++++++++++++---------
 kernel/posix-timers.c     |   16 ++++++++-
 kernel/time/timekeeping.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 146 insertions(+), 19 deletions(-)

-- 
1.7.3.2.146.gca209

