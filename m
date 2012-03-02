Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2CBHNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39731 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908Ab2CBHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 0/9] Reduce timekeeping lock hold time v2
Date: Thu,  1 Mar 2012 23:12:39 -0800
Message-Id: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-7282-0000-0000-000007061814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once again, here is the second half of the timekeeping cleanups (the
first half are already in -tip) as well as some changes to reduce the
timekeeping lock hold times.

This work grew out of some of Eric Dumazet's and Thomas Gleixner's
suggestions, after they noticed the xtime_lock hold time could be
on the long side.

The basic idea is that we keep a shadow copy of the timekeeper
stucture, which can be updated while readers are accessing the
time. Then we only have to block readers as we switch to the
newly updated structure.

Changelog:
v2: 
This revsion includes some formatting changes suggested by Ingo,
as well as a patch converting shift values from ints to u32 to 
avoid any unintended extra effort caused by the compiler. There
is also a few minor bug fixes that I caught with some additional
testing.

Let me know if you have any further issues with the patchset.

If not, feel free to pull the tree from:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

John Stultz (9):
  time: Condense timekeeper.xtime into xtime_sec
  time: Rework timekeeping functions to take timekeeper ptr as argument
  time: Split timekeeper lock into separate reader/writer locks
  time: Update timekeeper structure using a local shadow
  time: Shadow cycle_last in timekeeper structure
  time: Reduce timekeeper read lock hold time
  time: Convert the timekeeper's wlock to a raw_spin_lock
  time: Whitespace cleanups per Ingo's requests
  time: Explicitly use u32 instead of int for shift values

 kernel/time/timekeeping.c |  506 ++++++++++++++++++++++++++-------------------
 1 files changed, 290 insertions(+), 216 deletions(-)

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
-- 
1.7.3.2.146.gca209

