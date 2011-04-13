Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab1DMUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:01:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42490 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab1DMUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qTaAZpT436hIdatdOCzCTtneNaMvpLhASQRwaOd9nC+lybG4SFLH2OHTBXr7VPefuj
         74Uxnnt1Kfp6xUpPaUB0zKfA8Iq3SEwcrM1gDj2HqoAWXPqpn9mchpzHfvSiJ49bs903
         tUtKyDzDvZwpgDqfjA1WJelyzAvKljeRXpj4E=
Message-ID: <4DA6011F.7070405@openvz.org>
Date: Thu, 14 Apr 2011 00:01:35 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: maciej.rutecki@gmail.com, Shaun Ruffell <sruffell@digium.com>,
        Don Zickus <dzickus@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper
 MSR register to catch" and NMIs
References: <20110406223036.GA15721@digium.com> <201104132133.51958.maciej.rutecki@gmail.com>
In-Reply-To: <201104132133.51958.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 11:33 PM, Maciej Rutecki wrote:
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=33252
> for your bug report, please add your address to the CC list in there, thanks!
> 

Here is a patch flying around which I tuned a bit, when all reporters confirm it
works for them we could close the bug. Thanks.

 Cyrill
-- 
From: Don Zickus <dzickus@redhat.com>
Subject: [PATCH] perf, x86: fix unknown NMIs on a Pentium4 box v2

When using perf on a Pentium4 box, lots of unknown NMIs would be generated.
This is the result of a P4 quirk that is subtle.  The P4 generates an NMI
when the counter overflow and unlike other arches where the NMI is a one time
event, the P4 continues to assert its NMI until clear by the OS.

As a side effect to this quirk, the NMI on the apic is masked off to prevent
a stream of NMIs until the overflow flag is cleared.  During the perf
re-design, this subtle-ness was overlooked and the apic was unmasked _before_
the overflow flag was cleared.  As a result, this generated an extra NMI on
the P4 mchines.

The fix is trivial, wait until the NMI is properly handled before un-masking
the apic.

Sadly, in the old nmi watchdog there was a note that explained this exact
behaviour.

v2: Unmask LVT entry iif IRQ being handled by perf subsystem and add a comment.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Don, Shaun, Ming, I've tested it on my non-HT machine, so if you have a chance
to test it on HT machine -- this would be a great thing!

Don, note the version v2 changes, thanks. I've tuned the former a bit
but left your From field untouched, are you OK with that?

 arch/x86/kernel/cpu/perf_event.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1370,12 +1370,19 @@ perf_event_nmi_handler(struct notifier_b
 		return NOTIFY_DONE;
 	}

-	apic_write(APIC_LVTPC, APIC_DM_NMI);

 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;

+	/*
+	 * Unmasking should be done after IRQ handled, otherwise
+	 * there is a race between clearing of counter overflow
+	 * flag and LTV entry unmasking (which might lead to double
+	 * NMIs generation).
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	this_nmi = percpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
