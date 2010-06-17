Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0FQB4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:56:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44507 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946Ab0FQBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:39 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
       "kerstin.jonsson" <kerstin.jonsson@ericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac\@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>, "mingo\@elte.hu" <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, "trenn\@suse.de" <trenn@suse.de>,
       Thomas Renninger <trenn@suse.de>
References: <4B96116A.6090705@ericsson.com>
	<1268131954-13845-1-git-send-email-trenn@suse.de>
	<m11vfhaz24.fsf@fess.ebiederm.org> <m1pr2z8pe9.fsf@fess.ebiederm.org>
	<4BA75473.8090400@ericsson.com> <m1fx3swno3.fsf@fess.ebiederm.org>
	<43F901BD926A4E43B106BF17856F0755E7C393B9@orsmsx508.amr.corp.intel.com>
	<4C196A2F.5010604@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 16 Jun 2010 18:51:25 -0700
In-Reply-To: <4C196A2F.5010604@zytor.com> (H. Peter Anvin's message of "Wed\, 16 Jun 2010 17\:19\:59 -0700")
Message-ID: <m17hlyo28y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, trenn@suse.de, avi@redhat.com, mingo@elte.hu, yinghai@kernel.org, jbohac@novell.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, kerstin.jonsson@ericsson.com, jacob.jun.pan@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec - V5
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/16/2010 02:11 PM, Pan, Jacob jun wrote:
>> 
>> W.R.T. the loop limits, is it possible to use a default max_loops value in
>> case when cpu_khz is not set? The reason is that on Moorestown platform
>> we need to do an early APIC setup before tsc_init(), so cpu_khz is 0 at the
>> time we setup local APIC. The result is that we hit WARN_ON(max_loops<= 0)
>> on Moorestown for early APIC setup.

So you get a nasty warning but the system still boots?

>> The early APIC setup is needed because Moorestown does not have a PIT and the
>> system timer interrupts are routed via IOAPIC.
>> 
>
> Can't MRST install a quick ballpark value into cpu_khz?

Looking at the code the initialization order in init/main.c is:

early_irq_init()
init_IRQ()
init_timers()
time_init()
    tsc_init()

local_irq_enable()

So arguably if we simply switched those lines around we could make
this work, as you must be initializing the tsc with interrupts
disabled.

That said given the current ordering it appears that using the tsc
in setup_local_APIC is just broken because if it is properly called
from init_IRQ() the code doesn't work properly.

The question is what do we consider more important the current code
initialization ordering, or virtual processors having such an expensive
apic_read that we need a 1 second timeout.

I think the virtual processor concern is silly.  Most of the time
this loop should execute exactly once after having confirmed there
is nothing to do.  On a bad day this loop should execute at most twice.
If the vitalization is too expensive that this loop cannot execute
twice, bailing out early is a correctness concern.

I think we should set max_loops to 5.  Leave the WARN_ON, and call it
good.

Does the following patch work cleanly on Moorestown?

Eric


>From fc298618e87233de748c7a289f41bcc68ed8fc64 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 16 Jun 2010 18:42:39 -0700
Subject: [PATCH] x86/apic:  Don't use the tsc in setup_local_APIC

If everything is initialized in the order of init/main.c we should have:
init_IRQ()
    setup_local_APIC()
time_init()
    tsc_init()
local_irq_enable()

Which means the only reason the current use of the tsc in setup_local_APIC
works is because we are calling setup_local_APIC late on most x86
platforms.

The justification given for using a 1 second timeout on this loop
is because virtualized platforms have a very expensive apic_read().

Typically this loop should execute exactly once after confirming there
is nothing to do.  On a bad day this loop should execute twice
after clearing the ISR and the IRR unacked irqs.  If it is too
expensive to execute this loop twice on a virtualized platform
that is not our problem.

Let's set max_loops to 5.  Which is more than enough and that
removes the need for messing with the tsc.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/apic/apic.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c02cc69..d1a2b19 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -51,7 +51,6 @@
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
-#include <asm/tsc.h>
 
 unsigned int num_processors;
 
@@ -1154,11 +1153,7 @@ void __cpuinit setup_local_APIC(void)
 {
 	unsigned int value, queued;
 	int i, j, acked = 0;
-	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
-
-	if (cpu_has_tsc)
-		rdtscll(tsc);
+	int max_loops = 5;
 
 	if (disable_apic) {
 		arch_disable_smp_support();
@@ -1229,11 +1224,7 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
-			rdtscll(ntsc);
-			max_loops = (cpu_khz << 10) - (ntsc - tsc);
-		} else
-			max_loops--;
+		max_loops--;
 	} while (queued && max_loops > 0);
 	WARN_ON(max_loops <= 0);
 
-- 
1.6.5.2.143.g8cc62

