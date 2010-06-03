Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab0FCRy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:54:28 -0400
Received: from king.tilera.com ([72.1.168.226]:8449 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0FCRy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:54:26 -0400
Message-ID: <4C07EC4F.6050600@tilera.com>
Date: Thu, 03 Jun 2010 13:54:23 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 2/8] arch/tile: infrastructure and configuration-related
 files.
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005290333.o4T3XuRo029935@farm-0002.internal.tilera.com> <20100531074759.GC10515@linux-sh.org>
In-Reply-To: <20100531074759.GC10515@linux-sh.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 17:54:24.0890 (UTC) FILETIME=[CDB355A0:01CB0345]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2010 3:47 AM, Paul Mundt wrote:
> On Fri, May 28, 2010 at 11:09:12PM -0400, Chris Metcalf wrote:
>   
>> +config ZONE_DMA
>> +	def_bool y
>> +
>>     
> Do you really want ZONE_DMA? Looking through the code it seems like you
> are just using this in place of ZONE_NORMAL instead of for dealing with
> any specific DMA limitations.
>   

Yes, this dates back to 2.6.18 or so, when I think you had to have it. 
In any case I've switched it over to ZONE_NORMAL throughout our code
now, and it seems fine.  Thanks.

>> +config CLOCKSOURCE_WATCHDOG
>> +	def_bool y
>> +
>>     
> Are you also sure that you want this? It doesn't seem like you have any
> of the clocksource stability issues that x86 does, so it's not obvious
> why you are enabling this.
>   

Ah, good catch.  Thanks; I'm not sure where this config option came
from, but it's gone now.

>> +config ARCH_DISCONTIGMEM_ENABLE
>> +	def_bool y
>> +
>> +config ARCH_DISCONTIGMEM_DEFAULT
>> +	def_bool y
>> +
>>     
> Have you considered sparsemem instead?
>   

I looked at both of them a while ago (2.6.18 or 2.6.26, not sure which),
and at the time it seemed easier to do discontig.  I vaguely recall
there was some awkwardness with our architecture when I tried to figure
out the sparsemem route.  I filed a tracking bug on this issue
internally so we can revisit it at some point.

>> +# SMP is required for Tilera Linux.
>> +config SMP
>> +	def_bool y
>> +
>>     
> Forcing on SMP is fairly unusual, you do not support booting UP kernels
> at all?
>   

We've written the code to try to support UP, but the couple of times
we've tried to build with !SMP, there have been some subtle bugs. 
There's no reason we'd ever sell a chip with a single cpu on it (that I
can see, anyway), so it's not very pressing to investigate failures in
this mode, so it's disabled.

>> +config SERIAL_CONSOLE
>> +	def_bool y
>> +
>>     
> This seems unused and looks like it was just copied over from some other
> architecture?
>   

Thanks, good catch.

>> +menu "Bus options"
>> +
>> +config NO_IOMEM
>> +	bool
>> +	def_bool !PCI
>> +
>>     
> Have you inverted the logic here? Judging from your I/O routines it's the
> PIO stuff you want disabled, not MMIO. As such, it's NO_IOPORT that you
> want. Some of the PCI drivers will still use inb/outb and friends for PCI
> IO space so disabling it for the !PCI case is fine.
>   

If we don't have PCI, we don't have IOMEM, since our 32-bit chips don't
support any kind of direct MMIO.  I would also have set NO_IOPORT
unconditionally, but it turns out some generic code (e.g. some IDE
stuff) breaks in this case.  At some point I'll investigate this in more
detail, though probably only after we convert our GPIO-based ATA driver
to not use IDE at all.

Thanks for your feedback!  I'll put out a [PATCH 9/8] for now to
hopefully wrap this first set of changes up, and I'm also going to get
all this stuff into a GIT repository on kernel.org now that I have an
account there.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


