Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GTJHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:07:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:9867 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1GTJHf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Wed, 20 Jul 2011 05:07:35 -0400
Message-Id: <4E26B6F3020000780004E707@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 20 Jul 2011 10:07:31 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: make enabling of MMCFG on AMD Fam10 CPUs
	 actually work
References: <4E258A11020000780004E39B@nat28.tlf.novell.com>
 <CAE9FiQWdaNY_bjXtDbsR88ZsYPGzsiT18wQTqjtrRXVF-fu1dw@mail.gmail.com>
In-Reply-To: <CAE9FiQWdaNY_bjXtDbsR88ZsYPGzsiT18wQTqjtrRXVF-fu1dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.07.11 at 18:38, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jul 19, 2011 at 4:43 AM, Jan Beulich <JBeulich@novell.com> wrote:
>> Forcibly enabling the MMCFG space on AMD Fam10 CPUs cannot be expected
>> to work, since with the firmware not being aware of the address range
>> used, it cannot possibly reserve the space in E820 or ACPI resources.
>> Hence we need to manually insert the range into the E820 table, and
>> enable the range only when the insertion actually works without
>> conflict.
>>
>> Adding the calls to the respective E820 handling functions additionally
>> requires to deal with modpost's mismatch checking: The function doing
>> those calls needs to be __init, and it is being made sure that it gets
>> called (from its __cpuinit caller) only on the BSP, and through a stub
>> (silencing the warning).
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/mmconf-fam10h_64.c |   22 +++++++++++++++++++---
>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> --- 3.0-rc7/arch/x86/kernel/mmconf-fam10h_64.c
>> +++ 3.0-rc7-x86_64-mmcfg-fam10/arch/x86/kernel/mmconf-fam10h_64.c
>> @@ -14,6 +14,7 @@
>>  #include <asm/io.h>
>>  #include <asm/msr.h>
>>  #include <asm/acpi.h>
>> +#include <asm/e820.h>
>>  #include <asm/mmconfig.h>
>>  #include <asm/pci_x86.h>
>>
>> @@ -49,7 +50,7 @@ static int __cpuinit cmp_range(const voi
>>  /* need to avoid (0xfd<<32), (0xfe<<32), and (0xff<<32), ht used space */
>>  #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
>>  #define BASE_VALID(b) ((b) + MMCONF_SIZE <= (0xfdULL<<32) || (b) >= (1ULL<<40))
>> -static void __cpuinit get_fam10h_pci_mmconf_base(void)
>> +static void __init _get_fam10h_pci_mmconf_base(void)
>>  {
>>        int i;
>>        unsigned bus;
>> @@ -163,7 +164,21 @@ static void __cpuinit get_fam10h_pci_mmc
>>        return;
>>
>>  out:
>> -       fam10h_pci_mmconf_base = base;
>> +       if(!e820_any_mapped(base, base + MMCONF_SIZE, 0)) {
>> +               e820_add_region(base, MMCONF_SIZE, E820_RESERVED);
>> +               update_e820();
>> +               fam10h_pci_mmconf_base = base;
>> +       }
>> +}
>> +
>> +/*
>> + * Section-mismatch warning avoidance: This gets called from a ___cpuinit
>> + * function (below), but only on the BSP, and needs to call the __init
>> + * functions e820_add_region() and update_e820() (above).
>> + */
>> +static void __ref get_fam10h_pci_mmconf_base(void)
>> +{
>> +       _get_fam10h_pci_mmconf_base();
>>  }
>>
>>  void __cpuinit fam10h_check_enable_mmcfg(void)
>> @@ -199,7 +214,8 @@ void __cpuinit fam10h_check_enable_mmcfg
>>         * if it is not enabled, try to enable it and assume only one segment
>>         * with 256 buses
>>         */
>> -       get_fam10h_pci_mmconf_base();
>> +       if (!fam10h_pci_mmconf_base)
>> +               get_fam10h_pci_mmconf_base();
>>        if (!fam10h_pci_mmconf_base) {
>>                pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
>>                return;
>>
>>
>>
> 
> sent out some time ago...please check attached patch.
> 
> Maybe you can combine them together.

No, I don't think what you do is valid. In particular, adding/using the
range if !e820_all_mapped(..., E820_RESERVED) rather than (as in
my variant) !e820_any_mapped(..., 0) doesn't seem appropriate.

As to whether adding the range also for the case where we read
the value from the MSR - I'm not sure, and I don't have a system to
test that case on.

So bottom line is that I think your change for that second case could
go on top of my change - if that gets accepted/applied in the first
place.

Jan

