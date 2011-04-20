Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1DTOhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:37:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57417 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1DTOhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gRe1k1lpkFyKF7MkWADxi3sMuH0UdmC9rvUdqSljbj5RgBEHjyF4MQ/eQEDD29ADMc
         FgkrQPSLMrUsAuvzCSSOw8NN9/hpTqBbFlmUdbAL6kbH1DElsqBmOm1Gb8uc0xt+nkrV
         vNYlcREdvW7+jhrdZEtT9a/Shwz20GIwsKnfQ=
Message-ID: <4DAEEF96.4070807@gmail.com>
Date: Wed, 20 Apr 2011 18:37:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, nmi: Move LVT un-masking into irq handlers
References: <1303145815-15050-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303145815-15050-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 08:56 PM, Don Zickus wrote:
> It was noticed that P4 machines were generating double NMIs for each
> perf event.  These extra NMIs lead to 'Dazed and confused' messages on
> the screen.
> 
> I tracked this down to a P4 quirk that said the overflow bit had to be
> cleared before re-enabling the apic LVT mask.  My first attempt was
> to move the un-masking inside the perf nmi handler from before the
> chipset NMI handler to after.
> 
> This broke Nehalem boxes that seem to like the unmasking before the
> counters themselves are re-enabled.
> 
> In order to keep this change simple for 2.6.39, I decided to just
> simply move the apic LVT un-masking to the beginning of all the
> chipset NMI handlers, with the exeption of Pentium4's to fix the
> double NMI issue.
> 
> Later on we can move the un-masking to later in the handlers to save
> a number of 'extra' NMIs on those particular chipsets.
> 
> I tested this change on a P4 machine, an AMD machine, a Nehalem box,
> and a core2quad box.  'perf top' worked correctly along with various
> other small 'perf record' runs.  Anything high stress breaks all the
> machines but that is a different problem.
> 
> Thanks to various people for testing different versions of this patch.
> 
> Reported-and-tested-by: Shaun Ruffell <sruffell@digium.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> CC: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |    5 +++--
>  arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
>  arch/x86/kernel/cpu/perf_event_p4.c    |   14 ++++++++++----
>  3 files changed, 16 insertions(+), 6 deletions(-)
> 

Looks good to me (in terms of P4 PMU). So as an urgent solution

Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

For more deeper tests I've a slightly modified version which I've tested on Nehalem
and P4 but more testing is a way appreciated if someone interested in.

Don, sorry for delay, I somehow missed this patch at first place :/ And probably
the patch below could help with "stess" problem?

Ingo, please fetch Don's patch (not mine which I propose for testing instead of Don's patch) since
I believe it's important issue. Any tune ups could be done on top.

--
perf, x86: P4 PMU -- Fix race condition with LVTPC masking v3

Because perf_event_nmi_handler was unmasking LVTPC at the very
beginning of NMI handler routine P4 PMU observed "Uhhuh. NMI
received for unknown reason".

The description of such effect is rather the following: PMI issued,
it delivers APIC, APIC get masked and notifies cpu with NMI vector,
NMI handler starts and unmask APIC again, opening a window for a new
PMI delivery (but in real it's same PMI just signalled twice). So in
general such situation pretty well managed by our NMI in-flight catcher
but sometime it was found that such signal is delayed and delivered
at moment when counter get active again so kernel can't figure out
who was an initiator of NMI.

Moving APIC unmasking after x86_pmu.handle_irq lead to another problem,
at least on Nehalem it was found that second PMI signal may arrive APIC
too early, mask it and never propagate up to cpu as nmi signal. As result
apic entry get masked and no new PMI signal accepted.

Finally the conclusion was to make APIC unmaksing as a part of PMU
specific path, every PMU driver has its own unmasking call.

https://bugzilla.kernel.org/show_bug.cgi?id=33252

Reported-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++++++++----
 arch/x86/kernel/cpu/perf_event_p4.c    |    9 +++++++--
 3 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1325,6 +1325,8 @@ static int x86_pmu_handle_irq(struct pt_
 	if (handled)
 		inc_irq_stat(apic_perf_irqs);

+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	return handled;
 }

@@ -1377,8 +1379,6 @@ perf_event_nmi_handler(struct notifier_b
 		return NOTIFY_DONE;
 	}

-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
@@ -936,10 +936,8 @@ static int intel_pmu_handle_irq(struct p
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
-	if (!status) {
-		intel_pmu_enable_all(0);
-		return handled;
-	}
+	if (!status)
+		goto done;

 	loops = 0;
 again:
@@ -988,6 +986,15 @@ again:
 		goto again;

 done:
+	/*
+	 * We have to unmask LVTPC *before* enabling counters,
+	 * the key moment is that LVTPC is getting masked on
+	 * PMI arrival and if PMU enabled before APIC unmasked
+	 * a new oveflow signal may reach it but not propagated
+	 * as NMI (due to transition timings) and LVTPC eventually
+	 * stick masked forever dropping any further PMI signals.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_pmu_enable_all(0);
 	return handled;
 }
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -950,8 +950,13 @@ static int p4_pmu_handle_irq(struct pt_r
 	}

 	if (handled) {
-		/* p4 quirk: unmask it again */
-		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+		/*
+		 * P4 quirk: it needs two writes otherwise
+		 * may stay masked (as LVTPC is gettting
+		 * masked on irq arrival).
+		 */
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 		inc_irq_stat(apic_perf_irqs);
 	}

