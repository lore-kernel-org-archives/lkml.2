Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0KHIAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:00:38 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:55378 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0KHIAh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 8 Nov 2010 03:00:37 -0500
Message-Id: <4CD7BC300200007800020E08@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 08 Nov 2010 08:00:32 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix and clean up AMD Fam10 MMCONF enabling
References: <4CD2DDC6020000780002098C@vpn.id2.novell.com>
 <4CD454D1.2060503@kernel.org>
In-Reply-To: <4CD454D1.2060503@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.11.10 at 20:02, Yinghai Lu <yinghai@kernel.org> wrote:
> On 11/04/2010 08:22 AM, Jan Beulich wrote:
>> @@ -123,9 +123,9 @@ static void __cpuinit get_fam10h_pci_mmc
>>  		if (!(reg & 3))
>>  			continue;
>>  
>> -		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
>> +		start = (u64)(reg & 0xffffff00) << 8; /* 39:16 on 31:8*/
>>  		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
>> -		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
>> +		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
>>  
>>  		if (!end)
>>  			continue;
> 
> those section could be changed to:
> 
>                 start = reg & 0xffffff00; /* 39:16 on 31:8*/
>                 start <<= 8;
>                 reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
>                 end = (reg & 0xffffff00);
>                 end <<= 8;
> 
>                 if (!end)
>                         continue;
>                 end |= 0xffff;
> 
>                 hi_mmio_num = add_range(range, 8, hi_mmio_num, start, end + 1);
> 
> 1. append 0xffff after !end checking..

Yes, this one I missed, but it gets fixed by the follow-up patch
anyway (if I'm to re-submit, I'll fold in that second patch anyway).

> 2. add_range should take end + 1;

That's only after your change making use of this function.

>> @@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg
>>  	 * with 256 buses
>>  	 */
>>  	get_fam10h_pci_mmconf_base();
>> -	if (fam10h_pci_mmconf_base_status <= 0)
>> +	if (!fam10h_pci_mmconf_base) {
>> +		pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
>>  		return;
>> +	}
>>  
>>  	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
>>  	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
>> 
>> 
> 
> looks like fam10h_pci_mmconf_base_status should NOT be removed.
> 
> -1: mean we can not find right new base on BSP, so should not let AP to mess 
> it again.

Note that is now achieved by clearing PCI_CHECK_ENABLE_AMD_MMCONF
from pci_probe (imo a better way, as it inhibits code elsewhere which
is protected by checks of this bit).

Jan

