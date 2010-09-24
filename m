Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0IXUqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:46:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40290 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab0IXUpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:45:22 -0400
Date: Fri, 24 Sep 2010 13:45:20 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Message-ID: <20100924204520.GD10777@lucy>
References: <20100921224610.GO13162@lucy>
 <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
 <20100924170943.GB10777@lucy>
 <201009241940.18931.arnd@arndb.de>
 <20100924182327.GC10777@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100924182327.GC10777@lucy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-Sep-2010 11:23 AM, Vernon Mauery wrote:
>On 24-Sep-2010 07:40 PM, Arnd Bergmann wrote:
>>On Friday 24 September 2010 19:09:43 Vernon Mauery wrote:
>>>I looked into this and tested it on some hardware, but it doesn't work.
>>>After more digging and poking, it looks like the reason is that the port
>>>IO address is not within the x86 standard port IO range.
>>>
>>>I tried something like this:
>>>
>>>                        addr = ioread32(&rtl_table->cmd_port_address);
>>>                        plen = rtl_cmd_width/8;
>>>                        if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
>>>                                rtl_cmd_addr = ioremap(addr, plen);
>>>                        else
>>>                                rtl_cmd_addr = ioport_map(addr, plen);
>>>                        RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
>>>
>>>It printed out that rtl_cmd_addr was 0, meaning the ioport_map failed.
>>>After more digging, it turns out that on at least one of the machines
>>>this code is targeted for, the port IO address (from the first line
>>>above) is 0x40000.  Even if this did get mapped, the IO_COND macro would
>>>target it for MMIO access instead of PIO access.  So I don't think I can
>>>use this method (even though it did make my code a lot nicer to read).
>>>
>>>Any suggestions?
>>
>>That seems really strange. I thought the inb/outb instructions could not
>>actually operate on addresses above 0x10000 at all, since they take a 16
>>bit address operand (DX register). Passing 0x40000 into inb should have the
>>same effect as zero AFAICT, which means that your existing code should not
>>work either.
>
>No, inb/outb have address as as unsigned long, which would explain 
>why 0x40000 works with PIO.  When doing inb/outb via the 
>ioread/iowrite macros, the port value is the address (minus the 
>offset) masked off to PIO_MASK, which is 16 bits on x86.
>
>So it looks like this really not going to work and I will have to go 
>back to how it was before.  Would it be tacky to write my own little 
>macro?

Okay.  I finally have it.  In one of my changes, I inadvertently changed 
the shape of the struct ibm_rtl_table, which is where I read the ioport 
address from.  This explains why the weird port.  Once I fixed my table 
so it was correct again, the port is 0x600, which is completely 
reasonable and will work just fine with the iowrite functions.  Thanks 
for bringing this up -- it greatly simplifies things.

--Vernon
