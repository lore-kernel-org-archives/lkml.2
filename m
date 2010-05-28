Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0E1Qpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:45:42 -0400
Received: from king.tilera.com ([72.1.168.226]:6006 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0E1Qpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:45:39 -0400
Message-ID: <4BFFF330.4080509@tilera.com>
Date: Fri, 28 May 2010 12:45:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com> <201005240008.16497.arnd@arndb.de> <201005252345.15685.arnd@arndb.de>
In-Reply-To: <201005252345.15685.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 16:45:37.0841 (UTC) FILETIME=[334F2210:01CAFE85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2010 5:45 PM, Arnd Bergmann wrote:
>> +u32 inb(u32 addr)
>> > +{
>> > +	panic("inb not implemented");
>> > +}
>> > +EXPORT_SYMBOL(inb);
>>     
> If you just remove these definitions, you get a link error for any
> driver that tries to use these, which is probably more helpful than
> the panic.
>
> OTOH, are you sure that you can't just map the PIO calls to mmio functions
> like readb plus some fixed offset? On most non-x86 architectures, the PIO
> area of the PCI bus is just mapped to a memory range somewhere.
>   

I looked at where inb() and friends are used, and although we can get
close to not requiring them for tile, it's not quite there, and will
need some further discussions on the various lists to clean up enough
for our purposes.  There are three problems that surface when I try to
remove the inb family:

1. The ide-io-std.c file sets up the default_tp_ops, which we override
in our IDE driver, but we still have to build this file, and it contains
calls to inb, etc.

2. The usb pci quirks file contains some quirks that use inb and outb,
and since we support PCI, we have to try to compile this file.

3. CONFIG_DEVPORT defaults to yes, unless you're M68K.

None of this seems to depend on CONFIG_HAS_IOPORT.

Our PCI driver supports IOMEM read/write, but not IOPORT.

Perhaps something like CONFIG_ARCH_PCI_HAS_NO_IOPORT or some such, and
then we can disable all of the above things if that config option is
present (and CONFIG_HAS_IOPORT is false also?).

For now, I'll just leave the inb/outb implementation as panic() calls.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


