Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1A0O65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:58:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59965 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750904Ab1A0O64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:58:56 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/REJNfZTjR5IS7ketmpWKEhyVFUWFEf/Tts+sG/m
	/NRIGjnSHISPnD
Subject: [PATCH v2 00/20] localize xtime_lock usage to kernel/time/
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, yong.zhang0@gmail.com,
        hch@infradead.org
Date: Thu, 27 Jan 2011 15:58:50 +0100
Message-ID: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchseries cleans up the unnecessary export of xtime_lock
to arch code. After this series is applied its only used in
kernel/time/

- move do_timer() into kernel/time/timekeeping.c
  and provide a version which properly takes the xtime_lock.

- get_jiffies_64() is moved to kernel/time/jiffies.c

- provide get_xtime_and_monotonic_offset() for use in
  kernel/hrtimer.c and use that.

- make all arch code use the new xtime_update() function.

- finally moves do_timer() and xtime_lock into a header file
  private to kernel/time


ChangeLog:
   for v2:
      - add maintainer CC to all the arch commits.
      - improved commit logs based on tglx comments.
      - also deals with kernel/time.c and kernel/hrtimer.c
        by moving get_jiffies_64() and providing a function
	for kernel/hrtimer.c to use.
      - fix kdoc comment for xtime_update.
        
---

Torben Hohn (20):
      move do_timer() from kernel/timer.c into kernel/time/timekeeping.c
      move get_jiffies_64 to kernel/time/jiffies.c
      provide get_xtime_and_monotonic_offset() and use it in hrtimer.c
      provide xtime_update() which does not require the caller to hold xtime_lock
      alpha: change do_timer() to xtime_update()
      arm: switch from do_timer() to xtime_update()
      arm/mach-clps711x: switch do_timer() to xtime_update()
      blackfin: switch from do_timer() to xtime_update()
      cris/arch-v10: switch do_timer() to xtime_update()
      cris/arch-v32: switch do_timer() to xtime_update()
      frv: switch do_timer() to xtime_update()
      h8300: switch do_timer() to xtime_update()
      ia64: switch do_timer() to xtime_update()
      m32r: switch from do_timer() to xtime_update()
      m68k: switch do_timer() to xtime_update()
      mn10300: switch do_timer() to xtimer_update()
      parisc: switch do_timer() to xtime_update()
      sparc: switch do_timer() to xtime_update()
      xtensa: switch do_timer() to xtime_update()
      make do_timer() and xtime_lock private to the timer code


 arch/alpha/kernel/time.c                   |    8 +----
 arch/arm/kernel/time.c                     |    4 +-
 arch/arm/mach-clps711x/include/mach/time.h |    2 +
 arch/blackfin/kernel/time.c                |    6 +---
 arch/cris/arch-v10/kernel/time.c           |    4 +-
 arch/cris/arch-v32/kernel/time.c           |    6 +---
 arch/frv/kernel/time.c                     |    9 ++---
 arch/h8300/kernel/time.c                   |    4 +-
 arch/h8300/kernel/timer/timer8.c           |    2 +
 arch/ia64/kernel/time.c                    |   19 +++--------
 arch/ia64/xen/time.c                       |   13 +++-----
 arch/m32r/kernel/time.c                    |    5 +--
 arch/m68k/bvme6000/config.c                |    4 +-
 arch/m68k/kernel/time.c                    |    4 +-
 arch/m68k/mvme147/config.c                 |    4 +-
 arch/m68k/mvme16x/config.c                 |    4 +-
 arch/m68k/sun3/sun3ints.c                  |    2 +
 arch/m68knommu/kernel/time.c               |    8 +----
 arch/mn10300/kernel/time.c                 |    6 +---
 arch/parisc/kernel/time.c                  |    4 +-
 arch/sparc/kernel/pcic.c                   |    4 +-
 arch/sparc/kernel/time_32.c                |    9 +----
 arch/xtensa/kernel/time.c                  |    6 +---
 include/linux/sched.h                      |    2 +
 include/linux/time.h                       |    4 +-
 kernel/hrtimer.c                           |   12 +------
 kernel/time.c                              |   17 ----------
 kernel/time/jiffies.c                      |   17 ++++++++++
 kernel/time/ntp.c                          |    2 +
 kernel/time/tick-common.c                  |    1 +
 kernel/time/tick-sched.c                   |    1 +
 kernel/time/timekeeping.c                  |   47 +++++++++++++++++++++++++++-
 kernel/time/timer-internal.h               |    7 ++++
 kernel/timer.c                             |   12 -------
 34 files changed, 123 insertions(+), 136 deletions(-)
 create mode 100644 kernel/time/timer-internal.h

-- 
torben Hohn
