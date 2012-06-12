Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2FLRJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:09:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60225 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2FLRJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120612170725.GE5046@erda.amd.com>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
	<CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	<1339065932.23343.18.camel@twins>
	<CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	<1339067757.23343.21.camel@twins>
	<20120608093513.GA22520@gmail.com>
	<1339149613.23343.52.camel@twins>
	<1339161972.2507.13.camel@laptop>
	<20120612170725.GE5046@erda.amd.com>
Date: Tue, 12 Jun 2012 19:09:19 +0200
Message-ID: <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 7:07 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 08.06.12 15:26:12, Peter Zijlstra wrote:
>> +static const u32 snb_ucode_rev = 0x28;
>> +
>> +static void intel_snb_verify_ucode(void)
>> +{
>> +     u32 rev = UINT_MAX;
>> +     int pebs_broken = 0;
>> +     int cpu;
>> +
>> +     get_online_cpus();
>> +     /*
>> +      * Because the microcode loader is bloody stupid and allows different
>> +      * revisions per cpu and does strictly per-cpu loading, we now have to
>> +      * check all cpus to determine the minimally installed revision.
>> +      *
>> +      * This makes updating the microcode O(n^2) in the number of CPUs :/
>> +      */
>> +     for_each_online_cpu(cpu)
>> +             rev = min(cpu_data(cpu).microcode, rev);
>> +     put_online_cpus();
>> +
>> +     pebs_broken = (rev < snb_ucode_rev);
>> +
>> +     if (pebs_broken == x86_pmu.pebs_broken)
>> +             return;
>> +
>> +     /*
>> +      * Serialized by the microcode lock..
>> +      */
>> +     if (x86_pmu.pebs_broken) {
>> +             pr_info("PEBS enabled due to micro-code update\n");
>> +             x86_pmu.pebs_broken = 0;
>> +     } else {
>> +             pr_info("PEBS disabled due to CPU errata, "
>> +                     "please upgrade micro-code to at least %x (current: %x)\n",
>> +                     snb_ucode_rev, rev);
>> +             x86_pmu.pebs_broken = 1;
>> +     }
>> +}
>> +
>> +static int intel_snb_ucode_notifier(struct notifier_block *self,
>> +                                unsigned long action, void *_uci)
>> +{
>> +     /*
>> +      * Since ucode cannot be down-graded, and no future ucode revision
>> +      * is known to break PEBS again, we're ok with MICROCODE_CAN_UPDATE.
>> +      */
>> +
>> +     if (action == MICROCODE_UPDATED)
>> +             intel_snb_verify_ucode();
>> +
>> +     return NOTIFY_DONE;
>> +}
>> +
>>  static __init void intel_sandybridge_quirk(void)
>>  {
>> -     pr_warn("PEBS disabled due to CPU errata\n");
>> -     x86_pmu.pebs = 0;
>> -     x86_pmu.pebs_constraints = NULL;
>> +     intel_snb_verify_ucode();
>> +     /*
>> +      * we're still single threaded, so while there's a hole here,
>> +      * you can't trigger it.
>> +      */
>> +     microcode_notifier(intel_snb_ucode_notifier);
>>  }
>
> Instead of registering a microcode notifier, why not checking the
> availability of pebs dynamically with each syscall in
> intel_pmu_hw_config()? It looks like intel_snb_verify_ucode() is not
> that much expensive. We can perform the check only if the event could
> be for pebs and if pebs is broken. The check could be repeated when
> setting up a new event after ucode could potentially has been updated
> (e.g. after bringing a cpu online or so).
>
That's what I had in my original version.

> -Robert
>
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
