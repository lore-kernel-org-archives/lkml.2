Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab0LUEit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:38:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57541 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0LUEis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:38:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Arve Hjnnevg <arve@android.com>
Subject: [PATCH 0/2] Introduce CLOCK_BOOTTIME (v2)
Date: Mon, 20 Dec 2010 20:38:40 -0800
Message-Id: <1292906322-14705-1-git-send-email-john.stultz@linaro.org>
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

This second version of the patch uses a array table for the
clock_id->hrtimer_base convesion instead of the switch.

Thomas: I've not been able to do much comparision at the asm
level for ppc and arm (while I have cross tools for compiling,
I don't have objdump for those arches on my build box) between
this and the previous switch code. But on x86, size breakdown
looks like:

Original:
   text	   data	    bss	    dec	    hex	filename
15517512	1899836	 891200	18308548	1175dc4	vmlinux

Switch:
   text	   data	    bss	    dec	    hex	filename
15517716	1899804	 891200	18308720	1175e70	vmlinux

Table:
   text	   data	    bss	    dec	    hex	filename
15517873	1899868	 891200	18308941	1175f4d	vmlinux

So that's not as great, but remvoing the WARN_ON added in 
hrtimer_clockid_to_base drops it down quite a bit:
Table-nowarn:
   text	   data	    bss	    dec	    hex	filename
15517617	1899804	 891200	18308621	1175e0d	vmlinux

Looking at the asm, the change from the original is limited
(as expected)to: hrtimer_get_res, hrtimer_init, 
__hrtimer_start_range_ns,  where the difference is a few extra
movs, and and hrtimers_init, where there's the extra table
initialization work.

If you have any tips for more specific comprisions please let
me know. Diffing objdump output doesn't always make it super
clear as to what changed.

Jamie: On platforms that don't implement read_persistent_clock,
your issue would still be present, but fixing that is on my list.
Other then that issue, does this seem to address your concern?

Arve: I believe CLOCK_BOOTTIME would be sufficient for what
Android is using as elapsedRealtime() or 
ANDROID_ALARM_ELAPSED_REALTIME. If not please let me know why.

thanks
-john


CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve Hjnnevg <arve@android.com>

John Stultz (2):
  [RFC] hrtimers: extend hrtimer base code to handle more then 2
    clockids
  [RFC] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase and posix
    interface

 include/linux/hrtimer.h   |    8 ++++-
 include/linux/time.h      |    4 ++
 kernel/hrtimer.c          |   63 +++++++++++++++++++++++++++--------
 kernel/posix-timers.c     |   16 ++++++++-
 kernel/time/timekeeping.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 152 insertions(+), 18 deletions(-)

-- 
1.7.3.2.146.gca209

