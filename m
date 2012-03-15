Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108Ab2COW60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:58:26 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:54857 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2COW6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:58:25 -0400
Message-ID: <4F627401.1010907@numascale.com>
Date: Thu, 15 Mar 2012 23:58:09 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>  <1331834583-16070-1-git-send-email-sp@numascale.com>  <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com> <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com> <4F626E6C.5010809@numascale.com>
In-Reply-To: <4F626E6C.5010809@numascale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/12 23:34 , Steffen Persvold wrote:
> On 3/15/12 22:21 , Suresh Siddha wrote:
>> On Thu, 2012-03-15 at 13:23 -0700, Yinghai Lu wrote:
>>> On Thu, Mar 15, 2012 at 11:03 AM, Steffen Persvold<sp@numascale.com>
>>> wrote:
>>>> Use x2apic_supported() in the default_apic_id_valid() function. If
>>>> x2apic mode is disabled (via nox2apic for example),
>>>> x2apic_supported() will return false.
>>>>
>>>> This allows us to substitute the check in
>>>> arch/x86/kernel/acpi/boot.c::acpi_parse_x2apic and avoid feigning
>>>> the x2apic cpu feature in the NumaChip apic code.
>>>>
>>>> Signed-off-by: Steffen Persvold<sp@numascale.com>
>>>> Reviewed-by: Daniel J Blueman<daniel@numascale-asia.com>
>>>
>>> I double checked on system with x2apic preenabled,
>>> nox2apic in boot command line still works well and it
>>> skips starting APs with apic id> 255.
>>>
>>> Acked-by: Yinghai Lu<yinghai@kernel.org>
>>
>
> Suresh,
>
>> This breaks the smpboot check if enabling interrupt-remapping/x2apic
>> fails on a platform. We will be in xapic mode and we don't clear the
>> x2apic cpufeature bit in this case and as such smpboot check will fail.
>>
>> So this change breaks the commit
>> c284b42abadbb22083bfde24d308899c08d44ffa.
>>
>
> I was afraid of that.
>
>> I think the right thing is to have two different apid_id_valid checks
>> one for xapic driver (apic_flat_64.c) and another for x2apic driver
>> (x2apic_phys/cluster.c) and that way, x2apic MADT entries will be parsed
>> only if bios has handed over the OS in x2apic mode or if we have
>> selected the numachip model.
>>
>
> Is my understanding of your suggestion correct that in
> x2apic_phys/cluster.c we add the following apic_id_valid() function :
>
> static int x2apic_apic_id_valid(int apicid)
> {
> return x2apic_mode || (apicid < 255);
> }
>
> ?
>
> Considering that this function (apic->apic_id_valid()) is called already
> in the acpi/boot.c::acpi_parse_x2apic() function is it sufficient enough
> to test for x2apic_mode ? Yinghai indicated that x2apic_mode was not set
> at this point, thus it was testing cpu_has_x2apic instead ?
>
> I must admit that I am not familiar enough with the APIC/ACPI code base
> to determine the sequence of events here (i.e MADT parsing, enabling of
> x2apic mode etc. etc.).

After reading the code a bit more it seems that the sequence is as follows :

kernel/setup.c::setup_arch() calls check_x2apic(). check_x2apic() first 
checks the cpu feature flag, then checks the MSR_IA32_APICBASE msr to 
see if bios has enabled x2apic mode. If this is the case, 
x2apic_preenabled and x2apic_mode is set to 1.

Later on in setup_arch(), the ACPI parsing starts.

My assumption is that the approach suggested in my previous email (based 
on Suresh' comment) with separate apic_id_valid() functions would be 
sufficient even for the MADT parsing ?

Kind regards,
Steffen
