Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2FLRHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:07:46 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39343
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab2FLRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:07:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z1823lz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5IKWF-02-EM6-02
X-M-MSG: 
Date: Tue, 12 Jun 2012 19:07:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <andi@firstfloor.org>, <mingo@elte.hu>,
        <ming.m.lin@intel.com>, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612170725.GE5046@erda.amd.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339161972.2507.13.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.06.12 15:26:12, Peter Zijlstra wrote:
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
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static __init void intel_sandybridge_quirk(void)
>  {
> -	pr_warn("PEBS disabled due to CPU errata\n");
> -	x86_pmu.pebs = 0;
> -	x86_pmu.pebs_constraints = NULL;
> +	intel_snb_verify_ucode();
> +	/*
> +	 * we're still single threaded, so while there's a hole here,
> +	 * you can't trigger it.
> +	 */
> +	microcode_notifier(intel_snb_ucode_notifier);
>  }

Instead of registering a microcode notifier, why not checking the
availability of pebs dynamically with each syscall in
intel_pmu_hw_config()? It looks like intel_snb_verify_ucode() is not
that much expensive. We can perform the check only if the event could
be for pebs and if pebs is broken. The check could be repeated when
setting up a new event after ucode could potentially has been updated
(e.g. after bringing a cpu online or so).

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

