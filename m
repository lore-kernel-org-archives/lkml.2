Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab1DNOsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:48:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab1DNOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=j/HmYzkuI63tIwmAros39wktLMseKlZhY/dTjMc+y8ku/MEomyno06Z+UXV+M7AxDe
         i98CC7bxS4/DK50sPFTGbNXQHUcSynqxe2Q78E1j/6wUGNPTaGWl/zYSfa3wOE+VKkME
         u6wEEZcDQ+q7g92+MyVtU7pXSFFTmdDPZt+Vw=
Message-ID: <4DA70950.3060102@openvz.org>
Date: Thu, 14 Apr 2011 18:48:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>
Subject: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box

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

 Cyrill Gorcunov: Added a comment into code itself. We should consider
if we need to unmask LVTPC if no oveflow happened at all.

 Ingo Molnar: Pointed out that unmasking unconditionally is proven by time
to be correct.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Tested-by: Shaun Ruffell <sruffell@digium.com>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>
CC: Robert Richter <robert.richter@amd.com>
---

Ingo, please make sure I've added conform notes about conditional/uconditional
unmasking in changelog. Don, I've added a comment in code just to not forget why
we need it. Thanks.

 arch/x86/kernel/cpu/perf_event.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1370,9 +1370,16 @@ perf_event_nmi_handler(struct notifier_b
 		return NOTIFY_DONE;
 	}

-	apic_write(APIC_LVTPC, APIC_DM_NMI);

 	handled = x86_pmu.handle_irq(args->regs);
+
+	/*
+	 * Note the unmasking of LVTPC entry must be
+	 * done *after* counter oveflow flag is cleared
+	 * otherwise it might lead to double NMIs generation.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	if (!handled)
 		return NOTIFY_DONE;


-- 
    Cyrill
