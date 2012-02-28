Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2B1AbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:31:10 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36194 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2B1A3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [GIT PULL][PATCH 0/7] Reduce timekeeping lock hold time
Date: Mon, 27 Feb 2012 16:29:27 -0800
Message-Id: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-5518-0000-0000-0000028D6CD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second half of the timekeeping cleanups (the first
half are already in -tip) as well as some changes to reduce the
timekeeping lock hold times.

This work grew out of some of Eric Dumazet's and Thomas Gleixner's
suggestions, after they noticed the xtime_lock hold time could be
on the long side.

The basic idea is that we keep a shadow copy of the timekeeper
stucture, which can be updated while readers are accessing the
time. Then we only have to block readers as we switch to the
newly updated structure.

I've done some limited testing, but it would be good to get
this in -tip early, so we can be sure it gets enough testing
before 3.4 is released.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>

thanks
-john

Thomas,

These patches are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

John Stultz (7):
  time: Condense timekeeper.xtime into xtime_sec
  time: Rework timekeeping functions to take timekeeper ptr as argument
  time: Split timekeeper lock into separate reader/writer locks
  time: Update timekeeper structure using a local shadow
  time: Shadow cycle_last in timekeeper structure
  time: Reduce timekeeper read lock hold time
  time: Convert the timekeeper's wlock to a raw_spin_lock

 kernel/time/timekeeping.c |  414 ++++++++++++++++++++++++++-------------------
 1 files changed, 243 insertions(+), 171 deletions(-)

-- 
1.7.3.2.146.gca209

