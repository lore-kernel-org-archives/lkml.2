Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0IJP73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:59:29 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27062 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0IJP70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:59:26 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8JGAY-02-LP7-02
X-M-MSG: 
Date: Fri, 10 Sep 2010 17:56:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100910155659.GD13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100910144634.GA1060@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.10 10:46:34, Ingo Molnar wrote:
> > > I'll look at getting a trace of the thing, but if any of you has a
> > > bright idea...

I found another patch in my queue, which fixes a duplicate call of the
nmi handler. Since I could not yet reproduce the bug, I am not sure if
this fixes the problem, but it is worth a try.

-Robert

--

>From 037678d4231778c55ed1a19b53d24c7056ae8bbd Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 6 Aug 2010 20:45:51 +0200
Subject: [PATCH] x86: fix duplicate calls of the nmi handler

The commit:

 e40b172 x86: Move notify_die from nmi.c to traps.c

moved the nmi handler call to default_do_nmi(). DIE_NMI_IPI and
DIE_NMI are called subsequently now. If the return code is
!NOTIFY_STOP, then the handlers are called twice. This patch fixes
this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic/hw_nmi.c    |    1 -
 arch/x86/kernel/cpu/perf_event.c |    1 -
 arch/x86/oprofile/nmi_int.c      |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..61a3ad7 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -52,7 +52,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	int cpu = smp_processor_id();
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3efdf28..87dc9e2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1219,7 +1219,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		break;
 	case DIE_NMIUNKNOWN:
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cfe4faa..e0132bf 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -64,7 +64,6 @@ static int profile_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI:
 	case DIE_NMI_IPI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
-- 
1.7.1.1



> > 
> > What are you running to create the problem?  I can try and duplicate 
> > it here.
> 
> It happens easily here - just running something like:
> 
>    perf record -g ./hackbench 10
> 
> a couple of times triggers it. Note, unlike with the earlier bug, the 
> NMIs are not permanently 'stuck' - and everything continues working. 
> Obviously the messages are nasty looking so this is a regression we need 
> to fix.
> 
> Thanks,
> 
> 	Ingo
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

