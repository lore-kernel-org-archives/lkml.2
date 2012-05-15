Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228Ab2EOSa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:30:28 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49358 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab2EOSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:30:23 -0400
Message-ID: <4FB2A090.6060404@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 23:59:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: John David Anglin <dave.anglin@bell.net>,
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
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com> <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl> <4FB0197F.6010000@linux.vnet.ibm.com> <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl> <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl> <CA+55aFy1TGH07Ng-nbmWs2N8=kfFMCMosF1TsevLcHhCpWL-LQ@mail.gmail.com>
In-Reply-To: <CA+55aFy1TGH07Ng-nbmWs2N8=kfFMCMosF1TsevLcHhCpWL-LQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051518-3864-0000-0000-000002CD693B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 10:54 PM, Linus Torvalds wrote:

> On Sun, May 13, 2012 at 5:42 PM, John David Anglin <dave.anglin@bell.net> wrote:
>>
>> I successfully booted 3.4-rc7 with this change on rp3440 (4 cpu smp).  My
>> build also
>> included cache and other fixes that are being discussed on the parisc list.
> 
> Can somebody send the final patches with proper subject lines etc,
> instead of hiding them in unrelated threads? I hate picking up patches
> that I don't personally know from the middle of some random thread.
> 


Okay, here they are:

This is for PA-RISC:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] parisc/CPU hotplug: Add missing call to notify_cpu_starting()

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-and-Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-and-Tested-by: Tobias Ulmer <tobiasu@tmux.org>
Tested-by: John David Anglin <dave.anglin@bell.net>
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


