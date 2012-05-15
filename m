Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966371Ab2EOSlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:41:18 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58960 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab2EOSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:40:53 -0400
Message-ID: <4FB2A2F3.40101@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 00:09:47 +0530
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tobiasu@tmux.org
Subject: Re: Linux 3.4-rc7
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com> <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl> <4FB0197F.6010000@linux.vnet.ibm.com> <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl> <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl> <CA+55aFy1TGH07Ng-nbmWs2N8=kfFMCMosF1TsevLcHhCpWL-LQ@mail.gmail.com> <4FB2A090.6060404@linux.vnet.ibm.com>
In-Reply-To: <4FB2A090.6060404@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051518-5816-0000-0000-0000029F8612
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 11:59 PM, Srivatsa S. Bhat wrote:

> On 05/15/2012 10:54 PM, Linus Torvalds wrote:
> 
>> On Sun, May 13, 2012 at 5:42 PM, John David Anglin <dave.anglin@bell.net> wrote:
>>>
>>> I successfully booted 3.4-rc7 with this change on rp3440 (4 cpu smp).  My
>>> build also
>>> included cache and other fixes that are being discussed on the parisc list.
>>
>> Can somebody send the final patches with proper subject lines etc,
>> instead of hiding them in unrelated threads? I hate picking up patches
>> that I don't personally know from the middle of some random thread.
>>
> 
> 
> Okay, here they are:
> 


This one is for mn10300:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] mn10300/CPU hotplug: Add missing call to notify_cpu_starting()

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/mn10300/kernel/smp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 910dddf..9cd69ad 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
@@ -38,7 +39,6 @@
 #include "internal.h"
 
 #ifdef CONFIG_HOTPLUG_CPU
-#include <linux/cpu.h>
 #include <asm/cacheflush.h>
 
 static unsigned long sleep_mode[NR_CPUS];
@@ -874,10 +874,13 @@ static void __init smp_online(void)
 
 	cpu = smp_processor_id();
 
-	local_irq_enable();
+	notify_cpu_starting(cpu);
 
+	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	smp_wmb();
+	ipi_call_unlock();
+
+	local_irq_enable();
 }
 
 /**


