Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0EMVuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:50:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38938 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0EMVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:50:37 -0400
Message-ID: <4BEC73B2.2020909@oracle.com>
Date: Thu, 13 May 2010 14:48:34 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com>
In-Reply-To: <4BEC6C94.2020100@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BEC7417.0007:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 02:18 PM, Mike Travis wrote:
> 
> 
> Mike Travis wrote:
>>
>>
>> Yinghai wrote:
>>> On 05/12/2010 11:55 AM, H. Peter Anvin wrote:
>>>> On 05/12/2010 11:10 AM, Mike Travis wrote:
>>>>> Currently, the e820_reserve_resources() function does not add entries
>>>>> obtained via the "add_efi_memmap" kernel cmdline option.  This causes
>>>>> /sys/firmware/memmap/... to be incomplete (stops after 128 entries).
>>>>> Utilities that examine these entries then do not get the complete
>>>>> picture of system memory.
>>>>>
>>>>> This patch causes the above function to use the e820 memmap instead
>>>>> of the e820_saved memmap if "add_efi_memmap" cmdline option is
>>>>> specified.
>>>>>
>>>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>>>> Signed-off-by: Jack Steiner <steiner@sgi.com>
>>>> If I'm not mistaken, the very reason for the e820 vs e820_saved map is
>>>> that the latter is supposed to reflect the firmware report, whereas the
>>>> former is subject to be modified by the kernel.  As this is actually a
>>>> reflection of the firmware (although it would be better if you could
>>>> fix
>>>> the bootloader instead of adding hacks in the kernel...) it really
>>>> should go into e820_saved as well as e820.  Displaying the adjusted
>>>> e820
>>>> map doesn't seem appropriate under any circumstances.
>>>
>>> Yes, you are right.
>>>
>>> We should not touch e820_saved and keep /sys/firmware/memmap to be
>>> consistent with it.
>>>
>>> YH
>>
> 
> Here's where it gets confusing:
> 
> /*
> * The e820 map is the map that gets modified e.g. with command line
> parameters
> * and that is also registered with modifications in the kernel resource
> tree
> * with the iomem_resource as parent.
> *
> * The e820_saved is directly saved after the BIOS-provided memory map is
> * copied. It doesn't get modified afterwards. It's registered for the
> * /sys/firmware/memmap interface.
> *
> * That memory map is not modified and is used as base for kexec. The
> kexec'd
> * kernel should get the same memory map as the firmware provides. Then the
> * user can e.g. boot the original kernel with mem=1G while still booting
> the
> * next kernel with full memory.
> */
> struct e820map e820;
> struct e820map e820_saved;
> 
> 
> It specifically mentions that kexec needs the unmodified address map.  But
> we know it does not work if it does not have the "extra memmap entries"
> from BIOS (added with option "add_efi_memmap".)
> 
> So in essence I see it as a lie that e820_saved contains the memmap
> provided by the firmware.  It clearly does not.  It is missing all
> the entries greater than 128.
> 
> So the question remains, should /sys/firmware/memmap be provisioned
> from e820_saved with changes to add to that map the extra memmap
> entries?  Or should it be provisioned from the updated e820 map
> that is also printed by e820_print_map()? 
> The output to the console and the contents of /sys/firmware/memmap
> should match, and this is what this patch was intending to do.
> /sys/firmware/memmap should not be truncated due to legacy BIOS
> limitations.
> 
> If the e820 memmap changes further due to other circumstances,
> that should not change the mappings under /sys/firmware/memmap?
> Unless I'm missing something here, I don't see the downside.
> 
> So which should it be?

in setup.c::setup_arch()

        setup_memory_map();
        parse_setup_data();
        /* update the e820_saved too */
        e820_reserve_setup_data();
	...
	parse_early_param();
	...
	finish_e820_parsing();



efi memmap is appended to e820 by parse_setup_data
e820_reserve_setup_data() will copy e820 to e820_saved.


or do you have old boot loader 

        if (boot_params.hdr.version < 0x0209)
                return;

YH
