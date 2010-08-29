Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0H2PF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:05:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40389 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0H2PF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MHaTtiM7/ibnCoE4vPcJFTSMf4LRVLLTwYXOkaYMAQ8Yl3mfgxAN7n0u+kjwoep9T9
         yKzImiBWwx9jMFl74O1QMapg+Bmi54KYlzuRZncylwBd6pvkbif/Hzw/IiwHVxmq+i0i
         quc3/1zy/tlnjnSa03mVeShtJtKj9EN2iA1T0=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCHSET 0/6] timer/hrtimer/timer_stats: Improvement on timer_stats
Date: Sun, 29 Aug 2010 23:05:03 +0800
Message-Id: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset focus on two problem:

1)timer_stats_timer_*_start_info() should belong to timer core only.
  It should not be seen by outsider, such as workqueue. And should
  not resident in timer.h.
  Patch-0001~0003 first remove the only explicit out call, then move
  timer_stats_timer_*_start_info() from timer.h to timer.c.

2)call site recorded by timer_stats sometimes show the timer core functions
  instead of the real call site.
  Now /proc/timer_stats is like below on my machine:
---now---
Timer Stats Version: v0.2
Sample period: 7.967 s
 10075,     0 kworker/0:0      hrtimer_start_range_ns (tick_sched_timer)
  642,     0 swapper          hrtimer_start (tick_sched_timer)
   16,  1312 pulseaudio       hrtimer_start_range_ns (hrtimer_wakeup)
  153,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
    8,  1117 sshd             sk_reset_timer (tcp_write_timer)
   15,  1373 multiload-apple  hrtimer_start_range_ns (hrtimer_wakeup)
    8,  1361 gvfs-afc-volume  hrtimer_start_range_ns (hrtimer_wakeup)
    4,  1288 gnome-settings-  hrtimer_start_range_ns (hrtimer_wakeup)
    1,  1403 indicator-me-se  hrtimer_start_range_ns (hrtimer_wakeup)
    1,  1306 nautilus         hrtimer_start_range_ns (hrtimer_wakeup)
    1,   487 gdm-binary       hrtimer_start_range_ns (hrtimer_wakeup)
    3,  1304 gnome-panel      hrtimer_start_range_ns (hrtimer_wakeup)
    4,  1347 udisks-daemon    hrtimer_start_range_ns (hrtimer_wakeup)
    9,     0 kworker/0:0      hrtimer_start (tick_sched_timer)
    8,     1 swapper          __enqueue_rt_entity (sched_rt_period_timer)
   14,     0 swapper          clocksource_watchdog (clocksource_watchdog)
    2,  1227 gnome-session    hrtimer_start_range_ns (hrtimer_wakeup)
    4,  1013 hald-addon-stor  hrtimer_start_range_ns (hrtimer_wakeup)
    1,   951 hald             hrtimer_start_range_ns (hrtimer_wakeup)
    2,     0 kworker/0:0      cfq_completed_request (cfq_idle_slice_timer)
    1,   628 Xorg             queue_delayed_work (delayed_work_timer_fn)
    1,  1309 compiz           hrtimer_start_range_ns (hrtimer_wakeup)
   29,  1117 sshd             queue_delayed_work (delayed_work_timer_fn)
   28,  1159 bash             queue_delayed_work (delayed_work_timer_fn)
    9,     0 swapper          sk_reset_timer (tcp_delack_timer)
    6,   502 avahi-daemon     hrtimer_start_range_ns (hrtimer_wakeup)
    1,  1303 gnome-power-man  hrtimer_start_range_ns (hrtimer_wakeup)
    1,   542 console-kit-dae  hrtimer_start_range_ns (hrtimer_wakeup)
   6D,    11 kworker/0:1      queue_delayed_work (delayed_work_timer_fn)
   5D,    46 kworker/1:1      queue_delayed_work (delayed_work_timer_fn)
    2,     7 watchdog/0       hrtimer_start (watchdog_timer_fn)
    2,    12 watchdog/1       hrtimer_start (watchdog_timer_fn)
    1,   919 rtkit-daemon     hrtimer_start_range_ns (hrtimer_wakeup)
    1,  1307 pulseaudio       hrtimer_start_range_ns (hrtimer_wakeup)
    1,   651 irqbalance       hrtimer_start_range_ns (hrtimer_wakeup)
    1,     0 kworker/0:0      dev_watchdog (dev_watchdog)
    1,   914 pulseaudio       hrtimer_start_range_ns (hrtimer_wakeup)
    1,  1265 ssh-agent        hrtimer_start_range_ns (hrtimer_wakeup)
493 total events, 61.880 events/sec
---------------------------------------------------------------------------------------
Then after patches applied:
---patched--
Timer Stats Version: v0.2
Sample period: 8.683 s
         82,          0 kworker/0:0      tick_nohz_restart_sched_tick (tick_sched_timer)
        130,          0 swapper          tick_nohz_restart_sched_tick (tick_sched_timer)
          5,       1172 udisks-daemon    schedule_hrtimeout_range_clock (hrtimer_wakeup)
          5,       1009 hald-addon-stor  schedule_hrtimeout_range_clock (hrtimer_wakeup)
          1,        959 hald             schedule_hrtimeout_range_clock (hrtimer_wakeup)
          3,          7 watchdog/0       watchdog (watchdog_timer_fn)
          7,       3530 sshd             sk_reset_timer (tcp_write_timer)
          9,       1189 gvfs-afc-volume  do_nanosleep (hrtimer_wakeup)
         17,       1204 multiload-apple  schedule_hrtimeout_range_clock (hrtimer_wakeup)
          3,         12 watchdog/1       watchdog (watchdog_timer_fn)
          4,          1 swapper          __enqueue_rt_entity (sched_rt_period_timer)
         14,       1244 gnome-terminal   schedule_hrtimeout_range_clock (hrtimer_wakeup)
         13,        629 Xorg             queue_delayed_work_on (delayed_work_timer_fn)
         16,          0 kworker/0:0      clocksource_watchdog (clocksource_watchdog)
          2,       1368 update-notifier  schedule_hrtimeout_range_clock (hrtimer_wakeup)
         7D,         11 kworker/0:1      queue_delayed_work_on (delayed_work_timer_fn)
          2,       1096 gnome-settings-  schedule_hrtimeout_range_clock (hrtimer_wakeup)
         8D,         46 kworker/1:1      queue_delayed_work_on (delayed_work_timer_fn)
          2,        915 rtkit-daemon     schedule_hrtimeout_range_clock (hrtimer_wakeup)
          1,        654 irqbalance       do_nanosleep (hrtimer_wakeup)
          1,       1073 ssh-agent        schedule_hrtimeout_range_clock (hrtimer_wakeup)
          2,       1140 compiz           schedule_hrtimeout_range_clock (hrtimer_wakeup)
          2,       1136 gnome-panel      schedule_hrtimeout_range_clock (hrtimer_wakeup)
          4,         11 kworker/0:1      schedule_timeout_uninterruptible (process_timeout)
         25,       3530 sshd             queue_delayed_work_on (delayed_work_timer_fn)
         24,       3573 bash             queue_delayed_work_on (delayed_work_timer_fn)
          7,          0 swapper          sk_reset_timer (tcp_delack_timer)
          1,       1080 gconfd-2         schedule_hrtimeout_range_clock (hrtimer_wakeup)
          1,       1133 gnome-power-man  schedule_hrtimeout_range_clock (hrtimer_wakeup)
          1,        533 console-kit-dae  schedule_hrtimeout_range_clock (hrtimer_wakeup)
399 total events, 45.951 events/sec
---------------------------------------------------------------------------------------
You can notice tick_nohz_restart_sched_tick(), watchdog(), do_nanosleep()
is showed as the start_site.

And there is also something reflected in timer_list(AKA, more readable
start_site).

Any comments is appreciated.

Thanks,
Yong

Yong Zhang (6):
      timer: expliciyly call timer_stats_timer_set_start_info() in add_timer()
      workqueue: remove redundant timer_stats_timer_set_start_info()
      timer: move timer_stats_timer_*_start_info() to kernel/timer.c
      hrtimer: change call site of timer_stats_hrtimer_clear_start_info()
      hrtimer: record more real start_site for timer_stats
      timer_stats: make output more readable

 include/linux/timer.h     |   23 -----------------------
 kernel/hrtimer.c          |   10 ++++++----
 kernel/time/timer_stats.c |    4 ++--
 kernel/timer.c            |   21 +++++++++++++++++++--
 kernel/workqueue.c        |    2 --
 5 files changed, 27 insertions(+), 33 deletions(-)
