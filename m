Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1DFLAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:00:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab1DFLAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:45 -0400
Subject: Re: [PATCH 00/21] sched: Reduce runqueue lock contention -v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110405152338.692966333@chello.nl>
References: <20110405152338.692966333@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 13:00:10 +0200
Message-ID: <1302087610.2225.1379.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 17:23 +0200, Peter Zijlstra wrote:
> This patch series aims to optimize remote wakeups by moving most of the
> work of the wakeup to the remote cpu and avoid bouncing runqueue data
> structures where possible.
> 
> As measured by sembench (which basically creates a wakeup storm) on my
> dual-socket westmere:
> 
> $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance > $i; done
> $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
> $ ./sembench -t 2048 -w 1900 -o 0
> 
> unpatched: run time 30 seconds 647278 worker burns per second
> patched:   run time 30 seconds 816715 worker burns per second
> 
> I've queued this series for .40.

Full diffstat per request

---
 arch/alpha/kernel/smp.c             |    3 +-
 arch/arm/kernel/smp.c               |    5 +-
 arch/blackfin/mach-common/smp.c     |    3 +
 arch/cris/arch-v32/kernel/smp.c     |   13 +-
 arch/ia64/kernel/irq_ia64.c         |    2 +
 arch/ia64/xen/irq_xen.c             |   10 +-
 arch/m32r/kernel/smp.c              |    4 +-
 arch/mips/cavium-octeon/smp.c       |    2 +
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mti-malta/malta-int.c     |    2 +
 arch/mips/pmc-sierra/yosemite/smp.c |    4 +
 arch/mips/sgi-ip27/ip27-irq.c       |    2 +
 arch/mips/sibyte/bcm1480/smp.c      |    7 +-
 arch/mips/sibyte/sb1250/smp.c       |    7 +-
 arch/mn10300/kernel/smp.c           |    5 +-
 arch/parisc/kernel/smp.c            |    5 +-
 arch/powerpc/kernel/smp.c           |    4 +-
 arch/s390/kernel/smp.c              |    6 +-
 arch/sh/kernel/smp.c                |    2 +
 arch/sparc/kernel/smp_32.c          |    4 +-
 arch/sparc/kernel/smp_64.c          |    1 +
 arch/tile/kernel/smp.c              |    6 +-
 arch/um/kernel/smp.c                |    2 +-
 arch/x86/kernel/smp.c               |    5 +-
 arch/x86/xen/smp.c                  |    5 +-
 include/linux/mutex.h               |    2 +-
 include/linux/sched.h               |   23 +-
 init/Kconfig                        |    5 +
 kernel/mutex-debug.c                |    2 +-
 kernel/mutex-debug.h                |    2 +-
 kernel/mutex.c                      |    2 +-
 kernel/mutex.h                      |    2 +-
 kernel/sched.c                      |  622 +++++++++++++++++++----------------
 kernel/sched_debug.c                |    2 +-
 kernel/sched_fair.c                 |   23 ++-
 kernel/sched_features.h             |    6 +
 kernel/sched_idletask.c             |    2 +-
 kernel/sched_rt.c                   |   54 ++--
 kernel/sched_stoptask.c             |    5 +-
 39 files changed, 483 insertions(+), 380 deletions(-)

