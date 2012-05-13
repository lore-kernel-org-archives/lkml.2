Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2EMUis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:38:48 -0400
Received: from tin.tmux.org ([64.85.165.147]:26392 "EHLO tin.tmux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2EMUir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:38:47 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2012 16:38:47 EDT
Date: Sun, 13 May 2012 22:30:49 +0200
From: Tobias Ulmer <tobiasu@tmux.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc7
Message-ID: <20120513203049.GA10797@tin.tmux.org>
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
 <4FB011E7.1000604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB011E7.1000604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 01:26:23AM +0530, Srivatsa S. Bhat wrote:
> On 05/13/2012 07:34 AM, Linus Torvalds wrote:
> 
> > This is almost certainly the last -rc in this series - things really
> > have calmed down, and I even considered just cutting 3.4 this weekend,
> > but felt that another week wouldn't hurt.
> [...] 
> > So go forth and test. And don't send me any pull requests unless they
> > contain *only* regressions or fixes for really nasty bugs.
> 
> 
> Oh, I just noticed that 2 important fixes which fix boot failures on
> PA-RISC and mn10300 architectures haven't made it to mainline yet.
> 
> The regression was introduced in the 3.4 merge window itself (by commit
> 5fbd036b55 "sched: Cleanup cpu_active madness").
> 
> Links to the original posting:
> PA_RISC: http://marc.info/?l=linux-parisc&m=133241790810604&w=2
> mn10300: http://marc.info/?l=linux-parisc&m=133241580509804&w=2
> 
> Mikulas confirmed that this fixes the boot failure on PA-RISC:
> https://lkml.org/lkml/2012/5/8/97

Yes, indeed my c8000 boots again :-) Only had to add cpu.h for
notify_cpu_starting() to make it complile:

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Tobias Ulmer <tobiasu@tmux.org>
---
 arch/parisc/kernel/smp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 0bb1d63..4dc7b79 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
 
 #include <linux/atomic.h>
 #include <asm/current.h>
@@ -295,8 +296,13 @@ smp_cpu_init(int cpunum)
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
 		machine_halt();
-	}  
+	}
+
+	notify_cpu_starting(cpunum);
+
+	ipi_call_lock();
 	set_cpu_online(cpunum, true);
+	ipi_call_unlock();
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);
-- 
1.7.3.4


Thanks,
Tobias

> 
> Regards,
> Srivatsa S. Bhat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
