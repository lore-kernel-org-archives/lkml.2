Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2FXRic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 13:38:32 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:42245 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2FXRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 13:38:31 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2012 13:38:31 EDT
Message-ID: <4FE74F1B.6070803@corelatus.se>
Date: Sun, 24 Jun 2012 19:32:11 +0200
From: Thomas Lange <thomas@corelatus.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [BUG] sched: clock wrap bug in 2.6.35-stable kills scheduling
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 305e683 introduced a wrap bug that causes task scheduling to fail
after sched_clock() wrap. On a 1000 HZ system with 32bit jiffies, this
occurs after 49.7 days.

Bug was introduced in 2.6.35.12 and is still present in linux-2.6.35.y HEAD.

Symptoms include one task getting all available cpu time while others get
_none_. Setting niceness seems to make things even worse. Running this code
in a new process after wrap completely lock up user space, thus triggering a
watchdog reboot:
{ nice(1); while(1); }

To reproduce bug in reasonable time, one can up HZ. With 16000 HZ, bug occurs
after 3.1 days.
Modifying sched_clock() to wrap when jiffies does triggers bug after 5 mins.

The basic problem seems to be that rq->clock_task get stuck forever with a
really high value when rq->clock starts over from 0.

This fix solves that problem:

diff --git a/kernel/sched.c b/kernel/sched.c
index d40d662..883448f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -657,6 +657,8 @@ inline void update_rq_clock(struct rq *rq)
        if (!rq->skip_clock_update)
                rq->clock = sched_clock_cpu(cpu_of(rq));
        irq_time = irq_time_cpu(cpu);
+       if (rq->clock < rq->clock_task)
+               rq->clock_task = 0;
        if (rq->clock - irq_time > rq->clock_task)
                rq->clock_task = rq->clock - irq_time;

I can create a proper patch if the above is acceptable.

A more appropriate solution would perhaps be to pull some additional sched
commits into stable branch, like fe44d62 and friends. I don't know enough
about scheduler internals to tell.

All tests were performed on mips32 systems, but all systems with 32bit
jiffies should be affected.

/Thomas
