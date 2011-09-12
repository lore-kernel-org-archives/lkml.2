Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1ILROs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 13:14:48 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9368 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1ILROp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 13:14:45 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 13:14:45 EDT
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "davej@codemonkey.org.uk" <davej@codemonkey.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Mon, 12 Sep 2011 18:05:26 +0100
Subject: RE: [PATCH] cpufreq: pcc-cpufreq: sanity check to prevent a NULL
 pointer dereference
Thread-Topic: [PATCH] cpufreq: pcc-cpufreq: sanity check to prevent a NULL
 pointer dereference
Thread-Index: AcxugnYdNVqxj4gcSueNXsLSZShfHgC6xWZg
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE1635519C88F@GVW0676EXC.americas.hpqcorp.net>
References: <20110831200910.27633.20372.sendpatchset@nchumbalkar.americas.cpqcorp.net>
 <20110908165257.7b613baf.akpm@linux-foundation.org>
In-Reply-To: <20110908165257.7b613baf.akpm@linux-foundation.org>
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
>From: Andrew Morton [mailto:akpm@linux-foundation.org]
>Sent: Thursday, September 08, 2011 6:53 PM
>To: Chumbalkar, Nagananda
>Cc: davej@codemonkey.org.uk; linux-kernel@vger.kernel.org;
>cpufreq@vger.kernel.org; stable@kernel.org
>Subject: Re: [PATCH] cpufreq: pcc-cpufreq: sanity check to prevent a
>NULL pointer dereference
>
>On Wed, 31 Aug 2011 20:08:45 +0000 (UTC)
>Naga Chumbalkar <nagananda.chumbalkar@hp.com> wrote:
>
>> If, for whatever reason, "pr" ends up being NULL we would end up in a
>PANIC
>> as seen below:
>>
>> Loading CPUFreq modules[  437.661360] BUG: unable to handle kernel
>NULL pointer
>> dereference at (null)
>> IP: [<ffffffffa0434314>] pcc_cpufreq_cpu_init+0x74/0x220 [pcc_cpufreq]
>>
>> It's better to prevent the PANIC by failing the driver, and allowing
>the system to boot.
>>
>> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
>> Cc: stable@kernel.org
>>
>> diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-
>cpufreq.c
>> index 7b0603e..cdc02ac 100644
>> --- a/drivers/cpufreq/pcc-cpufreq.c
>> +++ b/drivers/cpufreq/pcc-cpufreq.c
>> @@ -261,6 +261,9 @@ static int pcc_get_offset(int cpu)
>>  	pr = per_cpu(processors, cpu);
>>  	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
>>
>> +	if (!pr)
>> +		return -ENODEV;
>> +
>>  	status = acpi_evaluate_object(pr->handle, "PCCP", NULL, &buffer);
>>  	if (ACPI_FAILURE(status))
>>  		return -ENODEV;
>
>hm, from reading drivers/acpi/processor_driver.c it appears that
>per_cpu(processors, n)==NULL is an expected and valid state.  Heaven
>knows what that state actually *means* - apparently this is a secret.
>
>I assume that you've hit this crash in real live code, hence your
>suggestion of a -stable backport?

Yes - the above oops can be reproduced on a shipping Linux distro when, 
for x2APIC implementations, the BIOS does not use the ACPI "Device" 
declaration for processors with Local APIC ID >= 255. Such a declaration 
is necessitated by Sec 8.4 of ACPI 4.0a.

- naga -


