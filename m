Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0HNQUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:20:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:10666 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757027Ab0HNQUK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:20:10 -0400
From: Alok Kataria <akataria@vmware.com>
To: Sven Joachim <svenjoac@gmx.de>
CC: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sat, 14 Aug 2010 09:21:08 -0700
Subject: Re: [01/54] x86, vmware: Preset lpj values when on VMware.
Thread-Topic: [01/54] x86, vmware: Preset lpj values when on VMware.
Thread-Index: Acs7zI+cjieHwsGQQQiO18HbvuxssA==
Message-ID: <70C34ED6-B722-4577-A124-A3E6CD0F4440@vmware.com>
References: <20100812000249.GA30948@kroah.com>
 <20100812000123.413199056@clark.site> <8739uho03t.fsf@turtle.gmx.de>
In-Reply-To: <8739uho03t.fsf@turtle.gmx.de>
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



On Aug 14, 2010, at 5:22 AM, "Sven Joachim" <svenjoac@gmx.de> wrote:

> On 2010-08-12 02:00 +0200, Greg KH wrote:
> 
>> 2.6.34-stable review patch.  If anyone has any objections, please let us know.
> 
> Sorry for being a bit late -- I didn't get around to build 2.6.34.4-rc1
> in time. :-(
> 
>> From: Alok Kataria <akataria@vmware.com>
>> 
>> commit 9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d upstream.
>> 
>> When running on VMware's platform, we have seen situations where
>> the AP's try to calibrate the lpj values and fail to get good calibration
>> runs becasue of timing issues. As a result delays don't work correctly
>> on all cpus.
>> 
>> The solutions is to set preset_lpj value based on the current tsc frequency
>> value. This is similar to what KVM does as well.
>> 
>> Signed-off-by: Alok N Kataria <akataria@vmware.com>
>> LKML-Reference: <1280790637.14933.29.camel@ank32.eng.vmware.com>
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>> 
>> ---
>> arch/x86/kernel/cpu/vmware.c |    9 ++++++++-
>> 1 file changed, 8 insertions(+), 1 deletion(-)
>> 
>> --- a/arch/x86/kernel/cpu/vmware.c
>> +++ b/arch/x86/kernel/cpu/vmware.c
>> @@ -51,7 +51,7 @@ static inline int __vmware_platform(void
>> 
>> static unsigned long vmware_get_tsc_khz(void)
>> {
>> -    uint64_t tsc_hz;
>> +    uint64_t tsc_hz, lpj;
>>    uint32_t eax, ebx, ecx, edx;
>> 
>>    VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
>> @@ -62,6 +62,13 @@ static unsigned long vmware_get_tsc_khz(
>>    printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
>>             (unsigned long) tsc_hz / 1000,
>>             (unsigned long) tsc_hz % 1000);
>> +
>> +    if (!preset_lpj) {
>> +        lpj = ((u64)tsc_hz * 1000);
>> +        do_div(lpj, HZ);
> 
> This led to a build failure for me because HZ is not defined in the
> attached configuration.  Note that this problem did not show up in
> 2.6.35.2 with a very similar .config file.

You might want to include jiffies.h in this file.
Can you please check if this is needed for 2.6.33-stable too ? AFAIK 2.6.32 already has it.

Thanks,
Alok
> 
>> +        preset_lpj = lpj;
>> +    }
>> +
>>    return tsc_hz;
>> }
> 
> Regards,
>        Sven
> 
> 
> <ATT05198.config>
