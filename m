Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0IXRkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:40:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab0IXRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:40:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vernon Mauery <vernux@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Date: Fri, 24 Sep 2010 19:40:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
References: <20100921224610.GO13162@lucy> <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com> <20100924170943.GB10777@lucy>
In-Reply-To: <20100924170943.GB10777@lucy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241940.18931.arnd@arndb.de>
X-Provags-ID: V02:K0:Zt3e/9u8x9phWdjecW7vSYFh2cVh9qf7KQ9KQq2xV3d
 DPWvTU96fzjLjZdo9DoP1iPgffe4SZu2ylcvNtQRpwvy2eoVVw
 jwKHTJUGrmAoXFxmqd3Ny4xD6tKUWqbbaxIpo6wu5mQYENPHYw
 V+Dw/DrUvXjFZyKXI9VGxq3t9v9wIjuCwSl/e8MLLk8103WDS5
 9O/sABrSqYGDGGUYZ/Xnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010 19:09:43 Vernon Mauery wrote:
> I looked into this and tested it on some hardware, but it doesn't work.  
> After more digging and poking, it looks like the reason is that the port 
> IO address is not within the x86 standard port IO range.
> 
> I tried something like this:
> 
>                         addr = ioread32(&rtl_table->cmd_port_address);
>                         plen = rtl_cmd_width/8;
>                         if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
>                                 rtl_cmd_addr = ioremap(addr, plen);
>                         else
>                                 rtl_cmd_addr = ioport_map(addr, plen);
>                         RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
> 
> It printed out that rtl_cmd_addr was 0, meaning the ioport_map failed.  
> After more digging, it turns out that on at least one of the machines 
> this code is targeted for, the port IO address (from the first line 
> above) is 0x40000.  Even if this did get mapped, the IO_COND macro would 
> target it for MMIO access instead of PIO access.  So I don't think I can 
> use this method (even though it did make my code a lot nicer to read).
> 
> Any suggestions?

That seems really strange. I thought the inb/outb instructions could not
actually operate on addresses above 0x10000 at all, since they take a 16
bit address operand (DX register). Passing 0x40000 into inb should have the
same effect as zero AFAICT, which means that your existing code should not
work either.

For non-x86 architectures, I would recommend defining HAVE_ARCH_PIO_SIZE
and setting PIO_RESERVED to a higher value.

	Arnd
