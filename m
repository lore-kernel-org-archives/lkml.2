Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab2FHPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:09:27 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39549 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758796Ab2FHPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:09:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(z1823lz98dI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5B0RH-01-5X6-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 17:09:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608150938.GI31359@aftab.osrc.amd.com>
References: <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
 <20120608135117.GB31359@aftab.osrc.amd.com>
 <1339163669.2507.16.camel@laptop>
 <20120608141543.GD31359@aftab.osrc.amd.com>
 <1339165250.2507.27.camel@laptop>
 <20120608143636.GG31359@aftab.osrc.amd.com>
 <1339166718.2507.37.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339166718.2507.37.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:45:18PM +0200, Peter Zijlstra wrote:
> I was thinking about reload_store(), that seems to only reload ucode for
> a single cpu.

Ok.

> > > The 'bestestet' idea I came up with is doing the verify thing I have
> > > from a delayed work -- say 1 second into the future. That way, when
> > > there's lots of cpus they all try and enqueue the one work, which at
> > > the end executes only once, provided the entire update scan took less
> > > than the second.
> > 
> > You're saying, you want the last CPU that gets to update its microcode
> > gets to also run the delayed work...? Probably, I'd assume ucode update
> > on a single CPU takes less than a second IIUC.
> 
> Nah.. it'll probably be the first. But it doesn't matter which cpu does
> it. So the idea was:
> 
> static void intel_snb_verify_work(struct work_struct *work)
> {
> 	/* do the verify thing.. */
> }
> 
> static DECLARE_DELAYED_WORK(intel_snb_delayed_work, intel_snb_verify_ucode);
> 
> static int intel_snb_ucode_notifier(struct notifier_block *self,
>                                    unsigned long action, void *_uci)
> {
>         /*
>          * Since ucode cannot be down-graded, and no future ucode revision
>          * is known to break PEBS again, we're ok with MICROCODE_CAN_UPDATE.
>          */
> 
>         if (action == MICROCODE_UPDATED)
> 		schedule_delayed_work(&intel_snb_delayed_work, HZ);
> 
>         return NOTIFY_DONE;
> }
> 
> Thus it will queue the delayed work when the work isn't already queued
> for execution. Resulting in the work only happening once a second (at
> most).

Ok, this would probably work - the last cpu that schedules the work should
definitely see ucode version updated on all cpus.

Or, instead of doing the verify thing on each cpu, you could track which
is the last cpu to run the delayed work and do the verify thing only on
it (the other works simply remove a bit from a bitmask or whatever...).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

