Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2FHNvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:51:09 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:45897
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2FHNvH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:51:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z1823lz98dIc89bh936eI1432Izz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M5AX4V-02-4R0-02
X-M-MSG: 
Date: Fri, 8 Jun 2012 15:51:17 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120608135117.GB31359@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <1339064319.23343.13.camel@twins>
 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
 <1339065932.23343.18.camel@twins>
 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
 <1339067757.23343.21.camel@twins>
 <20120608093513.GA22520@gmail.com>
 <1339149613.23343.52.camel@twins>
 <1339161972.2507.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1339161972.2507.13.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:26:12PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-08 at 12:00 +0200, Peter Zijlstra wrote:
> > > > Or we could put a hook in the ucode loader.
> > > 
> > > I'd really suggest the latter - I doubt this will be our only 
> > > ucode dependent quirk, going forward ...
> > 
> > Yeah, am in the middle of writing that.. 
> 
> OK so the micro-code stuff is a complete trainwreck.
> 
> The very worst is that it does per-cpu micro-code updates, not machine
> wide. This results in it being able to have different revisions on
> different cpus. This in turn makes the below O(n^2) :/

Reportedly, there are some obscure systems which need different
microcode versions per CPU:

http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/01010.html

> The biggest problem is finding when the minimum revision changes, at
> best this is a n log n sorting problem due to the per-cpu setup, but I
> couldn't be arsed to implement a tree or anything fancy since it all
> stinks anyway.

I know. Can't you just iterate over all CPUs and collect the lowest
ucode version? Provided, of course, newer microcode versions means a
higher version number.

> Why do we have per-cpu firmware anyway?

See above.

[ … ]

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 5ec146c..bde86cf 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -15,6 +15,7 @@
>  
>  #include <asm/hardirq.h>
>  #include <asm/apic.h>
> +#include <asm/microcode.h>
>  
>  #include "perf_event.h"
>  
> @@ -1714,11 +1715,67 @@ static __init void intel_clovertown_quirk(void)
>  	x86_pmu.pebs_constraints = NULL;
>  }
>  
> +static const u32 snb_ucode_rev = 0x28;
> +
> +static void intel_snb_verify_ucode(void)
> +{
> +	u32 rev = UINT_MAX;
> +	int pebs_broken = 0;
> +	int cpu;
> +
> +	get_online_cpus();
> +	/*
> +	 * Because the microcode loader is bloody stupid and allows different
> +	 * revisions per cpu and does strictly per-cpu loading, we now have to
> +	 * check all cpus to determine the minimally installed revision.
> +	 *
> +	 * This makes updating the microcode O(n^2) in the number of CPUs :/
> +	 */
> +	for_each_online_cpu(cpu)
> +		rev = min(cpu_data(cpu).microcode, rev);
> +	put_online_cpus();
> +
> +	pebs_broken = (rev < snb_ucode_rev);
> +
> +	if (pebs_broken == x86_pmu.pebs_broken)
> +		return;
> +
> +	/*
> +	 * Serialized by the microcode lock..
> +	 */
> +	if (x86_pmu.pebs_broken) {
> +		pr_info("PEBS enabled due to micro-code update\n");
> +		x86_pmu.pebs_broken = 0;
> +	} else {
> +		pr_info("PEBS disabled due to CPU errata, "
> +			"please upgrade micro-code to at least %x (current: %x)\n",
> +			snb_ucode_rev, rev);
> +		x86_pmu.pebs_broken = 1;
> +	}
> +}
> +
> +static int intel_snb_ucode_notifier(struct notifier_block *self,
> +				   unsigned long action, void *_uci)
> +{
> +	/*
> +	 * Since ucode cannot be down-graded, and no future ucode revision
> +	 * is known to break PEBS again, we're ok with MICROCODE_CAN_UPDATE.
> +	 */
> +
> +	if (action == MICROCODE_UPDATED)
> +		intel_snb_verify_ucode();

Actually, the deal here is that you could have received microcode
already from BIOS and you won't have to necessarily load ucode from
userspace with the Linux ucode loader.

Which means that on boxes which already come with PEBS-good microcode
version from the BIOS, you don't need the ucode notifier because you
most certainly are not loading newer ucode version from userspace - the
newest version is in the BIOS already.

In these cases, you already have PEBS fixed but since you're not loading
any ucode, you won't run intel_snb_verify_ucode().

So, you want to check for PEBS twice (and for all other features fixed
by ucode and tested for earlier than the ucode loader, for that matter):

* once when perf inits

* twice, a bit later when the ucode loader has loaded something from
userspace and the notifier corrects it.

Btw, this is why we wanted to load ucode as early as possible but
there's no progress on the whole thing right now...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

