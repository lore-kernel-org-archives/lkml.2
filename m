Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2EMU3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:29:33 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34656 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2EMU3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:29:31 -0400
Message-ID: <4FB0197F.6010000@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 01:58:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: John David Anglin <dave.anglin@bell.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com> <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
In-Reply-To: <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051310-1618-0000-0000-000001937D71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 01:38 AM, John David Anglin wrote:

> On 13-May-12, at 3:56 PM, Srivatsa S. Bhat wrote:
> 
>> The regression was introduced in the 3.4 merge window itself (by commit
>> 5fbd036b55 "sched: Cleanup cpu_active madness").
>>
>> Links to the original posting:
>> PA_RISC: http://marc.info/?l=linux-parisc&m=133241790810604&w=2
> 
> 
> If I had the above change, I get
> 
>   CHK     include/generated/compile.h
>   CC      arch/parisc/kernel/smp.o
> arch/parisc/kernel/smp.c: In function 'smp_cpu_init':
> arch/parisc/kernel/smp.c:300:2: error: implicit declaration of function
> 'notify_cpu_starting' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [arch/parisc/kernel/smp.o] Error 1
> 


Sorry about that. I neither have the hardware nor the toolchain
to test it. I guess this problem doesn't exist for mn10300 since it
already includes linux/cpu.h when CONFIG_HOTPLUG_CPU=y

Does the below updated patch help for PA-RISC?

----
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

parisc/CPU hotplug: Add missing call to notify_cpu_starting()

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
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

