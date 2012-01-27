Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2A0Q4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:56:35 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8022 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2A0Q4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:56:34 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Maxim Uvarov <maxim.uvarov@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Thread-Topic: [PATCH] hpwdt: clean up set_memory_x call for 32 bit
Thread-Index: AQHM1AQmvgYktPlZTkqNjF1gWE474ZYcA0YAgAR7+4CAAACdIA==
Date: Fri, 27 Jan 2012 16:55:49 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD34123320330F36@G9W0755.americas.hpqcorp.net>
References: <1326686570-19303-1-git-send-email-maxim.uvarov@oracle.com>
 <1326686570-19303-2-git-send-email-maxim.uvarov@oracle.com>
 <CA+55aFxzfCxwYUcRbSyf+U7nr5GPjH4Qfine_TcY6Oxj8WQrWw@mail.gmail.com>
 <20120127164933.GA18481@infomag.iguana.be>
In-Reply-To: <20120127164933.GA18481@infomag.iguana.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.10]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your last step I have coded up but not tested yet. I will get that done today.




Thanks,
Tom

-----Original Message-----
From: Wim Van Sebroeck [mailto:wim@iguana.be] 
Sent: Friday, January 27, 2012 10:50 AM
To: Mingarelli, Thomas; Linus Torvalds
Cc: Maxim Uvarov; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; stable@vger.kernel.org
Subject: Re: [PATCH] hpwdt: clean up set_memory_x call for 32 bit

Hi Tom,

> So I don't know who is supposed to be handling this (Wim?), but the
> patch itself looks suspicious.
> 
> On Sun, Jan 15, 2012 at 8:02 PM, Maxim Uvarov <maxim.uvarov@oracle.com> wrote:
> > -       set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
> > +       set_memory_x((unsigned long)bios32_entrypoint & PAGE_MASK, 2);
> 
> If it wasn't page-aligned to begin with, then maybe it needs three pages now?

I have been looking at the code again and basically we have for 32 bit the following sequence:
1) scan/search from 0x0f0000 through 0x0fffff, inclusive (in steps of 16 bytes) until we find
the 32-bit BIOS Service Directory with signature == PCI_BIOS32_SD_VALUE (=0x5F32335F ="_32_").
2) If we find this area then we first do a checksum check to see if it's a valid area.
3) if it's a valid area then we will check this area for a $CRU record.

the code for this is as follows:
	/*
	 * According to the spec, we're looking for the
	 * first 4KB-aligned address below the entrypoint
	 * listed in the header. The Service Directory code
	 * is guaranteed to occupy no more than 2 4KB pages.
	 */
	map_entry = bios_32_ptr->entry_point & ~(PAGE_SIZE - 1);
	map_offset = bios_32_ptr->entry_point - map_entry;

	bios32_map = ioremap(map_entry, (2 * PAGE_SIZE));

	if (bios32_map == NULL)
		return -ENODEV;

	bios32_entrypoint = bios32_map + map_offset;

	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;

	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
	asminline_call(&cmn_regs, bios32_entrypoint);

=> So if I understand it correctly then map_entry is page aligned. And thus bios32_map is also page aligned.
Wouldn't it then not make more sense to do a:
	set_memory_x((unsigned long)bios32_map, 2);

> > -                               set_memory_x((unsigned long)cru_rom_addr, cru_length);
> > +                               set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK, cru_length >> PAGE_SHIFT);
> 
> Same here. If we align the start address down, we should fix up the
> length. And should we not align the number of pages up?
> 
> In general, a "start/length" conversion to a "page/nr" model needs to be roughly
> 
>    len += start & ~PAGE_MASK;
>    start &= PAGE_MASK;
>    nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 
> to do things right. But I don't know where those magic numbers come
> from. Maybe the "2" is already due to the code possibly traversing a
> page boundary, and has already been fixed up. Somebody who knows the
> driver and the requirements should take a look at this.

4) if we then found the $CRU record then we do:
	physical_bios_base = cmn_regs.u2.rebx;
	physical_bios_offset = cmn_regs.u4.redx;
	cru_length = cmn_regs.u3.recx;
	cru_physical_address = physical_bios_base + physical_bios_offset;

	/* If the values look OK, then map it in. */
	if (cru_physical_address) {
		cru_rom_addr = ioremap(cru_physical_address, cru_length);
		if (cru_rom_addr) {
			set_memory_x((unsigned long)cru_rom_addr, cru_length);
			retval = 0;
		}
	}

=> Which means that cru_physical_address and cru_rom_addr are not page-aligned.
So if we follow the conversion model that Linus described we get:
	set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK,
			(cru_length + PAGE_SIZE - 1) >> PAGE_SHIFT);

Can you check this?

Kind regards,
Wim.

