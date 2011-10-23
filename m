Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1JWUMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 16:12:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48471 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1JWUMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 16:12:09 -0400
Date: Sun, 23 Oct 2011 21:11:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        mem@selenic.com
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111023201140.GA27802@n2100.arm.linux.org.uk>
References: <4E9E0B71.9020708@am.sony.com> <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com> <1500345.YeXPhIIHc5@wuerfel> <CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com> <20111022133648.GA21374@n2100.arm.linux.org.uk> <4EA46A16.5080005@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA46A16.5080005@am.sony.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 12:25:10PM -0700, Tim Bird wrote:
> We have about 50 hard real-time threads, that are part of a
> software stack for digital cameras that was ported over from
> micro-itron.  It has taken a _LONG_ time (on the order of a
> few years) to tune the Linux system using RT-preempt to run
> these threads as is.  It would be very painful to re-architect this
> part of the system.
>
> Note that these threads don't have any of the issues that
> people have raised about filesystem stack depth or printk
> recursion, since they avoid a whole range of Linux syscalls
> to avoid real-time issues (and stack size issues).
>
> I'm looking at possibly implementing a mixed stack
> size system, but I don't know if that will work, or whether
> it would be acceptable upstream.

I can't see how it would work, because the extremes of the kernel stack
are rather fixed.  At the top of the stack, we have the kernel stack
growing downwards.  At the bottom of the stack, we have the thread_info
structure.

If we have different stack sizes depending on the thread which is running,
you have a catch-22 situation - you need some per-thread data to find
out how large the kernel stack is, and that can't be stored in the
thread_info struct because to find that you need to know how large the
kernel stack is.

>> If memory fragmentation is an issue for this, it probably means that we
>> need to switch to a software page size of 8K (or maybe 16K) rather than
>> stick with the hardware 4K size.  That would be a much more reliable
>> solution, especially as the L1 page table is 16K (if you're suffering
>> from memory fragmentation, the first thing which'd get you is the L1
>> page table allocation, not the kernel stack allocation.)

So, the reason you don't have a problem with this is because you're
running 50 threads of the _same_ process, which are all sharing the
same L1 page table.  That information has a direct bearing on this
discussion.

>> The possibility of a kernel stack overflow is not something that should
>> be taken lightly
> Agreed.
>
> This kind of development is done with extensive in-house testing,
> and an absolutely fixed users space. This may sound like an
> isolated case, but I know Sony is not alone and that lots of
> embedded products are developed like this.  I'm pretty sure
> others would benefit from this patch.
>
> We've already shipped tens of thousands of cameras
> with this, with no problems, so it's certainly possible to get it
> right.
>
> Whether to include this comes down to a question of whether
> the ability of someone to get it wrong should preclude
> allowing the *option* into the kernel.

Given this comment, I assume you've already measured how much kernel
stack gets used, and would be able to provide those figures?

The kernel can give you this if you enable CONFIG_DEBUG_STACK_USAGE.  The
kernel will then report whenever a thread exits having used more kernel
stack than any previous exiting thread.
