Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2GASbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:31:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35069 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2GASbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:31:19 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue (v2)
Date: Sun,  1 Jul 2012 14:29:59 -0400
Message-Id: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
x-cbid: 12070118-7282-0000-0000-00000A7ABBC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Here's round two on this one. 

As widely reported on the internet, some Linux systems after
the leapsecond was inserted are experiencing futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent  workaround for this issue is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix


To address this issue we do two things:
1) Fix the clock_was_set() call to remove the limitation that kept
us from calling it from update_wall_time().

2) Call clock_was_set() when we add/remove a leapsecond.

I've been able to reproduce the load spike using Thunderbird
when triggering a leap second and with this patch the issue
did not crop up.

NOTE: Some reports have been of a hard hang right at or before
the leapsecond. I've not been able to reproduce or diagnose
this, so this fix does not likely address the reported hard
hangs (unless they end up being connected to the futex/hrtimer
issue).


TODOs:
* Chase down the futex/hrtimer interaction to see if this could
be triggered in any other way.
* Get Tglx's input/ack
* Generate a backport for pre-v3.4 kernels


v2:
* Address the issue w/ calling clock_was_set from atomic context, pointed
out by Prarit and Ben.
* Rework fix so its simpler.


CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>

John Stultz (2):
  [RFC] Fix clock_was_set so it is safe to call from atomic
  [RFC] Fix leapsecond triggered hrtimer/futex load spike issue

 kernel/hrtimer.c          |   16 +++++++++++++++-
 kernel/time/timekeeping.c |    4 ++++
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 
1.7.9.5

