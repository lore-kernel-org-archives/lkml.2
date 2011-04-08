Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1DHOAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:00:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab1DHOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:00:47 -0400
Message-ID: <4D9F150B.1030809@codemonkey.ws>
Date: Fri, 08 Apr 2011 09:00:43 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	<4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>	<4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>	<4D9E6F6E.9050709@codemonkey.ws> <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
In-Reply-To: <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 12:14 AM, Pekka Enberg wrote:
> Hey, feel free to help out! ;-)
>
> I don't agree that a working 2500 LOC program is 'repeating the same
> architectural mistakes' as QEMU. I hope you realize that we've gotten
> here with just three part-time hackers working from their proverbial
> basements. So what you call mistakes, we call features for the sake of
> simplicity.

And by all means, it's a good accomplishment.

But the mistakes I'm referring to aren't missing bits of code.  It's 
that the current code makes really bad assumptions.

An example is ioport_ops.  This maps directly to 
ioport_{read,write}_table in QEMU.  Then you use ioport__register() to 
register entries in this table similar register_ioport_{read,write}() in 
QEMU.

The use of a struct is a small improvement but the fundamental design is 
flawed because it models a view of hardware where all devices are 
directly connected to the CPU.  This is not how hardware works at all.

On the PC QEMU tries to emulate, a PIO operation flows from the CPU to 
the i440fx.  The i440fx will do the first level of decoding treating the 
PCI host controller ports specially and then posting any I/Os in the PCI 
port range to the PCI bus.  If no device selects these ports, or the 
ports fall into the non-PCI range, the I/O request is then posted to the 
PIIX3.

The PIIX3 will handle a good chunk of the I/O requests (via it's Super 
I/O chipset) and the remainder will be posted to the ISA bus.  One or 
more ISA devices may then react to these posted I/O operation.

Really, having a flat table doesn't make sense.  You should just send 
everything to an i440fx directly.  Then the i440fx should decode what it 
can, and send it to the next level, and so forth.

You can get 90% of the way to working device model without modelling 
this type of flow, but you hit a wall pretty quickly as it's not unusual 
for PCI controllers to manipulate I/O requests in some fashion 
(particularly on non-x86 platforms).  If you treat everything as 
directly attached to the CPU, it's impossible to model this.

Likewise, the same flow is true in the opposite direction.  You use 
guest_flat_to_host() which assumes a linear mapping of guest memory to 
host memory.  We used to do that too in QEMU (phys_ram_base + X).  It 
took a long time to get rid of that assumption in QEMU.

There are multiple problems with this sort of assumption.  The first is 
that you treat all devices as being directly attached to the memory 
controller.  As with I/O instruction dispatch, this is not the case, and 
there are many PCI controllers that will munge these accesses (think 
IOMMU, for instance).  The second is you assume that you're not doing 
I/O to device memory, but this does happen in practice.  The 
cpu_physical_memory_rw() API is careful to support cases where you're 
writing data to I/O memory.

The other big problem here is that if you have open access to guest 
memory like this, you cannot easily track dirty information.  Userspace 
accesses to guest memory will not result in KVM updating the guest dirty 
bitmap.  You can add another API to explicitly set dirty bits (and 
that's exactly what we did a few years ago) but then you'll get 
extremely subtle bugs in migration if you're missing a dirty update 
somewhere.  This is exactly how our API evolved in QEMU.

As I said earlier, there are very good reasons we do the things we do in 
QEMU.  We're a large code base and there's far too much of the code base 
that noone cares about enough but that users are happy with.  It's far 
too hard to make broad sweeping changes right now (although that's 
something we're trying to improve).

But I'd strongly suggest taking some of the advise being offered here.  
Don't ignore the hard problems to start out with because as the code 
base grows, it'll become more difficult to fix those.  That's not to say 
that you need to implement migration tomorrow, but at least keep the 
constraints in mind and make sure that you're designing interfaces that 
let you do things like keep an updated dirty bitmap when you do memory 
accesses in userspace.

> I also don't agree with this sentiment that unless we have SMP,
> migration, yadda yadda yadda, now, it's impossible to change that in
> the future. It ignores the fact that this is exactly how the Linux
> kernel evolved

Over the course of 20 years.  By my count, we still have another decade 
of refactoring before I can get on top of my ivory tower and call every 
other project terrible.

>   and the fact that we're aggressively trying to keep the
> code size as small and tidy as possible so that changing things is as
> easy as possible.
>
> I've looked at QEMU sources over the years and especially over the
> past year and I think you might be way too familiar with its inner
> workings to see how complex (even the core code) has become for
> someone who isn't familiar with it.

I have no doubts about the complexity of QEMU.  But the 'goo' factor is 
not due to complexity, it's due to the fact that there's a lot of code 
that basically needs to be removed.  But removing features from an 
existing project is never a popular thing to do particularly when the 
work well enough for a lot of people.

Regards,

Anthony Liguori
