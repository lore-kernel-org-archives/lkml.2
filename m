Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0DMVML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:12:11 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:23587 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0DMVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:12:09 -0400
Message-ID: <4BC4DD45.8090804@oracle.com>
Date: Tue, 13 Apr 2010 14:08:21 -0700
From: Yinghai <yinghai.lu@Oracle.COM>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home>
In-Reply-To: <1271192527.6035.44.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC4DE01.00C5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 02:02 PM, Bjorn Helgaas wrote:
> On Mon, 2010-04-12 at 15:32 -0700, Yinghai wrote:
>> Update e820 at first, and later put them resource tree.
>>
>> -V2: reserved that early, no PCI BAR can use it, force them to get new one
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
>> Cc: Andy Isaacson <adi@hexapodia.org>
>> Tested-by: Andy Isaacson <adi@hexapodia.org>
>> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
>> Acked-by: H. Peter Anvin <hpa@zytor.com>
>>
>> ---
>>  arch/x86/include/asm/setup.h |    1 -
>>  arch/x86/kernel/head32.c     |    1 -
>>  arch/x86/kernel/setup.c      |   19 +------------------
>>  3 files changed, 1 insertion(+), 20 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/setup.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/setup.h
>> +++ linux-2.6/arch/x86/include/asm/setup.h
>> @@ -44,7 +44,6 @@ static inline void visws_early_detect(vo
>>  extern unsigned long saved_video_mode;
>>  
>>  extern void reserve_standard_io_resources(void);
>> -extern void i386_reserve_resources(void);
>>  extern void setup_default_timer_irq(void);
>>  
>>  #ifdef CONFIG_X86_MRST
>> Index: linux-2.6/arch/x86/kernel/head32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/head32.c
>> +++ linux-2.6/arch/x86/kernel/head32.c
>> @@ -22,7 +22,6 @@ static void __init i386_default_early_se
>>  {
>>  	/* Initilize 32bit specific setup functions */
>>  	x86_init.resources.probe_roms = probe_roms;
>> -	x86_init.resources.reserve_resources = i386_reserve_resources;
>>  	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
>>  
>>  	reserve_ebda_region();
> 
> I like the fact that this makes x86_64 and x86_32 handle the legacy VGA
> framebuffer the same way.
> 
> What about arch/x86/kernel/probe_roms_32.c?  That deals with expansion
> ROMs in the 0xc0000-0xfffff range, including the VGA ROM.  We only build
> it for x86_32; is that correct, or should it be unified, too?

looks that file could be dropped.

We already put 0xa0000 - 0x100000 to reserved region.

> 
>> Index: linux-2.6/arch/x86/kernel/setup.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup.c
>> +++ linux-2.6/arch/x86/kernel/setup.c
>> @@ -693,7 +693,7 @@ static void __init trim_bios_range(void)
>>  	 * area (640->1Mb) as ram even though it is not.
>>  	 * take them out.
>>  	 */
>> -	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
>> +	e820_add_region(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RESERVED);
> 
> Let me see if I understand this.  On Andy's machine, the e820 map
> doesn't mention the 0xa0000-0xf0000 range at all:
> 
>   BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
>   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> 
> e820_reserve_resources() inserts resources for some e820 entries (those
> that start before 0x100000 or are not E820_RESERVED).  Andy's machine
> didn't supply any e820 entries that cover 0xa0000-0xf0000, so we didn't
> insert any resources there, and PCI assumed that range was available.
> 
> This patch adds the [0xa0000-0x100000] range as E820_RESERVED.  Since
> that starts below 0x100000, e820_reserve_resources() will insert a
> corresponding resource marked as BUSY.
> 
> Then the second patch prevents PCI from using that BUSY region to
> allocate resources to devices.
> 
> Is my understanding correct?

yes.

> 
> I don't feel like I know enough about x86 architecture to ack this
> patch, but I don't object to it.

Thanks

Yinghai
