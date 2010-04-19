Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab0DSUss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:48:48 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48772 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0DSUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vlAD76YIsXu8OC/Po0z1CE5FNrEL+fcmM4NvUuGRHLh3b3wK9RE6ambVyvBYDiUpVc
         QQbZyy0Ps5omwixihStz8fHZzxrErgDTLqRHM2E32tWhiKoxe+yFYGtGpubnIpdCjE6h
         uB353bqvz9yx5UbtFCCLHVs5XPo+rkCaemfVE=
MIME-Version: 1.0
Date: Mon, 19 Apr 2010 22:48:45 +0200
Message-ID: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
Subject: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all
I am an Italian researcher and I am working on a (cross-platform) Real
Time scheduling infrastructure.
I am currently using Linux Kernel 2.6.29.6-rt24-smp (PREEMPT-RT Patch)
running on a Intel Q9550 CPU.
Yesterday days I found a strange behavior of the scheduler API's using
the RT patch, in particular the pthread_setaffinity_np (that stands on
sched_setaffinity).
(link: http://article.gmane.org/gmane.linux.kernel.api/1550)

I think the main problem is that sched_setaffinity makes use of a
rwlock, but rwlocks are pre-emptible with the RT patch.
So it could happen that an high priority process/thread that makes use
of the sched_setaffinity facility could be unwillingly preempted when
controlling other (even low-priority) processes/threads.
I think sched_setaffinity should make use of raw_spinlocks, or should
anyway be guaranteed to not be pre-empted (maybe a preempt_disable?),
otherwise could lead in unwanted situations for a Real Time OS, such
the one described below.

The issue can be easily reproduced taking inspiration from this scenario:

I have 4 Real Time Threads (SCHED_FIFO) distributed as follows:

T0 : CPU 0, Priority 2 (HIGH)
T1 : CPU 1, Priority 2 (HIGH)
T3 : CPU 0, Priority 1 (LOW)
T4 : CPU 1, Priority 1 (LOW)

So T0 and T1 are actually the "big bosses" on CPUs #0 and #1, T3 and
T4, instead, never execute (let's assume that each thread is a simple
busy wait that never sleeps/yields) Now, at a certain point, from T0
code, I want to migrate T4 from CPU #1 to #0, keeping its low
priority.
Therefore I perform a pthread_setaffinity_np from T0 changing T4 mask
from CPU #1 to #0.

In this scenario it happens that T3 (that should never execute since
there is T0 with higher priority currently running on the same CPU #0)
"emerge" and executes for a bit.
It seems that the pthread_setaffinity_np syscall is somehow
"suspensive" for the time needed to migrate T4 and let the scheduler
to execute T3 for that bunch of time.

What do you think about this situation? Should sched APIs be revised?

Thanks in advance,
Primiano

--
 Primiano Tucci
 http://www.primianotucci.com
