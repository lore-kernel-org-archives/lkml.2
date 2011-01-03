Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1ACMUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 07:20:55 -0500
Received: from www.tglx.de ([62.245.132.106]:37306 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1ACMUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 07:20:54 -0500
Message-ID: <4D21BF17.6090209@linutronix.de>
Date: Mon, 03 Jan 2011 13:20:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 02/15] x86: Add device tree support
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-3-git-send-email-bigeasy@linutronix.de> <20101230084311.GD11721@angua.secretlab.ca>
In-Reply-To: <20101230084311.GD11721@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> +extern char cmd_line[COMMAND_LINE_SIZE];
>> +/* This number is used when no interrupt has been assigned */
>> +#define NO_IRQ		(-1)
> 
> 0 means NO_IRQ on x86 and most architectures.  I will change this when
> I pick up the patch.

cat /proc/interrupts
            CPU0
   0:         40   IO-APIC-edge      timer

>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 577d06b..26f2c9a 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -113,6 +113,7 @@
>>  #endif
>>  #include <asm/mce.h>
>>  #include <asm/alternative.h>
>> +#include <asm/prom.h>
>>  
>>  /*
>>   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
>> @@ -445,6 +446,9 @@ static void __init parse_setup_data(void)
>>  		case SETUP_E820_EXT:
>>  			parse_e820_ext(data);
>>  			break;
>> +		case SETUP_DTB:
>> +			add_dtb(pa_data);
>> +			break;
> 
> Why is the physical address being passed in when the virtual address
> is needed to be stored in initial_boot_params by add_dtb()?

add_dtb() changes it via phys_to_virt() so it is stored as virtual. I
can't touch this memory that early in the boot process so it is passed as
phys. phys_to_virt() isn't working (yet) so you need a fixmap or an
early_ioremap(). Earlier I used the device tree very late so the
phys_to_virt() memory was working.

Later in the series add_dtb() stores it in a custom u64 variable because I 
might have to use the built-in dtb, I have to relocate the dtb (so the
boot loader does not have to care about kernel's memory layout) and I have
to use it "early" so I create a fixmap for it.

The dtb is not usable before the ->get_config() hook (x86_dtb_get_config, 
patch #5) is called. After that initial_boot_params is set and can be used.

>>  		default:
>>  			break;
>>  		}
>> -- 
>> 1.7.3.2

Sebastian
