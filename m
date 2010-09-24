Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0IXRJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:09:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33136 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab0IXRJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:09:45 -0400
Date: Fri, 24 Sep 2010 10:09:43 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Message-ID: <20100924170943.GB10777@lucy>
References: <20100921224610.GO13162@lucy>
 <20100923221253.GA4960@lucy>
 <20100923225346.GB4960@lucy>
 <201009241512.39311.arnd@arndb.de>
 <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-Sep-2010 07:14 AM, Vernon Mauery wrote:
>On Fri, Sep 24, 2010 at 6:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Friday 24 September 2010, Vernon Mauery wrote:
[snip]
>>> +                     if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
>>> +                             iowrite8((u8)cmd_port_val, rtl_cmd_iomem_addr);
>>> +                     else
>>> +                             outb((u8)cmd_port_val, rtl_cmd_port_addr);
>>
>> ioread/iowrite already has the capability to use both mmio and pio
>> addresses. You can use ioport_map() to create an __iomem token that
>> corresponds to your rtl_cmd_port_addr and get rid of the rtl_cmd_type
>> variable.
>
>Thank you for that tip.  I will look into it and roll out another version.

I looked into this and tested it on some hardware, but it doesn't work.  
After more digging and poking, it looks like the reason is that the port 
IO address is not within the x86 standard port IO range.

I tried something like this:

			addr = ioread32(&rtl_table->cmd_port_address);
			plen = rtl_cmd_width/8;
			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
				rtl_cmd_addr = ioremap(addr, plen);
			else
				rtl_cmd_addr = ioport_map(addr, plen);
			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);

It printed out that rtl_cmd_addr was 0, meaning the ioport_map failed.  
After more digging, it turns out that on at least one of the machines 
this code is targeted for, the port IO address (from the first line 
above) is 0x40000.  Even if this did get mapped, the IO_COND macro would 
target it for MMIO access instead of PIO access.  So I don't think I can 
use this method (even though it did make my code *a lot* nicer to read).

Any suggestions?

--Vernon
