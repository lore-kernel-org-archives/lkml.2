Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2BHXRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:17:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab2BHXQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:16:58 -0500
Message-ID: <4F33025D.2040301@redhat.com>
Date: Wed, 08 Feb 2012 18:16:45 -0500
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
References: <1328623901-20628-1-git-send-email-ajax@redhat.com> <1328657985-13942-1-git-send-email-ajax@redhat.com> <20120208001724.7e5c7be4@pyramind.ukuu.org.uk> <4F31C417.30502@redhat.com> <20120208092611.49ada8c5@pyramind.ukuu.org.uk> <4F3280C7.1030401@redhat.com> <20120208143238.0003287e@pyramind.ukuu.org.uk>
In-Reply-To: <20120208143238.0003287e@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/12 9:32 AM, Alan Cox wrote:

>> iopl does not have identical security semantics to ioperm.  iopl lets my
>
> I didn't mention ioperm. I said /dev/ports

This was a typo on my part.  /dev/port was intended.

>> X server disable interrupts.  /dev/io would not, and would let me add a
>
> Yes it would - you can issue I/O accesses to the interrupt controller. So
> let me repeat that - the two are the same thing and equally insane.

Way to cut out the bit about volunteering to write the filter (which we 
could probably just steal whole from ACPI).

Besides, as noted (and cut), you need CAP_SYS_RAWIO anyway.

>> Your definition of "faster" is spurious.  VBE calls are not a
>
> You are not the only user of iopl, and they are faster. You may not
> *care* about the speed difference but the fact is they are faster.

So people continuing to use iopl will continue to be faster for their 
use case.  X can switch off of it and be faster for its use case, in 
which context switch overhead is infinitely more important than modeset 
taking another hundred micros.

>> performance path and system call overhead is negligible compared to I/O
>> serialization.  If anything /dev/io can be _faster_ in the mainline case
>> because we'll no longer need to handle the ioperm bitmask on every
>> context switch.
>
> See before - I never mentioned ioperm.

X is using ioperm to explicity disable access to some ports.

>> The current patch set results in a net gain of zero kernel interfaces,
>> once /dev/port is put down in a year.  I will admit that the current
>
> People will be shipping code using it for years.

You know, one of us is going to need to cite their sources here.  Thanks 
for shutting down codesearch, google.

>> /dev/port is probably not a meaningfully used API, seeing how it's been
>> broken since literally kernel 0.10.  But it's there and enabled by
>> default.  I would like it to work, please.
>
> So why hasn't it changed - because nobody has had a problem with it.

And now that I have a problem with it, I'm being told that I don't have 
a problem with it.

Charming.

>> Invoking architecture-specificity is spurious.  Competent architectures
>> have a usable framebuffer interface from the firmware, so vesa never
>> comes up.
>
> Exactly - so they don't need another port interface.

Except to support the case of booting vesa cards on non-x86.  A thing X 
can actually do, you know.

> iopl is functionally equivalent to your io port code. It's already in the
> kernel, it already works and it's already maintained.
>
> To be useful a port interface really needs to aware of hotplug, device
> mappings and the like. For VESA that's going to be pretty horrible both
> because of the uncontrolled nature of the interface and because of the
> vga "magic" both for ports and routing.
>
> An interface where you could do something like
>
> 	open a port channel
> 	bind device X to port channel  (imports its I/O ranges)
> 	bind portrange A-B to port channel (for nasties like the vga
> 				ports)
>
> read/write in 1/2/4/(8 ?) byte chunks meaningfully
>
> 	close

This isn't sufficient.  VBIOS can call SBIOS.  SBIOS can poke any port 
on the mainboard it wants.  There's no knowing a priori which ports on a 
channel I would need to bind, a rather bright fellow named Turing made a 
pretty good point about this once.

Yes, I have seen this in the wild.

More to the point I'm not concerned about hotplug here _at_ _all_.  If 
you want hotplug at this level you write a kernel driver.  If you _want_ 
me to write a kernel driver for vesa that pretends to be 
hotplug-compatible guess I can try, but the idea of an 8086 emulator in 
the kernel hasn't gone down well before.

> and which properly handled device hotplug - ie if you bind to device X, X
> is unplugged then the next read/write errors, or at least the address
> space is not freed until it isn't in the port range space.
>
> Now that would be an improvement, but it seems to be a fair amount of
> work.

To solve a problem no one is having, or is going to have.  And which 
wouldn't be sufficient for vesa regardless, short of the range of bound 
ports being 0 to 65535.

Whereas I've written something simple and supportable that does solve a 
problem I am currently having.  Something that _precisely_ matches the 
semantics of sysfs' legacy_io file API, a thing I have to use anyway for 
multi-domain machines.  Something that doesn't pretend VESA hotplug is a 
thing you can do because hey, guess what, it isn't.

Whatever.  I can continue to do this badly in userspace, or we could 
take some very small changes to make it slightly better, or we could do 
some enormous overengineered thing to fail to solve a non-problem.  Me, 
I like simple and incremental.  I guess that doesn't count for much.

- ajax
