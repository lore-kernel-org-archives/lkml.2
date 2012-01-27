Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2A0Sfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:35:52 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59173 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2A0Sfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:35:50 -0500
Message-ID: <4F22EDDE.5000301@oracle.com>
Date: Fri, 27 Jan 2012 10:33:02 -0800
From: Maxim Uvarov <maxim.uvarov@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Thomas.Mingarelli@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com> <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com> <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com> <20120127164933.GA18481@infomag.iguana.be>
In-Reply-To: <20120127164933.GA18481@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F22EE7D.0076,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 08:49 AM, Wim Van Sebroeck wrote:
> Hi Tom,
>
>> So I don't know who is supposed to be handling this (Wim?), but the
>> patch itself looks suspicious.
>>
>> On Sun, Jan 15, 2012 at 8:02 PM, Maxim Uvarov<maxim.uvarov@oracle.com>  wrote:
>>> -       set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
>>> +       set_memory_x((unsigned long)bios32_entrypoint&  PAGE_MASK, 2);
>>
>> If it wasn't page-aligned to begin with, then maybe it needs three pages now?
>
> I have been looking at the code again and basically we have for 32 bit the following sequence:
> 1) scan/search from 0x0f0000 through 0x0fffff, inclusive (in steps of 16 bytes) until we find
> the 32-bit BIOS Service Directory with signature == PCI_BIOS32_SD_VALUE (=0x5F32335F ="_32_").
> 2) If we find this area then we first do a checksum check to see if it's a valid area.
> 3) if it's a valid area then we will check this area for a $CRU record.
>
> the code for this is as follows:
> 	/*
> 	 * According to the spec, we're looking for the
> 	 * first 4KB-aligned address below the entrypoint
> 	 * listed in the header. The Service Directory code
> 	 * is guaranteed to occupy no more than 2 4KB pages.
> 	 */
> 	map_entry = bios_32_ptr->entry_point&  ~(PAGE_SIZE - 1);
> 	map_offset = bios_32_ptr->entry_point - map_entry;
>
> 	bios32_map = ioremap(map_entry, (2 * PAGE_SIZE));
>
> 	if (bios32_map == NULL)
> 		return -ENODEV;
>
> 	bios32_entrypoint = bios32_map + map_offset;
>
> 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
>
> 	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
> 	asminline_call(&cmn_regs, bios32_entrypoint);
>
> =>  So if I understand it correctly then map_entry is page aligned. And thus bios32_map is also page aligned.
> Wouldn't it then not make more sense to do a:
> 	set_memory_x((unsigned long)bios32_map, 2);
>
>>> -                               set_memory_x((unsigned long)cru_rom_addr, cru_length);
>>> +                               set_memory_x((unsigned long)cru_rom_addr&  PAGE_MASK, cru_length>>  PAGE_SHIFT);
>>
>> Same here. If we align the start address down, we should fix up the
>> length. And should we not align the number of pages up?
>>
>> In general, a "start/length" conversion to a "page/nr" model needs to be roughly
>>
>>     len += start&  ~PAGE_MASK;
>>     start&= PAGE_MASK;
>>     nr_pages = (len + PAGE_SIZE - 1)>>  PAGE_SHIFT;
>>
>> to do things right. But I don't know where those magic numbers come
>> from. Maybe the "2" is already due to the code possibly traversing a
>> page boundary, and has already been fixed up. Somebody who knows the
>> driver and the requirements should take a look at this.
>
> 4) if we then found the $CRU record then we do:
> 	physical_bios_base = cmn_regs.u2.rebx;
> 	physical_bios_offset = cmn_regs.u4.redx;
> 	cru_length = cmn_regs.u3.recx;
> 	cru_physical_address = physical_bios_base + physical_bios_offset;
>
> 	/* If the values look OK, then map it in. */
> 	if (cru_physical_address) {
> 		cru_rom_addr = ioremap(cru_physical_address, cru_length);
> 		if (cru_rom_addr) {
> 			set_memory_x((unsigned long)cru_rom_addr, cru_length);
> 			retval = 0;
> 		}
> 	}
>
> =>  Which means that cru_physical_address and cru_rom_addr are not page-aligned.
> So if we follow the conversion model that Linus described we get:
> 	set_memory_x((unsigned long)cru_rom_addr&  PAGE_MASK,
> 			(cru_length + PAGE_SIZE - 1)>>  PAGE_SHIFT);
>
> Can you check this?
>
> Kind regards,
> Wim.
>

I got this warning if address was not aligned:

  WARNING: at arch/x86/mm/pageattr.c:877 
change_page_attr_set_clr+0x21e/0x230()
  Hardware name: ProLiant DL580 G7
  Pid: 1321, comm: modprobe Not tainted
  Call Trace:
   [<c043e3be>] ? change_page_attr_set_clr+0x21e/0x230
   [<c045bd71>] warn_slowpath_common+0x81/0xa0
   [<c043e3be>] ? change_page_attr_set_clr+0x21e/0x230
   [<c045bdb2>] warn_slowpath_null+0x22/0x30
   [<c043e3be>] change_page_attr_set_clr+0x21e/0x230
   [<c043ec5f>] set_memory_x+0x5f/0x70
   [<f8c515ce>] cru_detect+0x11e/0x130 [hpwdt]
   [<f8c51617>] bios32_present+0x37/0x40 [hpwdt]
   [<f8c5166e>] detect_cru_service+0x4e/0x70 [hpwdt]
   [<f8c5169f>] hpwdt_init_nmi_decoding+0xf/0xf0 [hpwdt]
   [<f8c5107d>] ? hpwdt_change_timer+0x2d/0x60 [hpwdt]
   [<f8c517f8>] hpwdt_init_one+0x78/0x190 [hpwdt]
   [<c06e8c71>] ? pm_runtime_enable+0x51/0x80

Maxim.
