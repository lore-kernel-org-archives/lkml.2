Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0I1Aas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:30:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab0I1AaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:30:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wliCTS+Xi8oFfaWy4m8NA694ieqScaqgmfqY+H8X9pqZhO/Ta/ONPad8rLAroh2HN
	TwiTik92hccXjYg1gyUng==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 0/3][RFC] Improve load balancing when tasks have large weight differential
Date: Mon, 27 Sep 2010 17:29:55 -0700
Message-Id: <1285633798-26886-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have attached a series of patches that improve load balancing when there is a
large weight differential between tasks. These patches are based off the
feedback Peter Zijlstra gave in an earlier post (see http://thread.gmane.org/gmane.linux.kernel/1015966).
They can be applied to v2.6.36-rc5 or -tip without conflicts.

Tested with the following setup.
- Test machine is a 16 cpu box (quad-socket, quad-core).
- Baseline is v2.6.36-rc5 kernel

We spawn 16 SCHED_IDLE soaker threads and one SCHED_NORMAL task. On the
baseline kernel, the machine has ~18% idle time. With these patches applied on
top of baseline, idle time drops to 0%.

v2.6.36-rc5

04:58:46 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
04:58:47 PM  all   81.47    0.00    0.25    0.00    0.00    0.00    0.00   18.28  13796.00
04:58:48 PM  all   81.20    0.00    0.25    0.00    0.00    0.00    0.00   18.55  13816.00
04:58:49 PM  all   80.93    0.19    0.25    0.00    0.00    0.06    0.00   18.57  13965.00
04:58:50 PM  all   81.40    0.00    0.25    0.00    0.00    0.00    0.00   18.35  13837.37
04:58:51 PM  all   81.19    0.00    0.31    0.00    0.00    0.00    0.00   18.50  13592.08
04:58:52 PM  all   81.25    0.00    0.25    0.00    0.00    0.00    0.00   18.50  13721.00
04:58:53 PM  all   81.19    0.00    0.25    0.00    0.00    0.00    0.00   18.56  13764.00
04:58:54 PM  all   81.25    0.00    0.25    0.00    0.00    0.00    0.00   18.50  13841.41
04:58:55 PM  all   80.30    0.00    1.19    0.00    0.00    0.00    0.00   18.51  14989.11
04:58:56 PM  all   80.77    0.00    0.50    0.00    0.00    0.00    0.00   18.73  13964.65
Average:     all   81.09    0.02    0.37    0.00    0.00    0.01    0.00   18.51  13929.53

v2.6.36-rc5 + patches

05:00:06 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
05:00:07 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16364.00
05:00:08 PM  all   99.81    0.06    0.12    0.00    0.00    0.00    0.00    0.00  16348.00
05:00:09 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16330.00
05:00:10 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16317.00
05:00:11 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16327.00
05:00:12 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16323.00
05:00:13 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16323.00
05:00:14 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16321.00
05:00:15 PM  all   99.63    0.06    0.25    0.00    0.00    0.06    0.00    0.00  16354.00
05:00:16 PM  all   99.62    0.00    0.38    0.00    0.00    0.00    0.00    0.00  19059.60
Average:     all   99.85    0.02    0.13    0.00    0.00    0.01    0.00    0.00  16604.20

Comments, feedback welcome.

-Thanks,
Nikhil

Nikhil Rao (3):
  sched: set group_imb only a task can be pulled from the busiest cpu
  sched: drop group_capacity to 1 only if remote group has no running
    tasks
  sched: do not consider SCHED_IDLE tasks to be cache hot

 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

