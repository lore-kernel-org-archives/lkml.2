Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2BJUZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:25:03 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37507 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2BJUZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:25:00 -0500
MIME-Version: 1.0
X-Originating-IP: [89.138.49.59]
In-Reply-To: <1328899105.25989.37.camel@laptop>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
	<CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	<20120201170443.GE6731@somewhere.redhat.com>
	<CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
	<4F2AAEB9.9070302@tilera.com>
	<1328899105.25989.37.camel@laptop>
Date: Fri, 10 Feb 2012 22:24:59 +0200
Message-ID: <CAOtvUMf11CxFV+FR8YCjqaoEWojGT7oX46_QamjCkXkHzsW3-A@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 8:38 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-02-02 at 10:41 -0500, Chris Metcalf wrote:
>>
>> /*
>>  * Quiesce the timer interrupt before returning to user space after a
>>  * system call.  Normally if a task on a dataplane core makes a
>>  * syscall, the system will run one or more timer ticks after the
>>  * syscall has completed, causing unexpected interrupts in userspace.
>>  * Setting DP_QUIESCE avoids that problem by having the kernel "hold"
>>  * the task in kernel mode until the timer ticks are complete.  This
>>  * will make syscalls dramatically slower.
>>  *
>>  * If multiple dataplane tasks are scheduled on a single core, this
>>  * in effect silently disables DP_QUIESCE, which allows the tasks to make
>>  * progress, but without actually disabling the timer tick.
>>  */
>> #define DP_QUIESCE      0x1
>
> This is what Frederics work does

Actually it's not quite the same I believe. Frederic's patch set
disables the tick
for an adaptive tick task at some timer tick interrupt after the
system call, but
the task doesn't know when that happens, so if timing determinism guarantee is
what you are after you don't quite know in your user task if its safe
to start doing
real time stuff or know.

If I understood Chris quote correctly, they hold the task in kernel
space until the
timer tick is off, so that when the user space task continues to run
after the system
call it can assume the tick is off.

Of course, nothing stops something (IPI?) from re-enabling it later,
but I guess it at least
lets you start in a known state.

I think the concept of giving the task some way to know if the tick is
disabled or not is nice.
Not sure the exact feature and surely not the interface are what we
should adopt - maybe
allow registering to receive a signal at the end of the tick when it
is disabled an re-enabled?

>
>>
>> /*
>>  * Disallow the application from entering the kernel in any way,
>>  * unless it calls set_dataplane() again without this bit set.
>>  * Issuing any other syscall or causing a page fault would generate a
>>  * kernel message, and "kill -9" the process.
>>  *
>>  * Setting this flag automatically sets DP_QUIESCE as well.
>>  */
>> #define DP_STRICT       0x2
>
> This is a debug feature.. you'd better know what your own software does.
>
>>
>> /*
>>  * Debug dataplane interrupts, so that if any interrupt source
>>  * attempts to involve a dataplane cpu, a kernel message and stack
>>  * backtrace will be generated on the console.  As this warning is a
>>  * slow event, it may make sense to avoid this mode in production code
>>  * to avoid making any possible interrupts even more heavyweight.
>>  *
>>  * Setting this flag automatically sets DP_QUIESCE as well.
>>  */
>> #define DP_DEBUG        0x4
>
> This too is a debug feature, one that doesn't cover all possible
> scenarios.

I like the idea of these but suspect a trace event is more suitable to
provide the same information.

>
>> /*
>>  * Cause all memory mappings to be populated in the page table.
>>  * Specifying this when entering dataplane mode ensures that no future
>>  * page fault events will occur to cause interrupts into the Linux
>>  * kernel, as long as no new mappings are installed by mmap(), etc.
>>  * Note that since the hardware TLB is of finite size, there will
>>  * still be the potential for TLB misses that the hypervisor handles,
>>  * either via its software TLB cache (fast path) or by walking the
>>  * kernel page tables (slow path), so touching large amounts of memory
>>  * will still incur hypervisor interrupt overhead.
>>  */
>> #define DP_POPULATE     0x8
>
> map()s MAP_POPULATE will pre-populate the stuff for you, as will
> mlock(), the latter will (mostly) ensure they stay around.
>

Yeap.


I think it's a collection of nice ideas that somehow got grouped together
under a specific interface and I guess we adopt the ideas but not neccisiarly
the implementation or interface:

- trace events for the debug notifications
- recommend mlock & friends for the VM stuff
- Perhaps a signal handler for tick notification?

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
