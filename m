Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2HTNHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:07:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59278 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2HTNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:07:41 -0400
Date: Mon, 20 Aug 2012 15:07:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation v3
Message-ID: <20120820130731.GC16073@somewhere.redhat.com>
References: <1345214278-6245-1-git-send-email-fweisbec@gmail.com>
 <20120820084012.GA7237@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120820084012.GA7237@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:40:12AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > In this v3:
> > 
> > - Rebase against latest tip:sched/core
> > - Added acks from Martin
> > - Refined help text for the consolidated CONFIG_VIRT_CPU_ACCOUNTING option
> > in the 1st patch.
> > 
> > You can pull from:
> > 
> > git://github.com/fweisbec/linux-dynticks.git
> > 	virt-cputime-v3
> > 
> > Thanks.
> > 
> > Frederic Weisbecker (4):
> >   cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
> >   sched: Move cputime code to its own file
> >   cputime: Consolidate vtime handling on context switch
> >   s390: Remove leftover account_tick_vtime() header
> > 
> >  arch/Kconfig                           |    3 +
> >  arch/ia64/Kconfig                      |   12 +-
> >  arch/ia64/include/asm/switch_to.h      |    8 -
> >  arch/ia64/kernel/time.c                |    4 +-
> >  arch/powerpc/include/asm/time.h        |    6 -
> >  arch/powerpc/kernel/process.c          |    3 -
> >  arch/powerpc/kernel/time.c             |    6 +
> >  arch/powerpc/platforms/Kconfig.cputype |   16 +-
> >  arch/s390/Kconfig                      |    5 +-
> >  arch/s390/include/asm/switch_to.h      |    4 -
> >  arch/s390/kernel/vtime.c               |    4 +-
> >  include/linux/kernel_stat.h            |    6 +
> >  init/Kconfig                           |   13 +
> >  kernel/sched/Makefile                  |    2 +-
> >  kernel/sched/core.c                    |  558 +-------------------------------
> >  kernel/sched/cputime.c                 |  503 ++++++++++++++++++++++++++++
> >  kernel/sched/sched.h                   |   63 ++++
> >  17 files changed, 606 insertions(+), 610 deletions(-)
> >  create mode 100644 kernel/sched/cputime.c
> 
> Hm, I'm getting build failures on x86:
> 
> kernel/sched/cputime.c:60:2: error: implicit declaration of 
> function ‘irq_time_write_begin’ 
> [-Werror=implicit-function-declaration]
> kernel/sched/cputime.c:72:2: error: implicit declaration of 
> function ‘irq_time_write_end’ 
> [-Werror=implicit-function-declaration]
> kernel/sched/cputime.c:274:2: error: implicit declaration of 
> function ‘static_key_false’ 
> [-Werror=implicit-function-declaration]
> 
> Config attached.
> 
> Thanks,
> 
> 	Ingo

Oops, sorry. Some misplaced #endif and a missing header inclusion.
So I just fixed that in the branch:

git://github.com/fweisbec/linux-dynticks.git
     virt-cputime-v4

The diff against the previous set is:

$ git diff virt-cputime-v3..virt-cputime-v4

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ea9b4b6..372692b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/tsacct_kern.h>
 #include <linux/kernel_stat.h>
+#include <linux/static_key.h>
 #include "sched.h"
 
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 62f9850..804c2e5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1169,6 +1169,7 @@ enum rq_nohz_flag_bits {
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
+#endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
@@ -1219,4 +1220,3 @@ static inline u64 irq_time_read(int cpu)
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
-#endif

