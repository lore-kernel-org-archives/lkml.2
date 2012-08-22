Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2HVNnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:43:11 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:42298
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2HVNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:43:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah1155h)
X-WSS-ID: 0M95SRL-02-4OF-02
X-M-MSG: 
Message-ID: <5034E11C.1010006@amd.com>
Date: Wed, 22 Aug 2012 15:39:40 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] cpufreq: Remove support for hardware P-state chips
 from powernow-k8
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <503234FA.908@amd.com> <201208202249.16445.rjw@sisk.pl> <201208220300.03512.trenn@suse.de>
In-Reply-To: <201208220300.03512.trenn@suse.de>
Content-Type: text/plain; charset="ISO-8859-2"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:00 AM, Thomas Renninger wrote:
> On Monday 20 August 2012 22:49:16 Rafael J. Wysocki wrote:
>> On Monday, August 20, 2012, Andre Przywara wrote:
>>> On 08/05/2012 11:33 PM, Rafael J. Wysocki wrote:
>>>> On Thursday, July 26, 2012, Andre Przywara wrote:
> ...
>>>
>>> If you insist, I can keep the code in powernow-k8, but it probably
>>> wouldn't receive any support anymore and would increase confusion on the
>>> user side.
>>
>> I'm not afraid of that.  And as I said, you can just add info messages to
>> powernow-k8 saying that the feature is deprecated and will be removed in the
>> future and _then_ you actually _can_ remove it in the future (say, 2-3 major
>> kernel releasew from now).
>
> Full code duplication in powernow-k8 and acpi-cpufreq does not make sense
> to me.
> You would need extra logic that only the first is successfully loaded etc.
> IMO this has more risk of introducing new bugs than any good.
> A message like that might be useful though:
> if (boot_cpu_has(X86_FEATURE_HW_PSTATE))
> {
>       printk("powernowk8 does not serve MSR based frequency switching anymore, use acpi-cpufreq instead\n");
>       return -1;
> }

Matthew had something even better, that is patch 3/8:
+               if (static_cpu_has(X86_FEATURE_HW_PSTATE))
+			request_module("acpi_cpufreq");

So if someone tries to load powernow-k8 on a recent CPU, it will 
automatically load acpi-cpufreq instead.
I just realized that this doesn't work as expected, because powernow-k8 
bails out early due to only family 0xf being in the matching CPUID 
family list. Will fix this.

I will do some tests now to check our options:
1. A combination of Matthew's and Thomas' ideas: if powernow-k8 is 
loaded on newer CPUs, request acpi-cpufreq to load _plus_ write a 
warning that powernow-k8 is obsolete for this hardware. Don't load 
powernow-k8 (which has support removed anyway). My favorite.

2. Add code (probably to the generic cpufreq framework) to avoid loading 
two drivers. Print a warning if tried anyways. Leave h/w P-state support 
in powernow-k8. It seems like that acpi-cpufreq takes precedence over 
powernow-k8 in distribution's module load list, so this should work as 
expected even with keeping the support in powernow-k8 (as a fallback in 
case of trouble).

Regards,
Andre.

> This would show people with init scripts that try to load cpufreq drivers
> manually that they are not needed anymore. acpi-cpufreq should have been
> loaded automatically already and cpufreq should be active.
>
>      Thomas
>



-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

