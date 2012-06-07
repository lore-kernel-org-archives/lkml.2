Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab2FGKff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:35:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34577 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641Ab2FGKfd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <1339064319.23343.13.camel@twins>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
Date: Thu, 7 Jun 2012 12:35:31 +0200
Message-ID: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-06-07 at 09:15 +0200, Stephane Eranian wrote:
>> +static int check_pebs_quirks(void)
>> +{
>> +       int uversion = cpu_data(smp_processor_id()).microcode;
>> +       int model = cpu_data(smp_processor_id()).x86_model;
>> +
>> +       /* do not have PEBS to begin with */
>> +       if (!x86_pmu.pebs)
>> +               return 0;
>> +
>> +       /*
>> +        * check ucode version for SNB, SNB-EP
>> +        */
>> +       if ((model == 42 || model == 45) && uversion < 0x28) {
>> +               pr_warn("SandyBridge PEBS unavailable due to CPU erratum, "
>> +                       " update microcode (was 0x%x, needs at least 0x28).\n",
>> +                       uversion);
>> +               return -ENOTSUPP;
>> +       }
>> +       return 0;
>> +}
>> +
>>  static int intel_pmu_hw_config(struct perf_event *event)
>>  {
>>         int ret = x86_pmu_hw_config(event);
>> @@ -1401,8 +1422,14 @@ static int intel_pmu_hw_config(struct perf_event *event)
>>         if (ret)
>>                 return ret;
>>
>> -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
>> -               x86_pmu.pebs_aliases(event);
>> +       if (event->attr.precise_ip) {
>> +
>> +               if (check_pebs_quirks())
>> +                       return -ENOTSUPP;
>
> This will only warn about the PEBS issue once you try and use a PEBS
> counter. Shouldn't we do this on boot? IOW. put check_pebs_quirks()
> inside the existing quirk code instead of here?
>
The warning could also be done on boot. But the check has to be done
 when the event is created. The other thing is that as it is now, if you
get an error, you check dmesg and it's obvious what is wrong. With
the boot warning, you'd have to look back all the way to the early boot
messages. Whatever you prefer, I am fine.

>> +
>> +               if (x86_pmu.pebs_aliases)
>> +                       x86_pmu.pebs_aliases(event);
>> +       }
>>
>>         if (intel_pmu_needs_lbr_smpl(event)) {
>>                 ret = intel_pmu_setup_lbr_filter(event);
>> @@ -1714,13 +1741,6 @@ static __init void intel_clovertown_quirk(void)
>>         x86_pmu.pebs_constraints = NULL;
>>  }
