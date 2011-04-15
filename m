Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1DORGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:06:08 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43851 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab1DORGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:06:06 -0400
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Prarit Bhargava <prarit@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Russ Anderson <rja@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 15 Apr 2011 17:05:39 +0000
Subject: RE: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Thread-Topic: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Thread-Index: Acv7Sb5+wp4M42bST86xiVWye1EbcgARSqew
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
In-Reply-To: <1302857141-17580-1-git-send-email-bp@amd64.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: linux-edac-owner@vger.kernel.org [mailto:linux-edac-
>owner@vger.kernel.org] On Behalf Of Borislav Petkov
>Sent: Friday, April 15, 2011 3:46 AM
>To: H. Peter Anvin; Ingo Molnar; Thomas Gleixner
>Cc: Prarit Bhargava; Tony Luck; Russ Anderson; LKML; EDAC devel;
>Borislav Petkov
>Subject: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
>errors
>
>From: Borislav Petkov <borislav.petkov@amd.com>
>
>Correctable errors are considered something rather normal on modern
>hardware these days. Even more importantly, correctable errors mean
>exactly that - they've been corrected by the hardware - and there's no
>need to taint the kernel since execution hasn't been compromised so far.
>

Would it be okay to extend this reasoning and also remove the tainting 
caused by TM1/TM2 thermal events:

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c
b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..9f3b5ae 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -188,7 +188,6 @@ static int therm_throt_process(bool new_event, int event,
int level)
                                level == CORE_LEVEL ? "Core" : "Package",
                                state->count);

-               add_taint(TAINT_MACHINE_CHECK);
                return 1;
        }
        if (old_event) {
@@ -393,7 +392,6 @@ static void unexpected_thermal_interrupt(void)
{
        printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
                        smp_processor_id());
-       add_taint(TAINT_MACHINE_CHECK);
}

static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;


- naga -


>Suggested-by: Tony Luck <tony.luck@intel.com>
>Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>---
> arch/x86/kernel/cpu/mcheck/mce.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
>b/arch/x86/kernel/cpu/mcheck/mce.c
>index 3385ea2..68e2303 100644
>--- a/arch/x86/kernel/cpu/mcheck/mce.c
>+++ b/arch/x86/kernel/cpu/mcheck/mce.c
>@@ -590,7 +590,6 @@ void machine_check_poll(enum mcp_flags flags,
>mce_banks_t *b)
> 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
> 			mce_log(&m);
> 			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0,
>&m);
>-			add_taint(TAINT_MACHINE_CHECK);
> 		}
>
> 		/*
>--
>1.7.4.rc2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-edac" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
