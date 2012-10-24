Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab2JXASp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:18:45 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:52778 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2JXASn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:18:43 -0400
Message-ID: <508733D5.3060207@firmworks.com>
Date: Tue, 23 Oct 2012 14:18:29 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Sebastien Guiriec <s-guiriec@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap5: Update GPIO with address space
 and interrupts
References: <1350981432-6750-1-git-send-email-s-guiriec@ti.com> <1350981432-6750-2-git-send-email-s-guiriec@ti.com> <5086AE8E.60106@ti.com> <5086CC02.6070801@firmworks.com> <5087252A.50203@ti.com>
In-Reply-To: <5087252A.50203@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q9O0IUQj024354 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 1:15 PM, Jon Hunter wrote:
> Hi Mitch,
> 
> On 10/23/2012 11:55 AM, Mitch Bradley wrote:
>> On 10/23/2012 4:49 AM, Jon Hunter wrote:
>>
>>> Therefore, I believe it will improve search time and hence, boot time if
>>> we have interrupt-parent defined in each node.
>>
>> I strongly suspect (based on many years of performance tuning, with
>> special focus on boot time) that the time difference will be completely
>> insignificant.  The total extra time for walking up the interrupt tree
>> for every interrupt in a large system is comparable to the time it takes
>> to send a few characters out a UART.  So you can get more improvement
>> from eliminating a single printk() than from globally adding per-node
>> interrupt-parent.
>>
>> Furthermore, the cost of processing all of the interrupt-parent
>> properties is probably similar to the cost of the avoided tree walks.
>>
>> CPU cycles are very fast compared to I/O register accesses, say a factor
>> of 100.  Now consider that many modern devices contain embedded
>> microcontrollers (SD cards, network interface modules, USB hubs and
>> devices, ...), and those devices usually require various delays measured
>> in milliseconds, to ensure that the microcontroller is ready for the
>> next initialization step.  Those delays are extremely long compared to
>> CPU cycles.  Obviously, some of that can be overlapped by careful
>> multithreading, but that isn't free either.
>>
>> The bottom line is that I'm pretty sure that adding per-node
>> interrupt-parent would not be worthwhile from the standpoint of speeding
>> up boot time.
> 
> Absolutely, I don't expect this to miraculously improve the boot time or
> suggest that this is a major contributor to boot time, but what is the
> best approach in general in terms of efficiency (memory and time). In
> other words, is there a best practice? And from your feedback, I
> understand that adding a global interrupt-parent is a good practice.

>From a maintenance standpoint, "saying it once" is best practice.  Time
that you don't spend doing unnecessary maintenance can be spent looking
for other, higher value, improvements.  And when you do need to optimize
something, it's much easier if the function is centralized.

Pushing the interrupt parent up the tree to the appropriate point can
make the next platform easier, opening the possibility of changing just
one thing instead of several dozen.

There have been several cases when I have violated good factoring in
order to save a little time, only to have to undo it later when the next
system was enough different that the de-factored version didn't work.

So, while there are certainly cases where you are forced to do
otherwise, I generally like the "don't repeat yourself" mantra.

> 
> For a bit of fun, I took an omap4430 board and benchmarked the time
> taken by the of_irq_find_parent() when interrupt-parent was defined for
> each node using interrupts and without.
> 
> There were a total of 47 device nodes using interrupts. Adding the
> interrupt-parent to all 47 nodes increased the dtb from 13211 bytes to
> 13963 bytes.
> 
> On boot-up I saw 117 calls to of_irq_find_parent() for this platform
> (there appears to be multiple calls for a given device). Without
> interrupt-parent defined for each node total time spent in
> of_irq_find_parent() was 1.028 ms where as with interrupt-parent defined
> for each node the total time was 0.4032 ms. This was done using a
> 38.4MHz timer and the overhead of reading the timer 117 times was about
> 36 us.

That sounds about right.  The savings of 600 us is 6 characters at
115200 baud.

> 
> I understand that this does not provide the full picture, but I wanted
> to get a better handle on the times here. So yes the overall overhead
> here is not significant for us to worry about.

Big ticket items for boot time improvement are time spent waiting for
peripheral devices to become ready and time spent spewing diagnostic
messages.  But in the final analysis, you just have to measure what is
happening and see what you can do to improve it.  In my experience, CPU
cycles are rarely problematic, unless they are artificially slowed down
due to caches being off or due to direct execution from slow memory like
ROMs.

I once shaved an hour off the startup time for a PowerPC system by
moving some critical code into cache.  This was on a prototype "chip"
that was being emulated by arrays of FPGAs.

On the first generation OLPC XO-1 machine we were really interested in
super-fast wakeup from suspend.  I tuned that firmware code path to the
nth degree, finally getting stuck at 2 ms because you had to wait that
long before accessing the PCI bus interface, otherwise the SD controller
chip would lock up.  Then I transferred control to the kernel, which had
to wait something like 40 ms (two display frame times) to re-sync the
video subsystem, then it had to re-enable the USB subsystem, which ended
up taking a good fraction of a second.

Things haven't gotten much better (in fact they are probably worse),
because, even the the CPUs have gotten faster, there are more
peripherals with hard-to-avoid delays.  So, in the end, a few
sub-millisecond delays just don't matter.

> 
> Cheers
> Jon
> 
> 
