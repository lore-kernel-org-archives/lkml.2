Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2HWMJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:09:55 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43399 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2HWMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:09:49 -0400
Message-ID: <50361D25.5020704@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2012 17:38:05 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org, ananth@in.ibm.com,
        Chris McDermott <lcm@us.ibm.com>, masbock@linux.vnet.ibm.com
Subject: Re: [PATCH] x86: mce: Honour bios-set CMCI threshold
References: <20120822123054.29238.3864.stgit@localhost.localdomain> <20120822124649.GD5817@aftab.osrc.amd.com>
In-Reply-To: <20120822124649.GD5817@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082312-0260-0000-0000-000001B9404D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 06:16 PM, Borislav Petkov wrote:
> On Wed, Aug 22, 2012 at 06:00:54PM +0530, Naveen N. Rao wrote:
>> The ACPI spec doesn't provide for a way for the bios to pass down
>> recommended thresholds to the OS on a _per-bank_ basis. This patch adds
>> a new boot option, which if passed, allows bios to initialize the CMCI
>> threshold. In such a case, we simply skip programming any threshold
>> value.
>>
>> As fail-safe, we initialize threshold to 1 if some banks have not been
>> initialized by the bios and warn the user.
>>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>>   Documentation/x86/x86_64/boot-options.txt |    5 ++++
>>   arch/x86/include/asm/mce.h                |    1 +
>>   arch/x86/kernel/cpu/mcheck/mce.c          |    4 +++
>>   arch/x86/kernel/cpu/mcheck/mce_intel.c    |   39 +++++++++++++++++++++++++++--
>>   4 files changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
>> index c54b4f5..ec92540 100644
>> --- a/Documentation/x86/x86_64/boot-options.txt
>> +++ b/Documentation/x86/x86_64/boot-options.txt
>> @@ -50,6 +50,11 @@ Machine check
>>   		monarchtimeout:
>>   		Sets the time in us to wait for other CPUs on machine checks. 0
>>   		to disable.
>> +   mce=bios_cmci_threshold
>> +		Don't overwrite the bios-set CMCI threshold. This boot option
>> +		prevents Linux from overwriting the CMCI threshold set by the
>> +		bios. Without this option, Linux always sets the CMCI
>> +		threshold to 1.
>>
>>      nomce (for compatibility with i386): same as mce=off
>>
>> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
>> index a3ac52b..8ad5078 100644
>> --- a/arch/x86/include/asm/mce.h
>> +++ b/arch/x86/include/asm/mce.h
>> @@ -171,6 +171,7 @@ DECLARE_PER_CPU(struct device *, mce_device);
>>   #ifdef CONFIG_X86_MCE_INTEL
>>   extern int mce_cmci_disabled;
>>   extern int mce_ignore_ce;
>> +extern int mce_bios_cmci_threshold;
>>   void mce_intel_feature_init(struct cpuinfo_x86 *c);
>>   void cmci_clear(void);
>>   void cmci_reenable(void);
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>> index 292d025..401359d 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -82,6 +82,7 @@ static int			mce_panic_timeout	__read_mostly;
>>   static int			mce_dont_log_ce		__read_mostly;
>>   int				mce_cmci_disabled	__read_mostly;
>>   int				mce_ignore_ce		__read_mostly;
>> +int				mce_bios_cmci_threshold	__read_mostly;
>>   int				mce_ser			__read_mostly;
>
> AFAICT, this is actually a single-bit flag but we're using a whole
> integer for it and from looking at the other boot options a couple of
> them are used as flags too.
>
> Care to define a
>
> struct boot_flags {
> 	__u64 	mce_bios_cmci_threshold : 1,
> 		__reserved		: 63;
> };
>
> and use
>
> 	boot_flags.mce_bios_cmci_threshold
>
> in the conditionals below instead?

Sure - that sounds like a good idea. Further, a #define can be used to 
avoid the need to change other references, though I'm not sure it's 
considered good practice:

#define mce_bios_cmci_threshold   boot_flags.mce_bios_cmci_threshold


Thanks!
- Naveen

>
> I'll try to convert the rest of them to that struct and thus save some
> more space...
>
> Thanks.
>

